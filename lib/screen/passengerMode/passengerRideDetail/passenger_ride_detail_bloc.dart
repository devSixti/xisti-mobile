import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/cancel_ride_bottom_sheet.dart';
import '../../../bottomSheet/invoice_detail_bottom_sheet.dart';
import '../../../bottomSheet/rating_bottom_sheet.dart';
import '../../../bottomSheet/selectPaymentBottomSheet/select_payment_bottom_sheet.dart';
import '../../../commonView/statusView/passenger_ride_status_view.dart';
import '../../../constant/chat_constant.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/base_dl.dart';
import '../../../services/active_ride_offline_service.dart';
import '../../../services/push_notification_service.dart';
import '../../../utils/map_curved_lines.dart';
import '../../../utils/utils.dart';
import '../../common/wallet/walletHome/wallet_home_dl.dart';
import '../passengerHome/passenger_home.dart';
import '../../common/wallet/walletHome/wallet_home_repo.dart';
import '../offerRide/offer_ride_repo.dart';
import '../passengerRunningRide/passenger_running_ride.dart';
import '../passengerRunningRide/ps_running_repo.dart';
import '../passengerRunningRide/ps_running_ride_dl.dart';

class PassengerRideDetailBloc extends Bloc {
  GoogleMapController? googleMapController;
  BuildContext context;
  List<AddressListItem> addressList = [];
  double walletAmount = 0;
  final WalletHomeRepo _myWalletRepo = WalletHomeRepo();
  final PassengerRunningRideRepo _passengerRunningRideRepo = PassengerRunningRideRepo();
  final OfferRideRepo _offerRideRepo = OfferRideRepo();
  int rideId;
  StreamSubscription<RemoteMessage>? firebaseOnMessageStream;

  PassengerRideDetailBloc(this.context, this.rideId) {
    subjectRideDetail.sink.add(ApiResponse.loading());
    getWalletAmount();
    manageNotification();
  }

  final mapStyle = BehaviorSubject<String>.seeded("");
  final subjectRideDetail = BehaviorSubject<ApiResponse<PassengerRunningRidePojo>>();
  final markersListController = BehaviorSubject<List<Marker>>();
  final polyLineController = BehaviorSubject<Map<PolylineId, Polyline>>();
  final subjectCancelOrder = BehaviorSubject<ApiResponse<BaseModel>>();
  final subjectRating = BehaviorSubject<ApiResponse<BaseModel>>();
  final subjectPay = BehaviorSubject<ApiResponse<PaymentBaseModel>>();

  Future<void> getRideDetailApi() async {
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
          addressList = response.addressList ?? [];
          if (response.rideStatus == 4) {
            ActiveRideOfflineService.instance.clearRideSnapshot();
            pushNotificationService.flutterLocalNotificationsPlugin.cancelAll();
            openScreenWithClearPrevious(context, const PassengerHome());
            return;
          }
          setMarkers();
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
          getRideDetailApi();
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
          pushNotificationService.flutterLocalNotificationsPlugin.cancelAll();
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

  Future<void> setMarkers() async {
    List<Marker> markerList = [];
    if ((addressList).isNotEmpty) {
      LatLng pickUpLatLng = LatLng(getDoubleFromDynamic(addressList.first.addressLat), getDoubleFromDynamic(addressList.first.addressLong));
      LatLng destinationLatLng = LatLng(getDoubleFromDynamic(addressList.last.addressLat), getDoubleFromDynamic(addressList.last.addressLong));

      BitmapDescriptor pickUpMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, 'ic_pin_pickup_location.png'));
      if (!context.mounted) return;
      BitmapDescriptor destinationMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, 'ic_pin_destination_location.png'));
      markerList.add(
        Marker(
          markerId: const MarkerId("PickUpMarker"),
          position: pickUpLatLng,
          icon: pickUpMarkerIcon,
          infoWindow: const InfoWindow(title: ""),
        ),
      );
      markerList.add(
        Marker(
          markerId: const MarkerId("DestinationMarker"),
          position: destinationLatLng,
          icon: destinationMarkerIcon,
          infoWindow: const InfoWindow(title: ""),
        ),
      );
      markersListController.sink.add(markerList);
      Map<PolylineId, Polyline> polyLines = {};
      PolylineId id = const PolylineId("poly");
      if (!context.mounted) return;
      Polyline polyline = Polyline(
        polylineId: id,
        color: getCurrentTheme(context).colorBlack,
        points: MapsCurvedLines.getPointsOnCurve(pickUpLatLng, destinationLatLng),
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        width: 2.w.toInt(),
      );
      polyLines[id] = polyline;
      polyLineController.sink.add(polyLines);

      var lngs = markerList.map<double>((m) => m.position.longitude).toList();
      var lats = markerList.map<double>((m) => m.position.latitude).toList();

      setMapFitToTourUsingLatLng(latList: lats, longList: lngs, controller: googleMapController!, padding: 30.sp);
    }
  }

  void openInvoiceBottomSheet() {
    PassengerRunningRidePojo? rideDetail = subjectRideDetail.valueOrNull?.data;
    List<KeyValueModel> keyValuesList = [];
    setKeyValuePair(
      keyValuesList: keyValuesList,
      setDivider: false,
      setBold: false,
      setValueWithCurrency: true,
      key: languages.rideFare,
      value: "${rideDetail?.rideFare ?? "0"}",
    );
    setKeyValuePair(
      keyValuesList: keyValuesList,
      setDivider: false,
      setBold: false,
      setValueWithCurrency: true,
      key: languages.tollAmount,
      value: "${rideDetail?.tollCharge ?? "0"}",
    );
    setKeyValuePair(
      keyValuesList: keyValuesList,
      setDivider: false,
      setBold: false,
      setValueWithCurrency: true,
      key: languages.referDiscount,
      value: "${rideDetail?.referDiscount ?? "0"}",
    );
    setKeyValuePair(
      keyValuesList: keyValuesList,
      setDivider: true,
      setBold: true,
      setValueWithCurrency: true,
      key: languages.totalPay,
      value: "${rideDetail?.totalPay ?? "0"}",
    );
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
          child: InvoiceDetailBottomSheet(invoiceList: keyValuesList),
        );
      },
    );
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
        return AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(/*bottom: MediaQuery.of(context).viewInsets.bottom, */ top: MediaQueryData.fromView(View.of(context)).padding.top + 10.h),
          child: RatingBottomSheet(
            title: languages.shareFeedBack,
            onSubmit: (rating, comment) {
              rideRatingApiCall(driverId, rating, comment);
            },
          ),
        );
      },
    );
  }

  void finishChat() {
    String driverIdCode = ChatConstant.userIdCode + (subjectRideDetail.value.data?.driverId ?? 0).toString();
    String userIdCode = ChatConstant.userIdCode + getIntFromUserInfoBox(hiveUserId).toString();

    DatabaseReference referenceMessage = FirebaseDatabase.instance.ref().child(ChatConstant.chat).child(ChatConstant.messages).child("${userIdCode}_$driverIdCode");
    referenceMessage.once().then((dataSnapshot) {
      if (dataSnapshot.snapshot.value != null) {
        referenceMessage.remove();
      }
      return;
    });

    DatabaseReference referenceUser = FirebaseDatabase.instance.ref().child(ChatConstant.chat).child(ChatConstant.users).child(userIdCode);
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
      if (notificationType == 1 && orderId == rideId) {
        if (orderStatus == 4) {
          pushNotificationService.flutterLocalNotificationsPlugin.cancelAll();
          ActiveRideOfflineService.instance.clearRideSnapshot();
          if (!context.mounted) return;
          openScreenWithClearPrevious(context, const PassengerHome());
        } else if (orderStatus == passengerArrive || orderStatus == passengerRunning) {
          if (!context.mounted) return;
          openScreenWithClearPrevious(context, PassengerRunningRide(rideId: rideId, isFromNotification: true));
        } else {
          PassengerRunningRidePojo? data = subjectRideDetail.value.data;
          data?.setRideStatus(orderStatus);
          subjectRideDetail.add(ApiResponse.completed(data));
          getRideDetailApi();
        }
      }
    });
  }

  @override
  void dispose() {
    if (firebaseOnMessageStream != null) {
      firebaseOnMessageStream!.cancel();
    }
    mapStyle.close();
    subjectRideDetail.close();
    markersListController.close();
    polyLineController.close();
    subjectCancelOrder.close();
    subjectRating.close();
    subjectPay.close();
  }
}
