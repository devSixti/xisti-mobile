import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../services/push_notification_service.dart';
import '../../../utils/utils.dart';
import '../driverHome/driver_home.dart';
import '../driverRideHistory/driver_ride_history.dart';
import '../driverRunningRide/driver_running_ride.dart';
import 'driver_waiting_dl.dart';
import 'driver_waiting_repo.dart';

class DriverWaitingBloc extends Bloc {
  BuildContext context;
  int rideId;
  int serviceId;
  int timeOut;
  StreamSubscription<RemoteMessage>? firebaseOnMessageStream;

  DriverWaitingBloc(this.context, this.rideId, this.serviceId, this.timeOut) {
    startDriverWaitingTimer();
    manageNotification();
  }

  final DriverWaitingRepo _repo = DriverWaitingRepo();

  Timer? _apiTimer;
  Timer? _screenTimer;

  final driverWaitingSubject = BehaviorSubject<ApiResponse<DriverWaitingPojo>>();

  Future<void> callGetRideStatusApi({required bool isLoading}) async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callGetRideStatusApi(isLoading: isLoading);
      },
    )) {
      if (isLoading) {
        driverWaitingSubject.add(ApiResponse.loading());
      }
      try {
        var response = DriverWaitingPojo.fromJson(await _repo.getRideStatusApi(rideId: rideId));
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          if (response.rideStatus == 4) {
            stopTimer();
            openScreenWithClearPrevious(context, const DriverHome());
          } else {
            switch (response.bidStatus) {
              case 0:
                break;
              case 1:
                stopTimer();
                if (response.rideType == 1) {
                  openScreenWithClearPrevious(context, DriverRideHistory());
                } else {
                  openScreenWithClearPrevious(context, DriverRunningRide(rideId: rideId, serviceId: serviceId));
                }
                break;
              case 2:
                stopTimer();
                openScreenWithClearPrevious(context, const DriverHome());
                openSimpleSnackbar(context, languages.reqRejectCustomer);
                break;
            }
          }
        } else {
          stopTimer();
          openScreenWithClearPrevious(context, const DriverHome());
          openSimpleSnackbar(context, message);
          driverWaitingSubject.add(ApiResponse.error(message));
        }
      } catch (e) {
        driverWaitingSubject.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void startDriverWaitingTimer() {
    callGetRideStatusApi(isLoading: true);
    _apiTimer ??= Timer.periodic(const Duration(seconds: 10), (timer) {
      callGetRideStatusApi(isLoading: false);
    });
    _screenTimer ??= Timer(Duration(seconds: timeOut), () {
      stopTimer();
      openScreenWithClearPrevious(context, const DriverHome());
    });
  }

  void stopTimer() {
    if (_apiTimer != null && _apiTimer!.isActive) {
      _apiTimer!.cancel();
    }
    _apiTimer = null;
    if (_screenTimer != null && _screenTimer!.isActive) {
      _screenTimer!.cancel();
    }
    _screenTimer = null;
  }

  /// This function listing all notification here also, while user using this screen....
  void manageNotification() {
    firebaseOnMessageStream ??= FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String, dynamic> notificationData = message.data;
      int notificationType = int.parse((notificationData[NotificationConstant.notificationType] ?? 0).toString());
      int orderId = int.parse((notificationData[NotificationConstant.rideId] ?? 0).toString());
      int rideType = int.parse((notificationData[NotificationConstant.rideType] ?? 0).toString());
      if (notificationType == 1 && orderId == rideId) {
        pushNotificationService.flutterLocalNotificationsPlugin.cancelAll();
        if (rideType == 1) {
          if (!context.mounted) return;
          openScreenWithClearPrevious(context, DriverRideHistory());
        } else {
          if (!context.mounted) return;
          openScreenWithClearPrevious(context, DriverRunningRide(rideId: rideId, serviceId: serviceId));
        }
      } else if (notificationType == 14) {
        if (!context.mounted) return;
        openScreenWithClearPrevious(context, DriverHome());
      }
    });
  }

  @override
  void dispose() {
    if (firebaseOnMessageStream != null) {
      firebaseOnMessageStream!.cancel();
    }
    driverWaitingSubject.close();
    if (_apiTimer != null && _apiTimer!.isActive) {
      _apiTimer!.cancel();
    }
    if (_screenTimer != null && _screenTimer!.isActive) {
      _screenTimer!.cancel();
    }
  }
}
