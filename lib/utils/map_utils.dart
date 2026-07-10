import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../constant/constant.dart';
import '../googleApi/geocoding_api_call.dart';

Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes({required String path, dynamic width, dynamic height}) async {
  return BitmapDescriptor.asset(
    ImageConfiguration(devicePixelRatio: ui.PlatformDispatcher.instance.views.first.devicePixelRatio, size: ui.Size(width ?? 25.sp, height ?? 25.sp)),
    path,
  );
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}

bool isValidMapCoordinate(double latitude, double longitude) {
  return latitude.abs() >= 0.01 && longitude.abs() >= 0.01;
}

void setMapFitToTour({required Set<Polyline> polyline, required GoogleMapController controller, double? padding}) {
  try {
    if (polyline.isEmpty) {
      return;
    }
    double? minLat;
    double? minLong;
    double? maxLat;
    double? maxLong;
    for (var poly in polyline) {
      for (var point in poly.points) {
        if (!isValidMapCoordinate(point.latitude, point.longitude)) {
          continue;
        }
        minLat = minLat == null ? point.latitude : min(minLat, point.latitude);
        maxLat = maxLat == null ? point.latitude : max(maxLat, point.latitude);
        minLong = minLong == null ? point.longitude : min(minLong, point.longitude);
        maxLong = maxLong == null ? point.longitude : max(maxLong, point.longitude);
      }
    }
    if (minLat == null || minLong == null || maxLat == null || maxLong == null) {
      return;
    }
    controller.moveCamera(
      CameraUpdate.newLatLngBounds(LatLngBounds(southwest: LatLng(minLat, minLong), northeast: LatLng(maxLat, maxLong)), padding ?? 100.sp),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

void setMapFitToTourUsingLatLng({required List<double> latList, required List<double> longList, required GoogleMapController controller, double? padding}) {
  if (latList.isEmpty || longList.isEmpty || latList.length != longList.length) {
    return;
  }
  final validLats = <double>[];
  final validLongs = <double>[];
  for (var i = 0; i < latList.length; i++) {
    if (isValidMapCoordinate(latList[i], longList[i])) {
      validLats.add(latList[i]);
      validLongs.add(longList[i]);
    }
  }
  if (validLats.isEmpty || validLongs.isEmpty) {
    return;
  }
  double topMost = validLongs.reduce(max);
  double leftMost = validLats.reduce(min);
  double rightMost = validLats.reduce(max);
  double bottomMost = validLongs.reduce(min);
  controller.moveCamera(
    CameraUpdate.newLatLngBounds(LatLngBounds(northeast: LatLng(rightMost, topMost), southwest: LatLng(leftMost, bottomMost)), padding ?? 12.sp),
  );
}

void focusInMap(GoogleMapController googleMapController, double latitude, double longitude, bool isZoom) {
  if (latitude.abs() < 0.01 && longitude.abs() < 0.01) return;
  isZoom
      ? googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(latitude, longitude), zoom: defaultMapZoom)))
      : googleMapController.getZoomLevel().then((value) {
          return googleMapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(latitude, longitude), zoom: value)));
        });
}

Future<String> getStringAddress(double latitude, double longitude) async {
  final coordinates = LatLng(latitude, longitude);
  try {
    List<Placemark> placeMark = await placemarkFromCoordinates(latitude, longitude);
    return '${getAddressFromKey(placeMark.first.name)}${(!placeMark.first.street!.contains(placeMark.first.name ?? "")) ? getAddressFromKey(placeMark.first.street) : ''}${getAddressFromKey(placeMark.first.thoroughfare)}${getAddressFromKey(placeMark.first.subLocality)}${getAddressFromKey(placeMark.first.locality)}${getAddressFromKey(placeMark.first.subAdministrativeArea)}${getAddressFromKey(placeMark.first.postalCode)}${getAddressFromKey(placeMark.first.administrativeArea)}';
  } catch (e) {
    List<Placemark> placeMark = await GeoCodingApiCall().findAddressesFromCoordinates(coordinates) ?? [];
    return '${getAddressFromKey(placeMark.first.name)}${(!placeMark.first.street!.contains(placeMark.first.name ?? "")) ? getAddressFromKey(placeMark.first.street) : ''}${getAddressFromKey(placeMark.first.thoroughfare)}${getAddressFromKey(placeMark.first.subLocality)}${getAddressFromKey(placeMark.first.locality)}${getAddressFromKey(placeMark.first.subAdministrativeArea)}${getAddressFromKey(placeMark.first.postalCode)}${getAddressFromKey(placeMark.first.administrativeArea)}';
  }
}

String getAddressFromKey(String? address) {
  return (address ?? "").trim().isNotEmpty ? "$address, " : "";
}

LatLng convertStringLatLongToLatLongObject(String latLong) {
  List<String> latLongs = latLong.split(",");
  return LatLng(double.parse(latLongs[0]), double.parse(latLongs[1]));
}

Future<void> setMapStyle({required BuildContext context, Function(String changedStyle)? callback}) async {
  String currentMapStyle = getCurrentTheme(context).mapStyle;
  String style = "";
  if (currentMapStyle.trim().isNotEmpty) {
    style = await rootBundle.loadString(currentMapStyle);
  } else {
    style = await rootBundle.loadString('assets/mapStyle/map_style.json');
  }
  callback?.call(style);
  // mapStyle.sink.add(style);
}

Future<BitmapDescriptor> getServiceMarkerIcon({required int serviceId}) async {
  if (serviceId == ServiceType.taxi) {
    return await getBitmapDescriptorFromAssetBytes(path: 'assets/images/ic_taxi.png');
  } else if (serviceId == ServiceType.bike) {
    return await getBitmapDescriptorFromAssetBytes(path: 'assets/images/ic_bike.png');
  } else if (serviceId == ServiceType.courier) {
    return await getBitmapDescriptorFromAssetBytes(path: 'assets/images/ic_truck.png');
  } else if (serviceId == ServiceType.rickshaw) {
    return await getBitmapDescriptorFromAssetBytes(path: 'assets/images/ic_auto.png');
  } else {
    return await getBitmapDescriptorFromAssetBytes(path: 'assets/images/ic_taxi.png');
  }
}
