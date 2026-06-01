import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/add_customer_details_bs.dart';
import '../../../bottomSheet/raise_fare_sheet.dart';
import '../../../commonView/sliding_panel.dart';
import '../../../googleApi/google_api_repo.dart';
import '../../../googleApi/place_auto_complete_dl.dart';
import '../../../googleApi/place_detail_dl.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/get_route_utils.dart';
import '../../../utils/utils.dart';
import '../../driverMode/hailRide/ride_estimation_preview.dart';
import '../../passengerMode/passengerHome/passenger_home_dl.dart';
import '../../passengerMode/passengerHome/passenger_home_repo.dart';

class SelectLocationBloc extends Bloc {
  BuildContext context;
  final deBouncer = DeBouncer(milliseconds: 1000);
  CameraPosition? cameraPosition;
  GoogleMapController? googleMapController;
  bool setAddress = false, isSearched = true, setFromPlaceList = false, isFirstTime = true;
  LatLng? latLng;
  LatLng? currentLatLng;
  String? currentAddress;
  SearchedLocation searchAndSelectLocationModel = SearchedLocation();
  TextEditingController textEditingController = TextEditingController();
  PanelController controller = PanelController();
  final bool showFilledLocation;
  final GoogleApiRepo _googleApiRepo = GoogleApiRepo();
  final bool isHailRide;

  SelectLocationBloc(this.context, this.showFilledLocation, this.isHailRide);

  final _locationSearchController = BehaviorSubject<String>();
  final _placesListController = BehaviorSubject<List<Suggestions>>();
  final _loadingController = BehaviorSubject<bool>.seeded(false);
  final mapStyle = BehaviorSubject<String>.seeded("");
  final distanceController = BehaviorSubject<double>();
  final timeController = BehaviorSubject<int>();
  final offerFareAmountController = BehaviorSubject<String?>();
  final subjectHailRide = BehaviorSubject<ApiResponse>();
  final minPriceSubject = BehaviorSubject<double>();
  final maxPriceSubject = BehaviorSubject<double>();
  final recommendedPriceSubject = BehaviorSubject<double>();

  Stream<String> get locationSearch => _locationSearchController.stream;

  Stream<bool> get loading => _loadingController.stream;

  Stream<List<Suggestions>> get placesList => _placesListController.stream;

  Function(bool) get changeLoading => _loadingController.sink.add;

  Function(String) get changeLocationSearch => _locationSearchController.sink.add;

  Function(List<Suggestions>) get changePlaceList => _placesListController.sink.add;

  void onMapCreated(GoogleMapController googleMapController) {
    this.googleMapController = googleMapController;
    getCurrentLocation(forcefullyGetLocation: true);
  }

  void getCurrentLocation({bool forcefullyGetLocation = false}) {
    changeLoading(true);

    getLocationUtils.getLocationUtils(
      (locationData) {
        latLng = LatLng(locationData.latitude, locationData.longitude);
        currentLatLng = LatLng(locationData.latitude, locationData.longitude);
      },
      (l, address) {
        if (!context.mounted) return;
        changeLoading(false);
        isSearched = true;
        setFromPlaceList = true;
        if (showFilledLocation) {
          changeLocationSearch(address);
        } else {
          _locationSearchController.sink.add("");
          isSearched = false;
        }
        currentAddress = address;
        focusInMap(googleMapController!, l.latitude, l.longitude, true);
      },
      getForceFully: forcefullyGetLocation,
      isGetAddress: true,
    );
  }

  Future<void> getPlaces(String search) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => getPlaces(search))) {
      try {
        var response = PlaceAutoCompletePojo.fromJson(await _googleApiRepo.placeAutoCompleteApiCall(search, latLng!));
        _placesListController.sink.add(response.suggestions ?? []);
        if ((response.suggestions ?? []).isNotEmpty) {
          if (!controller.isPanelOpen) {
            controller.open();
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void onCameraMoved(CameraPosition cameraPosition) {
    _loadingController.sink.add(true);
    if (!setFromPlaceList) {
      setAddress = true;
      changeLocationSearch("");
      clearAddressData();
    }
    this.cameraPosition = cameraPosition;
  }

  void onCameraIdle() {
    _placesListController.sink.add([]);
    if (setFromPlaceList) {
      changeLoading(false);
    }
    if (cameraPosition != null && setAddress && !setFromPlaceList) {
      changeLoading(true);
      isSearched = true;
      latLng = cameraPosition?.target;
      getStringAddress(cameraPosition?.target.latitude ?? 0, cameraPosition?.target.longitude ?? 0).then((value) {
        changeLoading(false);
        setAddress = false;
        changeLocationSearch(value);
        searchAndSelectLocationModel = SearchedLocation(name: value, lat: cameraPosition?.target.latitude, lng: cameraPosition?.target.longitude);
      });
    } else {
      setFromPlaceList = false;
    }
  }

  void clearAddressData() {
    searchAndSelectLocationModel = SearchedLocation();
  }

  Future<void> onPlaceListClick(String placeName, String placeId) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => onPlaceListClick(placeName, placeId))) {
      changeLoading(true);
      isSearched = true;
      setFromPlaceList = true;
      changeLocationSearch(placeName);
      try {
        var response = PlaceDetailPojo.fromJson(await _googleApiRepo.placeDetailApiCall(placeId));
        changeLoading(false);
        String? address = response.formattedAddress;
        if ((address ?? "").isNotEmpty) {
          PlaceLocation? locationLatLong = response.location;
          if (locationLatLong != null) {
            latLng = LatLng(locationLatLong.latitude ?? 0, locationLatLong.longitude ?? 0);
            focusInMap(googleMapController!, locationLatLong.latitude ?? 0, locationLatLong.longitude ?? 0, true);
            if (controller.isPanelOpen) {
              controller.close();
            }
            searchAndSelectLocationModel = SearchedLocation(name: placeName, lat: latLng?.latitude, lng: latLng?.longitude);
            FocusManager.instance.primaryFocus?.unfocus();
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> mapApiCall() async {
    try {
      subjectHailRide.sink.add(ApiResponse.loading());
      await GetRoutesUtils().getRoutes(currentLatLng ?? LatLng(0, 0), latLng ?? LatLng(0, 0), [], (polyLines, duration, distance) async {
        timeController.sink.add((duration / 60).round());
        distanceController.sink.add(getDoubleFromDynamic((distance / 1000).toStringAsFixed(2)));
        offerFareAmountController.sink.add(null);
        callRideCalculationApi();
      });
    } catch (e) {
      subjectHailRide.sink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> callRideCalculationApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callRideCalculationApi();
      },
    )) {
      try {
        var response = RideCalculationPojo.fromJson(
          await PassengerHomeRepo().rideCalculation(getIntFromSettingBox(hiveServiceId), distanceController.valueOrNull ?? 0, timeController.valueOrNull ?? 0),
        );
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          // subjectRideCalculation.add(ApiResponse.completed(response));
          subjectHailRide.add(ApiResponse.completed());
          recommendedPriceSubject.sink.add(getDoubleFromDynamic(response.recommendedFare));
          minPriceSubject.sink.add(getDoubleFromDynamic(response.minPrice));
          maxPriceSubject.sink.add(getDoubleFromDynamic(response.maxPrice));
        } else {
          subjectHailRide.add(ApiResponse.error(message));
          // subjectRideCalculation.add(ApiResponse.error(message));
        }
      } catch (e) {
        subjectHailRide.add(ApiResponse.error(e.toString()));
      }
    } else {
      subjectHailRide.add(ApiResponse.error());
    }
  }

  void confirmPlace() {
    if (_locationSearchController.value.isNotEmpty && latLng != null) {
      if (isHailRide) {
        openAddCustomerDetailsBS();
      } else {
        Navigator.pop(context, {"address": _locationSearchController.value, "lat": latLng?.latitude ?? 0, "lng": latLng?.longitude ?? 0});
      }
    } else {
      openSimpleSnackbar(context, languages.selectLocation);
    }
  }

  Future<void> openAddCustomerDetailsBS() async {
    if (currentLatLng == null) {
      openSimpleSnackbar(context, languages.errorMessageCommon);
      return;
    }
    await mapApiCall();
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      builder: (context) {
        return AddCustomerDetailsBS(
          onSubmit: (name, countryCode, phoneNumber) {
            Navigator.pop(context);
            offerAmountBottomSheet(name, countryCode, phoneNumber);
          },
        );
      },
    );
  }

  void offerAmountBottomSheet(String name, String countryCode, String phoneNumber) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.9),
      builder: (context) {
        return RaiseFareSheet(
          currentFare: recommendedPriceSubject.valueOrNull ?? 0,
          minFare: minPriceSubject.valueOrNull ?? 0,
          maxFare: maxPriceSubject.valueOrNull ?? 0,
          btnTitle: languages.continueTxt,
          isShowFareDetail: true,
          km: "${distanceController.valueOrNull ?? 0} ${languages.km}",
          min: "${timeController.valueOrNull ?? 0} ${languages.min}",
          onSubmit: (amount) {
            Navigator.pop(context);
            openRideEstimationScreen(name, countryCode, phoneNumber, getDoubleFromDynamic(amount));
          },
        );
      },
    );
  }

  void openRideEstimationScreen(String name, String countryCode, String phoneNumber, double offerFare) {
    openScreen(
      context,
      RideEstimationPreview(
        addressList: [
          SearchedLocation(name: currentAddress, lat: currentLatLng?.latitude ?? 0, lng: currentLatLng?.longitude ?? 0),
          SearchedLocation(name: _locationSearchController.value, lat: latLng?.latitude ?? 0, lng: latLng?.longitude ?? 0),
        ],
        offerPrice: offerFare,
        distance: distanceController.valueOrNull ?? 0,
        time: timeController.valueOrNull ?? 0,
        customerName: name,
        customerNumber: "$countryCode $phoneNumber",
      ),
    );
  }

  @override
  void dispose() {
    _locationSearchController.close();
    _placesListController.close();
    _loadingController.close();
    textEditingController.dispose();
  }
}
