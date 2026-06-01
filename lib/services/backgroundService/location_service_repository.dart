import 'dart:async';

import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import 'package:hive_flutter/adapters.dart';
import '../../hive/hive_helper.dart';
import '../../screen/driverMode/driverHome/driver_home_repo.dart';

class LocationServiceRepository {
  static final LocationServiceRepository _instance = LocationServiceRepository._();

  LocationServiceRepository._();

  final DriverHomeRepo _repo = DriverHomeRepo();

  factory LocationServiceRepository() {
    return _instance;
  }

  DateTime? dateTime;
  BackgroundLocationUpdateData? lastLocationDto;

  @pragma('vm:entry-point')
  Future<void> callback(BackgroundLocationUpdateData locationDto) async {
    debugPrint('>>>callback  location in dart: ${locationDto.toString()}');
    await Hive.initFlutter();
    await initBox();
    DateTime ct = DateTime.now();
    if (getStringFromSettingBox(hiveBgLocationTime, defaultValue: "").isNotEmpty) {
      dateTime = DateTime.parse(getStringFromSettingBox(hiveBgLocationTime, defaultValue: ""));
    }
    if (getStringFromSettingBox(hiveBgLocationData, defaultValue: "").isNotEmpty) {
      lastLocationDto = BackgroundLocationUpdateData.fromJson(getStringFromSettingBox(hiveBgLocationData, defaultValue: ""));
    }
    if (dateTime != null) {
      var inSeconds = ct.difference(dateTime!).inSeconds;
      if (inSeconds > 15) {
        putDataInSettingBox(hiveBgLocationTime, ct.toString());
        await getLocation(locationDto);
      }
      debugPrint(">>>inSeconds $inSeconds");
    } else {
      debugPrint('>>>port.listen else: $locationDto');
      putDataInSettingBox(hiveBgLocationTime, ct.toString());
      await getLocation(locationDto);
    }
  }

  Future<void> getLocation(BackgroundLocationUpdateData data) async {
    if (lastLocationDto == null || (lastLocationDto!.lat != data.lat && lastLocationDto!.lon != data.lon)) {
      await callUpdateCurrentLatLongApi(data.lat, data.lon);
      putDataInSettingBox(hiveBgLocationData, data.toJson());
      lastLocationDto = data;
    }
  }

  Future<void> callUpdateCurrentLatLongApi(double currentLat, double currentLong) async {
    if (await isNetworkConnected()) {
      try {
        debugPrint('>>>location in api call: $currentLat');
        var response = await _repo.updateCurrentLatLongApi(currentLat: currentLat, currentLong: currentLong);
        debugPrint(">>> ${response.toString()}");
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}
