import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../services/push_notification_service.dart';

/// Ride-related pushes that need sound, vibration, and heads-up priority.
const Set<int> kRideAlertNotificationTypes = {1, 6, 7, 8, 14};

bool isRideAlertNotificationType(int type) => kRideAlertNotificationTypes.contains(type);

Map<String, dynamic> normalizeNotificationPayload(RemoteMessage message) {
  final data = Map<String, dynamic>.from(message.data);
  final alert = message.notification;
  if (alert != null) {
    data.putIfAbsent(NotificationConstant.title, () => alert.title ?? '');
    data.putIfAbsent(NotificationConstant.message, () => alert.body ?? '');
    data.putIfAbsent('body', () => alert.body ?? '');
  }
  return normalizeNotificationDataMap(data);
}

Map<String, dynamic> normalizeNotificationDataMap(Map<String, dynamic> data) {
  final normalized = Map<String, dynamic>.from(data);
  final message = (normalized[NotificationConstant.message] ?? normalized['body'] ?? '').toString();
  if (message.isNotEmpty) {
    normalized[NotificationConstant.message] = message;
    normalized['body'] = message;
  }
  final title = (normalized[NotificationConstant.title] ?? normalized['title'] ?? '').toString();
  if (title.isNotEmpty) {
    normalized[NotificationConstant.title] = title;
  }
  return normalized;
}

int notificationIdForData(Map<String, dynamic> data) {
  final rideId = int.tryParse((data[NotificationConstant.rideId] ?? '').toString());
  if (rideId != null && rideId > 0) return rideId;
  final userId = data[NotificationConstant.userId];
  if (userId != null) {
    final parsed = int.tryParse(userId.toString().replaceAll(RegExp(r'[^0-9]'), ''));
    if (parsed != null && parsed > 0) return parsed;
  }
  return data.hashCode;
}

class NotificationDisplayConfig {
  final AndroidNotificationChannel channel;
  final String? soundIOS;
  final bool fullScreenIntent;
  final bool playFeedbackSound;

  const NotificationDisplayConfig({
    required this.channel,
    this.soundIOS,
    this.fullScreenIntent = false,
    this.playFeedbackSound = false,
  });
}

NotificationDisplayConfig resolveNotificationDisplayConfig(int notificationType) {
  switch (notificationType) {
    case 7:
      return NotificationDisplayConfig(
        channel: const AndroidNotificationChannel(
          'new_request_channel',
          'New Request Notifications',
          description: 'Driver new ride requests',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          sound: RawResourceAndroidNotificationSound('new_request'),
        ),
        soundIOS: 'new_request.wav',
        fullScreenIntent: true,
        playFeedbackSound: true,
      );
    case 1:
    case 6:
    case 8:
    case 14:
      return NotificationDisplayConfig(
        channel: const AndroidNotificationChannel(
          'ride_alert_channel',
          'Ride Alerts',
          description: 'High priority ride notifications',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          sound: RawResourceAndroidNotificationSound('new_request'),
        ),
        soundIOS: 'new_request.wav',
        fullScreenIntent: true,
        playFeedbackSound: true,
      );
    default:
      return NotificationDisplayConfig(
        channel: const AndroidNotificationChannel(
          'high_importance_channel',
          'High Importance Notifications',
          description: 'Account and ride alerts',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
        playFeedbackSound: isRideAlertNotificationType(notificationType),
      );
  }
}
