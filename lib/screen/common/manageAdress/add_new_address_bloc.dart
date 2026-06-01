import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../googleApi/google_api_repo.dart';
import '../../../googleApi/place_auto_complete_dl.dart';
import '../../../googleApi/place_detail_dl.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import "../selectLocation/select_location.dart" show SelectLocation;
import 'add_new_address_repo.dart';
import 'manage_address_dl.dart';

class AddNewAddressBloc extends Bloc {
  BuildContext context;
  final AddNewAddressRepo _addNewAddressRepo = AddNewAddressRepo();
  ItemManageAddressList? addressListItem;
  LatLng? latLng;
  var locationController = TextEditingController();
  final deBouncer = DeBouncer(milliseconds: 1000);
  final GoogleApiRepo _googleApiRepo = GoogleApiRepo();
  bool isSearched = true, setFromPlaceList = false;

  AddNewAddressBloc(this.context, this.addressListItem);

  final BehaviorSubject<int> addressTypeController = BehaviorSubject<int>.seeded(1);
  final placesListController = BehaviorSubject<List<Suggestions>>();
  final subject = BehaviorSubject<ApiResponse<BaseModel>>();

  Future<void> editAddress() async {
    latLng ??= LatLng(double.parse("${addressListItem?.lat ?? "0"}"), double.parse("${addressListItem?.long ?? "0"}"));
    if (await isNetworkConnected(onRetryPressedCallApi: () => editAddress())) {
      subject.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(
          await _addNewAddressRepo.callEditAddressApi(addressListItem?.addressId ?? 0, locationController.text.trim(), addressTypeController.value, latLng!),
        );
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true, showMess: false)) {
          subject.sink.add(ApiResponse.completed(response));
          Navigator.pop(context, true);
        } else {
          subject.sink.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> addAddress() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => addAddress())) {
      subject.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(
          await _addNewAddressRepo.callAddAddressApi(locationController.text.trim(), addressTypeController.valueOrNull ?? 0, latLng!),
        );
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true)) {
          subject.sink.add(ApiResponse.completed(response));
          Navigator.pop(context, true);
        } else {
          subject.sink.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> getPlaces(String search) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => getPlaces(search))) {
      try {
        var response = PlaceAutoCompletePojo.fromJson(
          await _googleApiRepo.placeAutoCompleteApiCall(search, LatLng(latLng?.latitude ?? 0, latLng?.longitude ?? 0)),
        );
        placesListController.sink.add(response.suggestions ?? []);
      } catch (e) {
        debugPrint(e.toString());
      }
      /*} else {
      openSimpleSnackbar(languages.internetConnLostTitle);*/
    }
  }

  Future<void> onPlaceListClick(String placeName, String placeId) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => onPlaceListClick(placeName, placeId))) {
      isSearched = true;
      setFromPlaceList = true;
      try {
        var response = PlaceDetailPojo.fromJson(await _googleApiRepo.placeDetailApiCall(placeId));
        String address = response.formattedAddress ?? "";
        if (address.isNotEmpty) {
          PlaceLocation? locationLatLong = response.location;
          locationController.text = placeName;
          latLng = LatLng(locationLatLong?.latitude ?? 0, locationLatLong?.longitude ?? 0);
          placesListController.sink.add([]);
          isSearched = false;
          FocusManager.instance.primaryFocus?.unfocus();
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void gotoSelectLocation() {
    openScreenWithResult(context, const SelectLocation(showFilledLocation: true)).then((value) {
      if (value != null && value["lat"] != null && value["lng"] != null) {
        locationController.text = value["address"];
        latLng = LatLng(value["lat"], value["lng"]);
      }
    });
  }

  void submit() {
    if (locationController.text.trim().isNotEmpty && latLng != null) {
      FocusManager.instance.primaryFocus?.unfocus();
      if (addressListItem != null) {
        editAddress();
      } else {
        addAddress();
      }
    } else {
      openSimpleSnackbar(context, languages.selectLocation);
    }
  }

  @override
  void dispose() {
    addressTypeController.close();
    locationController.dispose();
    subject.close();
  }
}
