import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/cancel_ride_bottom_sheet.dart';
import '../../../bottomSheet/common_bottom_sheet.dart';
import '../../../bottomSheet/otp_share_bottom_sheet.dart';
import '../../../bottomSheet/rating_bottom_sheet.dart';
import '../../../bottomSheet/selectPaymentBottomSheet/select_payment_bottom_sheet.dart';
import '../../../constant/chat_constant.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/base_dl.dart';
import '../../../services/push_notification_service.dart';
import '../../../utils/get_route_utils.dart';
import '../../../services/active_ride_offline_service.dart';
import '../../../utils/utils.dart';
import '../../common/wallet/walletHome/wallet_home_dl.dart';
import '../../common/wallet/walletHome/wallet_home_repo.dart';
import '../offerRide/offer_ride_repo.dart';
import '../passengerHome/passenger_home.dart';
import '../passengerRideDetail/passenger_ride_detail.dart';
import 'ps_running_repo.dart';
import 'ps_running_ride_dl.dart';

class PassengerRunningRideBloc extends Bloc {
  BuildContext context;
  BuildContext? shareOtpContext, cancelContext, completeContext;
  int rideId;
  final PassengerRunningRideRepo _passengerRunningRideRepo = PassengerRunningRideRepo();
  final OfferRideRepo _offerRideRepo = OfferRideRepo();
  int rideStatus = 0;
  BuildContext? bottomSheetContext, cancelSheetContext;
  LatLng? driverPreviousLatLng, driverCurrentLatLong;
  DatabaseReference? _reference;
  GoogleMapController? googleMapController;
  Marker? markerDriver;
  StreamSubscription<RemoteMessage>? firebaseOnMessageStream;
  final WalletHomeRepo _myWalletRepo = WalletHomeRepo();
  double walletAmount = 0;
  List<AddressListItem> addressList = [];
  bool isFromNotification;
  DateTime? _lastPassengerRouteRefreshAt;
  static const Duration _passengerRouteRefreshThrottle = Duration(seconds: 8);
  Timer? _rideStatusPollTimer;

  PassengerRunningRideBloc(this.context, this.rideId, this.isFromNotification) {
    manageNotification();
    startRideStatusPolling();
    getWalletAmount();
  }

  void startRideStatusPolling() {
    _rideStatusPollTimer?.cancel();
    _rideStatusPollTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!context.mounted) {
        _rideStatusPollTimer?.cancel();
        return;
      }
      if (rideStatus == 4 || rideStatus == 9) {
        _rideStatusPollTimer?.cancel();
        return;
      }
      getRideDetailApi();
    });
  }

  final mapStyle = BehaviorSubject<String>.seeded("");
  final subjectRideDetail = BehaviorSubject<ApiResponse<PassengerRunningRidePojo>>();
  final rotateMarkerListController = BehaviorSubject<List<Marker>>();
  final markersListController = BehaviorSubject<List<Marker>>();
  final polyLinesController = BehaviorSubject<Map<PolylineId, Polyline>>();
  final subjectDistance = BehaviorSubject<dynamic>.seeded(0);
  final subjectTime = BehaviorSubject<dynamic>.seeded(0);
  final subjectCancelOrder = BehaviorSubject<ApiResponse<BaseModel>>();
  final subjectRating = BehaviorSubject<ApiResponse<BaseModel>>();
  final subjectPay = BehaviorSubject<ApiResponse<PaymentBaseModel>>();

  Future<void> getRideDetailApi() async {
    final offlineService = ActiveRideOfflineService.instance;
    if (!await offlineService.hasNetwork) {
      if (offlineService.cachedRideId() == rideId && subjectRideDetail.valueOrNull?.status == Status.completed) {
        if (context.mounted) {
          openSimpleSnackbar(context, 'Viaje en caché — reconectando cuando haya señal.');
        }
        return;
      }
    }

    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        getRideDetailApi();
      },
    )) {
      subjectRideDetail.sink.add(ApiResponse.loading());
      try {
        var response = PassengerRunningRidePojo.fromJson(await _passengerRunningRideRepo.getRideDetail(rideId));

        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status ?? 0, message, true)) {
          subjectRideDetail.sink.add(ApiResponse.completed(response));
          putDataInSettingBox(hivePaymentTypeCash, response.cashPayment == 1);
          putDataInSettingBox(hivePaymentTypeOnline, response.onlinePayment == 1);
          putDataInSettingBox(hivePaymentTypeWallet, response.walletPayment == 1);
          rideStatus = response.rideStatus ?? 0;
          addressList = response.addressList ?? [];
          ActiveRideOfflineService.instance.persistFromApiResponse(
            {
              'ride_id': response.rideId,
              'service_id': response.serviceId,
              'pickup_lat': addressList.isNotEmpty ? addressList.first.addressLat : null,
              'pickup_long': addressList.isNotEmpty ? addressList.first.addressLong : null,
              'destination_lat': addressList.length > 1 ? addressList.last.addressLat : null,
              'destination_long': addressList.length > 1 ? addressList.last.addressLong : null,
            },
            rideStatus: rideStatus,
          );
          if (response.rideStatus == 9 && response.userRatingStatus == 1 && bottomSheetContext == null) {
            ActiveRideOfflineService.instance.clearRideSnapshot();
            bottomSheetContext = context;
            openCommonCompleteBottomSheet(languages.rideCompletedMsg);
          } else if (rideStatus == 4) {
            ActiveRideOfflineService.instance.clearRideSnapshot();
            openCommonCancelBottomSheet(languages.rideCancelBy(response.cancelBy ?? ""), response.rideId ?? 0);
          } else {
            mapApiCall();
          }
          if (isFromNotification && response.rideStatus == 3 && response.isOtp == 1 && (response.otp ?? "").isNotEmpty) {
            openOTPBottomSheet(response.otp ?? "");
            isFromNotification = false;
          }
          if (response.rideStatus != 3 && (shareOtpContext?.mounted ?? false) && Navigator.canPop(shareOtpContext!)) {
            Navigator.pop(shareOtpContext!);
          }
          createFirebaseDataBase(response);
        } else {
          subjectRideDetail.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        subjectRideDetail.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> cancelOrderApi(String reason) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        cancelOrderApi(reason);
      },
    )) {
      subjectCancelOrder.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(await _offerRideRepo.cancelRideBookingApi(rideId, reason));

        String message = getApiMsg(response.message);
        subjectCancelOrder.sink.add(ApiResponse.completed(response));

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          ActiveRideOfflineService.instance.clearRideSnapshot();
          pushNotificationService.dismissRideNotification(rideId);
          addressList = [];
          _rideStatusPollTimer?.cancel();
          if (cancelContext?.mounted ?? false) {
            Navigator.pop(cancelContext!);
            cancelContext = null;
          }
          openScreenWithClearPrevious(context, const PassengerHome());
        }
      } catch (e) {
        subjectCancelOrder.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> rideRatingApiCall(int driverId, dynamic rating, String comment) async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        rideRatingApiCall(driverId, rating, comment);
      },
    )) {
      subjectRating.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(await _passengerRunningRideRepo.rideUserRating(rideId, driverId, rating, comment));

        String message = getApiMsg(response.message);

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          subjectRating.sink.add(ApiResponse.completed(response));
          pushNotificationService.dismissRideNotification(rideId);
          getRideDetailApi();
        } else {
          subjectRating.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        subjectRating.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> payForRideApiCall(int paymentType) async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        payForRideApiCall(paymentType);
      },
    )) {
      subjectPay.sink.add(ApiResponse.loading());
      try {
        var response = PaymentBaseModel.fromJson(await _passengerRunningRideRepo.payToOnRide(rideId, paymentType));

        String message = getApiMsg(response.message);

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          subjectPay.sink.add(ApiResponse.completed(response));
          getRideDetailApi();
        } else {
          subjectPay.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        subjectPay.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> getWalletAmount() async {
    try {
      var response = WalletBalancePojo.fromJson(await _myWalletRepo.getWalletBalanceApi());

      String message = getApiMsg(response.message);
      if (!context.mounted) return;
      if (isApiStatus(context, response.status, message, true, showMess: false)) {
        walletAmount = getDoubleFromDynamic(response.walletBalance ?? "0");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> onMapCreated(GoogleMapController googleMapController) async {
    this.googleMapController = googleMapController;
    getRideDetailApi();
  }

  Future<void> fetchCurrentLocation() async {
    getLocationUtils.getLocationUtils(
      (locationData) {
        if (googleMapController != null) {
          focusInMap(googleMapController!, locationData.latitude, locationData.longitude, true);
        }
      },
      (locationData, address) {},
      getForceFully: true,
      isGetAddress: false,
    );
  }

  Future<void> mapApiCall() async {
    if (addressList.isEmpty) {
      polyLinesController.sink.add({});
      markersListController.sink.add([]);
      return;
    }
    List<LatLng> latLngs = [];
    int locationListLength = addressList.length;
    for (int i = 0; i < locationListLength; i++) {
      LatLng stopLatLng = LatLng(getDoubleFromDynamic(addressList[i].addressLat ?? "0"), getDoubleFromDynamic(addressList[i].addressLong ?? "0"));
      if (i != 0 && i != (locationListLength - 1)) {
        latLngs.add(stopLatLng);
      }
    }
    LatLng pickupLatLng = convertStringLatLongToLatLongObject("${addressList.first.addressLat ?? "0"},${addressList.first.addressLong ?? "0"}");
    LatLng dropLatLng = convertStringLatLongToLatLongObject("${addressList.last.addressLat ?? "0"},${addressList.last.addressLong ?? "0"}");
    await GetRoutesUtils().getRoutes(pickupLatLng, dropLatLng, latLngs, (polyLines, duration, distance) async {
      dynamic dist = getDoubleFromDynamic((distance / 1000).toStringAsFixed(2));
      polyLinesController.sink.add(polyLines);
      subjectDistance.sink.add(dist);
      subjectTime.sink.add("${formattedTime(timeInSecond: duration)} ${languages.away}");
      if (googleMapController != null) {
        setMapFitToTour(polyline: Set<Polyline>.of(polyLines.values), controller: googleMapController!, padding: 50.sp);
      }
      setMarkers();
    });
  }

  Future<void> setMarkers() async {
    if (addressList.isEmpty) {
      markersListController.sink.add([]);
      return;
    }
    List<LatLng> latLngs = [];
    int locationListLength = addressList.length;
    for (int i = 0; i < locationListLength; i++) {
      LatLng stopLatLng = LatLng(getDoubleFromDynamic(addressList[i].addressLat ?? "0"), getDoubleFromDynamic(addressList[i].addressLong ?? "0"));
      if (i != 0 && i != (locationListLength - 1)) {
        latLngs.add(stopLatLng);
      }
    }
    LatLng pickupLatLng = convertStringLatLongToLatLongObject("${addressList.first.addressLat ?? "0"},${addressList.first.addressLong ?? "0"}");
    LatLng dropLatLng = convertStringLatLongToLatLongObject("${addressList.last.addressLat ?? "0"},${addressList.last.addressLong ?? "0"}");
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
        position: dropLatLng,
        icon: destinationMarkerIcon,
        infoWindow: InfoWindow(title: languages.dropLocation),
      ),
    );

    if (latLngs.isNotEmpty) {
      if (!context.mounted) return;
      BitmapDescriptor stopMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, 'stop_location.png'));
      for (int index = 0; index < latLngs.length; index++) {
        int stopNumber = index + 1;
        markerList.add(
          Marker(
            markerId: MarkerId("stop$stopNumber"),
            position: latLngs[index],
            icon: stopMarkerIcon,
            infoWindow: InfoWindow(title: "${languages.stop} $stopNumber"),
          ),
        );
      }
    }
    markersListController.sink.add(markerList);
  }

  void changePolylineColorPerTheme() {
    Map<PolylineId, Polyline> polyLines = polyLinesController.valueOrNull ?? {};
    final oldPolyline = polyLines[PolylineId("poly")];
    if (oldPolyline != null) {
      final updatedPolyline = oldPolyline.copyWith(colorParam: getCurrentTheme(context).colorBlack);
      polyLines[PolylineId("poly")] = updatedPolyline;
    }
    polyLinesController.sink.add(polyLines);
  }

  void createFirebaseDataBase(PassengerRunningRidePojo data) {
    _reference = FirebaseDatabase.instance.ref().child(ChatConstant.chat).child(ChatConstant.rides).child(data.bookingNo ?? "0");
    _reference?.onValue.listen((event) async {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<String, dynamic> result = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        driverCurrentLatLong = LatLng(double.parse(result[ChatConstant.latitude].toString()), double.parse(result[ChatConstant.longitude].toString()));
        if (markerDriver == null) {
          List<Marker> markerList = rotateMarkerListController.valueOrNull ?? [];
          BitmapDescriptor driverMarkerIcon = await getServiceMarkerIcon(serviceId: data.serviceId ?? 0);
          markerDriver = Marker(
            markerId: const MarkerId("DriverMarker"),
            position: driverCurrentLatLong!,
            // anchor: Offset(0.5, 0.5),
            icon: driverMarkerIcon,
            infoWindow: InfoWindow(title: data.driverName),
          );
          markerList.add(markerDriver!);
          rotateMarkerListController.sink.add(markerList);
        }
        if (driverPreviousLatLng != null) {
          updateDriverMarker();
          _refreshPassengerRouteIfNeeded();
        }
        driverPreviousLatLng = driverCurrentLatLong;
        focusInMap(googleMapController!, driverCurrentLatLong!.latitude, driverCurrentLatLong!.longitude, true);
      }
    });
  }

  Future<void> _refreshPassengerRouteIfNeeded() async {
    if (driverCurrentLatLong == null || addressList.isEmpty || rideStatus < 1) {
      return;
    }
    final now = DateTime.now();
    if (_lastPassengerRouteRefreshAt != null && now.difference(_lastPassengerRouteRefreshAt!) < _passengerRouteRefreshThrottle) {
      return;
    }
    _lastPassengerRouteRefreshAt = now;
    List<LatLng> latLngs = [];
    final locationListLength = addressList.length;
    for (int i = 0; i < locationListLength; i++) {
      final stopLatLng = LatLng(getDoubleFromDynamic(addressList[i].addressLat ?? "0"), getDoubleFromDynamic(addressList[i].addressLong ?? "0"));
      if (i != 0 && i != (locationListLength - 1)) {
        latLngs.add(stopLatLng);
      }
    }
    final dropLatLng = convertStringLatLongToLatLongObject("${addressList.last.addressLat ?? "0"},${addressList.last.addressLong ?? "0"}");
    await GetRoutesUtils().getRoutes(driverCurrentLatLong!, dropLatLng, latLngs, (polyLines, duration, distance) async {
      polyLinesController.sink.add(polyLines);
    });
  }

  void updateDriverMarker() {
    List<Marker> markers = rotateMarkerListController.valueOrNull ?? [];
    int pos = markers.indexWhere((item) => item.markerId == const MarkerId("DriverMarker"));
    if (pos >= 0) {
      Marker driverMarker = markers[pos];
      Marker driverNewMarker = Marker(
        markerId: driverMarker.markerId,
        position: driverCurrentLatLong!,
        icon: driverMarker.icon,
        infoWindow: driverMarker.infoWindow,
      );
      markers[pos] = driverNewMarker;
      if (rotateMarkerListController.isClosed) return;
      rotateMarkerListController.sink.add(markers);
    }
  }

  void openOTPBottomSheet(String otp) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        shareOtpContext = context;
        return OtpShareBottomSheet(otp: otp);
      },
    ).then((value) {
      shareOtpContext = null;
    });
  }

  void openPaymentBottomSheet(double totalPay) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: MediaQueryData.fromView(View.of(context)).padding.top + 10.h),
          child: SelectPaymentBottomSheet(
            totalPay: totalPay,
            walletAmount: walletAmount,
            showCash: true,
            showWallet: true,
            showOnlinePayment: true,
            onSubmit: (paymentType) {
              Navigator.pop(context);
              payForRideApiCall(paymentType);
            },
          ),
        );
      },
    );
  }

  void openCancelRideSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return CancelRideBottomSheet(
          onSubmit: (cancelReason) {
            cancelOrderApi(cancelReason);
          },
        );
      },
    );
  }

  void openRatingBottomSheet(int driverId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return RatingBottomSheet(
          title: languages.shareFeedBack,
          onSubmit: (rating, comment) {
            rideRatingApiCall(driverId, rating, comment);
          },
        );
      },
    );
  }

  void openCommonCompleteBottomSheet(String message) {
    if ((completeContext?.mounted ?? false)) {
      return;
    }
    FirebaseDatabase.instance.ref().child(ChatConstant.chat).child(ChatConstant.rides).child((subjectRideDetail.value.data?.bookingNo ?? "").toString()).remove();
    pushNotificationService.dismissRideNotification(rideId);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        completeContext = context;
        return CommonBottomSheet(
          cancelable: false,
          title: languages.rideCompleted,
          message: message,
          positiveButtonTxt: languages.ok,
          onPositivePress: () {
            finishChat();
            openScreenWithClearPrevious(context, PassengerRideDetail(rideId: rideId));
          },
        );
      },
    ).then((value) {
      completeContext = null;
    });
  }

  void openCommonCancelBottomSheet(String cancelReason, int rideId) {
    if ((cancelContext?.mounted ?? false)) {
      return;
    }
    FirebaseDatabase.instance.ref().child(ChatConstant.chat).child(ChatConstant.rides).child((subjectRideDetail.value.data?.bookingNo ?? "").toString()).remove();
    pushNotificationService.dismissRideNotification(rideId);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        cancelContext = context;
        return CommonBottomSheet(
          cancelable: false,
          title: languages.rideCancel,
          message: cancelReason,
          positiveButtonTxt: languages.ok,
          onPositivePress: () {
            finishChat();
            ActiveRideOfflineService.instance.clearRideSnapshot();
            openScreenWithClearPrevious(context, const PassengerHome());
          },
        );
      },
    ).then((value) {
      cancelContext = null;
    });
  }

  void finishChat() {
    String driverIdCode = ChatConstant.userIdCode + (subjectRideDetail.value.data?.driverId ?? 0).toString();
    String userIdCode = ChatConstant.userIdCode + getIntFromUserInfoBox(hiveUserId).toString();
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

    DatabaseReference referenceMessage = firebaseDatabase.ref().child(ChatConstant.chat).child(ChatConstant.messages).child("${userIdCode}_$driverIdCode");
    referenceMessage.once().then((dataSnapshot) {
      if (dataSnapshot.snapshot.value != null) {
        referenceMessage.remove();
      }
      return;
    });

    DatabaseReference referenceUser = firebaseDatabase.ref().child(ChatConstant.chat).child(ChatConstant.users).child(userIdCode);
    referenceUser.orderByChild(ChatConstant.userId).equalTo(driverIdCode).once().then((dataSnapshot) {
      if (dataSnapshot.snapshot.value != null) {
        Map<String, dynamic> result = Map<String, dynamic>.from(dataSnapshot.snapshot.value as Map<dynamic, dynamic>);
        result.forEach((key, value) {
          referenceUser.child(key.toString()).remove();
        });
      }
      return;
    });
  }

  void manageNotification() {
    firebaseOnMessageStream ??= FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("OnMessage message==> ${message.data.toString()}");
      Map<String, dynamic> notificationData = message.data;
      int notificationType = int.parse((notificationData[NotificationConstant.notificationType] ?? 0).toString());
      int orderStatus = int.parse((notificationData[NotificationConstant.rideStatus] ?? 0).toString());
      int orderId = int.parse((notificationData[NotificationConstant.rideId] ?? 0).toString());
      int messageCode = int.parse((notificationData[NotificationConstant.messageCode] ?? 0).toString());
      String notificationMessage = notificationData[NotificationConstant.message] ?? "";
      if (notificationType == 1 && orderId == rideId) {
        pushNotificationService.dismissRideNotification(rideId);
        rideStatus = orderStatus;
        PassengerRunningRidePojo? data = subjectRideDetail.value.data;
        if (orderStatus == 3) {
          if (data?.isOtp == 1 && (data?.otp ?? "").isNotEmpty) {
            openOTPBottomSheet(data?.otp ?? "");
          }
        } else if (orderStatus == 4) {
          openCommonCancelBottomSheet(notificationMessage, orderId);
        }
        getRideDetailApi();
        if (orderStatus == 9 && bottomSheetContext == null && messageCode == 114) {
          bottomSheetContext = context;
          openCommonCompleteBottomSheet(notificationMessage);
        }
      }
    });
  }

  @override
  void dispose() {
    mapStyle.close();
    subjectRideDetail.close();
    rotateMarkerListController.close();
    markersListController.close();
    polyLinesController.close();
    subjectDistance.close();
    subjectTime.close();
    subjectCancelOrder.close();
    subjectRating.close();
    subjectPay.close();
    if (firebaseOnMessageStream != null) {
      firebaseOnMessageStream!.cancel();
    }
    _rideStatusPollTimer?.cancel();
  }
}
