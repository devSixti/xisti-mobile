import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../constant/constant.dart';
import 'utils.dart';

class GetLocationUtils {
  Position? locationData;
  LocationPermission? permission;
  String address = "";

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
      if (onPermissionReq != null) {
        onPermissionReq();
      }
      return;
    }
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    debugPrint("service:$serviceEnabled");
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    if (onPermissionReq != null) {
      onPermissionReq();
    }

    locationData = await fetchCurrentLocation();
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

  Future<Position> fetchCurrentLocation() async {
    if (_useMedellinTestLocation()) {
      return _medellinTestPosition();
    }
    Position l = await Geolocator.getCurrentPosition();
    return l;
  }

  bool _useMedellinTestLocation() {
    if (kDebugMode) return true;
    return const bool.fromEnvironment('USE_MEDELLIN_TEST_LOCATION', defaultValue: false);
  }

  Position _medellinTestPosition() {
    return Position(
      latitude: defaultLatLng.latitude,
      longitude: defaultLatLng.longitude,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }
}
