import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../hive/hive_helper.dart';

/// Queues driver ride-status mutations when offline; replays on reconnect.
class RideActionQueueService {
  RideActionQueueService._();

  static final RideActionQueueService instance = RideActionQueueService._();

  static const String _hiveQueueKey = 'rideActionQueueJson';

  Future<bool> get hasNetwork async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  List<Map<String, dynamic>> readQueue() {
    final raw = getStringFromSettingBox(_hiveQueueKey);
    if (raw.trim().isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList(growable: true);
    } catch (_) {
      return [];
    }
  }

  Future<void> _persist(List<Map<String, dynamic>> queue) async {
    await putDataInSettingBox(_hiveQueueKey, jsonEncode(queue));
  }

  Future<void> enqueue({
    required int rideId,
    required int rideStatus,
    String cancelReason = '',
    String otp = '',
    dynamic rating = 0,
    String comment = '',
    int wayPointStatus = 0,
    dynamic tollCharge = 0,
    dynamic tollCount = 0,
  }) async {
    final queue = readQueue();
    queue.removeWhere((item) => item['ride_id'] == rideId && item['ride_status'] == rideStatus);
    queue.add({
      'ride_id': rideId,
      'ride_status': rideStatus,
      'cancel_reason': cancelReason,
      'otp': otp,
      'rating': rating,
      'comment': comment,
      'way_point_status': wayPointStatus,
      'toll_charge': tollCharge,
      'toll_count': tollCount,
      'queued_at': DateTime.now().toIso8601String(),
    });
    await _persist(queue);
  }

  Future<void> clearForRide(int rideId) async {
    final queue = readQueue().where((item) => item['ride_id'] != rideId).toList();
    await _persist(queue);
  }

  Future<void> clearAll() async => _persist([]);

  int pendingCountForRide(int rideId) =>
      readQueue().where((item) => item['ride_id'] == rideId).length;

  /// Replays queued actions via [executor]. Removes items that return true.
  Future<int> flush(
    Future<bool> Function(Map<String, dynamic> action) executor,
  ) async {
    if (!await hasNetwork) return 0;
    final queue = readQueue();
    if (queue.isEmpty) return 0;

    var flushed = 0;
    final remaining = <Map<String, dynamic>>[];
    for (final action in queue) {
      final ok = await executor(action);
      if (ok) {
        flushed++;
      } else {
        remaining.add(action);
      }
    }
    await _persist(remaining);
    return flushed;
  }
}
