import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../blocs/bloc.dart';
import '../../screen/common/wallet/walletHome/wallet_home.dart';
import '../../screen/driverMode/driverHome/driver_home_dl.dart';
import '../../screen/driverMode/driverNewRequest/driver_new_request_dl.dart';
import '../../screen/driverMode/driverWaiting/driver_waiting_dl.dart';
import '../../screen/driverMode/driverWaiting/driver_waiting_repo.dart';
import '../../screen/driverMode/driverNewRequest/driver_new_request_repo.dart';
import '../../screen/driverMode/driverRideHistory/driver_ride_history.dart';
import '../../screen/driverMode/driverRunningRide/driver_running_ride.dart';
import '../../screen/driverMode/driverWaiting/driver_waiting_screen.dart';
import '../../utils/get_route_utils.dart';
import '../../utils/utils.dart';
import '../common_bottom_sheet.dart';

class AcceptRequestBottomSheetBloc extends Bloc {
  BuildContext context;
  RideList rideListItem;
  bool isNearestRide;
  List<int> rideIdList;

  AcceptRequestBottomSheetBloc(this.context, this.rideListItem, this.isNearestRide, this.rideIdList) {
    pushNotificationService.dismissRideNotification(rideListItem.rideId);
  }

  final DriverNewRequestRepo _repo = DriverNewRequestRepo();
  final DriverWaitingRepo _waitingRepo = DriverWaitingRepo();

  GoogleMapController? googleMapController;
  BuildContext? walletBottomSheet;

  final selectedAmountSubject = BehaviorSubject<dynamic>();
  final markersListSubject = BehaviorSubject<List<Marker>>();
  final polyLinesSubject = BehaviorSubject<Map<PolylineId, Polyline>>();
  final mapStyleSubject = BehaviorSubject<String>.seeded("");
  final etaSubject = BehaviorSubject<int>();
  final distanceSubject = BehaviorSubject<double>();
  final driverBidSubject = BehaviorSubject<ApiResponse<DriverBidPojo>>();

  void setNewRideItem(RideList rideListItem) {
    this.rideListItem = rideListItem;
  }

  Future<void> onMapCreated(GoogleMapController value) async {
    googleMapController = value;
    mapApiCall();
    setMarkers();
  }

  Future<bool> _navigateIfRideAlreadyActive() async {
    try {
      final waiting = DriverWaitingPojo.fromJson(await _waitingRepo.getRideStatusApi(rideId: rideListItem.rideId));
      if (waiting.status != 1) return false;
      final accepted = waiting.bidStatus == 1 || waiting.rideStatus == 1 || waiting.rideStatus == 2;
      if (!accepted) return false;
      if (!context.mounted) return true;
      rideIdList.clear();
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      if (waiting.rideType == 1) {
        openScreenWithClearPrevious(context, DriverRideHistory());
      } else {
        openScreenWithClearPrevious(
          context,
          DriverRunningRide(
            rideId: rideListItem.rideId,
            serviceId: rideListItem.serviceId != 0 ? rideListItem.serviceId : ServiceType.taxi,
          ),
        );
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  void _navigateAfterAcceptSuccess() {
    rideIdList.clear();
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    if (rideListItem.rideType == 1) {
      openScreenWithClearPrevious(context, DriverRideHistory());
    } else {
      openScreenWithClearPrevious(
        context,
        DriverRunningRide(
          rideId: rideListItem.rideId,
          serviceId: rideListItem.serviceId != 0 ? rideListItem.serviceId : ServiceType.taxi,
        ),
      );
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
        var response = DriverBidPojo.fromJson(
          await _repo.driverBidApi(rideId: rideListItem.rideId, offerAmount: selectedAmountSubject.valueOrNull ?? (rideListItem.offeredPrice ?? 0)),
        );
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, false, hideMessOnCodeList: [0, 339])) {
          driverBidSubject.sink.add(ApiResponse.completed(response));
          rideIdList.clear();
          Navigator.pop(context);
          openScreenWithTransparentBg(
            context,
            DriverWaitingScreen(
              userProfile: response.userProfile,
              rideId: rideListItem.rideId,
              serviceId: rideListItem.serviceId != 0 ? rideListItem.serviceId : ServiceType.taxi,
              timeOut: response.timeout,
            ),
          );
        } else {
          if (response.messageCode == 339) {
            openWalletBottomSheet(message: message);
          } else if (await _navigateIfRideAlreadyActive()) {
            return;
          } else {
            openSimpleSnackbar(context, message);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        }
      } catch (e) {
        driverBidSubject.sink.add(ApiResponse.error(e.toString()));
        if (await _navigateIfRideAlreadyActive()) {
          return;
        }
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
        var response = DriverBidPojo.fromJson(await _repo.rideAcceptApi(rideListItem.rideId));
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true, showMess: response.messageCode != 23, messageCode: response.messageCode, hideMessOnCodeList: [0, 339, 23])) {
          driverBidSubject.sink.add(ApiResponse.completed(response));
          if (!context.mounted) return;
          _navigateAfterAcceptSuccess();
        } else {
          if (response.messageCode == 339) {
            openWalletBottomSheet(message: message);
          } else if (response.messageCode == 23 || await _navigateIfRideAlreadyActive()) {
            return;
          } else {
            openSimpleSnackbar(context, message);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        }
      } catch (e) {
        driverBidSubject.sink.add(ApiResponse.error(e.toString()));
        if (await _navigateIfRideAlreadyActive()) {
          return;
        }
      }
    }
  }

  Future<void> mapApiCall() async {
    final pickupLat = parseMapCoordinate(rideListItem.addressList.first.addressLat);
    final pickupLng = parseMapCoordinate(rideListItem.addressList.first.addressLong);
    final destinationLat = parseMapCoordinate(rideListItem.addressList.last.addressLat);
    final destinationLng = parseMapCoordinate(rideListItem.addressList.last.addressLong);
    await GetRoutesUtils().getRoutes(
      LatLng(pickupLat, pickupLng),
      LatLng(destinationLat, destinationLng),
      [],
      (polyLines, duration, distance) async {
        if (!context.mounted) return;
        distanceSubject.sink.add(getDoubleFromDynamic((distance / 1000).toStringAsFixed(2)));
        etaSubject.sink.add((duration / 60).round());
        polyLinesSubject.sink.add(polyLines);
        if (googleMapController == null) return;
        final hasRoutePoints = polyLines.values.any((line) => line.points.isNotEmpty);
        if (hasRoutePoints) {
          setMapFitToTour(polyline: Set<Polyline>.of(polyLines.values), controller: googleMapController!, padding: 30.sp);
        } else {
          setMapFitToTourUsingLatLng(
            latList: [pickupLat, destinationLat],
            longList: [pickupLng, destinationLng],
            controller: googleMapController!,
            padding: 30.sp,
          );
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

  Future<void> setMarkers() async {
    List<Marker> markerList = [];
    BitmapDescriptor pickUpMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, "ic_pin_pickup_location.png"));
    if (!context.mounted) return;
    BitmapDescriptor destinationMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, "ic_pin_destination_location.png"));
    markerList.add(
      Marker(
        markerId: const MarkerId("pickup"),
        position: LatLng(
          parseMapCoordinate(rideListItem.addressList.first.addressLat),
          parseMapCoordinate(rideListItem.addressList.first.addressLong),
        ),
        icon: pickUpMarkerIcon,
        infoWindow: InfoWindow(title: languages.pickUpLocation),
      ),
    );
    markerList.add(
      Marker(
        markerId: const MarkerId("destination"),
        position: LatLng(
          parseMapCoordinate(rideListItem.addressList.last.addressLat),
          parseMapCoordinate(rideListItem.addressList.last.addressLong),
        ),
        icon: destinationMarkerIcon,
        infoWindow: InfoWindow(title: languages.dropLocation),
      ),
    );
    markersListSubject.sink.add(markerList);
  }

  Future<Null> openWalletBottomSheet({required String message}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        walletBottomSheet = context;
        return CommonBottomSheet(
          title: message,
          positiveButtonTxt: languages.ok,
          onPositivePress: () {
            if (!context.mounted) return;
            openScreenWithResult(context, const WalletHome()).then((value) {
              if (!context.mounted) return;
              Navigator.pop(context);
            });
          },
        );
      },
    ).then((value) {
      if (!context.mounted) return;
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    selectedAmountSubject.close();
    markersListSubject.close();
    polyLinesSubject.close();
    mapStyleSubject.close();
    etaSubject.close();
    distanceSubject.close();
    driverBidSubject.close();
  }
}
