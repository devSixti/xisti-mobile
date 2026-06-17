import 'dart:convert';

import '../hive/hive_helper.dart';
import '../utils/xisti_region_catalog.dart';

/// Syncs regional catalog from admin `POST /customer/market-config`.
abstract final class MarketConfigService {
  static Map<String, dynamic>? _memoryCache;

  static void loadFromHive() {
    if (_memoryCache != null) return;
    final raw = getStringFromSettingBox(hiveMarketConfigJson);
    if (raw.trim().isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        _memoryCache = decoded;
      } else if (decoded is Map) {
        _memoryCache = Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
  }

  static void clearMemoryCache() => _memoryCache = null;

  static String storedVersion() =>
      getStringFromSettingBox(hiveMarketConfigVersion);

  static void applyFromJson(Map<String, dynamic> json) {
    _memoryCache = json;
    putDataInSettingBox(hiveMarketConfigJson, jsonEncode(json));
    final version = json['config_version']?.toString() ?? '';
    if (version.isNotEmpty) {
      putDataInSettingBox(hiveMarketConfigVersion, version);
    }
  }

  static Map<String, dynamic>? countryJson(String countryId) {
    loadFromHive();
    final countries = _memoryCache?['countries'];
    if (countries is! List) return null;
    for (final item in countries) {
      if (item is Map && item['id']?.toString() == countryId) {
        return Map<String, dynamic>.from(item);
      }
    }
    return null;
  }

  static XistiCountryProfile overlayCountry(XistiCountryProfile local) {
    final server = countryJson(local.id);
    if (server == null) return local;
    return XistiCountryProfile(
      id: local.id,
      isoCode: server['iso_code']?.toString() ?? local.isoCode,
      displayName: server['display_name']?.toString() ?? local.displayName,
      currencyCode: server['currency_code']?.toString() ?? local.currencyCode,
      currencySymbol: server['currency_symbol']?.toString() ?? local.currencySymbol,
      dialCode: server['dial_code']?.toString() ?? local.dialCode,
      defaultLanguageCode:
          server['default_language_code']?.toString() ?? local.defaultLanguageCode,
      minFare: _toDouble(server['min_fare'], local.minFare),
      fareNegotiationStep:
          _toDouble(server['fare_negotiation_step'], local.fareNegotiationStep),
      centerLat: local.centerLat,
      centerLng: local.centerLng,
      minLat: local.minLat,
      maxLat: local.maxLat,
      minLng: local.minLng,
      maxLng: local.maxLng,
      cities: local.cities,
    );
  }

  static ResolvedXistiRegion overlayResolved(ResolvedXistiRegion region) {
    final country = overlayCountry(region.country);
    return ResolvedXistiRegion(
      country: country,
      city: region.city,
      isInsideCityBounds: region.isInsideCityBounds,
    );
  }

  static double _toDouble(dynamic value, double fallback) {
    if (value == null) return fallback;
    return double.tryParse(value.toString()) ?? fallback;
  }
}
