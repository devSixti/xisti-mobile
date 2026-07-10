import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/get_route_utils.dart';
import '../../../utils/map_utils.dart';
import '../../../utils/shared_pref_util.dart';
import '../../../utils/utils.dart';
import '../driverHome/driver_home.dart';
import '../driverRideHistory/driver_ride_history.dart';
import '../driverRunningRide/driver_running_ride.dart';
import '../driverWaiting/driver_waiting_screen.dart';
import 'driver_new_request_dl.dart';
import 'driver_new_request_repo.dart';

class DriverNewRequestBloc extends Bloc {
  BuildContext context;
  int rideId;

  DriverNewRequestBloc(this.context, this.rideId) {
    newRequestSubject.sink.add(ApiResponse.loading());
    setPrefNotificationData(null);
    pushNotificationService.dismissRideNotification(rideId);
  }

  final DriverNewRequestRepo _repo = DriverNewRequestRepo();

  GoogleMapController? googleMapController;
  BuildContext? walletBottomSheet;

  final selectedAmountSubject = BehaviorSubject<dynamic>();
  final markersListSubject = BehaviorSubject<List<Marker>>();
  final polyLinesSubject = BehaviorSubject<Map<PolylineId, Polyline>>();
  final mapStyleSubject = BehaviorSubject<String>.seeded("");
  final etaSubject = BehaviorSubject<int>();
  final distanceSubject = BehaviorSubject<double>();
  final driverBidSubject = BehaviorSubject<ApiResponse<DriverBidPojo>>();
  final newRequestSubject = BehaviorSubject<ApiResponse<NewRequestPojo>>();

  Future<void> callGetRideApi() async {
    // newRequestSubject.sink.add(ApiResponse.error("message"));
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callGetRideApi();
      },
    )) {
      newRequestSubject.sink.add(ApiResponse.loading());
      try {
        var response = NewRequestPojo.fromJson(await _repo.getRideApi(rideId: rideId));
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          newRequestSubject.sink.add(ApiResponse.completed(response));
          mapApiCall(response);
          setMarkers(response);
          selectedAmountSubject.sink.add(response.offeredPrice ?? 0);
        } else {
          newRequestSubject.sink.add(ApiResponse.error(message));
          openScreenWithClearPrevious(context, const DriverHome());
        }
      } catch (e) {
        newRequestSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> callDriverBidApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callDriverBidApi();
      },
    )) {
      driverBidSubject.sink.add(ApiResponse.loading());
      try {
        var response = DriverBidPojo.fromJson(await _repo.driverBidApi(rideId: rideId, offerAmount: selectedAmountSubject.valueOrNull ?? (newRequestSubject.valueOrNull?.data?.offeredPrice ?? 0)));
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, false, hideMessOnCodeList: [335], showMess: false)) {
          driverBidSubject.sink.add(ApiResponse.completed(response));
          openScreenWithTransparentBg(
            context,
            DriverWaitingScreen(
              userProfile: response.userProfile,
              rideId: rideId,
              serviceId: newRequestSubject.valueOrNull?.data?.serviceId ?? ServiceType.taxi,
              timeOut: response.timeout,
            ),
          );
          player.stop();
        } else {
          openSimpleSnackbar(context, message);
          openScreenWithClearPrevious(context, const DriverHome());
          driverBidSubject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        driverBidSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> acceptRideApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        acceptRideApi();
      },
    )) {
      driverBidSubject.sink.add(ApiResponse.loading());
      try {
        var response = DriverBidPojo.fromJson(await _repo.rideAcceptApi(rideId));
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true, showMess: true, messageCode: response.messageCode, hideMessOnCodeList: [0, 339])) {
          driverBidSubject.sink.add(ApiResponse.completed(response));
          if (newRequestSubject.valueOrNull?.data?.rideType == 1) {
            openScreenWithClearPrevious(context, DriverRideHistory());
          } else {
            openScreenWithClearPrevious(
              context,
              DriverRunningRide(rideId: rideId, serviceId: newRequestSubject.valueOrNull?.data?.serviceId ?? ServiceType.taxi),
            );
          }
        } else {
          openSimpleSnackbar(context, message);
          openScreenWithClearPrevious(context, const DriverHome());
          driverBidSubject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        driverBidSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> onMapCreated(GoogleMapController value) async {
    googleMapController = value;
    callGetRideApi();
  }

  Future<void> mapApiCall(NewRequestPojo requestPojo) async {
    if (requestPojo.addressList.isEmpty) return;
    final pickupLat = getDoubleFromDynamic(requestPojo.addressList.first.addressLat.toString());
    final pickupLng = getDoubleFromDynamic(requestPojo.addressList.first.addressLong.toString());
    final destinationLat = getDoubleFromDynamic(requestPojo.addressList.last.addressLat.toString());
    final destinationLng = getDoubleFromDynamic(requestPojo.addressList.last.addressLong.toString());
    final pickupValid = isValidMapCoordinate(pickupLat, pickupLng);
    final destinationValid = isValidMapCoordinate(destinationLat, destinationLng);

    if (googleMapController != null && pickupValid) {
      focusInMap(googleMapController!, pickupLat, pickupLng, true);
    }
    if (!pickupValid || !destinationValid) {
      return;
    }

    await GetRoutesUtils().getRoutes(
      LatLng(pickupLat, pickupLng),
      LatLng(destinationLat, destinationLng),
      [],
      (polyLines, duration, distance) async {
        if (!context.mounted) return;
        distanceSubject.sink.add(getDoubleFromDynamic((distance / 1000).toStringAsFixed(2)));
        etaSubject.sink.add((duration / 60).round());
        polyLinesSubject.sink.add(polyLines);
        if (googleMapController != null) {
          setMapFitToTour(polyline: Set<Polyline>.of(polyLines.values), controller: googleMapController!, padding: 30.sp);
        }
      },
    );
  }

  void changePolylineColorPerTheme() {
    Map<PolylineId, Polyline> polyLines = polyLinesSubject.valueOrNull ?? {};
    if (polyLines.isNotEmpty) {
      final oldPolyline = polyLines[PolylineId("poly")]!;
      final updatedPolyline = oldPolyline.copyWith(colorParam: getCurrentTheme(context).colorBlack);
      polyLines[PolylineId("poly")] = updatedPolyline;
    }
    polyLinesSubject.sink.add(polyLines);
  }

  Future<void> setMarkers(NewRequestPojo requestPojo) async {
    if (requestPojo.addressList.isEmpty) return;
    List<Marker> markerList = [];
    BitmapDescriptor pickUpMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, "ic_pin_pickup_location.png"));
    if (!context.mounted) return;
    BitmapDescriptor destinationMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, "ic_pin_destination_location.png"));
    final pickupLat = getDoubleFromDynamic(requestPojo.addressList.first.addressLat.toString());
    final pickupLng = getDoubleFromDynamic(requestPojo.addressList.first.addressLong.toString());
    final destinationLat = getDoubleFromDynamic(requestPojo.addressList.last.addressLat.toString());
    final destinationLng = getDoubleFromDynamic(requestPojo.addressList.last.addressLong.toString());
    if (isValidMapCoordinate(pickupLat, pickupLng)) {
      markerList.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: LatLng(pickupLat, pickupLng),
          icon: pickUpMarkerIcon,
          infoWindow: InfoWindow(title: languages.pickUpLocation),
        ),
      );
    }
    if (isValidMapCoordinate(destinationLat, destinationLng)) {
      markerList.add(
        Marker(
          markerId: const MarkerId("destination"),
          position: LatLng(destinationLat, destinationLng),
          icon: destinationMarkerIcon,
          infoWindow: InfoWindow(title: languages.dropLocation),
        ),
      );
    }
    markersListSubject.sink.add(markerList);
  }

  @override
  void dispose() {}
}
