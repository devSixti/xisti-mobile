import 'dart:async';

import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';

@pragma('vm:entry-point')
class BackgroundLocationService {
  @pragma('vm:entry-point')
  Future<void> initialise() async {
    await initPlatformState();
  }

  Future<void> initPlatformState() async {
    await BackgroundLocationTrackerManager.initialize(
      backgroundCallback,
      config: BackgroundLocationTrackerConfig(
        loggingEnabled: true,
        androidConfig: AndroidConfig(
            notificationIcon: 'ic_notification',
            channelName: 'XISTI',
            trackingInterval: const Duration(seconds: 4),
            distanceFilterMeters: 2,
            cancelTrackingActionText: '',
            enableCancelTrackingAction: false,
            enableNotificationLocationUpdates: false,
            notificationBody: 'XISTI · ${languages.trackLocationInBackground}'),
        iOSConfig: const IOSConfig(
          activityType: ActivityType.NAVIGATION,
          distanceFilterMeters: 2,
          restartAfterKill: true,
        ),
      ),
    );
  }

  Future<void> onStop() async {
    try {
      debugPrint(">>> onStop()");
      if (await BackgroundLocationTrackerManager.isTracking()) {
        BackgroundLocationTrackerManager.stopTracking();
      }
    } catch (e) {
      debugPrint(">>>Error: ${e.toString()}");
    }
  }

  Future<void> onStart() async {
    debugPrint(">>> onStart()");
    bool isEnable = await checkAllLocationPermission();
    try {
      if (isEnable && (!await BackgroundLocationTrackerManager.isTracking())) {
        BackgroundLocationTrackerManager.startTracking();
      } else {
        // show error
      }
    } catch (e) {
      debugPrint(">>>Error:${e.toString()}");
    }
  }

  Future<bool> checkAllLocationPermission() async {
    List<PermissionWithService> permissionList = [Permission.location, Permission.locationWhenInUse, Permission.locationAlways];
    bool isAllowed = true;
    await Future.forEach(permissionList, (item) async {
      debugPrint("item $item");
      bool value = await checkLocationPermission(item);
      debugPrint("value $value");
      if (!value) {
        isAllowed = false;
      }
      debugPrint("isAllowed $isAllowed");
    });
    return isAllowed;
    // debugPrint("checkAllLocationPermission : $value");
  }

  Future<bool> checkLocationPermission(PermissionWithService checkPermission) async {
    final access = await checkPermission.status;
    debugPrint("checkLocationPermission access : $checkPermission $access");
    switch (access) {
    // case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        final permission = await checkPermission.request();
        debugPrint("checkLocationPermission 1 : $checkPermission $permission");
        if (permission == PermissionStatus.granted) {
          return true;
        } else if (permission == PermissionStatus.permanentlyDenied || permission == PermissionStatus.denied) {
          return await openAppSettings();
        } else {
          return false;
        }
      case PermissionStatus.granted:
        debugPrint("checkLocationPermission 2 : $checkPermission");
        return true;
      case PermissionStatus.permanentlyDenied:
        debugPrint("checkLocationPermission 3 : $checkPermission");
        return await openAppSettings();
      default:
        debugPrint("checkLocationPermission 3 : $checkPermission");
        return false;
    }
  }
}
