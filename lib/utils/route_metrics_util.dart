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

/// Rejects invalid coordinates before routing (0,0 or swapped extremes).
bool isPlausibleRouteCoordinate(double lat, double lng) {
  if (lat.abs() < 0.01 && lng.abs() < 0.01) return false;
  if (lat.abs() > 90 || lng.abs() > 180) return false;
  return true;
}

/// Converts meters to kilometers with two decimal precision.
double routeDistanceKmFromMeters(int meters) {
  if (meters <= 0) return 0;
  return double.parse((meters / 1000).toStringAsFixed(2));
}
