import 'dart:io';

import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

/// Ride, wallet, document, and offer notifications should vibrate when the OS allows it.
bool shouldVibrateForNotificationData(Map<String, dynamic> data) {
  final userId = data['user_id'];
  if (userId != null && userId.toString().trim().isNotEmpty) {
    final rawType = data['notification_type'];
    if (rawType == null || rawType.toString().trim().isEmpty) {
      return true;
    }
  }
  final type = int.tryParse((data['notification_type'] ?? -1).toString()) ?? -1;
  return const {0, 1, 6, 7, 8, 12, 13, 14}.contains(type);
}

/// In-app alert tone (assets/audio/new_request.mp3). iOS system banners use ios/Runner/new_request.wav.
Future<void> playNewRequestInAppSound() async {
  try {
    final audioPlayer = AudioPlayer();
    await audioPlayer.setAsset('assets/audio/new_request.mp3');
    await audioPlayer.play();
    Future<void>.delayed(const Duration(seconds: 4), () async {
      await audioPlayer.dispose();
    });
  } catch (_) {}
}

/// Haptic + vibration alert for time-sensitive ride events (driver request, passenger accept).
Future<void> triggerRideAlertFeedback({bool playSound = false}) async {
  if (playSound) {
    await playNewRequestInAppSound();
  }
  try {
    await HapticFeedback.heavyImpact();
    if (Platform.isAndroid) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        final hasAmplitude = await Vibration.hasAmplitudeControl();
        if (hasAmplitude == true) {
          await Vibration.vibrate(pattern: [0, 350, 120, 350, 120, 350], intensities: [0, 200, 0, 255, 0, 255]);
        } else {
          await Vibration.vibrate(pattern: [0, 350, 120, 350, 120, 350]);
        }
      }
    } else {
      await HapticFeedback.mediumImpact();
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await HapticFeedback.heavyImpact();
    }
  } catch (_) {
    await HapticFeedback.heavyImpact();
  }
}
