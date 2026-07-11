import '../hive/hive_helper.dart';
import '../screen/common/languageCurrency/language_and_currency_repo.dart';
import '../utils/xisti_region_catalog.dart';
import 'market_config_service.dart';
import '../googleApi/geocoding_api_call.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class XistiRegionPrompt {
  final ResolvedXistiRegion resolved;
  final bool countryChanged;
  final bool cityChanged;

  const XistiRegionPrompt({
    required this.resolved,
    required this.countryChanged,
    required this.cityChanged,
  });
}

/// Applies country/city defaults from geolocation (catalog + worldwide geocode fallback).
abstract final class XistiRegionService {
  static ResolvedXistiRegion resolve(double lat, double lng) {
    final inCatalog = XistiRegionCatalog.resolveRegionInCatalog(lat, lng);
    if (inCatalog != null) {
      return MarketConfigService.overlayResolved(inCatalog);
    }
    // Sync path without network: keep last active region rather than snapping markets.
    return activeRegion();
  }

  /// Preferred resolve: catalog bbox, else reverse-geocode → ISO defaults (no snap).
  static Future<ResolvedXistiRegion> resolveAsync(double lat, double lng) async {
    final inCatalog = XistiRegionCatalog.resolveRegionInCatalog(lat, lng);
    if (inCatalog != null) {
      return MarketConfigService.overlayResolved(inCatalog);
    }

    final geo = await _reverseGeocode(lat, lng);
    if (geo != null) {
      return MarketConfigService.overlayResolved(
        XistiRegionCatalog.regionFromGeocode(
          isoCode: geo.$1,
          countryName: geo.$2,
          cityName: geo.$3,
          lat: lat,
          lng: lng,
        ),
      );
    }

    return activeRegion();
  }

  static Future<(String, String, String)?> _reverseGeocode(double lat, double lng) async {
    try {
      final marks = await placemarkFromCoordinates(lat, lng);
      if (marks.isNotEmpty) {
        final p = marks.first;
        final iso = (p.isoCountryCode ?? '').trim();
        if (iso.isNotEmpty) {
          final country = (p.country ?? iso).trim();
          final city = (p.locality?.trim().isNotEmpty == true)
              ? p.locality!.trim()
              : ((p.subAdministrativeArea?.trim().isNotEmpty == true)
                  ? p.subAdministrativeArea!.trim()
                  : ((p.administrativeArea?.trim().isNotEmpty == true)
                      ? p.administrativeArea!.trim()
                      : country));
          return (iso, country, city);
        }
      }
    } catch (_) {
      // Fall through to Google proxy geocoder.
    }

    try {
      final marks = await GeoCodingApiCall().findAddressesFromCoordinates(LatLng(lat, lng)) ?? [];
      if (marks.isEmpty) return null;
      final p = marks.first;
      final iso = (p.isoCountryCode ?? '').trim();
      if (iso.isEmpty) return null;
      final country = (p.country ?? iso).trim();
      final city = (p.locality?.trim().isNotEmpty == true)
          ? p.locality!.trim()
          : ((p.administrativeArea?.trim().isNotEmpty == true) ? p.administrativeArea!.trim() : country);
      return (iso, country, city);
    } catch (_) {
      return null;
    }
  }

  static ResolvedXistiRegion activeRegion() {
    final storedCountry = XistiRegionCatalog.countryById(getStringFromSettingBox(hiveActiveRegionCountryId));
    final country = MarketConfigService.overlayCountry(
      storedCountry ?? XistiRegionCatalog.defaultCountry,
    );
    final city = XistiRegionCatalog.cityById(getStringFromSettingBox(hiveActiveRegionCityId)) ??
        country.resolveCity(country.centerLat, country.centerLng);
    return ResolvedXistiRegion(country: country, city: city, isInsideCityBounds: true);
  }

  /// Map center when GPS permission is denied: last applied city, else catalog default.
  static LatLng fallbackLatLng() {
    final cityId = getStringFromSettingBox(hiveActiveRegionCityId);
    final city = XistiRegionCatalog.cityById(cityId);
    if (city != null) {
      return LatLng(city.centerLat, city.centerLng);
    }
    final region = activeRegion();
    return LatLng(region.city.centerLat, region.city.centerLng);
  }

  static Future<XistiRegionPrompt?> promptForCoordinatesAsync(double lat, double lng) async {
    final resolved = await resolveAsync(lat, lng);
    return _promptForResolved(resolved);
  }

  static XistiRegionPrompt? promptForCoordinates(double lat, double lng) {
    final resolved = resolve(lat, lng);
    return _promptForResolved(resolved);
  }

  static XistiRegionPrompt? _promptForResolved(ResolvedXistiRegion resolved) {
    final storedCountryId = getStringFromSettingBox(hiveActiveRegionCountryId);
    final storedCityId = getStringFromSettingBox(hiveActiveRegionCityId);
    final declinedCityId = getStringFromSettingBox(hiveDeclinedRegionCityId);

    if (storedCountryId.isEmpty && storedCityId.isEmpty) {
      return XistiRegionPrompt(resolved: resolved, countryChanged: true, cityChanged: true);
    }

    final countryChanged = storedCountryId.isNotEmpty && storedCountryId != resolved.country.id;
    final cityChanged = storedCityId.isNotEmpty && storedCityId != resolved.city.id;

    if (!countryChanged && !cityChanged) {
      return null;
    }
    if (!countryChanged && cityChanged && declinedCityId == resolved.city.id) {
      return null;
    }
    return XistiRegionPrompt(
      resolved: resolved,
      countryChanged: countryChanged || storedCountryId.isEmpty,
      cityChanged: cityChanged || storedCityId.isEmpty,
    );
  }

  static Future<void> applyRegion(ResolvedXistiRegion resolved) async {
    final region = MarketConfigService.overlayResolved(resolved);
    putDataInSettingBox(hiveActiveRegionCountryId, region.country.id);
    putDataInSettingBox(hiveActiveRegionCityId, region.city.id);
    putDataInSettingBox(hiveDeclinedRegionCityId, '');
    putDataInSettingBox(hiveSelectedCurrency, region.country.currencySymbol);
    putDataInSettingBox(hiveFareNegotiationStep, region.country.fareNegotiationStep);
    putDataInSettingBox(hiveRegionMinFare, region.country.minFare);
    putDataInUserPrefBox(hiveSelectedLanguageCode, region.country.defaultLanguageCode);
    if (region.country.dialCode.isNotEmpty) {
      putDataInUserInfoBox(hiveCountryCode, region.country.dialCode);
    }

    // Align backend users.currency / language with local Hive region.
    try {
      final userId = getIntFromUserInfoBox(hiveUserId);
      final token = getStringFromSettingBox(hiveAccessToken);
      if (userId > 0 && token.isNotEmpty) {
        await LanguageAndCurrencyRepo().updateCountryAndCurrency(
          region.country.defaultLanguageCode,
          region.country.currencySymbol,
        );
      }
    } catch (_) {
      // Non-blocking: local Hive already updated.
    }
  }

  static void declineCity(ResolvedXistiRegion resolved) {
    putDataInSettingBox(hiveDeclinedRegionCityId, resolved.city.id);
  }
}
