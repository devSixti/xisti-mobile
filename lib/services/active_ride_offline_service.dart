import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../hive/hive_helper.dart';

/// Caches the active ride snapshot for rural/offline zones and restores UI after reconnect.
class ActiveRideOfflineService {
  ActiveRideOfflineService._();

  static final ActiveRideOfflineService instance = ActiveRideOfflineService._();

  static const String _hiveActiveRideSnapshot = 'activeRideSnapshotJson';
  static const String _hiveActiveRideSyncedAt = 'activeRideSyncedAtMs';

  Future<bool> get hasNetwork async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  void saveRideSnapshot(Map<String, dynamic> payload) {
    putDataInSettingBox(_hiveActiveRideSnapshot, jsonEncode(payload));
    putDataInSettingBox(_hiveActiveRideSyncedAt, DateTime.now().millisecondsSinceEpoch);
  }

  Map<String, dynamic>? readRideSnapshot() {
    final raw = getStringFromSettingBox(_hiveActiveRideSnapshot);
    if (raw.trim().isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
    return null;
  }

  void clearRideSnapshot() {
    putDataInSettingBox(_hiveActiveRideSnapshot, '');
    putDataInSettingBox(_hiveActiveRideSyncedAt, 0);
  }

  /// Call after a successful ride-status API response while [rideStatus] indicates an active trip.
  void persistFromApiResponse(Map<String, dynamic> response, {required int rideStatus}) {
    if (rideStatus <= 0 || rideStatus == 4 || rideStatus >= 9) {
      clearRideSnapshot();
      return;
    }
    saveRideSnapshot({
      'ride_id': response['ride_id'] ?? response['id'],
      'ride_status': rideStatus,
      'service_id': response['service_id'] ?? response['ride_service_cat_id'],
      'pickup_lat': response['pickup_lat'],
      'pickup_long': response['pickup_long'],
      'destination_lat': response['destination_lat'],
      'destination_long': response['destination_long'],
      'driver_lat': response['driver_lat'] ?? response['provider_lat'],
      'driver_long': response['driver_long'] ?? response['provider_long'],
      'cached_at': DateTime.now().toIso8601String(),
    });
  }

  int? cachedRideId() {
    final snap = readRideSnapshot();
    final id = snap?['ride_id'];
    if (id is int) {
      return id;
    }
    if (id is String) {
      return int.tryParse(id);
    }
    return null;
  }
}
