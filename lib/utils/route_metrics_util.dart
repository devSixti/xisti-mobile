import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Parses Google Routes API duration strings (e.g. "1140s", "19m").
int parseRouteDurationSeconds(String? raw) {
  final value = (raw ?? '').trim();
  if (value.isEmpty) return 0;
  if (value.endsWith('s') && !value.endsWith('ms')) {
    return int.tryParse(value.substring(0, value.length - 1)) ?? 0;
  }
  final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
  return int.tryParse(digits) ?? 0;
}

bool isPlausibleRouteCoordinate(double lat, double lng) {
  if (lat.abs() < 0.01 && lng.abs() < 0.01) return false;
  if (lat.abs() > 90 || lng.abs() > 180) return false;
  return true;
}

double routeDistanceKmFromMeters(int meters) {
  if (meters <= 0) return 0;
  return double.parse((meters / 1000).toStringAsFixed(2));
}

/// Great-circle distance in meters (WGS84 sphere).
int haversineDistanceMeters(LatLng origin, LatLng destination) {
  const earthRadiusM = 6371000.0;
  final lat1 = origin.latitude * pi / 180;
  final lat2 = destination.latitude * pi / 180;
  final dLat = (destination.latitude - origin.latitude) * pi / 180;
  final dLng = (destination.longitude - origin.longitude) * pi / 180;
  final a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return (earthRadiusM * c).round();
}

/// Rough urban ETA assuming ~25 km/h average.
int estimateDurationSecondsFromMeters(int meters) {
  if (meters <= 0) return 0;
  const metersPerSecond = 25 / 3.6;
  return (meters / metersPerSecond).round();
}
