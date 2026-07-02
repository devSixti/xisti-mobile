import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../hive/hive_helper.dart';

/// Lightweight ride funnel and error telemetry for session resume and live tracking.
class AppTelemetry {
  AppTelemetry._();

  static final AppTelemetry instance = AppTelemetry._();

  Future<void> bindUserContext() async {
    final userId = getIntFromUserInfoBox(hiveUserId);
    if (userId <= 0) {
      return;
    }
    await FirebaseCrashlytics.instance.setUserIdentifier('$userId');
  }

  void clearUserContext() {
    unawaited(FirebaseCrashlytics.instance.setUserIdentifier(''));
  }

  void logRideFunnel(
    String step, {
    int? rideId,
    int? rideStatus,
    Map<String, Object?> extra = const {},
  }) {
    FirebaseCrashlytics.instance.log('ride_funnel:$step ride=$rideId status=$rideStatus');
    if (kDebugMode) {
      debugPrint('ride_telemetry step=$step rideId=$rideId rideStatus=$rideStatus extra=$extra');
    }
  }

  void logAuthEvent(String step, {Map<String, Object?> extra = const {}}) {
    FirebaseCrashlytics.instance.log('auth:$step');
    if (kDebugMode) {
      debugPrint('auth_telemetry step=$step extra=$extra');
    }
  }

  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    if (kDebugMode) {
      debugPrint('Telemetry error${reason == null ? '' : ' ($reason)'}: $error');
      return;
    }
    await FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }
}
