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
  bool _hasNavigatedAway = false;

  DriverWaitingBloc(this.context, this.rideId, this.serviceId, this.timeOut) {
    startDriverWaitingTimer();
    manageNotification();
  }

  final DriverWaitingRepo _repo = DriverWaitingRepo();

  Timer? _apiTimer;
  Timer? _screenTimer;

  final driverWaitingSubject = BehaviorSubject<ApiResponse<DriverWaitingPojo>>();

  void _leaveWaitingScreen(Widget screen) {
    if (_hasNavigatedAway || !context.mounted) {
      return;
    }
    _hasNavigatedAway = true;
    stopTimer();
    openScreenWithClearPrevious(context, screen);
  }

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
            _leaveWaitingScreen(const DriverHome());
          } else {
            switch (response.bidStatus) {
              case 0:
                break;
              case 1:
                if (response.rideType == 1) {
                  _leaveWaitingScreen(DriverRideHistory());
                } else {
                  _leaveWaitingScreen(DriverRunningRide(rideId: rideId, serviceId: serviceId));
                }
                break;
              case 2:
                _leaveWaitingScreen(const DriverHome());
                if (context.mounted) {
                  openSimpleSnackbar(context, languages.reqRejectCustomer);
                }
                break;
            }
          }
        } else {
          driverWaitingSubject.add(ApiResponse.error(message));
          if (context.mounted && isLoading) {
            openSimpleSnackbar(context, message);
          }
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
      _leaveWaitingScreen(const DriverHome());
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
        pushNotificationService.dismissRideNotification(rideId);
        if (rideType == 1) {
          _leaveWaitingScreen(DriverRideHistory());
        } else {
          _leaveWaitingScreen(DriverRunningRide(rideId: rideId, serviceId: serviceId));
        }
      } else if (notificationType == 14 && orderId == rideId) {
        _leaveWaitingScreen(const DriverHome());
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
