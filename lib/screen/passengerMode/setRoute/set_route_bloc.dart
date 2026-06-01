import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../googleApi/google_api_repo.dart';
import '../../../googleApi/place_auto_complete_dl.dart';
import '../../../googleApi/place_detail_dl.dart';
import '../../../utils/utils.dart';
import '../../common/manageAdress/manage_address_dl.dart';
import '../../common/manageAdress/manage_address_repo.dart';
import '../../common/selectLocation/select_location.dart';
import '../passengerHome/passenger_home_dl.dart';

class SetRouteBloc extends Bloc {
  BuildContext context;
  bool isSearched = true, setFromPlaceList = false;
  final pickUpLocationTEC = TextEditingController();
  final dropLocationTEC = TextEditingController();
  final deBouncer = DeBouncer(milliseconds: 1000);
  final GoogleApiRepo _googleApiRepo = GoogleApiRepo();
  final ManageAddressRepo _manageAddressRepo = ManageAddressRepo();
  final Function(SearchedLocation? fromAddress, SearchedLocation? toAddress, List<SearchedLocation>? stopAddressList) onConfirmLocation;
  int selectedIndex;
  static const String tag = "SetRouteTag>>>";
  int maxAddressLimit = 0;
  int addressListLength = 0;
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  SetRouteBloc(
    this.context,
    SearchedLocation? fromAddress,
    SearchedLocation? toAddress,
    List<SearchedLocation>? stopAddressList,
    bool isAddStopAddress,
    this.selectedIndex,
    this.onConfirmLocation,
  ) {
    if (fromAddress != null) {
      pickUpLocationTEC.text = fromAddress.name ?? "";
      fromAddressController.sink.add(fromAddress);
    }
    if (toAddress != null) {
      dropLocationTEC.text = toAddress.name ?? "";
      toAddressController.sink.add(toAddress);
    }
    if ((stopAddressList ?? []).isNotEmpty) {
      addStopAddressListController.sink.add(stopAddressList ?? []);
    }
    if (isAddStopAddress) {
      List<SearchedLocation>? stopAddressList = addStopAddressListController.valueOrNull ?? [];
      stopAddressList.add(SearchedLocation());
      addStopAddressListController.sink.add(stopAddressList);
    }
    getAddressList();
    selectedIndexController.sink.add(selectedIndex);
  }

  final fromAddressController = BehaviorSubject<SearchedLocation?>();
  final toAddressController = BehaviorSubject<SearchedLocation?>();
  final addStopAddressListController = BehaviorSubject<List<SearchedLocation>>.seeded([]);
  final selectedIndexController = BehaviorSubject<int>.seeded(0);
  final placesListController = BehaviorSubject<List<Suggestions>>();
  final subjectManageAddress = BehaviorSubject<ApiResponse<AddressListPojo>>();

  Future<void> getPlaces(String search) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => getPlaces(search))) {
      try {
        var response = PlaceAutoCompletePojo.fromJson(
          await _googleApiRepo.placeAutoCompleteApiCall(
            search,
            LatLng(fromAddressController.valueOrNull?.lat ?? 0, fromAddressController.valueOrNull?.lng ?? 0),
          ),
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
          setAddressDetail(placeName, locationLatLong?.latitude, locationLatLong?.longitude);
          placesListController.sink.add([]);
          isSearched = false;
          FocusManager.instance.primaryFocus?.unfocus();
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void setAddressDetail(String placeName, double? lat, double? long) {
    int index = selectedIndexController.valueOrNull ?? 0;
    if (index == 1) {
      pickUpLocationTEC.text = placeName;
      fromAddressController.sink.add(SearchedLocation(name: placeName, lat: lat, lng: long));
    } else if (index == 2) {
      dropLocationTEC.text = placeName;
      toAddressController.sink.add(SearchedLocation(name: placeName, lat: lat, lng: long));
    } else if (index > 2) {
      List<SearchedLocation> searchedLocationList = addStopAddressListController.valueOrNull ?? [];
      if (searchedLocationList.isNotEmpty) {
        searchedLocationList[index - 3] = SearchedLocation(name: placeName, lat: lat, lng: long);
        addStopAddressListController.sink.add(searchedLocationList);
      } else if (dropLocationTEC.text.isEmpty) {
        dropLocationTEC.text = placeName;
        toAddressController.sink.add(SearchedLocation(name: placeName, lat: lat, lng: long));
      } else {
        pickUpLocationTEC.text = placeName;
        fromAddressController.sink.add(SearchedLocation(name: placeName, lat: lat, lng: long));
      }
    } else {
      pickUpLocationTEC.text = placeName;
      fromAddressController.sink.add(SearchedLocation(name: placeName, lat: lat, lng: long));
    }
    scrollController.animateTo(0, duration: Duration(milliseconds: 250), curve: Curves.fastOutSlowIn);
    changeLocationSearch();
  }

  void removeMultiStopAddress(int pos) {
    List<SearchedLocation> searchedLocationList = addStopAddressListController.value;
    if (searchedLocationList.length > pos) {
      searchedLocationList.removeAt(pos);
      addStopAddressListController.sink.add(searchedLocationList);
    }
  }

  void changeLocationSearch() {
    placesListController.sink.add([]);
    isSearched = false;
  }

  void selectFromMap() {
    openScreenWithResult(context, SelectLocation(showFilledLocation: true)).then((value) {
      if (value != null) {
        setAddressDetail(value["address"], value["lat"], value["lng"]);
      }
    });
  }

  void onPressConfirm() {
    SearchedLocation? fromAddress = fromAddressController.valueOrNull;
    SearchedLocation? toAddress = toAddressController.valueOrNull;
    if (!addressDetailValid(fromAddress)) {
      openSimpleSnackbar(context, languages.selectPickup);
    } else if (!addressDetailValid(toAddress)) {
      openSimpleSnackbar(context, languages.selectDrop);
    } else {
      List<SearchedLocation> stopAddressList = [];
      for (SearchedLocation element in (addStopAddressListController.valueOrNull ?? [])) {
        if (!addressDetailValid(element)) {
          openSimpleSnackbar(context, languages.selectStop);
          return;
        } else {
          stopAddressList.add(element);
        }
      }
      onConfirmLocation(fromAddress, toAddress, stopAddressList);
    }
  }

  void getAddressList() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => getAddressList())) {
      subjectManageAddress.sink.add(ApiResponse.loading());
      try {
        var response = AddressListPojo.fromJson(await _manageAddressRepo.callAddressListApi());

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true)) {
          subjectManageAddress.sink.add(ApiResponse.completed(response));
          maxAddressLimit = response.maxAddressLimit;
          addressListLength = 0;
          for (var element in response.typeList) {
            addressListLength = addressListLength + element.addressList.length;
          }
        } else {
          subjectManageAddress.sink.add(ApiResponse.error(response.message));
          debugPrint("$tag ${response.message}");
        }
      } catch (e) {
        debugPrint("$tag ${e.toString()}");
        subjectManageAddress.sink.add(ApiResponse.error(e.toString()));
        if (!context.mounted) return;
        openSimpleSnackbar(context, e.toString());
      }
    }
  }

  bool addressDetailValid(SearchedLocation? location) {
    return ((location?.name ?? "").isNotEmpty && ((location?.lat ?? 0) != 0) && ((location?.lng ?? 0) != 0));
  }

  @override
  void dispose() {
    fromAddressController.close();
    toAddressController.close();
    addStopAddressListController.close();
    selectedIndexController.close();
    placesListController.close();
    subjectManageAddress.close();
  }
}
