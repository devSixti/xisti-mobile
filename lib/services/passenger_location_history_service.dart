import 'dart:convert';

import '../hive/hive_helper.dart';
import '../main.dart';
import '../screen/passengerMode/passengerHome/passenger_home_dl.dart';

/// Recent pickup/destination pairs per service for faster rebooking (v1.0.2).
class PassengerLocationHistoryService {
  static const int maxEntriesPerService = 8;

  static String _boxKey(int serviceId) => 'passenger_location_history_$serviceId';

  static Future<void> recordTrip({
    required int serviceId,
    required SearchedLocation pickup,
    required SearchedLocation destination,
  }) async {
    if (serviceId <= 0) return;
    if ((pickup.name ?? '').trim().isEmpty || (destination.name ?? '').trim().isEmpty) return;

    final existing = await recentTrips(serviceId);
    final entry = {
      'pickup_name': pickup.name,
      'pickup_lat': pickup.lat,
      'pickup_lng': pickup.lng,
      'destination_name': destination.name,
      'destination_lat': destination.lat,
      'destination_lng': destination.lng,
      'saved_at': DateTime.now().toIso8601String(),
    };

    final filtered = existing.where((e) {
      return e['pickup_name'] != entry['pickup_name'] || e['destination_name'] != entry['destination_name'];
    }).toList();

    filtered.insert(0, entry);
    if (filtered.length > maxEntriesPerService) {
      filtered.removeRange(maxEntriesPerService, filtered.length);
    }

    await putDataInUserPrefBox(_boxKey(serviceId), jsonEncode(filtered));
  }

  /// Envíos usan varios `service_id`; une historial para la pantalla Definir ruta.
  static Future<List<Map<String, dynamic>>> recentTripsForBooking(int serviceId) async {
    const deliveryServiceIds = {1, 3, 4, 5};
    if (!deliveryServiceIds.contains(serviceId)) {
      return recentTrips(serviceId);
    }

    final merged = <Map<String, dynamic>>[];
    final seen = <String>{};
    for (final id in deliveryServiceIds) {
      for (final entry in await recentTrips(id)) {
        final key = '${entry['pickup_name']}|${entry['destination_name']}';
        if (seen.add(key)) {
          merged.add(entry);
        }
        if (merged.length >= maxEntriesPerService) {
          return merged;
        }
      }
    }

    return merged;
  }

  static Future<List<Map<String, dynamic>>> recentTrips(int serviceId) async {
    if (serviceId <= 0) return [];
    final raw = userPrefBox.get(_boxKey(serviceId), defaultValue: '')?.toString() ?? '';
    if (raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static SearchedLocation pickupFromEntry(Map<String, dynamic> entry) {
    return SearchedLocation(
      name: entry['pickup_name']?.toString() ?? '',
      lat: double.tryParse('${entry['pickup_lat']}') ?? 0,
      lng: double.tryParse('${entry['pickup_lng']}') ?? 0,
    );
  }

  static SearchedLocation destinationFromEntry(Map<String, dynamic> entry) {
    return SearchedLocation(
      name: entry['destination_name']?.toString() ?? '',
      lat: double.tryParse('${entry['destination_lat']}') ?? 0,
      lng: double.tryParse('${entry['destination_lng']}') ?? 0,
    );
  }
}
