import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/demo_product_bottom_sheet.dart';
import '../../../bottomSheet/region_confirm_sheet.dart';
import '../../../bottomSheet/warning_bottom_sheet.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/custom_marker.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/app_mobile_settings.dart';
import '../../../utils/destination_payment_util.dart';
import '../../../utils/get_route_utils.dart';
import '../../../services/passenger_location_history_service.dart';
import '../../../utils/service_mode_util.dart';
import '../../../utils/xisti_vehicle_catalog.dart';
import '../../../utils/utils.dart';
import '../../common/splash/splash_dl.dart';
import '../../common/splash/splash_repo.dart';
import '../offerRide/offer_ride_screen.dart';
import '../passengerRunningRide/passenger_running_ride.dart';
import '../setRoute/set_route_screen.dart';
import '../../../services/xisti_region_service.dart';
import '../../../utils/xisti_region_catalog.dart';
import '../../../utils/xisti_ui_tokens.dart';
import 'passenger_home_activity_dl.dart';
import 'passenger_home_barrio_shortcuts.dart';
import 'passenger_home_dl.dart';
import 'passenger_home_repo.dart';
import 'psHomeBottomSheet/offerFareAndBookSheet/offer_fare_and_book_sheet.dart';
import 'psHomeBottomSheet/additionalOptionSheet/additional_option_sheet.dart';

class PassengerHomeBloc extends Bloc {
  BuildContext context;

  PassengerHomeBloc(this.context, this.isFromLogin) {
    getCurrentLocation();
    firebaseAuth().then((value) {
      setFCMToken();
    });
    if (isDemoApp && !(demoSheetContext?.mounted ?? false) && Platform.isAndroid) {
      openDemoSheet();
    }
  }

  GoogleMapController? googleMapController;
  final SplashRepo _splashRepo = SplashRepo();
  final PassengerHomeRepo _passengerHomeRepo = PassengerHomeRepo();
  String versionName = "";
  bool isFromLogin;
  CameraPosition? cameraPosition;
  bool isFromBottomSheet = false;
  BuildContext? demoSheetContext;
  LatLng? currentLatLng;

  final subjectServiceData = BehaviorSubject<ApiResponse<ServiceTypeModel>>();
  final selectedServiceModeSubject =
      BehaviorSubject<String>.seeded(ServiceModeKind.transport);
  final filteredServicesSubject = BehaviorSubject<List<ServiceTypeItem>>.seeded([]);
  final markersListController = BehaviorSubject<List<Marker>>();
  final rotateMarkerListController = BehaviorSubject<List<Marker>>();
  final polyLinesController = BehaviorSubject<Map<PolylineId, Polyline>>();
  final fromAddressController = BehaviorSubject<SearchedLocation?>();
  final toAddressController = BehaviorSubject<SearchedLocation?>();
  final mapApiSubject = BehaviorSubject<bool>();
  final distanceController = BehaviorSubject<double>();
  final timeController = BehaviorSubject<int>();
  final offerFareAmountController = BehaviorSubject<String?>();
  final subjectSelectedServiceData = BehaviorSubject<ServiceTypeItem?>();
  final addStopAddressList = BehaviorSubject<List<SearchedLocation>>.seeded([]);
  final commentController = BehaviorSubject<String>();
  final childSafetyController = BehaviorSubject<bool>();
  final handyCapAccessibilityController = BehaviorSubject<bool>();
  final bookForOtherController = BehaviorSubject<bool>();
  final otherContactController = BehaviorSubject<String>();
  final otherContactNameController = BehaviorSubject<String>();
  final additionalOptionController = BehaviorSubject<bool>.seeded(false);
  final subjectRideCalculation = BehaviorSubject<ApiResponse<RideCalculationPojo>>();
  final minPriceSubject = BehaviorSubject<double>();
  final maxPriceSubject = BehaviorSubject<double>();
  final recommendedPriceSubject = BehaviorSubject<double>();
  final mapLoadController = BehaviorSubject<bool>();
  final rideBookSubject = BehaviorSubject<ApiResponse<RideBookPojo>>();
  final paymentTypeController = BehaviorSubject<int>();
  final scheduleDateController = BehaviorSubject<DateTime?>();
  final autoAcceptController = BehaviorSubject<int>();
  final itemDescController = BehaviorSubject<String>();
  final destinationPaymentMethodController = BehaviorSubject<String>.seeded(DestinationPaymentUtil.cash);
  final packageWeightController = BehaviorSubject<String>();
  final packageHeightController = BehaviorSubject<String>();
  final packageWidthController = BehaviorSubject<String>();
  final packageLengthController = BehaviorSubject<String>();
  final recipientNameController = BehaviorSubject<String>();
  final recipientNumberController = BehaviorSubject<String>();
  final itemEstimatedPriceController = BehaviorSubject<String>();
  final purchaseDescriptionTEC = TextEditingController();
  final priceCapTEC = TextEditingController();
  final mapStyle = BehaviorSubject<String>.seeded("");
  List<DeliveryVehicleOption> deliveryVehicleOptions = [];
  String deliveryPassengerDisclaimer = '';
  String encomiendaPassengerDisclaimer = '';
  final selectedDeliveryVehicleServiceId = BehaviorSubject<int?>();
  final locationHistorySubject = BehaviorSubject<List<Map<String, dynamic>>>.seeded([]);
  final activityHubSubject = BehaviorSubject<PassengerActivitySnapshot?>.seeded(null);
  final activeCityZonesSubject = BehaviorSubject<List<XistiBarrioShortcut>>.seeded(
    XistiMainCityZoneCatalog.defaultCity.zones,
  );
  final activeMainCitySubject = BehaviorSubject<String>.seeded(
    XistiMainCityZoneCatalog.defaultCity.displayName,
  );

  Future<void> callPassengerRunningServiceApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callPassengerRunningServiceApi();
      },
    )) {
      subjectServiceData.add(ApiResponse.loading());
      try {
        var response = PassengerRunningPojo.fromJson(await _splashRepo.getPassengerRunningServiceApi());
        String message = getApiMsg(response.message, response.messageCode);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true, showMess: false)) {
          if ((response.rideId ?? 0) == 0) {
            callHomeApi();
          } else {
            Widget screen;
            if (response.rideStatus == 0 && (response.rideDetails ?? []).isNotEmpty) {
              RideDetails rideDetail = response.rideDetails!.first;
              screen = OfferRideScreen(
                rideId: rideDetail.rideId ?? 0,
                serviceType: rideDetail.serviceId ?? 0,
                addressList: rideDetail.addressList ?? [],
                fareAmount: "${rideDetail.offeredPrice ?? 0}",
                itemDesc: rideDetail.itemDescription ?? "",
                recipientName: rideDetail.recipientName ?? "",
                recipientNumber: rideDetail.recipientContactNumber ?? "",
                minFareAmount: rideDetail.minBargainAmt ?? 0,
                maxFareAmount: rideDetail.maxBargainAmt ?? 0,
                estimatedPrice: "${rideDetail.offeredPrice ?? 0}",
              );
            } else {
              screen = PassengerRunningRide(rideId: response.rideId ?? 0);
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openScreenWithClearPrevious(context, screen); // executes after build
            });
          }
        } else {
          callHomeApi();
        }
      } catch (e) {
        callHomeApi();
        debugPrint(e.toString());
      }
    }
  }

  Future<void> callHomeApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callHomeApi();
      },
    )) {
      subjectServiceData.add(ApiResponse.loading());
      try {
        if (versionName.trim().isEmpty) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          versionName = packageInfo.version;
        }
        var response = ServiceTypeModel.fromJson(
          await _passengerHomeRepo.home(
            appVersion: versionName,
            currentLat: (currentLatLng?.latitude ?? 0).toString(),
            currentLng: (currentLatLng?.longitude ?? 0).toString(),
          ),
        );
        String message = getApiMsg(response.message, response.messageCode);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status ?? 0, message, true)) {
          deliveryVehicleOptions = response.deliveryVehicleOptions ?? [];
          if (deliveryVehicleOptions.length < XistiVehicleCatalog.deliveryOptions().length) {
            deliveryVehicleOptions = XistiVehicleCatalog.deliveryOptions();
          }
          deliveryPassengerDisclaimer = response.deliveryPassengerDisclaimer ?? '';
          encomiendaPassengerDisclaimer = response.encomiendaPassengerDisclaimer ?? '';
          if (deliveryVehicleOptions.isNotEmpty) {
            selectedDeliveryVehicleServiceId.add(deliveryVehicleOptions.first.vehicleServiceId);
          }
          _applyHomeServices(response);
          await refreshLocationHistory();
          await refreshActivityHub();
          subjectServiceData.add(ApiResponse.completed(response));
          putDataInSettingBox(hiveDriverStatus, response.isDriverStatus ?? 0);
          putDataInSettingBox(hiveDocumentStatus, response.driverDocStatus ?? 0);
          putDataInSettingBox(hiveVehicleStatus, response.driverVehicleStatus ?? 0);
          putDataInSettingBox(hiveDriverType, response.isDriverType ?? 0);
          putDataInSettingBox(hivePaymentTypeCash, response.cashPayment == 1);
          putDataInSettingBox(hivePaymentTypeOnline, response.onlinePayment == 1);
          putDataInSettingBox(hivePaymentTypeWallet, response.walletPayment == 1);
        } else {
          subjectServiceData.add(ApiResponse.error(message));
        }
      } catch (e) {
        subjectServiceData.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> callNearestDriverApi(Position currentLocation) async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callNearestDriverApi(currentLocation);
      },
    )) {
      try {
        var response = NearestDriverPojo.fromJson(await _passengerHomeRepo.nearestDriverPositionApi(currentLocation.latitude, currentLocation.longitude));

        String message = getApiMsg(response.message, response.messageCode);

        if (!context.mounted) return;
        if (isApiStatus(context, response.status ?? 0, message, true, showMess: false)) {
          List<Marker> nearMarkerList = rotateMarkerListController.valueOrNull ?? [];
          BitmapDescriptor nearMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, "avatar.png"));
          for (DriverList activeDriver in (response.driverList ?? [])) {
            if ((activeDriver.driverProfile ?? "").isNotEmpty) {
              try {
                if (!context.mounted) return;
                nearMarkerIcon = await MarkerIcon.downloadResizePictureCircle(
                  activeDriver.driverProfile ?? "",
                  size: 100.sp.toInt(),
                  addBorder: true,
                  borderColor: getCurrentTheme(context).colorPrimary,
                  borderSize: 1.sp,
                );
              } catch (e) {
                debugPrint("marker error : ${e.toString()}");
              }
            }
            nearMarkerList.add(
              Marker(
                markerId: MarkerId(activeDriver.hashCode.toString()),
                position: LatLng(getDoubleFromDynamic(activeDriver.currentLat), getDoubleFromDynamic(activeDriver.currentLong)),
                icon: nearMarkerIcon,
                infoWindow: InfoWindow(title: activeDriver.firstName ?? ""),
              ),
            );
          }
          rotateMarkerListController.sink.add(nearMarkerList);
        }
      } catch (e) {
        debugPrint("my error is: ${e.toString()}");
      }
    }
  }

  Future<void> callRideCalculationApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callRideCalculationApi();
      },
    )) {
      subjectRideCalculation.add(ApiResponse.loading());
      mapApiSubject.sink.add(true);
      try {
        var response = RideCalculationPojo.fromJson(
          await _passengerHomeRepo.rideCalculation(
            subjectSelectedServiceData.valueOrNull?.serviceId ?? 0,
            distanceController.valueOrNull ?? 0,
            timeController.valueOrNull ?? 0,
          ),
        );
        String message = getApiMsg(response.message, response.messageCode);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          subjectRideCalculation.add(ApiResponse.completed(response));
          final fares = normalizePassengerFareRange(
            recommendedFare: response.recommendedFare,
            minPrice: response.minPrice,
            maxPrice: response.maxPrice,
          );
          recommendedPriceSubject.sink.add(fares.recommended);
          minPriceSubject.sink.add(fares.minPrice);
          maxPriceSubject.sink.add(fares.maxPrice);
          mapApiSubject.sink.add(false);
        } else {
          mapApiSubject.sink.add(false);
          subjectRideCalculation.add(ApiResponse.error(message));
        }
      } catch (e) {
        mapApiSubject.sink.add(false);
        subjectRideCalculation.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> callBookRideApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callBookRideApi();
      },
    )) {
      rideBookSubject.add(ApiResponse.loading());
      try {
        final encomienda = isEncomiendasMode;
        final deliveryLike = isCourierLikeBooking;
        final bookServiceId = encomienda || isDeliveryMode
            ? (selectedDeliveryVehicleServiceId.valueOrNull ?? subjectSelectedServiceData.valueOrNull?.serviceId ?? 0)
            : (subjectSelectedServiceData.valueOrNull?.serviceId ?? 0);

        List<SearchedLocation> addressList = [];
        addressList.add(fromAddressController.value!);
        if (!deliveryLike && (addStopAddressList.valueOrNull?.isNotEmpty ?? false)) {
          addressList.addAll(addStopAddressList.valueOrNull ?? []);
        }
        addressList.add(toAddressController.value!);
        final selectedService = subjectSelectedServiceData.valueOrNull;
        final bookVariant = (selectedService?.deliveryVariant ?? '').trim();
        var response = RideBookPojo.fromJson(
          await _passengerHomeRepo.bookRide(
            addressList: jsonEncode(addressList),
            estimatedTime: timeController.valueOrNull ?? 0,
            offeredFare: offerFareAmountController.valueOrNull ?? "0",
            additionalRemark: commentController.valueOrNull ?? "",
            paymentType: paymentTypeController.valueOrNull ?? 0,
            serviceId: bookServiceId,
            minFareAmount: minPriceSubject.valueOrNull ?? 0,
            maxFareAmount: maxPriceSubject.valueOrNull ?? 0,
            totalDistance: distanceController.valueOrNull ?? 0,
            recipientName: deliveryLike ? recipientNameController.valueOrNull ?? "" : "",
            recipientNumber: deliveryLike ? recipientNumberController.valueOrNull ?? "" : "",
            itemDecs: deliveryLike ? itemDescController.valueOrNull ?? "" : "",
            estimatePrice: deliveryLike
                ? (encomienda
                      ? (itemEstimatedPriceController.valueOrNull ?? "").trim()
                      : (itemEstimatedPriceController.valueOrNull ?? "").isNotEmpty
                            ? (itemEstimatedPriceController.valueOrNull ?? "").trim()
                            : "0")
                : "",
            pickupDateTime: scheduleDateController.valueOrNull == null ? "" : convertTimeToServerTime(scheduleDateController.value!),
            autoAccept: autoAcceptController.valueOrNull ?? 0,
            childSeat: bookServiceId == ServiceType.taxi
                ? (childSafetyController.valueOrNull ?? false)
                      ? 1
                      : 0
                : 0,
            handicap: bookServiceId == ServiceType.taxi
                ? (handyCapAccessibilityController.valueOrNull ?? false)
                      ? 1
                      : 0
                : 0,
            rideForOther: (bookForOtherController.valueOrNull ?? false) ? 1 : 0,
            otherName: (bookForOtherController.valueOrNull ?? false) ? otherContactNameController.valueOrNull ?? "" : "",
            otherNumber: (bookForOtherController.valueOrNull ?? false) ? otherContactController.valueOrNull ?? "" : "",
            destinationPaymentMethod: destinationPaymentMethodController.valueOrNull ?? DestinationPaymentUtil.cash,
            packageWeightKg: deliveryLike && !encomienda ? packageWeightController.valueOrNull ?? "" : "",
            packageHeightCm: deliveryLike && !encomienda ? packageHeightController.valueOrNull ?? "" : "",
            packageWidthCm: deliveryLike && !encomienda ? packageWidthController.valueOrNull ?? "" : "",
            packageLengthCm: deliveryLike && !encomienda ? packageLengthController.valueOrNull ?? "" : "",
            requestedVehicleServiceId: deliveryLike ? (selectedDeliveryVehicleServiceId.valueOrNull ?? bookServiceId) : 0,
            errandType: encomienda ? 'encomienda' : (deliveryLike ? 'delivery' : ''),
            deliveryVariant: bookVariant,
          ),
        );
        String message = getApiMsg(response.message, response.messageCode);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status ?? 0, message, true)) {
          final serviceId = subjectSelectedServiceData.valueOrNull?.serviceId ?? 0;
          final pickup = fromAddressController.valueOrNull;
          final drop = toAddressController.valueOrNull;
          if (pickup != null && drop != null) {
            await PassengerLocationHistoryService.recordTrip(
              serviceId: serviceId,
              pickup: pickup,
              destination: drop,
            );
            await refreshLocationHistory();
          }
          rideBookSubject.add(ApiResponse.completed(response));
          openOfferRideScreen(response.rideId ?? 0);
        } else {
          rideBookSubject.add(ApiResponse.error(message));
        }
      } catch (e) {
        rideBookSubject.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void openOfferRideScreen(int rideId) {
    List<AddressListItem> addressList = [];
    addressList.add(
      AddressListItem(
        address: fromAddressController.valueOrNull?.name ?? "",
        addressLat: "${fromAddressController.valueOrNull?.lat ?? 0}",
        addressLong: "${fromAddressController.valueOrNull?.lng ?? 0}",
      ),
    );
    if (!isCourierLikeBooking && (addStopAddressList.valueOrNull?.isNotEmpty ?? false)) {
      for (SearchedLocation addressItem in (addStopAddressList.valueOrNull ?? [])) {
        addressList.add(AddressListItem(address: addressItem.name ?? "", addressLat: "${addressItem.lat ?? 0}", addressLong: "${addressItem.lng ?? 0}"));
      }
    }
    addressList.add(
      AddressListItem(
        address: toAddressController.valueOrNull?.name ?? "",
        addressLat: "${toAddressController.valueOrNull?.lat ?? 0}",
        addressLong: "${toAddressController.valueOrNull?.lng ?? 0}",
      ),
    );
    openScreenWithClearPrevious(
      context,
      OfferRideScreen(
        rideId: rideId,
        serviceType: subjectSelectedServiceData.valueOrNull?.serviceId ?? 0,
        showCourierDetails: isCourierLikeBooking,
        addressList: addressList,
        fareAmount: offerFareAmountController.valueOrNull ?? "0",
        itemDesc: isCourierLikeBooking ? itemDescController.valueOrNull ?? "" : "",
        recipientName: isCourierLikeBooking ? recipientNameController.valueOrNull ?? "" : "",
        recipientNumber: isCourierLikeBooking ? recipientNumberController.valueOrNull ?? "" : "",
        minFareAmount: minPriceSubject.valueOrNull ?? 0,
        maxFareAmount: maxPriceSubject.valueOrNull ?? 0,
        estimatedPrice: isCourierLikeBooking
            ? (itemEstimatedPriceController.valueOrNull ?? "").isNotEmpty
                  ? itemEstimatedPriceController.valueOrNull ?? ""
                  : "0"
            : "",
      ),
    );
  }

  void _applyHomeServices(ServiceTypeModel response) {
    List<ServiceTypeItem> allServices = response.services ?? [];
    if ((response.serviceModes ?? []).isNotEmpty) {
      allServices = [];
      for (final group in response.serviceModes!) {
        allServices.addAll(group.services);
      }
      response.services = allServices;
    }
    var groups = (response.serviceModes ?? []).isNotEmpty
        ? response.serviceModes!
        : ServiceModeKind.groupsFromFlatServices(allServices);
    groups = ServiceModeKind.filterServiceModeGroupsForFeatureFlags(groups);
    groups = ServiceModeKind.enrichFlaggedModeGroups(groups, allServices);
    response.serviceModes = groups;
    var mode = selectedServiceModeSubject.valueOrNull ?? ServiceModeKind.transport;
    final savedMode = userPrefBox.get(hivePassengerLastServiceMode, defaultValue: '')?.toString() ?? '';
    if (savedMode.isNotEmpty && groups.any((g) => g.mode == savedMode)) {
      mode = savedMode;
    }
    if (groups.every((g) => g.mode != mode)) {
      mode = groups.isNotEmpty ? groups.first.mode : ServiceModeKind.transport;
    }
    if (selectedServiceModeSubject.valueOrNull != mode) {
      selectedServiceModeSubject.add(mode);
    }
    _refreshFilteredServices(groups, mode);
    final filtered = filteredServicesSubject.valueOrNull ?? [];
    if (filtered.isNotEmpty) {
      vehicleSelect(0);
    }
  }

  void selectServiceMode(String mode) {
    if (selectedServiceModeSubject.valueOrNull == mode) return;
    selectedServiceModeSubject.add(mode);
    putDataInUserPrefBox(hivePassengerLastServiceMode, mode);
    final response = subjectServiceData.valueOrNull?.data;
    var groups = (response?.serviceModes ?? []).isNotEmpty
        ? response!.serviceModes!
        : ServiceModeKind.groupsFromFlatServices(response?.services ?? []);
    groups = ServiceModeKind.filterServiceModeGroupsForFeatureFlags(groups);
    groups = ServiceModeKind.enrichFlaggedModeGroups(groups, response?.services ?? []);
    _refreshFilteredServices(groups, mode);
    final filtered = filteredServicesSubject.valueOrNull ?? [];
    if (filtered.isNotEmpty) {
      vehicleSelect(0);
    } else {
      subjectSelectedServiceData.add(null);
    }
    if (mode != ServiceModeKind.delivery) {
      packageWeightController.add('');
      packageHeightController.add('');
      packageWidthController.add('');
      packageLengthController.add('');
    }
    changePolylineColorPerTheme();
  }

  bool get isEncomiendasMode =>
      selectedServiceModeSubject.valueOrNull == ServiceModeKind.encomiendas;

  bool get isDeliveryMode =>
      (selectedServiceModeSubject.valueOrNull ?? ServiceModeKind.transport) == ServiceModeKind.delivery;

  bool get isCourierLikeBooking {
    final mode = selectedServiceModeSubject.valueOrNull ?? ServiceModeKind.transport;
    if (mode == ServiceModeKind.transport) {
      return false;
    }
    if (mode == ServiceModeKind.delivery || mode == ServiceModeKind.encomiendas) {
      return true;
    }
    return (subjectSelectedServiceData.valueOrNull?.serviceId ?? 0) == ServiceType.courier;
  }

  Future<void> refreshLocationHistory() async {
    final serviceId = subjectSelectedServiceData.valueOrNull?.serviceId ?? 0;
    final trips = await PassengerLocationHistoryService.recentTripsForBooking(serviceId);
    locationHistorySubject.add(trips);
  }

  /// Fills destination only from a recent trip (keeps current pickup).
  void applyRecentDestinationEntry(Map<String, dynamic> entry) {
    final destination = PassengerLocationHistoryService.destinationFromEntry(entry);
    toAddressController.add(destination);
    setMarkers();
    mapApiCall();
  }

  void _refreshFilteredServices(List<ServiceModeGroup> groups, String mode) {
    if (ServiceModeKind.isDeliveryLikeMode(mode)) {
      final list = XistiVehicleCatalog.mergeDeliveryApi(
        deliveryVehicleOptions,
        serviceMode: mode,
      );
      filteredServicesSubject.add(list);
      return;
    }
    ServiceModeGroup? matched;
    for (final g in groups) {
      if (g.mode == mode) {
        matched = g;
        break;
      }
    }
    var list = List<ServiceTypeItem>.from(matched?.services ?? []);
    if (list.isEmpty) {
      list = ServiceModeKind.filterByMode(
        subjectServiceData.valueOrNull?.data?.services ?? [],
        mode,
      );
    }
    if (list.isEmpty && mode == ServiceModeKind.transport) {
      list = (subjectServiceData.valueOrNull?.data?.services ?? [])
          .where((s) => !ServiceModeKind.isDeliveryServiceId(s.serviceId))
          .where((s) => s.serviceId != ServiceType.rickshaw)
          .toList();
    }
    if (mode == ServiceModeKind.transport) {
      list = XistiVehicleCatalog.mergeTransportApi(list);
    } else if (list.isEmpty && deliveryVehicleOptions.isNotEmpty) {
      list = XistiVehicleCatalog.mergeDeliveryApi(deliveryVehicleOptions);
    }
    list.sort(_serviceDisplayOrder);
    filteredServicesSubject.add(list);
  }

  void vehicleSelect(int position) {
    final filtered = filteredServicesSubject.valueOrNull ?? [];
    if (position < 0 || position >= filtered.length) return;
    final selectedServiceType = filtered[position];
    subjectSelectedServiceData.sink.add(selectedServiceType);
    if (ServiceModeKind.isDeliveryLikeMode(selectedServiceModeSubject.valueOrNull)) {
      final variant = selectedServiceType.deliveryVariant ?? '';
      DeliveryVehicleOption? matched;
      for (final opt in deliveryVehicleOptions) {
        if (opt.vehicleServiceId == selectedServiceType.serviceId &&
            (opt.deliveryVariant ?? '') == variant) {
          matched = opt;
          break;
        }
      }
      matched ??= (position >= 0 && position < deliveryVehicleOptions.length)
          ? deliveryVehicleOptions[position]
          : null;
      if (matched?.vehicleServiceId != null) {
        selectedDeliveryVehicleServiceId.add(matched!.vehicleServiceId);
      }
    }
    offerFareAmountController.sink.add(null);
    if ((fromAddressController.valueOrNull?.name ?? "").isNotEmpty && (toAddressController.valueOrNull?.name ?? "").isNotEmpty) {
      callRideCalculationApi();
    }
  }

  void openAdditionalOptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.9),
      builder: (context) {
        return AdditionalOptionSheet(
          comment: commentController.valueOrNull ?? "",
          childSafety: childSafetyController.valueOrNull ?? false,
          handicap: handyCapAccessibilityController.valueOrNull ?? false,
          bookForOther: bookForOtherController.valueOrNull ?? false,
          otherContact: otherContactController.valueOrNull ?? "",
          otherContactName: otherContactNameController.valueOrNull ?? "",
          selectedService: subjectSelectedServiceData.valueOrNull?.serviceId ?? 0,
          onSubmit: (comment, childSafety, handicap, bookForOther, otherContact, otherContactName) {
            commentController.sink.add(comment);
            childSafetyController.sink.add(childSafety);
            handyCapAccessibilityController.sink.add(handicap);
            bookForOtherController.sink.add(bookForOther);
            otherContactController.sink.add(otherContact);
            otherContactNameController.sink.add(otherContactName);
            if (comment.isNotEmpty || childSafety || handicap || otherContact.isNotEmpty) {
              additionalOptionController.sink.add(true);
            } else {
              additionalOptionController.sink.add(false);
            }
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void openOfferFareBottomSheet() {
    if (getStringFromUserInfoBox(hiveProfileImage).trim().isEmpty) {
      showProfileImageRequiredSheet(context);
      return;
    }
    if ((subjectSelectedServiceData.valueOrNull?.serviceId ?? 0) <= 0) {
      openSimpleSnackbar(context, languages.selectVehicle);
      return;
    }
    if (isEncomiendasMode) {
      if (purchaseDescriptionTEC.text.trim().isEmpty) {
        openSimpleSnackbar(context, 'Indica qué quieres que compren');
        return;
      }
      if (priceCapTEC.text.trim().isEmpty) {
        openSimpleSnackbar(context, 'Indica el tope de precio');
        return;
      }
      itemDescController.sink.add(purchaseDescriptionTEC.text.trim());
      itemEstimatedPriceController.sink.add(priceCapTEC.text.trim());
    }
    if ((fromAddressController.valueOrNull?.name ?? "").isEmpty) {
      openSimpleSnackbar(context, isEncomiendasMode ? 'Selecciona dónde comprar' : languages.selectPickup);
      return;
    }
    if ((toAddressController.valueOrNull?.name ?? "").isEmpty) {
      openSimpleSnackbar(context, isEncomiendasMode ? 'Selecciona dónde entregar' : languages.selectDrop);
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.9),
      builder: (context) {
        return OfferFareAndBookSheet(
          isCourier: isCourierLikeBooking && !isEncomiendasMode,
          isEncomienda: isEncomiendasMode,
          deliveryVehicleOptions: deliveryVehicleOptions,
          deliveryDisclaimer: isEncomiendasMode ? encomiendaPassengerDisclaimer : deliveryPassengerDisclaimer,
          selectedDeliveryVehicleServiceId: selectedDeliveryVehicleServiceId.valueOrNull,
          recommendedFare: recommendedPriceSubject.valueOrNull ?? 0,
          minFare: minPriceSubject.valueOrNull ?? 0,
          maxFare: maxPriceSubject.valueOrNull ?? 0,
          minutes: "${timeController.valueOrNull} ${languages.minute}",
          km: "${distanceController.valueOrNull} ${languages.km}",
          estimatedPrice: itemEstimatedPriceController.valueOrNull ?? "",
          recipientName: recipientNameController.valueOrNull ?? "",
          recipientNumber: recipientNumberController.valueOrNull ?? "",
          parcelNote: itemDescController.valueOrNull ?? "",
          destinationPaymentMethod: destinationPaymentMethodController.valueOrNull ?? DestinationPaymentUtil.cash,
          packageWeightKg: packageWeightController.valueOrNull ?? "",
          packageHeightCm: packageHeightController.valueOrNull ?? "",
          packageWidthCm: packageWidthController.valueOrNull ?? "",
          packageLengthCm: packageLengthController.valueOrNull ?? "",
          autoAccept: autoAcceptController.valueOrNull ?? 0,
          paymentType: paymentTypeController.valueOrNull ?? 0,
          scheduleDate: scheduleDateController.valueOrNull,
          onSubmit: (offerFare, paymentType, destinationPaymentMethod, scheduleDate, autoAccept, recipientName, recipientNumber, estimatedPrice, parcelNote, packageWeightKg, packageHeightCm, packageWidthCm, packageLengthCm, requestedVehicleServiceId) {
            recommendedPriceSubject.sink.add(getDoubleFromDynamic(offerFare));
            offerFareAmountController.sink.add(offerFare);
            paymentTypeController.sink.add(paymentType);
            destinationPaymentMethodController.sink.add(destinationPaymentMethod);
            scheduleDateController.sink.add(scheduleDate);
            autoAcceptController.sink.add(autoAccept);
            recipientNameController.sink.add(recipientName);
            recipientNumberController.sink.add(recipientNumber);
            itemEstimatedPriceController.sink.add(estimatedPrice);
            itemDescController.sink.add(parcelNote);
            packageWeightController.sink.add(packageWeightKg);
            packageHeightController.sink.add(packageHeightCm);
            packageWidthController.sink.add(packageWidthCm);
            packageLengthController.sink.add(packageLengthCm);
            if (requestedVehicleServiceId > 0) {
              selectedDeliveryVehicleServiceId.add(requestedVehicleServiceId);
            }
            Navigator.pop(context);
            callBookRideApi();
          },
        );
      },
    );
  }

  void onCameraMoved(CameraPosition cameraPosition) {
    if ((toAddressController.valueOrNull?.name ?? "").isEmpty && (addStopAddressList.valueOrNull ?? []).isEmpty && !isFromBottomSheet) {
      mapLoadController.sink.add(true);
      this.cameraPosition = cameraPosition;
    }
  }

  Future<void> onCameraIdle() async {
    if (cameraPosition != null &&
        (toAddressController.valueOrNull?.name ?? "").isEmpty &&
        (addStopAddressList.valueOrNull ?? []).isEmpty &&
        !isFromBottomSheet) {
      getStringAddress(cameraPosition?.target.latitude ?? 0, cameraPosition?.target.longitude ?? 0).then((value) {
        if (!context.mounted) return;
        mapLoadController.sink.add(false);
        fromAddressController.sink.add(SearchedLocation(name: value, lat: cameraPosition?.target.latitude ?? 0, lng: cameraPosition?.target.longitude ?? 0));
        setMarkers();
        mapApiCall();
      });
    }
    isFromBottomSheet = false;
  }

  void selectAddress({required int selectedIndex, bool isAddStopAddress = false}) {
    openRequiredInfoBottomSheet(context, () {
      openScreen(
        context,
        SetRouteScreen(
          fromAddress: fromAddressController.valueOrNull,
          toAddress: toAddressController.valueOrNull,
          stopAddressList: addStopAddressList.valueOrNull,
          isAddStopAddress: isAddStopAddress,
          selectedIndex: selectedIndex,
          serviceId: subjectSelectedServiceData.valueOrNull?.serviceId ?? 0,
          onConfirmLocation: (fromAddress, toAddress, addressList) {
            fromAddressController.sink.add(fromAddress);
            toAddressController.sink.add(toAddress);
            addStopAddressList.sink.add(addressList ?? []);
            Navigator.pop(context);
            if ((toAddressController.valueOrNull?.name ?? "").isEmpty &&
                (addStopAddressList.valueOrNull ?? []).isEmpty &&
                fromAddressController.valueOrNull?.lat != null &&
                fromAddressController.valueOrNull?.lng != null) {
              isFromBottomSheet = true;
              focusInMap(googleMapController!, fromAddressController.valueOrNull?.lat, fromAddressController.valueOrNull?.lng, true);
            }
            setMarkers();
            mapApiCall();
          },
        ),
      );
    });
  }

  void clearMapData() {
    markersListController.sink.add([]);
    polyLinesController.sink.add({});
  }

  void removeStopAddress(int index) {
    List<SearchedLocation>? stopAddressList = addStopAddressList.valueOrNull ?? [];
    stopAddressList.removeAt(index);
    addStopAddressList.sink.add(stopAddressList);
    removeMarkers();
    mapApiCall();
  }

  SearchedLocation getAddressFromJson(dynamic json) {
    LatLng latLng = json["lat_long"] ?? defaultLatLng;
    return SearchedLocation(name: json["address"] ?? "", lat: latLng.latitude, lng: latLng.longitude, latLng: latLng);
  }

  Future<void> onMapCreated(GoogleMapController googleMapController) async {
    this.googleMapController = googleMapController;
    await getCurrentLocation();
  }

  void focusCurrentPosition() {
    getLocationUtils.getLocationUtils(
      (locationData) {},
      (locationData, address) {
        _updateCityZonesForCoordinates(locationData.latitude, locationData.longitude);
        if (googleMapController != null) {
          focusInMap(googleMapController!, locationData.latitude, locationData.longitude, true);
        }
      },
      getForceFully: true,
      isGetAddress: false,
    );
  }

  bool _regionPromptInFlight = false;

  void _applyRegionToUi(ResolvedXistiRegion region) {
    activeMainCitySubject.add(region.city.displayName);
    activeCityZonesSubject.add(region.city.zones);
    final recommended = recommendedPriceSubject.valueOrNull;
    final currentMin = minPriceSubject.valueOrNull;
    final currentMax = maxPriceSubject.valueOrNull;
    if (recommended != null && currentMin != null && currentMax != null) {
      final fares = normalizePassengerFareRange(
        recommendedFare: recommended,
        minPrice: currentMin,
        maxPrice: currentMax,
      );
      recommendedPriceSubject.sink.add(fares.recommended);
      minPriceSubject.sink.add(fares.minPrice);
      maxPriceSubject.sink.add(fares.maxPrice);
      return;
    }
    final regionalMin = getRegionMinFareFromSettings();
    if (regionalMin > 0) {
      minPriceSubject.sink.add(
        currentMin == null ? regionalMin : applyRegionalMinFareFloor(currentMin),
      );
    }
  }

  Future<void> _updateCityZonesForCoordinates(double lat, double lng) async {
    if (_regionPromptInFlight) return;
    final preview = XistiRegionService.resolve(lat, lng);
    _applyRegionToUi(preview);

    final prompt = XistiRegionService.promptForCoordinates(lat, lng);
    if (prompt == null) {
      _applyRegionToUi(XistiRegionService.activeRegion());
      return;
    }

    _regionPromptInFlight = true;
    if (!context.mounted) {
      _regionPromptInFlight = false;
      return;
    }
    await handleRegionPromptIfNeeded(
      context,
      lat,
      lng,
      onRegionApplied: _applyRegionToUi,
    );
    _regionPromptInFlight = false;
  }

  Future<void> getCurrentLocation() async {
    subjectServiceData.add(ApiResponse.loading());
    getLocationUtils.getLocationUtils(
      (locationData) {
        currentLatLng = LatLng(locationData.latitude, locationData.longitude);
        _updateCityZonesForCoordinates(locationData.latitude, locationData.longitude);
        if (googleMapController != null) {
          focusInMap(googleMapController!, locationData.latitude, locationData.longitude, true);
        }
        if (isFromLogin) {
          callPassengerRunningServiceApi();
        } else {
          callHomeApi();
        }
        callNearestDriverApi(locationData);
      },
      (locationData, address) {
        fromAddressController.sink.add(
          SearchedLocation(
            name: address,
            lat: locationData.latitude,
            lng: locationData.longitude,
            latLng: LatLng(locationData.latitude, locationData.longitude),
          ),
        );
        setMarkers();
      },
      getForceFully: true,
      isGetAddress: true,
    );
  }

  Future<void> mapApiCall() async {
    if ((fromAddressController.valueOrNull?.name ?? "").isNotEmpty && (toAddressController.valueOrNull?.name ?? "").isNotEmpty) {
      List<LatLng> wayPointsList = [];
      if ((addStopAddressList.valueOrNull?.isNotEmpty ?? false) && !isCourierLikeBooking) {
        addStopAddressList.valueOrNull?.forEach((element) {
          wayPointsList.add(LatLng(element.lat ?? 0, element.lng ?? 0));
        });
      }
      mapApiSubject.sink.add(true);
      await GetRoutesUtils().getRoutes(
        LatLng(fromAddressController.valueOrNull?.lat ?? 0, fromAddressController.valueOrNull?.lng ?? 0),
        LatLng(toAddressController.valueOrNull?.lat ?? 0, toAddressController.valueOrNull?.lng ?? 0),
        wayPointsList,
        (polyLines, duration, distance) async {
          debugPrint("my map data is : $duration $distance");
          mapApiSubject.sink.add(false);
          polyLinesController.sink.add(polyLines);
          changePolylineColorPerTheme();
          timeController.sink.add((duration / 60).round());
          distanceController.sink.add(getDoubleFromDynamic((distance / 1000).toStringAsFixed(2)));
          if (googleMapController != null) {
            setMapFitToTour(polyline: Set<Polyline>.of(polyLines.values), controller: googleMapController!, padding: 50.sp);
          }
          offerFareAmountController.sink.add(null);
          callRideCalculationApi();
        },
      );
    }
  }

  Future<void> removeMarkers() async {
    List<Marker> markerList = markersListController.valueOrNull ?? [];

    if ((addStopAddressList.valueOrNull?.isNotEmpty ?? false) && ((addStopAddressList.valueOrNull?.length ?? 0) > 0)) {
      addStopAddressList.valueOrNull?.asMap().forEach((int index, SearchedLocation searchedLocation) {
        int stopNumber = index + 1;
        int pos = markerList.indexWhere((item) => item.markerId == MarkerId("stop$stopNumber"));
        if (pos >= 0) {
          markerList.removeAt(pos);
        }
      });
    }
    markersListController.sink.add(markerList);
  }

  Future<void> refreshActivityHub() async {
    try {
      final response = PassengerRunningPojo.fromJson(await _splashRepo.getPassengerRunningServiceApi());
      if (!context.mounted) return;
      if (response.status == 1 && (response.rideId ?? 0) > 0) {
        final details = response.rideDetails;
        final firstDetail = (details != null && details.isNotEmpty) ? details.first : null;
        final addresses = firstDetail?.addressList;
        final lastAddress = (addresses != null && addresses.isNotEmpty) ? addresses.last.address : null;
        final statusLabel = _activityStatusLabel(response.rideStatus ?? 0);
        activityHubSubject.add(
          PassengerActivitySnapshot.active(
            rideId: response.rideId ?? 0,
            rideStatus: response.rideStatus ?? 0,
            serviceId: firstDetail?.serviceId,
            title: statusLabel,
            subtitle: lastAddress ?? 'Viaje en curso',
          ),
        );
        return;
      }
    } catch (_) {
      // Hub is optional — fall through to recent trip.
    }
    final history = locationHistorySubject.valueOrNull ?? [];
    if (history.isNotEmpty) {
      final entry = history.first;
      final dest = entry['destination_name']?.toString() ?? '';
      if (dest.isNotEmpty) {
        activityHubSubject.add(
          PassengerActivitySnapshot.recent(
            destinationName: dest,
            destinationLat: getDoubleFromDynamic(entry['destination_lat']),
            destinationLng: getDoubleFromDynamic(entry['destination_long']),
            serviceLabel: entry['is_delivery'] == 1 ? 'envío' : 'viaje',
          ),
        );
        return;
      }
    }
    activityHubSubject.add(null);
  }

  String _activityStatusLabel(int rideStatus) {
    switch (rideStatus) {
      case 0:
        return 'Buscando conductor';
      case 1:
      case 2:
        return 'Viaje confirmado';
      case 3:
        return 'Conductor en camino';
      case 5:
        return 'Viaje en curso';
      default:
        return 'Actividad activa';
    }
  }

  Future<void> openActivityHub() async {
    final snapshot = activityHubSubject.valueOrNull;
    if (snapshot == null) return;
    if (snapshot.isActive) {
      try {
        final response = PassengerRunningPojo.fromJson(await _splashRepo.getPassengerRunningServiceApi());
        if (!context.mounted || (response.rideId ?? 0) == 0) return;
        if (response.rideStatus == 0 && (response.rideDetails ?? []).isNotEmpty) {
          final rideDetail = response.rideDetails!.first;
          openScreen(
            context,
            OfferRideScreen(
              rideId: rideDetail.rideId ?? 0,
              serviceType: rideDetail.serviceId ?? 0,
              addressList: rideDetail.addressList ?? [],
              fareAmount: '${rideDetail.offeredPrice ?? 0}',
              itemDesc: rideDetail.itemDescription ?? '',
              recipientName: rideDetail.recipientName ?? '',
              recipientNumber: rideDetail.recipientContactNumber ?? '',
              minFareAmount: rideDetail.minBargainAmt ?? 0,
              maxFareAmount: rideDetail.maxBargainAmt ?? 0,
              estimatedPrice: '${rideDetail.offeredPrice ?? 0}',
            ),
          );
        } else {
          openScreen(context, PassengerRunningRide(rideId: response.rideId ?? 0));
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      return;
    }
    if (snapshot.destinationName != null) {
      applyRecentDestinationEntry({
        'destination_name': snapshot.destinationName,
        'destination_lat': snapshot.destinationLat,
        'destination_long': snapshot.destinationLng,
      });
    }
  }

  Future<void> flyToBarrio(XistiBarrioShortcut barrio) async {
    if (googleMapController == null) return;
    await googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: barrio.latLng, zoom: 14),
      ),
    );
  }

  void changePolylineColorPerTheme() {
    Map<PolylineId, Polyline> polyLines = polyLinesController.valueOrNull ?? {};
    if (polyLines.isNotEmpty) {
      final mode = selectedServiceModeSubject.valueOrNull;
      final lineColor = XistiUiTokens.polylineColorForMode(mode);
      final oldPolyline = polyLines[PolylineId("poly")]!;
      final updatedPolyline = oldPolyline.copyWith(
        colorParam: lineColor,
        widthParam: 5,
      );
      polyLines[PolylineId("poly")] = updatedPolyline;
    }
    polyLinesController.sink.add(polyLines);
  }

  Future<void> setMarkers() async {
    if ((fromAddressController.valueOrNull?.name ?? "").isEmpty &&
        (toAddressController.valueOrNull?.name ?? "").isEmpty) {
      return;
    }
    if (!context.mounted) return;
    List<Marker> markerList = markersListController.valueOrNull ?? [];
    if ((fromAddressController.valueOrNull?.name ?? "").isNotEmpty) {
      BitmapDescriptor pickUpMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, 'ic_pin_pickup_location.png'));
      if (!context.mounted) return;
      int pos = markerList.indexWhere((item) => item.markerId == const MarkerId("pickup"));
        if (pos >= 0) {
          Marker currentMarker = markerList[pos];
          Marker currentNewMarker = Marker(
            markerId: currentMarker.markerId,
            position: LatLng(fromAddressController.valueOrNull?.lat ?? 0, fromAddressController.valueOrNull?.lng ?? 0),
            icon: pickUpMarkerIcon,
            infoWindow: currentMarker.infoWindow,
          );
          markerList[pos] = currentNewMarker;
        } else {
          markerList.add(
            Marker(
              markerId: const MarkerId("pickup"),
              position: LatLng(fromAddressController.valueOrNull?.lat ?? 0, fromAddressController.valueOrNull?.lng ?? 0),
              icon: pickUpMarkerIcon,
              infoWindow: InfoWindow(title: languages.pickUpLocation),
            ),
          );
        }
      }

      if ((toAddressController.valueOrNull?.name ?? "").isNotEmpty) {
        if (!context.mounted) return;
        BitmapDescriptor destinationMarkerIcon = await getBitmapDescriptorFromAssetBytes(
          path: setImagesBasedOnTheme(context, 'ic_pin_destination_location.png'),
        );
        int pos = markerList.indexWhere((item) => item.markerId == const MarkerId("destination"));
        if (pos >= 0) {
          Marker currentMarker = markerList[pos];
          Marker currentNewMarker = Marker(
            markerId: currentMarker.markerId,
            position: LatLng(toAddressController.valueOrNull?.lat ?? 0, toAddressController.valueOrNull?.lng ?? 0),
            icon: destinationMarkerIcon,
            infoWindow: currentMarker.infoWindow,
          );
          markerList[pos] = currentNewMarker;
        } else {
          markerList.add(
            Marker(
              markerId: const MarkerId("destination"),
              position: LatLng(toAddressController.valueOrNull?.lat ?? 0, toAddressController.valueOrNull?.lng ?? 0),
              icon: destinationMarkerIcon,
              infoWindow: InfoWindow(title: languages.dropLocation),
            ),
          );
        }
      }

      if ((addStopAddressList.valueOrNull?.isNotEmpty ?? false) &&
          ((addStopAddressList.valueOrNull?.length ?? 0) > 0) &&
          !isCourierLikeBooking) {
        addStopAddressList.valueOrNull?.asMap().forEach((int index, SearchedLocation searchedLocation) async {
          int stopNumber = index + 1;
          int pos = markerList.indexWhere((item) => item.markerId == MarkerId("stop$stopNumber"));
          BitmapDescriptor stopMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, 'stop_location.png'));

          if (pos >= 0) {
            Marker currentMarker = markerList[pos];
            Marker currentNewMarker = Marker(
              markerId: currentMarker.markerId,
              position: LatLng(searchedLocation.lat, searchedLocation.lng),
              icon: stopMarkerIcon,
              infoWindow: currentMarker.infoWindow,
            );
            markerList[pos] = currentNewMarker;
          } else {
            markerList.add(
              Marker(
                markerId: MarkerId("stop$stopNumber"),
                position: LatLng(searchedLocation.lat, searchedLocation.lng),
                icon: stopMarkerIcon,
                infoWindow: InfoWindow(title: "${languages.stop} $stopNumber"),
              ),
            );
          }
        });
      }
    markersListController.sink.add(markerList);
  }

  void openDemoSheet() {
    if (!getBoolFromSettingBox(hiveDemoSheetOpen)) {
      Future.delayed(const Duration(seconds: 1), () {
        if (!context.mounted) return;
        showModalBottomSheet(
          context: context,
          enableDrag: false,
          isDismissible: false,
          barrierColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            demoSheetContext = context;
            return WarningBottomSheet();
          },
        ).then((value) {
          demoSheetContext = null;
          if (!context.mounted) return;
          showModalBottomSheet(
            context: context,
            enableDrag: false,
            isDismissible: false,
            isScrollControlled: true,
            barrierColor: Colors.transparent,
            builder: (context) {
              demoSheetContext = context;
              putDataInSettingBox(hiveDemoSheetOpen, true);
              return ProductBottomSheet();
            },
          ).then((value) {
            demoSheetContext = null;
          });
        });
      });
    }
  }

  @override
  void dispose() {
    subjectServiceData.close();
    selectedServiceModeSubject.close();
    filteredServicesSubject.close();
    markersListController.close();
    rotateMarkerListController.close();
    polyLinesController.close();
    fromAddressController.close();
    toAddressController.close();
    mapApiSubject.close();
    distanceController.close();
    timeController.close();
    offerFareAmountController.close();
    subjectSelectedServiceData.close();
    addStopAddressList.close();
    commentController.close();
    childSafetyController.close();
    handyCapAccessibilityController.close();
    bookForOtherController.close();
    otherContactController.close();
    additionalOptionController.close();
    subjectRideCalculation.close();
    minPriceSubject.close();
    maxPriceSubject.close();
    recommendedPriceSubject.close();
    mapLoadController.close();
    rideBookSubject.close();
    paymentTypeController.close();
    scheduleDateController.close();
    autoAcceptController.close();
    itemDescController.close();
    destinationPaymentMethodController.close();
    packageWeightController.close();
    packageHeightController.close();
    packageWidthController.close();
    packageLengthController.close();
    recipientNameController.close();
    recipientNumberController.close();
    itemEstimatedPriceController.close();
    selectedDeliveryVehicleServiceId.close();
    locationHistorySubject.close();
    activityHubSubject.close();
    activeCityZonesSubject.close();
    activeMainCitySubject.close();
  }
}

int _serviceDisplayOrder(ServiceTypeItem a, ServiceTypeItem b) {
  final byDisplayOrder = (a.displayOrder ?? 999).compareTo(b.displayOrder ?? 999);
  if (byDisplayOrder != 0) {
    return byDisplayOrder;
  }
  return _colombiaServiceFallbackOrder(a).compareTo(_colombiaServiceFallbackOrder(b));
}

int _colombiaServiceFallbackOrder(ServiceTypeItem item) {
  switch (item.serviceId) {
    case 3:
      return 1; // Moto
    case 5:
      return 2; // Moto-ratón
    case 1:
      return 3; // Carro
    case 4:
      return 1; // Envíos (delivery tab)
    default:
      return item.serviceId ?? 999;
  }
}
