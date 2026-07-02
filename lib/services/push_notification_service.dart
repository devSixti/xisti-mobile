import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constant/chat_constant.dart';
import '../hive/hive_helper.dart';
import '../networking/base_dl.dart';
import '../screen/common/chatting/chatting_screen.dart';
import '../screen/common/languageCurrency/language_and_currency_repo.dart';
import '../screen/common/notificationsScreen/notification_screen.dart';
import '../screen/common/reportIssue/addReportIssue/add_report_issue_screen.dart';
import '../screen/common/splash/splash_screen.dart';
import '../screen/common/wallet/walletHome/wallet_home.dart';
import '../screen/driverMode/driverDocumentScreen/require_document_screen.dart';
import '../screen/driverMode/driverHome/driver_home.dart';
import '../screen/driverMode/driverNewRequest/driver_new_request_screen.dart';
import '../screen/driverMode/driverRideDetail/driver_ride_detail.dart';
import '../screen/driverMode/driverRideHistory/driver_ride_history.dart';
import '../screen/driverMode/driverRunningRide/driver_running_ride.dart';
import '../screen/passengerMode/offerRide/offer_ride_screen.dart';
import '../screen/passengerMode/passengerRideDetail/passenger_ride_detail.dart';
import '../screen/passengerMode/passengerRunningRide/passenger_running_ride.dart';
import 'ride_session_manager.dart';
import '../utils/alert_feedback_util.dart';
import '../utils/notification_payload_util.dart';
import '../utils/utils.dart';

bool isChatNotificationData(Map<String, dynamic> notificationData) {
  final userId = notificationData[NotificationConstant.userId];
  if (userId == null || userId.toString().trim().isEmpty) {
    return false;
  }
  final rawType = notificationData[NotificationConstant.notificationType];
  return rawType == null || rawType.toString().trim().isEmpty;
}

class PushNotificationService {
  String tag = "PushNotificationService>>>";

  /// Create a [AndroidNotificationChannel] for heads up notifications

  AndroidNotificationChannel newRequestChannel = const AndroidNotificationChannel(
    'new_request_channel', // id
    'New Request Notifications', // title
    description: 'This channel is used for new request notifications.', // description
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound("new_request"),
  );

  AndroidNotificationChannel highImportanceChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  AndroidNotificationChannel rideAlertChannel = const AndroidNotificationChannel(
    'ride_alert_channel',
    'Ride Alerts',
    description: 'High priority ride notifications for drivers and passengers.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    sound: RawResourceAndroidNotificationSound('new_request'),
  );

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final StreamController<NotificationResponse> pushNotificationStream = StreamController<NotificationResponse>.broadcast();
  final LanguageAndCurrencyRepo _selectLanguageAndCurrencyRepo = LanguageAndCurrencyRepo();

  Future<void> dismissRideNotification(int? rideId) async {
    if (rideId != null && rideId > 0) {
      await flutterLocalNotificationsPlugin.cancel(id: rideId);
    }
  }

  Future<void> dismissNotificationsForRideIds(Iterable<int> rideIds) async {
    for (final rideId in rideIds) {
      await dismissRideNotification(rideId);
    }
  }

  Future<void> pushNotificationInitialise() async {
    if (await isNetworkConnected()) {
      await _firebaseNotificationPermissions();
      getFCMToken();
    }
    await initLocalNotification();
    _localNotificationPermissions();
  }

  Future<void> _firebaseNotificationPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await getAPNsToken();
    try {
      FirebaseMessaging.instance.subscribeToTopic(firebaseTopicNameForUser);
    } catch (e) {
      logd(e.toString());
    }

    /// Foreground: FCM no muestra banner en iOS; usamos notificación local + sonido en showNotification.
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }

  void configureSelectNotificationSubject() {
    pushNotificationStream.stream.listen((NotificationResponse? notificationResponse) async {
      Map<String, dynamic> notificationData = jsonDecode(notificationResponse?.payload ?? "");
      logd("NotificationAppLaunchDetails ===> $notificationData");
      await handleNotificationClick(
        notificationData: notificationData,
        isClearPrevious: (isAppKilledOrTerminatedSubject.value && Platform.isIOS) ? true : false,
      );
    });
  }

  Future<void> showNotification(Map<String, dynamic> notificationData, {bool isFromForeground = true}) async {
    notificationData = normalizeNotificationDataMap(notificationData);
    if (shouldVibrateForNotificationData(notificationData)) {
      unawaited(triggerRideAlertFeedback());
    }
    bool isShowNotification = true;

    String title = notificationData[NotificationConstant.title] != null ? notificationData[NotificationConstant.title].toString() : "";
    String message = notificationData[NotificationConstant.message] != null ? notificationData[NotificationConstant.message].toString() : "";

    message = notificationData[NotificationConstant.userId] == null ? message : notificationData[NotificationConstant.desc].toString();

    int notificationType = int.parse((notificationData[NotificationConstant.notificationType] ?? -1).toString());
    int rideStatus = int.parse((notificationData[NotificationConstant.rideStatus] ?? 0).toString());
    int rideId = int.parse((notificationData[NotificationConstant.rideId] ?? 0).toString());
    int userType = int.parse((notificationData[NotificationConstant.userType] ?? 0).toString());
    int rideType = int.parse((notificationData[NotificationConstant.rideType] ?? 0).toString());

    if (notificationType == 1 && userType == 1 && (rideStatus == 1 || rideStatus == 2)) {
      unawaited(triggerRideAlertFeedback(playSound: Platform.isIOS));
    }

    if (notificationType == 1 && rideStatus == 1) {
      if (rideType == 1) {
        openScreenWithClearPrevious(navigatorKey.currentContext!, openRideDetailScreen(rideId, userType, isDriverHistoryOpen: true));
      } else {
        openScreenWithClearPrevious(navigatorKey.currentContext!, openRunningRideScreen(rideId, userType));
      }
    }

    int? notificationId;
    AndroidNotificationChannel androidNotificationChannel = highImportanceChannel;
    String? soundIOS;
    Importance? importance;
    Priority? priority;
    bool fullScreenIntent = false;
    if (notificationData[NotificationConstant.notificationType] != null) {
      switch (notificationType) {
        case 0: // Notification screen
        case 9: // Splash
        case 13: // Require document
          androidNotificationChannel = highImportanceChannel;
          break;
        case 8: // Offer ride
        case 14: // Driver home
          androidNotificationChannel = rideAlertChannel;
          soundIOS = "new_request.wav";
          fullScreenIntent = true;
          unawaited(triggerRideAlertFeedback(playSound: Platform.isIOS));
          break;
        case 12: // Report issue
          androidNotificationChannel = highImportanceChannel;
          break;
        case 7: // New request (Driver)
          if (acceptRequestBottomSheetState?.mounted ?? false) {
            isShowNotification = false;
          } else {
            androidNotificationChannel = newRequestChannel;
            unawaited(triggerRideAlertFeedback(playSound: true));
            soundIOS = "new_request.wav";
            fullScreenIntent = true;
          }
          break;
        case 1:
        case 6:
          androidNotificationChannel = rideAlertChannel;
          soundIOS = "new_request.wav";
          fullScreenIntent = true;
          unawaited(triggerRideAlertFeedback(playSound: Platform.isIOS));
          break;
        default:
          androidNotificationChannel = highImportanceChannel;
          break;
      }
    } else if ((!(chatState?.mounted ?? false)) ||
        (chatState?.mounted ?? false) && (chatState?.widget.chatWithId != notificationData[NotificationConstant.userId]) ||
        (chatState?.mounted ?? false) && (chatState?.widget.chatNo != notificationData[NotificationConstant.orderChatNumber])) {
      notificationId = int.parse(
        ((notificationData[NotificationConstant.userId] ?? notificationData.hashCode)
            .toString()
            .replaceAll(ChatConstant.userIdCode, "")
            .replaceAll(ChatConstant.adminIdCode, "")
            .trim()),
      );

      androidNotificationChannel = highImportanceChannel;
    } else if ((chatState?.mounted ?? false) &&
        (chatState?.widget.chatWithId == notificationData[NotificationConstant.userId] ||
            chatState?.widget.chatNo == notificationData[NotificationConstant.orderChatNumber])) {
      isShowNotification = false;
    }
    if (isShowNotification) {
      createNotification(
        notificationId: notificationId ?? notificationIdForData(notificationData),
        title: title,
        message: message,
        androidNotificationChannel: androidNotificationChannel,
        notificationData: notificationData,
        importance: importance,
        priority: priority,
        soundIOS: soundIOS,
        fullScreenIntent: fullScreenIntent,
      );
    }
  }

  Future<void> createNotification({
    int? notificationId,
    required String title,
    required String message,
    required AndroidNotificationChannel androidNotificationChannel,
    required Map<String, dynamic> notificationData,
    Importance? importance,
    Priority? priority,
    String? soundIOS,
    bool fullScreenIntent = false,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id: notificationId ?? notificationData.hashCode,
      title: title,
      body: message,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          androidNotificationChannel.id,
          androidNotificationChannel.name,
          channelDescription: androidNotificationChannel.description,
          icon: 'ic_notification',
          color: AppThemeColors().themeMode == 1 ? AppThemeColors.light().colorPrimary : AppThemeColors.dark().colorPrimary,
          importance: importance ?? Importance.max,
          priority: priority ?? Priority.max,
          playSound: true,
          enableVibration: true,
          fullScreenIntent: fullScreenIntent,
          sound: androidNotificationChannel.sound,
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true, sound: soundIOS),
      ),
      payload: jsonEncode(notificationData),
    );
  }

  Future<void> handleNotificationClick({
    required Map<String, dynamic> notificationData,
    required bool isClearPrevious,
    bool clearAllNotifications = false,
  }) async {
    debugPrint("handleNotificationClick 1-------->>>>>>>>>>>> $notificationData");
    if (isLoggedIn()) {
      Widget screen = const SplashScreen();
      bool isReplaceScreen = false;
      bool needToOpenScreen = true;
      final int notificationType = int.parse((notificationData[NotificationConstant.notificationType] ?? -1).toString());

      /// ---------------- CHAT NOTIFICATION ----------------
      if (isChatNotificationData(notificationData)) {
        if (chatState?.mounted ?? false) isReplaceScreen = true;
        final bool isReportChat = int.parse((notificationData[NotificationConstant.isReportChat] ?? 0).toString()) == 1;
        screen = ChattingScreen(
          showImagePick: isReportChat,
          isReportIssueChat: isReportChat,
          chatWithId: notificationData[NotificationConstant.userId].toString(),
          chatWithName: notificationData[NotificationConstant.title].toString(),
          chatWithImage: notificationData[NotificationConstant.userImg].toString(),
          chatWithUserType: int.parse((notificationData[NotificationConstant.userType] ?? -1).toString()),
          chatNo: notificationData[NotificationConstant.orderChatNumber].toString(),
        );
      } else {
        final int rideId = int.parse((notificationData[NotificationConstant.rideId] ?? 0).toString());
        final int rideStatus = int.parse((notificationData[NotificationConstant.rideStatus] ?? 0).toString());
        final int userType = int.parse((notificationData[NotificationConstant.userType] ?? 0).toString());
        final int rideType = int.parse((notificationData[NotificationConstant.rideType] ?? 0).toString());
        final int reportId = int.parse((notificationData[NotificationConstant.reportId] ?? 0).toString());
        RideSessionManager.instance.applyPushNotification(notificationType: notificationType, rideId: rideId);

        /// ---------------- NORMAL NOTIFICATION ----------------
        switch (notificationType) {
          case 0:
            if (notificationState?.mounted ?? false) isReplaceScreen = true;
            screen = const NotificationScreen();
            break;

          case 6:
            isClearPrevious = true;
            screen = const WalletHome();
            break;

          case 7:
            needToOpenScreen = !isNewRequestScreenOpen;
            screen = DriverNewRequestScreen(rideId: rideId);
            break;

          case 8:
            isClearPrevious = true;
            List<AddressListItem> addressList = [];

            final String addressJson = (notificationData[NotificationConstant.addressList] ?? "").toString();
            if (addressJson.isNotEmpty) {
              final List parsedList = jsonDecode(addressJson);
              addressList = parsedList.map((e) => AddressListItem.fromJson(e)).toList();
            }
            screen = OfferRideScreen(
              rideId: rideId,
              serviceType: int.parse((notificationData[NotificationConstant.serviceId] ?? 0).toString()),
              addressList: addressList,
              estimatedPrice: (notificationData[NotificationConstant.estimatePrice] ?? "").toString(),
              fareAmount: (notificationData[NotificationConstant.offeredPrice] ?? "").toString(),
              itemDesc: (notificationData[NotificationConstant.itemDescription] ?? "").toString(),
              recipientName: (notificationData[NotificationConstant.recipientName] ?? "").toString(),
              recipientNumber: (notificationData[NotificationConstant.recipientContactNumber] ?? "").toString(),
              minFareAmount: (notificationData[NotificationConstant.minBargainAmt] ?? "").toString(),
              maxFareAmount: (notificationData[NotificationConstant.maxBargainAmt] ?? "").toString(),
            );
            break;

          case 9:
            screen = const SplashScreen();
            break;

          case 12:
            screen = AddReportIssueScreen(isFromNotification: true, isFromIssueHistory: true, reportId: reportId, isResolved: true);
            break;

          case 13:
            isClearPrevious = true;
            screen = const RequireDocumentScreen(isFromHomeScreen: false);
            break;

          case 14:
            isClearPrevious = true;
            screen = const DriverHome();
            break;

          default:
            if (notificationType != 0) {
              isClearPrevious = true;
              if (rideStatus == 4 || rideStatus == 9 || rideStatus == 10) {
                screen = openRideDetailScreen(rideId, userType);
              } else if (rideType == 1 && rideStatus < 3) {
                screen = openRideDetailScreen(rideId, userType, isDriverHistoryOpen: true);
              } else {
                screen = openRunningRideScreen(rideId, userType);
              }
            }
            break;
        }
      }
      if (needToOpenScreen) {
        if (isReplaceScreen) {
          openScreenWithReplacePrevious(navigatorKey.currentContext!, screen);
        } else if (isClearPrevious) {
          openScreenWithClearPrevious(navigatorKey.currentContext!, screen);
        } else {
          openScreen(navigatorKey.currentContext!, screen);
        }
      }
    } else {
      openScreenWithClearPrevious(navigatorKey.currentContext!, const SplashScreen());
    }
  }

  void showNotificationInApp() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("onMessage -------->>>>>>>>>>>> ${message.data}");
      //Added this condition due to Firebase messaging(14.7.10) lib issue. It's call with empty data when clear notification
      if (message.data.isNotEmpty) {
        Map<String, dynamic> notificationData = normalizeNotificationPayload(message);
        showNotification(notificationData);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      debugPrint("onMessageOpenedApp -------->>>>>>>>>>>> ${message?.data}");
      if (message != null) {
        Map<String, dynamic> notificationData = normalizeNotificationPayload(message);
        await handleNotificationClick(notificationData: notificationData, isClearPrevious: false);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      debugPrint("getInitialMessage -------->>>>>>>>>>>> ${message?.data}");
      if (message != null) {
        Map<String, dynamic> notificationData = normalizeNotificationPayload(message);
        await handleNotificationClick(notificationData: notificationData, isClearPrevious: true);
      }
    });

    onTokenRefreshFun();
  }

  Future initLocalNotification() async {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      newRequestChannel,
    );
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      highImportanceChannel,
    );
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      rideAlertChannel,
    );

    /// Configure Android initialization settings, including the app icon.
    var initializationSettingsAndroid = const AndroidInitializationSettings('@drawable/ic_notification');

    /// Configure iOS initialization settings to request all permissions.
    var initializationSettingsIOS = DarwinInitializationSettings(requestSoundPermission: true, requestBadgePermission: true, requestAlertPermission: true);

    /// Configure initialization settings by combining both Android and iOS settings.\
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    /// Use [NotificationAppLaunchDetails] to handle cases where the app is killed or terminated, allowing the app to open and handle notification clicks.
    /// Place this code below the [FlutterLocalNotificationsPlugin] initialization.
    NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    bool didNotificationLaunchApp = notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

    if (didNotificationLaunchApp) {
      if ((notificationAppLaunchDetails?.notificationResponse?.payload ?? "").isNotEmpty) {
        logd("NotificationAppLaunchDetails ===> ${notificationAppLaunchDetails!.notificationResponse?.payload}");
        Map<String, dynamic> notificationData = jsonDecode(notificationAppLaunchDetails.notificationResponse?.payload ?? "");
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await handleNotificationClick(notificationData: notificationData, isClearPrevious: true);
        });
      }
    }

    /// Inside the FlutterLocalNotificationsPlugin initialize method, add the InitializationSettings and the onDidReceiveNotificationResponse callback.
    /// The onDidReceiveNotificationResponse method handles and accesses notification data when the app is running in the background.

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        pushNotificationStream.sink.add(response);
      },
    );
  }

  StatefulWidget openRideDetailScreen(int rideId, int userType, {bool isDriverHistoryOpen = false}) {
    // 1 : passenger
    // 2 : driver
    if (userType == 1) {
      return PassengerRideDetail(rideId: rideId);
    } else {
      if (isDriverHistoryOpen) {
        return DriverRideHistory();
      } else {
        return DriverRideDetail(rideId: rideId);
      }
    }
  }

  StatefulWidget openRunningRideScreen(int rideId, int userType) {
    // 1 : passenger
    // 2 : driver
    if (userType == 1) {
      return PassengerRunningRide(rideId: rideId, isFromNotification: true);
    } else {
      return DriverRunningRide(rideId: rideId, serviceId: getIntFromSettingBox(hiveServiceId));
    }
  }

  void onTokenRefreshFun() async {
    await getAPNsToken();
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      if (!isLoggedIn()) return;

      if (newToken != getStringFromSettingBox(hiveDeviceToken)) {
        putDataInSettingBox(hiveDeviceToken, newToken);
        setFCMToken();
        callUpdateDeviceTokenApi();
      }
    });
  }

  void callUpdateDeviceTokenApi() async {
    if (await isNetworkConnected()) {
      try {
        var response = BaseModel.fromJson(await _selectLanguageAndCurrencyRepo.updateDeviceTokenApi());
        logd(">>> ${response.toString()}");
      } catch (e) {
        logd(e.toString());
      }
    }
  }

  Future<void> _localNotificationPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final bool isGranted = await androidImplementation?.areNotificationsEnabled() ?? false;
      if (!isGranted) {
        final bool? granted = await androidImplementation?.requestNotificationsPermission();
        logd("Notification Permission: $granted");
      }
    }
  }

  void dispose() {
    if (pushNotificationStream.isClosed) return;
    pushNotificationStream.close();
  }

  /// Background FCM: show heads-up + payload for tap (v1.0.1 compat).
  @pragma('vm:entry-point')
  static Future<void> displayBackgroundNotification(Map<String, dynamic> rawNotificationData) async {
    final notificationData = normalizeNotificationDataMap(rawNotificationData);
    WidgetsFlutterBinding.ensureInitialized();
    final plugin = FlutterLocalNotificationsPlugin();
    const androidInit = AndroidInitializationSettings('@drawable/ic_notification');
    const iosInit = DarwinInitializationSettings(requestSoundPermission: true, requestBadgePermission: true, requestAlertPermission: true);
    await plugin.initialize(settings: const InitializationSettings(android: androidInit, iOS: iosInit));
    final androidPlugin = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    const newRequestChannel = AndroidNotificationChannel(
      'new_request_channel',
      'New Request Notifications',
      description: 'Driver new ride requests',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('new_request'),
    );
    const highChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Ride and account alerts',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );
    const rideAlertChannel = AndroidNotificationChannel(
      'ride_alert_channel',
      'Ride Alerts',
      description: 'High priority ride notifications for drivers and passengers.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('new_request'),
    );
    await androidPlugin?.createNotificationChannel(newRequestChannel);
    await androidPlugin?.createNotificationChannel(highChannel);
    await androidPlugin?.createNotificationChannel(rideAlertChannel);
    final title = (notificationData['title'] ?? notificationData['body'] ?? 'XISTI').toString();
    final body = (notificationData['message'] ?? notificationData['body'] ?? '').toString();
    final type = int.tryParse((notificationData['notification_type'] ?? -1).toString()) ?? -1;
    final isRideAlert = const {1, 6, 7, 8, 14}.contains(type);
    final soundIos = isRideAlert ? 'new_request.wav' : null;
    final androidChannel = type == 7 ? newRequestChannel : (isRideAlert ? rideAlertChannel : highChannel);
    await plugin.show(
      id: notificationIdForData(notificationData),
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannel.id,
          androidChannel.name,
          channelDescription: androidChannel.description,
          importance: Importance.max,
          priority: Priority.max,
          icon: 'ic_notification',
          playSound: true,
          enableVibration: true,
          fullScreenIntent: isRideAlert,
          sound: androidChannel.sound,
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true, sound: soundIos),
      ),
      payload: jsonEncode(notificationData),
    );
    if (shouldVibrateForNotificationData(notificationData)) {
      await triggerRideAlertFeedback(playSound: isRideAlert);
    }
  }
}

class NotificationConstant {
  static const title = 'title';
  static const titleCode = 'title_code';
  static const message = 'message';
  static const messageCode = 'message_code';
  static const desc = 'desc';
  static const notificationType = 'notification_type';
  static const userId = 'user_id';
  static const userImg = 'user_img';
  static const userServiceName = 'user_service_name';
  static const rideId = 'ride_id';
  static const rideStatus = 'ride_status';
  static const userType = 'user_type';
  static const serviceCategoryId = 'service_category_id';
  static const bookingType = 'booking_type';
  static const customerName = 'customer_name';
  static const serviceId = 'service_id';
  static const pickupAddress = 'pickup_address';
  static const destinationAddress = 'destination_address';
  static const pickupLatLng = 'pickup_latlng';
  static const destinationLatLng = 'destination_latlng';
  static const offeredPrice = 'offered_price';
  static const itemDescription = 'item_description';
  static const recipientName = 'recipient_name';
  static const recipientContactNumber = 'recipient_contact_number';
  static const minBargainAmt = 'min_bargain_amt';
  static const maxBargainAmt = 'max_bargain_amt';
  static const estimatePrice = 'estimate_price';
  static const addressList = 'address_list';
  static const rideType = 'ride_type';
  static const orderChatNumber = 'order_chat_number';
  static const reportId = 'report_id';
  static const isReportChat = 'is_report_chat';
  static const isAppKilledOrTerminated = 'isAppKilledOrTerminated';
  static const dispatchAction = 'dispatch_action';
  static const dispatchTs = 'dispatch_ts';
}
