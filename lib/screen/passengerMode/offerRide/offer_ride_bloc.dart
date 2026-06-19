import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/common_bottom_sheet.dart';
import '../../../bottomSheet/raise_fare_sheet.dart';
import '../../../networking/base_dl.dart';
import '../../../services/dispatch_trigger_service.dart';
import '../../../services/push_notification_service.dart';
import '../../../utils/alert_feedback_util.dart';
import '../../../utils/utils.dart';
import '../passengerHome/passenger_home.dart';
import '../passengerRideDetail/passenger_ride_detail.dart';
import '../passengerRunningRide/passenger_running_ride.dart';
import 'offer_ride_dl.dart';
import 'offer_ride_repo.dart';

class OfferRideBloc extends Bloc {
  BuildContext context;
  GoogleMapController? googleMapController;
  String offerFare;
  int rideId;
  final dynamic minFareAmount, maxFareAmount;
  StreamSubscription<RemoteMessage>? firebaseOnMessageStream;
  final OfferRideRepo _offerRideRepo = OfferRideRepo();
  Timer? _apiTimer;

  double get fareNegotiationStep => getFareNegotiationStep();

  OfferRideBloc(this.context, this.rideId, {required this.offerFare, required this.minFareAmount, required this.maxFareAmount}) {
    totalAmountController.sink.add(getDoubleFromDynamic(offerFare));
    raiseFareBtnController.sink.add(false);
    manageNotification();
  }

  final findDriverSubject = BehaviorSubject<ApiResponse<OfferRidePojo>>();
  final totalAmountController = BehaviorSubject<dynamic>();
  final minAvailableController = BehaviorSubject<bool>.seeded(true);
  final maxAvailableController = BehaviorSubject<bool>.seeded(true);
  final driverListController = BehaviorSubject<List<ItemDriverBid>>();
  final mapStyle = BehaviorSubject<String>.seeded("");
  final updatePriceSubject = BehaviorSubject<ApiResponse<BaseModel>>();
  final acceptDriverSubject = BehaviorSubject<ApiResponse<BaseModel>>();
  final rejectDriverSubject = BehaviorSubject<ApiResponse<BaseModel>>();
  final cancelRideSubject = BehaviorSubject<ApiResponse<BaseModel>>();
  final raiseFareBtnController = BehaviorSubject<bool>.seeded(true);
  final bottomSheetHideFromRaiseFareController = BehaviorSubject<bool>.seeded(false);

  Future<void> findDriverApi(bool isLoading) async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        findDriverApi(isLoading);
      },
    )) {
      if (isLoading) {
        findDriverSubject.sink.add(ApiResponse.loading());
      }
      try {
        var response = OfferRidePojo.fromJson(await _offerRideRepo.findDriverApi(rideId));
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status ?? 0, message, messageCode: response.messageCode ?? 0, true, hideMessOnCodeList: [26])) {
          driverListController.sink.add(response.itemDriverBid ?? []);
          findDriverSubject.sink.add(ApiResponse.completed(response));
        } else {
          if (response.messageCode == 26) {
            openScreenWithClearPrevious(context, const PassengerHome(isFromLogin: true));
          }
          findDriverSubject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        findDriverSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> updatePriceApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        updatePriceApi();
      },
    )) {
      updatePriceSubject.sink.add(ApiResponse.loading());

      try {
        var response = BaseModel.fromJson(await _offerRideRepo.updatePriceApi(rideId, totalAmountController.valueOrNull ?? 0));
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          updatePriceSubject.sink.add(ApiResponse.completed(response));
          startFindDriverTimer();
          raiseFareBtnController.sink.add(false);
        } else {
          openSimpleSnackbar(context, message);
          updatePriceSubject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        updatePriceSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> acceptDriverApi(ItemDriverBid itemDriverBid) async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        acceptDriverApi(itemDriverBid);
      },
    )) {
      acceptDriverSubject.sink.add(ApiResponse.loading());
      itemDriverBid.setAcceptLoading(true);
      try {
        var response = BaseModel.fromJson(await _offerRideRepo.acceptDriverApi(itemDriverBid.rideId ?? 0, itemDriverBid.driverId ?? 0));
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true, messageCode: response.messageCode, hideMessOnCodeList: [26])) {
          stopTimer();
          acceptDriverSubject.sink.add(ApiResponse.completed(response));
          itemDriverBid.setAcceptLoading(false);
          pushNotificationService.dismissRideNotification(rideId);
          openScreenWithClearPrevious(
            context,
            itemDriverBid.rideType == 1 ? PassengerRideDetail(rideId: rideId) : PassengerRunningRide(rideId: itemDriverBid.rideId ?? 0),
          );
        } else {
          openSimpleSnackbar(context, message);
          acceptDriverSubject.sink.add(ApiResponse.error(message));
          itemDriverBid.setAcceptLoading(false);
        }
      } catch (e) {
        itemDriverBid.setAcceptLoading(false);
        acceptDriverSubject.sink.add(ApiResponse.error(e.toString()));
      }
    } else {
      itemDriverBid.setAcceptLoading(false);
    }
  }

  Future<void> rejectDriverApi(ItemDriverBid itemDriverBid) async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        rejectDriverApi(itemDriverBid);
      },
    )) {
      rejectDriverSubject.sink.add(ApiResponse.loading());
      itemDriverBid.setRejectLoading(true);
      try {
        var response = BaseModel.fromJson(await _offerRideRepo.rejectDriverApi(itemDriverBid.rideId ?? 0, itemDriverBid.driverId ?? 0));
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          itemDriverBid.setRejectLoading(false);
          findDriverApi(false);
          rejectDriverSubject.sink.add(ApiResponse.completed(response));
        } else {
          itemDriverBid.setRejectLoading(false);
          openSimpleSnackbar(context, message);
          rejectDriverSubject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        itemDriverBid.setRejectLoading(false);
        rejectDriverSubject.sink.add(ApiResponse.error(e.toString()));
      }
    } else {
      itemDriverBid.setRejectLoading(false);
    }
  }

  Future<void> cancelRideApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        cancelRideApi();
      },
    )) {
      cancelRideSubject.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(await _offerRideRepo.cancelRideBookingApi(rideId, ""));
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          stopTimer();
          pushNotificationService.dismissRideNotification(rideId);
          cancelRideSubject.sink.add(ApiResponse.completed(response));
          openScreenWithClearPrevious(context, const PassengerHome());
        } else {
          openSimpleSnackbar(context, message);
          cancelRideSubject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        cancelRideSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void onMapCreated(GoogleMapController googleMapController) {
    this.googleMapController = googleMapController;
    getCurrentLocation();
    startFindDriverTimer();
  }

  Future<void> getCurrentLocation() async {
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

  void startFindDriverTimer() {
    findDriverApi(true);
    if (_apiTimer?.isActive ?? false) return;
    _apiTimer = Timer.periodic(DispatchTriggerService.fastPollInterval, (timer) {
      if (DispatchTriggerService.shouldSkipScheduledPoll('refresh_driver_bids')) {
        return;
      }
      findDriverApi(false);
    });
  }

  void stopTimer() {
    if (_apiTimer != null && _apiTimer!.isActive) {
      _apiTimer!.cancel();
    }
    _apiTimer = null;
  }

  void farePlus() {
    double total = totalAmountController.valueOrNull ?? 0;
    total = total + fareNegotiationStep;
    if (total == getDoubleFromDynamic(offerFare)) {
      raiseFareBtnController.sink.add(false);
    } else {
      raiseFareBtnController.sink.add(true);
    }
    if (total <= maxFareAmount) {
      maxAvailableController.sink.add(true);
      totalAmountController.sink.add(total);
      minAvailableController.sink.add(true);
    } else {
      maxAvailableController.sink.add(false);
      openSimpleSnackbar(context, languages.offerFareMax(getAmountWithCurrency(maxFareAmount)));
    }
  }

  void fareMinus() {
    dynamic total = totalAmountController.valueOrNull ?? 0;
    total = total - fareNegotiationStep;
    if (total == getDoubleFromDynamic(offerFare)) {
      raiseFareBtnController.sink.add(false);
    } else {
      raiseFareBtnController.sink.add(true);
    }
    if (total >= minFareAmount) {
      minAvailableController.sink.add(true);
      maxAvailableController.sink.add(true);
      totalAmountController.sink.add(total);
    } else {
      minAvailableController.sink.add(false);
      openSimpleSnackbar(context, languages.offerFareMin(getAmountWithCurrency(minFareAmount)));
    }
  }

  void openRaiseFareSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return RaiseFareSheet(
          minFare: getDoubleFromDynamic(minFareAmount),
          maxFare: getDoubleFromDynamic(maxFareAmount),
          currentFare: totalAmountController.valueOrNull ?? 0,
          onSubmit: (newOfferFare) {
            raiseFareBtnController.sink.add(getDoubleFromDynamic(newOfferFare) != getDoubleFromDynamic(offerFare));
            totalAmountController.sink.add(getDoubleFromDynamic(newOfferFare));
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void openCancelSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return CommonBottomSheet(
          title: languages.cancelRide,
          message: languages.sureToCancel,
          positiveButtonTxt: languages.yes,
          negativeButtonTxt: languages.no,
          onPositivePress: () {
            Navigator.pop(context);
            cancelRideApi();
          },
          onNegativePress: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void showOrderCancelSheet(String message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return CommonBottomSheet(
          title: languages.rideCancel,
          message: message,
          positiveButtonTxt: languages.yes,
          onPositivePress: () {
            openScreenWithClearPrevious(context, const PassengerHome());
          },
        );
      },
    );
  }

  void manageNotification() {
    firebaseOnMessageStream ??= FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("OnMessage message==> ${message.data.toString()}");
      Map<String, dynamic> notificationData = message.data;
      DispatchTriggerService.recordFromNotificationData(notificationData);
      int notificationType = int.parse((notificationData[NotificationConstant.notificationType] ?? 0).toString());
      int orderStatus = int.parse((notificationData[NotificationConstant.rideStatus] ?? 0).toString());
      int rideType = int.parse((notificationData[NotificationConstant.rideType] ?? 0).toString());
      String notificationMessage = notificationData[NotificationConstant.message] ?? "";

      if (notificationType == 1 && orderStatus == 4) {
        showOrderCancelSheet(notificationMessage);
        pushNotificationService.dismissRideNotification(rideId);
        stopTimer();
      } else if (notificationType == 1) {
        unawaited(triggerRideAlertFeedback());
        stopTimer();
        if (!context.mounted) return;
        if (rideType == 1) {
          openScreenWithClearPrevious(context, PassengerRideDetail(rideId: rideId));
        } else {
          openScreenWithClearPrevious(context, PassengerRunningRide(rideId: rideId));
        }
      } else if (notificationType == 8) {
        pushNotificationService.dismissRideNotification(rideId);
        DispatchTriggerService.recordManualRefresh('refresh_driver_bids');
        findDriverApi(false);
      }
    });
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    totalAmountController.close();
    acceptDriverSubject.close();
    rejectDriverSubject.close();
    cancelRideSubject.close();
    if (_apiTimer != null && _apiTimer!.isActive) {
      _apiTimer!.cancel();
    }
    if (firebaseOnMessageStream != null) {
      firebaseOnMessageStream!.cancel();
    }
  }
}
