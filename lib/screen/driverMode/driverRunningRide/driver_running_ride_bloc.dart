import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/cancel_ride_bottom_sheet.dart';
import '../../../bottomSheet/common_bottom_sheet.dart';
import '../../../bottomSheet/enter_otp_bottom_sheet.dart';
import '../../../bottomSheet/enter_toll_amount_bottom_sheet.dart';
import '../../../bottomSheet/rating_bottom_sheet.dart';
import '../../../commonView/scaffold_with_safe_area.dart';
import '../../../commonView/statusView/driver_ride_status_view.dart';
import '../../../constant/chat_constant.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/base_dl.dart';
import '../../../services/push_notification_service.dart';
import '../../../utils/get_route_utils.dart';
import '../../../services/active_ride_offline_service.dart';
import '../../../services/dispatch_trigger_service.dart';
import '../../../services/ride_action_queue_service.dart';
import '../../../utils/utils.dart';
import '../driverHome/driver_home.dart';
import 'driver_running_ride_dl.dart';
import 'driver_running_ride_repo.dart';

class DriverRunningRideBloc extends Bloc {
  final BuildContext context;
  BuildContext? ratingContext, cancelContext;
  final int rideId;
  int rideStatus = 0, serviceId;
  GoogleMapController? googleMapController;
  Marker? markerDriver;
  Position? currentLocationData;
  BitmapDescriptor? driverMarkerIcon;
  DatabaseReference? _databaseReference;
  StreamSubscription<RemoteMessage>? firebaseOnMessageStream;
  StreamSubscription<Position>? subscription;
  bool _exitToHomeScheduled = false;
  AddressListItem? pickupAddressItem;
  AddressListItem? dropAddressItem;

  DriverRunningRideBloc({required this.context, required this.rideId, required this.serviceId}) {
    pushNotificationService.dismissRideNotification(rideId);
    manageNotification();
    setDriverMarker(serviceId);
    unawaited(_flushQueuedRideActions());
  }

  RideDetails _rideDetails = RideDetails();
  final DriverRunningRideRepo _runningRideRepo = DriverRunningRideRepo();
  bool isRideOTP = false;
  int apiRideStatus = 3, noOfWayPoint = 0, wayPointStatus = 0, isTollCharge = 0;
  bool isRideStart = false;
  String preFillOTP = "";
  String currentDestinationLatLong = "";
  List<AddressListItem> rideAddressList = [];
  dynamic toll = 0;
  DateTime? _lastRouteRefreshAt;
  static const Duration _routeRefreshThrottle = Duration(seconds: 8);

  final subject = BehaviorSubject<ApiResponse<DriverRunningRidePojo>>();
  final subjectUpdateRideStatus = BehaviorSubject<ApiResponse<UpdateRideStatusPojo>>();
  final subjectCancelRide = BehaviorSubject<ApiResponse<BaseModel>>();
  final subjectStatus = BehaviorSubject<int>();
  final markersListController = BehaviorSubject<List<Marker>>();
  final rotateMarkerListController = BehaviorSubject<List<Marker>>();
  final polyLinesController = BehaviorSubject<Map<PolylineId, Polyline>>();

  final distanceController = BehaviorSubject<dynamic>.seeded(0);
  final etaController = BehaviorSubject<dynamic>.seeded(0);
  final actionBtnTextController = BehaviorSubject<String>();
  final mapStyleController = BehaviorSubject<String>();
  final addressTitleController = BehaviorSubject<String>();
  final addressController = BehaviorSubject<String>();

  Function(List<Marker>) get changeMarkerList => markersListController.sink.add;

  Function(List<Marker>) get changeRotateMarker => rotateMarkerListController.sink.add;

  Function(Map<PolylineId, Polyline>) get changePolyLines => polyLinesController.sink.add;

  Function(dynamic) get changeDistance => distanceController.sink.add;

  Function(String) get changeEta => etaController.sink.add;

  Function(String) get changeActionButtonText => actionBtnTextController.sink.add;

  Function(String) get changeAddressTitle => addressTitleController.sink.add;

  Function(String) get changeAddress => addressController.sink.add;

  Function(int) get changeStatus => subjectStatus.sink.add;

  Future<void> callRideDetailsApi({bool isLoading = true}) async {
    final offlineService = ActiveRideOfflineService.instance;
    if (!await offlineService.hasNetwork) {
      if (offlineService.cachedRideId() == rideId && subject.valueOrNull?.status == Status.completed) {
        if (context.mounted) {
          openSimpleSnackbar(
            context,
            offlineService.isSnapshotStale
                ? 'Sin señal — mostrando última ubicación conocida.'
                : 'Viaje en caché — reconectando cuando haya señal.',
          );
        }
        return;
      }
    }

    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callRideDetailsApi(isLoading: isLoading);
      },
    )) {
      if (isLoading) {
        subject.sink.add(ApiResponse.loading());
      }
      try {
        var response = DriverRunningRidePojo.fromJson(await _runningRideRepo.getRideDetails(rideId));

        if (!context.mounted) return;
        String message = getApiMsg(response.message);
        if (isApiStatus(context, response.status, message, true)) {
          subject.sink.add(ApiResponse.completed(response));

          /// Initializing variables for using every where in bloc
          _rideDetails = response.rideDetails ?? RideDetails();
          rideStatus = _rideDetails.rideStatus;
          changeStatus(rideStatus);
          serviceId = _rideDetails.serviceId;
          isRideOTP = _rideDetails.isOtp == 1;
          isTollCharge = _rideDetails.isTollCharge;
          wayPointStatus = response.rideDetails?.wayPointStatus ?? 0;
          rideAddressList = response.rideDetails?.addressList ?? [];
          if (rideAddressList.isNotEmpty) {
            pickupAddressItem = rideAddressList[0];
            dropAddressItem = rideAddressList[rideAddressList.length - 1];
            if (rideAddressList.length > 2) {
              noOfWayPoint = rideAddressList.length - 2;
            }
          }
          ActiveRideOfflineService.instance.persistFromApiResponse(
            {
              'ride_id': _rideDetails.rideId,
              'service_id': _rideDetails.serviceId,
              'pickup_lat': pickupAddressItem?.addressLat,
              'pickup_long': pickupAddressItem?.addressLong,
              'destination_lat': dropAddressItem?.addressLat,
              'destination_long': dropAddressItem?.addressLong,
            },
            rideStatus: rideStatus,
          );
          if (rideStatus >= DriverRideStatus.driverRunning) {
            changeAddressTitle(languages.dropLocation);
            changeAddress(dropAddressItem?.address ?? "");
          } else {
            changeAddressTitle(languages.pickUpLocation);
            changeAddress(pickupAddressItem?.address ?? "");
          }
          if (isDemoApp) preFillOTP = (response.rideDetails?.otp ?? "").toString();
          setLayout();
          await mapApiCall();
          if (rideStatus > DriverRideStatus.driverCancel && rideStatus < DriverRideStatus.driverPayment) {
            isRideStart = true;
            backgroundLocationService.onStart();
          }
          unawaited(_flushQueuedRideActions());
        } else {
          subject.sink.add(ApiResponse.error(message));
          if (response.status != 3) openSimpleSnackbar(context, message);
        }
      } catch (e) {
        debugPrint("myError == ${e.toString()}");
        subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> callUpdateRideStatusApi({
    dynamic rating = 0,
    String comment = "",
    String otp = "",
    String cancelReason = "",
    bool rideDetailsApiCall = false,
  }) async {
    await _flushQueuedRideActions();

    final queue = RideActionQueueService.instance;
    if (!await queue.hasNetwork) {
      await queue.enqueue(
        rideId: rideId,
        rideStatus: apiRideStatus,
        cancelReason: cancelReason,
        otp: otp,
        rating: rating,
        comment: comment,
        wayPointStatus: wayPointStatus,
        tollCharge: (apiRideStatus == DriverRideStatus.driverDrop && isTollCharge == 1) ? toll : 0,
        tollCount: (apiRideStatus == DriverRideStatus.driverDrop && isTollCharge == 2) ? toll : 0,
      );
      if (context.mounted) {
        openSimpleSnackbar(context, 'Sin señal: acción guardada. Se enviará al reconectar.');
      }
      return;
    }

    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callUpdateRideStatusApi(rating: rating, comment: comment, otp: otp);
      },
    )) {
      if (cancelReason.trim().isNotEmpty) {
        subjectCancelRide.sink.add(ApiResponse.loading());
      } else {
        subjectUpdateRideStatus.sink.add(ApiResponse.loading());
      }
      try {
        var response = UpdateRideStatusPojo.fromJson(
          await _runningRideRepo.updateRideStatus(
            rideId: rideId,
            rideStatus: apiRideStatus,
            cancelReason: cancelReason,
            rating: rating,
            comment: comment,
            otp: otp,
            tollCharge: (apiRideStatus == DriverRideStatus.driverDrop && isTollCharge == 1) ? toll : 0,
            tollCount: (apiRideStatus == DriverRideStatus.driverDrop && isTollCharge == 2) ? toll : 0,
            wayPointStatus: wayPointStatus,
          ),
        );

        if (!context.mounted) return;
        String message = getApiMsg(response.message);
        if (isApiStatus(context, response.status, message, true)) {
          subjectCancelRide.sink.add(ApiResponse.completed());
          subjectUpdateRideStatus.sink.add(ApiResponse.completed(response));
          putDataInSettingBox(hiveDriverCurrentStatus, response.driverCurrentStatus ?? 0);
          if (response.rideCompletedStatus == 1) {
            message = languages.rideCompleteByAdminMsg;
            showRideCompleteCancelBottomSheet(languages.rideCompleted, message);
            return;
          }

          if (response.rideCancelledStatus == 1 || (response.rideStatus ?? 0) == DriverRideStatus.driverCancel) {
            rideStatus = response.rideStatus ?? DriverRideStatus.driverCancel;
            changeStatus(rideStatus);
            if (cancelReason.trim().isNotEmpty) {
              _navigateToDriverHomeAfterRideEnded();
              return;
            }
            message = (response.cancelBy ?? '').trim().isNotEmpty
                ? (response.cancelBy ?? '')
                : languages.rideCancelByAdminMsg;
            showRideCompleteCancelBottomSheet(languages.rideCancel, message);
            return;
          }
          rideStatus = response.rideStatus ?? 0;
          changeStatus(rideStatus);
          changeRideStatusWiseLayout();
          if (rideDetailsApiCall) {
            callRideDetailsApi(isLoading: false);
          }
          await queue.clearForRide(rideId);
        } else {
          subjectUpdateRideStatus.sink.add(ApiResponse.error(message));
          subjectCancelRide.sink.add(ApiResponse.error(message));
          if (response.status != 3 && response.adminReassign != 1) openSimpleSnackbar(context, message);
          if (response.adminReassign == 1) {
            showReAssignDriverSheet(message);
          }
          wayPointStatus = wayPointStatus != 0 ? wayPointStatus - 1 : wayPointStatus;
        }
      } catch (e) {
        debugPrint(e.toString());
        subjectUpdateRideStatus.sink.add(ApiResponse.error(e.toString()));
        subjectCancelRide.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void setLayout() {
    if (rideStatus == DriverRideStatus.driverCancel) {
      _navigateToDriverHomeAfterRideEnded();
      return;
    }
    changeRideStatusWiseLayout();
    setFirebaseReference();
    writeDataInFirebase();
  }

  void _navigateToDriverHomeAfterRideEnded() {
    if (_exitToHomeScheduled || !context.mounted) return;
    _exitToHomeScheduled = true;

    backgroundLocationService.onStop();
    ActiveRideOfflineService.instance.clearRideSnapshot();
    pushNotificationService.dismissRideNotification(rideId);
    finishChatWithUser();
    deleteRideHistoryInFirebase();

    final bookingNo = _rideDetails.bookingNo;
    if (bookingNo.toString().isNotEmpty) {
      FirebaseDatabase.instance.ref().child(ChatConstant.chat).child(ChatConstant.rides).child(bookingNo.toString()).remove();
    }

    if (cancelContext?.mounted ?? false) {
      Navigator.pop(cancelContext!);
      cancelContext = null;
    }

    if (!context.mounted) return;
    openScreenWithClearPrevious(context, const DriverHome());
  }

  void rideButtonOnTapAction({bool callRideDetailsApi = false}) {
    if (apiRideStatus != DriverRideStatus.driverCancel) {
      apiRideStatus = getRideStatusForApi();
    }
    switch (apiRideStatus) {
      case DriverRideStatus.driverRunning:
        if (isRideOTP) {
          openEnterOtpBottomSheet();
        } else {
          callUpdateRideStatusApi();
        }
        break;
      case DriverRideStatus.driverDrop:
        if ((noOfWayPoint - wayPointStatus) > 0) {
          wayPointStatus++;
          apiRideStatus = 5;
          callUpdateRideStatusApi();
        } else {
          openEnterTollAmountBottomSheet();
        }
        break;
      case DriverRideStatus.driverPayment:
        openCollectAmountBottomSheet();
        break;
      case DriverRideStatus.driverRating:
        openReviewUserBottomSheet();
        break;
      default:
        callUpdateRideStatusApi(rideDetailsApiCall: callRideDetailsApi);
        break;
    }
  }

  void changeRideStatusWiseLayout() {
    switch (rideStatus) {
      case DriverRideStatus.driverApproved:
      case DriverRideStatus.driverSchedule:
        changeActionButtonText(languages.startRide);
        break;
      case DriverRideStatus.driverCancel:
        _navigateToDriverHomeAfterRideEnded();
        break;
      case DriverRideStatus.driverRunning:
        startRide();
        break;
      case DriverRideStatus.driverDrop:
        completeRide();
        changeActionButtonText(languages.collectPayment);
        break;
      case DriverRideStatus.driverPayment:
        changeActionButtonText(languages.rateUser);
        openReviewUserBottomSheet();
        break;
      case DriverRideStatus.driverRating:
        changeActionButtonText(languages.completeRide);
        openRideCompletedBottomSheet();
        break;
      case DriverRideStatus.driverCompleted:
        pushNotificationService.dismissRideNotification(rideId);
        openScreenWithClearPrevious(context, DriverHome());
        break;
      default:
        break;
    }
  }

  void startRide() {
    isRideStart = true;
    mapApiCall();
    if (noOfWayPoint > 0 && (noOfWayPoint - wayPointStatus) > 0) {
      int i = wayPointStatus + 1;
      changeAddressTitle('${languages.stop} $i');
      changeActionButtonText("${languages.arrived} ${languages.at} ${languages.stop} $i");
      setNextAddress(rideAddressList[i].address, "${rideAddressList[i].addressLat},${rideAddressList[i].addressLong}");
    } else {
      changeAddressTitle(languages.dropLocation);
      changeActionButtonText(languages.completeRide);
      setNextAddress(dropAddressItem?.address ?? "", "${dropAddressItem?.addressLat},${dropAddressItem?.addressLong}");
    }
  }

  void setNextAddress(String nextAddress, String latLng) {
    changeAddress(nextAddress);
    currentDestinationLatLong = latLng;
  }

  void completeRide() {
    finishChatWithUser();
    deleteRideHistoryInFirebase();
  }

  /*  navigateTo() async {
    String startingPoint = "0,0", endingPoint = "0,0";

    /// [wayPointsBetweenStartAndEnd] Way points list creating from [rideAddressList]
    List<String> wayPointsBetweenStartAndEnd = [];
    int locationListLength = rideAddressList.length;
    for (int i = 0; i < locationListLength; i++) {
      if (i != 0 && i != (locationListLength - 1)) {
        wayPointsBetweenStartAndEnd.add("${rideAddressList[i].addressLat ?? "0"},${rideAddressList[i].addressLong ?? "0"}");
      }
    }
    if (currentLocationData != null) {
      if (rideStatus <= 4) {
        startingPoint = "${currentLocationData?.latitude ?? 0},${currentLocationData?.longitude ?? 0}";
        endingPoint = "${pickupAddressItem?.addressLat ?? "0"},${pickupAddressItem?.addressLong ?? "0"}";
      } else {
        startingPoint = "${pickupAddressItem?.addressLat ?? "0"},${pickupAddressItem?.addressLong ?? "0"}";
        endingPoint = "${dropAddressItem?.addressLat ?? "0"},${dropAddressItem?.addressLong ?? "0"}";
      }
    } else {
      startingPoint = "${pickupAddressItem?.addressLat ?? "0"},${pickupAddressItem?.addressLong ?? "0"}";
      endingPoint = "${dropAddressItem?.addressLat ?? "0"},${dropAddressItem?.addressLong ?? "0"}";
    }

    String url =
        "https://www.google.com/maps/dir/?api=1&origin=$startingPoint&destination=$endingPoint&waypoints=${wayPointsBetweenStartAndEnd.join('|')}&travelmode=driving&dir_action=navigate";
    openUrl(url, launchMode: LaunchMode.externalApplication);
  }*/

  Future<void> navigateTo() async {
    int myStatus = (noOfWayPoint > 0 && isRideStart) ? 5 : rideStatus;
    String latLong = myStatus < DriverRideStatus.driverRunning
        ? '${pickupAddressItem?.addressLat},${pickupAddressItem?.addressLong}'
        : (currentDestinationLatLong).isNotEmpty
        ? (currentDestinationLatLong)
        : '${dropAddressItem?.addressLat},${dropAddressItem?.addressLong}';

    openMapsSheet(convertStringLatLongToLatLongObject(latLong));
  }

  int getRideStatusForApi() {
    int rideStatusApi = DriverRideStatus.driverPending;
    switch (rideStatus) {
      case DriverRideStatus.driverApproved:
      case DriverRideStatus.driverSchedule:
        rideStatusApi = DriverRideStatus.driverArrive;
        break;
      case DriverRideStatus.driverArrive:
        rideStatusApi = DriverRideStatus.driverRunning;
        break;
      case DriverRideStatus.driverRunning:
        rideStatusApi = DriverRideStatus.driverDrop;
        break;
      case DriverRideStatus.driverDrop:
        if (_rideDetails.paymentType == 1) {
          rideStatusApi = DriverRideStatus.driverPayment;
        } else {
          rideStatusApi = DriverRideStatus.driverRating;
        }
        break;
      case DriverRideStatus.driverPayment:
        rideStatusApi = DriverRideStatus.driverRating;
        break;
      case DriverRideStatus.driverRating:
        rideStatusApi = DriverRideStatus.driverCompleted;
        break;
    }
    return rideStatusApi;
  }

  /// Firebase functions
  void finishChatWithUser() {
    String userIdCode = ChatConstant.userIdCode + _rideDetails.userId.toString();
    String driverIdCode = ChatConstant.userIdCode + getIntFromUserInfoBox(hiveUserId).toString();
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

    DatabaseReference referenceMessage = firebaseDatabase.ref().child(ChatConstant.chat).child(ChatConstant.messages).child("${driverIdCode}_$userIdCode");
    referenceMessage.once().then((event) {
      if (event.snapshot.value != null) {
        referenceMessage.remove();
      }
      return;
    });
    DatabaseReference referenceUser = firebaseDatabase.ref().child(ChatConstant.chat).child(ChatConstant.users).child(driverIdCode);
    referenceUser.orderByChild(ChatConstant.userId).equalTo(userIdCode).once().then((event) {
      if (event.snapshot.value != null) {
        Map data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          referenceUser.child(key.toString()).remove();
        });
      }
      return;
    });
  }

  void setFirebaseReference() {
    _databaseReference = FirebaseDatabase.instance.ref().child(ChatConstant.chat).child(ChatConstant.rides).child(_rideDetails.bookingNo.toString());
  }

  void writeDataInFirebase() {
    if (_databaseReference != null && currentLocationData != null) {
      var map = <String, dynamic>{};
      map[ChatConstant.userIdCode] = getIntFromUserInfoBox(hiveUserId);
      map[ChatConstant.latitude] = currentLocationData!.latitude;
      map[ChatConstant.longitude] = currentLocationData!.longitude;
      _databaseReference!.update(map);
    }
  }

  void deleteRideHistoryInFirebase() {
    if (_databaseReference != null) {
      _databaseReference!.once().then((event) {
        if (event.snapshot.value != null) {
          _databaseReference!.remove();
        }
        return;
      });
    }
  }

  /// This function listing all notification here also, while user using this screen....
  Future<void> _flushQueuedRideActions() async {
    final queue = RideActionQueueService.instance;
    await queue.flush((action) async {
      if ((action['ride_id'] ?? 0).toString() != rideId.toString()) {
        return true;
      }
      try {
        final response = UpdateRideStatusPojo.fromJson(
          await _runningRideRepo.updateRideStatus(
            rideId: rideId,
            rideStatus: int.parse((action['ride_status'] ?? 0).toString()),
            cancelReason: (action['cancel_reason'] ?? '').toString(),
            rating: action['rating'] ?? 0,
            comment: (action['comment'] ?? '').toString(),
            otp: (action['otp'] ?? '').toString(),
            tollCharge: action['toll_charge'] ?? 0,
            tollCount: action['toll_count'] ?? 0,
            wayPointStatus: int.parse((action['way_point_status'] ?? 0).toString()),
          ),
        );
        if ((response.status ?? 0) == 1) {
          rideStatus = response.rideStatus ?? rideStatus;
          changeStatus(rideStatus);
          changeRideStatusWiseLayout();
          return true;
        }
      } catch (_) {}
      return false;
    });
  }

  void manageNotification() {
    firebaseOnMessageStream ??= FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Map<String, dynamic> notificationData = message.data;
      DispatchTriggerService.recordFromNotificationData(notificationData);
      int notificationType = int.parse((notificationData[NotificationConstant.notificationType] ?? 0).toString());
      int orderId = int.parse((notificationData[NotificationConstant.rideId] ?? 0).toString());
      String notificationMessage = notificationData[NotificationConstant.message] ?? "";
      String notificationTitle = notificationData[NotificationConstant.title] ?? "";
      if (notificationType == 2 && orderId == rideId) {
        pushNotificationService.dismissRideNotification(rideId);
        showRideCompleteCancelBottomSheet(notificationTitle, notificationMessage);
      } else if (orderId == rideId) {
        callRideDetailsApi(isLoading: false);
      }
    });
  }

  /// Google map functions
  Future<void> onMapCreated(GoogleMapController googleMapController) async {
    this.googleMapController = googleMapController;
    await getCurrentLocation();
  }

  Future<void> getCurrentLocation({bool isCallRideDetailsApi = true}) async {
    if (isCallRideDetailsApi) {
      subject.sink.add(ApiResponse.loading());
    }
    getLocationUtils.getLocationUtils((locationData) {
      currentLocationData = locationData;
      if (isCallRideDetailsApi) {
        callRideDetailsApi();
      } else {
        setLocationData(locationData);
      }
      // setLocationData(locationData);
    }, (locationData, address) {});
    LocationSettings locationSettings;
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 3, intervalDuration: const Duration(seconds: 2));
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 3);
    } else {
      locationSettings = const LocationSettings(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 3);
    }
    subscription ??=
        Geolocator.getPositionStream(locationSettings: locationSettings).listen((location) {
          setLocationData(location);
        })..onError((handleError) {
          debugPrint("enter in track : handleError :${handleError.toString()}");
        });
  }

  void setLocationData(Position currentLocation) {
    currentLocationData = currentLocation;
    if (markerDriver == null && driverMarkerIcon != null) {
      List<Marker> markerList = [];
      markerDriver = Marker(
        markerId: const MarkerId("DriverMarker"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        icon: driverMarkerIcon!,
        infoWindow: InfoWindow(title: getStringFromUserInfoBox(hiveUserName)),
      );
      markerList.add(markerDriver!);
      changeRotateMarker(markerList);
    } else {
      updateDriverMarker(currentLocation);
    }
    focusInMap(googleMapController!, currentLocation.latitude, currentLocation.longitude, true);
    writeDataInFirebase();
    if (rideStatus >= DriverRideStatus.driverRunning && isRideStart) {
      _refreshRouteIfNeeded(currentLocation);
    }
  }

  Future<void> _refreshRouteIfNeeded(Position currentLocation) async {
    final now = DateTime.now();
    if (_lastRouteRefreshAt != null && now.difference(_lastRouteRefreshAt!) < _routeRefreshThrottle) {
      return;
    }
    _lastRouteRefreshAt = now;
    final LatLng current = LatLng(currentLocation.latitude, currentLocation.longitude);
    final LatLng destination = (currentDestinationLatLong).isNotEmpty
        ? convertStringLatLongToLatLongObject(currentDestinationLatLong)
        : convertStringLatLongToLatLongObject("${dropAddressItem?.addressLat},${dropAddressItem?.addressLong}");
    await getRoutDetails(current, destination, []);
  }

  void updateDriverMarker(Position locationData) {
    List<Marker> markers = rotateMarkerListController.valueOrNull ?? [];
    int pos = markers.indexWhere((item) => item.markerId == const MarkerId("DriverMarker"));
    if (pos >= 0) {
      Marker driverMarker = markers[pos];
      Marker driverNewMarker = Marker(
        markerId: driverMarker.markerId,
        position: LatLng(locationData.latitude, locationData.longitude),
        icon: driverMarkerIcon!,
        infoWindow: driverMarker.infoWindow,
      );
      markers[pos] = driverNewMarker;
      changeRotateMarker(markers);
    }
  }

  Future<void> setDriverMarker(int serviceId) async {
    driverMarkerIcon = await getServiceMarkerIcon(serviceId: serviceId);
  }

  Future<void> mapApiCall() async {
    /// For driver mode when driver has not started ride we need to draw location from driver to customer pickup.
    /// Because of this logic we use this both parameters to change accordingly by ride status
    LatLng driverRideStartLocation = LatLng(0, 0), driverRideEndLocation = LatLng(0, 0);
    LatLng pickupLanLng = convertStringLatLongToLatLongObject("${pickupAddressItem?.addressLat},${pickupAddressItem?.addressLong}");
    LatLng dropLanLng = convertStringLatLongToLatLongObject("${dropAddressItem?.addressLat},${dropAddressItem?.addressLong}");

    // if (!(rideStatus >= DriverRideStatus.driverRunning)) {
    //   List<LatLng> wayPointsBetweenStartAndEnd = [];
    //   int locationListLength = rideAddressList.length;
    //   for (int i = 0; i < locationListLength; i++) {
    //     LatLng stopLatLng = LatLng(
    //       getDoubleFromDynamic(rideAddressList[i].addressLat ?? "0"),
    //       getDoubleFromDynamic(rideAddressList[i].addressLong ?? "0"),
    //     );
    //     if (i != 0 && i != (locationListLength - 1)) {
    //       wayPointsBetweenStartAndEnd.add(stopLatLng);
    //     }
    //   }
    //   await setMarkers(pickupLanLng, dropLanLng, wayPointsBetweenStartAndEnd);
    // }

    if (currentLocationData != null) {
      if (rideStatus >= DriverRideStatus.driverRunning) {
        driverRideStartLocation = LatLng(currentLocationData?.latitude ?? 0, currentLocationData?.longitude ?? 0);
        driverRideEndLocation = (currentDestinationLatLong).isNotEmpty ? convertStringLatLongToLatLongObject(currentDestinationLatLong) : dropLanLng;
      } else if (rideStatus < DriverRideStatus.driverRunning) {
        driverRideStartLocation = LatLng(currentLocationData?.latitude ?? 0, currentLocationData?.longitude ?? 0);
        driverRideEndLocation = pickupLanLng;
      } else {
        driverRideStartLocation = pickupLanLng;
        driverRideEndLocation = dropLanLng;
      }

      await getRoutDetails(driverRideStartLocation, driverRideEndLocation, []);
    } else {
      await getRoutDetails(pickupLanLng, dropLanLng, []);
    }
  }

  Future<void> getRoutDetails(LatLng origin, LatLng destination, List<LatLng> wayPoints) async {
    await GetRoutesUtils().getRoutes(origin, destination, wayPoints, (polyLines, duration, distance) async {
      // dynamic dist = getDoubleFromDynamic((distance / 1000).toStringAsFixed(2));
      changePolyLines(polyLines);
      // changeDistance(dist);
      // changeEta("${formattedTime(timeInSecond: duration)} ${languages.away}");
      // await setMarkers(origin, destination, wayPoints);
      // if (rideStatus >= DriverRideStatus.driverRunning) {
      await setMarkers(origin, destination, []);
      // }
      if (googleMapController != null) {
        setMapFitToTour(polyline: Set<Polyline>.of(polyLines.values), controller: googleMapController!, padding: 10.sp);
      }
    });
  }

  Future<void> setMarkers(LatLng pickupLatLng, LatLng destinationLatLong, List<LatLng> wayPointList) async {
    List<Marker> markerList = [];
    BitmapDescriptor pickUpMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, 'ic_pin_pickup_location.png'));
    markerList.add(
      Marker(
        markerId: const MarkerId("pickup"),
        position: pickupLatLng,
        icon: pickUpMarkerIcon,
        infoWindow: InfoWindow(title: languages.pickUpLocation),
      ),
    );
    if (!context.mounted) return;
    BitmapDescriptor destinationMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, 'ic_pin_destination_location.png'));
    markerList.add(
      Marker(
        markerId: const MarkerId("destination"),
        position: destinationLatLong,
        icon: destinationMarkerIcon,
        infoWindow: InfoWindow(title: languages.dropLocation),
      ),
    );
    if (wayPointList.isNotEmpty) {
      if (!context.mounted) return;
      BitmapDescriptor stopMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, 'stop_location.png'));
      for (int index = 0; index < wayPointList.length; index++) {
        int stopNumber = index + 1;
        markerList.add(
          Marker(
            markerId: MarkerId("stop$stopNumber"),
            position: wayPointList[index],
            icon: stopMarkerIcon,
            zIndexInt: 8,
            infoWindow: InfoWindow(title: "${languages.stop} $stopNumber"),
          ),
        );
      }
    }

    changeMarkerList(markerList);
  }

  void changePolylineColorPerTheme() {
    Map<PolylineId, Polyline> polyLines = polyLinesController.valueOrNull ?? {};
    if (polyLines.isNotEmpty) {
      final oldPolyline = polyLines[PolylineId("poly")]!;
      final updatedPolyline = oldPolyline.copyWith(colorParam: getCurrentTheme(context).colorBlack);
      polyLines[PolylineId("poly")] = updatedPolyline;
    }
    polyLinesController.sink.add(polyLines);
  }

  /// Bottom sheet for this screen
  void openRideCompletedBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      builder: (context) {
        return CommonBottomSheet(
          title: languages.rideCompleted,
          cancelable: false,
          textAlign: TextAlign.center,
          positiveButtonTxt: languages.ok,
          onPositivePress: () {
            apiRideStatus = getRideStatusForApi();
            Navigator.pop(context);
            callUpdateRideStatusApi();
          },
        );
      },
    );
  }

  void openEnterOtpBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return EnterOtpBottomSheet(
          preFillOTP: preFillOTP,
          onSubmit: (otp) {
            apiRideStatus = getRideStatusForApi();
            Navigator.pop(context);
            callUpdateRideStatusApi(otp: otp);
          },
        );
      },
    );
  }

  void openEnterTollAmountBottomSheet() {
    if (isTollCharge == 0) {
      callUpdateRideStatusApi();
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return EnterTollAmountBottomSheet(
          tollType: isTollCharge,
          onPositiveBtnClick: (tollAmount) {
            if (isTollCharge == 2) {
              toll = int.parse(tollAmount);
            } else {
              toll = getDoubleFromDynamic(tollAmount);
            }
            Navigator.pop(context);
            callUpdateRideStatusApi(rideDetailsApiCall: true);
          },
          onNegativeClick: () {
            toll = 0;
            apiRideStatus = getRideStatusForApi();
            Navigator.pop(context);
            callUpdateRideStatusApi(rideDetailsApiCall: true);
          },
        );
      },
    );
  }

  void openCollectAmountBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      builder: (context) {
        return CommonBottomSheet(
          title: languages.collectAmount,
          message: languages.collectAmountMsg(getAmountWithCurrency(_rideDetails.totalAmount)),
          positiveButtonTxt: languages.yes,
          negativeButtonTxt: languages.no,
          onPositivePress: () {
            apiRideStatus = getRideStatusForApi();
            Navigator.pop(context);
            callUpdateRideStatusApi();
          },
          onNegativePress: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void openReviewUserBottomSheet() {
    if (ratingContext?.mounted ?? false) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        ratingContext = context;
        return RatingBottomSheet(
          title: languages.reviewUser,
          onSubmit: (double rating, String comment) {
            apiRideStatus = getRideStatusForApi();
            callUpdateRideStatusApi(rating: rating, comment: comment);
          },
          message: languages.reviewUserMsg,
        );
      },
    ).then((value) {
      ratingContext = null;
    });
  }

  void showRideCompleteCancelBottomSheet(String title, String message) {
    if (_exitToHomeScheduled) return;
    if (cancelContext?.mounted ?? false) {
      return;
    }
    pushNotificationService.dismissRideNotification(rideId);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      builder: (sheetContext) {
        cancelContext = sheetContext;
        return CommonBottomSheet(
          cancelable: false,
          title: title,
          message: message,
          positiveButtonTxt: languages.ok,
          onPositivePress: () {
            _navigateToDriverHomeAfterRideEnded();
          },
        );
      },
    ).then((value) {
      cancelContext = null;
    });
  }

  Future<void> openCancelRideConfirmationSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return CancelRideBottomSheet(
          onSubmit: (String cancelReason) {
            if (cancelReason.trim().isNotEmpty) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              apiRideStatus = DriverRideStatus.driverCancel;
              callUpdateRideStatusApi(cancelReason: cancelReason);
            }
          },
        );
      },
    );
  }

  Future<void> openMapsSheet(LatLng latLang) async {
    try {
      final coords = Coords(latLang.latitude, latLang.longitude);
      final availableMaps = await MapLauncher.installedMaps;

      if (!context.mounted) return;
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return ScaffoldWithSafeArea(
            backgroundColor: Colors.transparent,
            body: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
                padding: bottomSheetPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            languages.whatWouldYouLikeToChoose,
                            textAlign: TextAlign.start,
                            style: bodyText(
                              context: context,
                              fontSize: textSize18px,
                              textColor: getCurrentTheme(context).colorTextCommon,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsetsDirectional.only(bottom: 15.h),
                      itemCount: availableMaps.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            availableMaps[index].showDirections(destination: coords);
                          },
                          child: Container(
                            padding: EdgeInsetsDirectional.all(10.sp),
                            margin: EdgeInsetsDirectional.only(bottom: 15.h),
                            decoration: BoxDecoration(
                              color: getCurrentTheme(context).colorWhite.withValues(alpha: 0.5),
                              borderRadius: BorderRadiusDirectional.all(Radius.circular(5.r)),
                              border: Border.all(color: getCurrentTheme(context).colorBlack),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(availableMaps[index].icon, height: 30.sp, width: 30.sp),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(availableMaps[index].mapName, style: bodyText(context: context)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint("openMapsSheet Error: ${e.toString()}");
    }
  }

  void showReAssignDriverSheet(String message) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CommonBottomSheet(
          isLoading: false,
          title: message,
          message: "",
          positiveButtonTxt: languages.ok,
          onPositivePress: () async {
            pushNotificationService.dismissRideNotification(rideId);
            finishChatWithUser();
            openScreenWithReplacePrevious(context, DriverHome());
          },
        );
      },
    );
  }

  @override
  void dispose() {
    deleteRideHistoryInFirebase();
    if (firebaseOnMessageStream != null) {
      firebaseOnMessageStream!.cancel();
    }
    subject.close();
    subjectUpdateRideStatus.close();
    markersListController.close();
    rotateMarkerListController.close();
    polyLinesController.close();
    distanceController.close();
    etaController.close();
    actionBtnTextController.close();
    subscription?.cancel();
    subjectCancelRide.close();
    subjectStatus.close();
    mapStyleController.close();
    addressTitleController.close();
    addressController.close();
  }
}
