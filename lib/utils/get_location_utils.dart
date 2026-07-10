import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../constant/constant.dart';
import 'utils.dart';

class GetLocationUtils {
  Position? locationData;
  LocationPermission? permission;
  String address = "";
  Future<void>? _permissionRequestInFlight;
  static Future<LocationPermission>? _globalPermissionRequestInFlight;

  Future getLocationUtils(
    Function(Position locationData) onLocationDataGet,
    Function(Position locationData, String address) onLocationDataGetWithAddress, {
    Function()? onPermissionReq,
    bool getForceFully = false,
    bool isGetAddress = true,
  }) async {
    if (!getForceFully && locationData != null) {
      onLocationDataGet(locationData!);
      onLocationDataGetWithAddress(locationData!, address);
      onPermissionReq?.call();
      return;
    }
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    debugPrint("service:$serviceEnabled");
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _requestPermissionOnce();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied');
        _emitFallbackLocation(onLocationDataGet, onLocationDataGetWithAddress, onPermissionReq);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied');
      _emitFallbackLocation(onLocationDataGet, onLocationDataGetWithAddress, onPermissionReq);
      return;
    }
    onPermissionReq?.call();

    try {
      locationData = await fetchCurrentLocation();
    } catch (e) {
      debugPrint('Unable to fetch current location: $e');
      _emitFallbackLocation(onLocationDataGet, onLocationDataGetWithAddress, onPermissionReq);
      return;
    }
    onLocationDataGet(locationData!);
    if (isGetAddress) {
      try {
        getStringAddress(locationData!.latitude, locationData!.longitude).then((addressLine) {
          address = addressLine;
          onLocationDataGetWithAddress(locationData!, addressLine);
        });
      } catch (e) {
        getStringAddress(locationData!.latitude, locationData!.longitude).then((addressLine) {
          address = addressLine;
          onLocationDataGetWithAddress(locationData!, addressLine);
        });
      }
    } else {
      onLocationDataGetWithAddress(locationData!, address);
    }
  }

  void _emitFallbackLocation(
    Function(Position locationData) onLocationDataGet,
    Function(Position locationData, String address) onLocationDataGetWithAddress,
    Function()? onPermissionReq,
  ) {
    locationData = Position(
      latitude: defaultLatLng.latitude,
      longitude: defaultLatLng.longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
    onPermissionReq?.call();
    onLocationDataGet(locationData!);
    onLocationDataGetWithAddress(locationData!, address);
  }

  Future<LocationPermission> _requestPermissionOnce() async {
    if (_globalPermissionRequestInFlight != null) {
      await _globalPermissionRequestInFlight;
      return Geolocator.checkPermission();
    }
    if (_permissionRequestInFlight != null) {
      await _permissionRequestInFlight;
      return Geolocator.checkPermission();
    }
    _globalPermissionRequestInFlight = Geolocator.requestPermission();
    _permissionRequestInFlight = _globalPermissionRequestInFlight;
    try {
      return await _globalPermissionRequestInFlight!;
    } finally {
      _permissionRequestInFlight = null;
      _globalPermissionRequestInFlight = null;
    }
  }

  Future<Position> fetchCurrentLocation() async {
    return Geolocator.getCurrentPosition();
  }
}
