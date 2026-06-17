import '../hive/hive_helper.dart';
import '../utils/xisti_region_catalog.dart';
import 'market_config_service.dart';

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

/// Applies country/city defaults from geolocation (CO, US, BR, AR).
abstract final class XistiRegionService {
  static ResolvedXistiRegion resolve(double lat, double lng) =>
      MarketConfigService.overlayResolved(XistiRegionCatalog.resolveRegion(lat, lng));

  static ResolvedXistiRegion activeRegion() {
    final country = MarketConfigService.overlayCountry(
      XistiRegionCatalog.countryById(getStringFromSettingBox(hiveActiveRegionCountryId)) ??
          XistiRegionCatalog.defaultCountry,
    );
    final city = XistiRegionCatalog.cityById(getStringFromSettingBox(hiveActiveRegionCityId)) ??
        country.resolveCity(country.centerLat, country.centerLng);
    return ResolvedXistiRegion(country: country, city: city, isInsideCityBounds: true);
  }

  static XistiRegionPrompt? promptForCoordinates(double lat, double lng) {
    final resolved = resolve(lat, lng);
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

  static void applyRegion(ResolvedXistiRegion resolved) {
    final region = MarketConfigService.overlayResolved(resolved);
    putDataInSettingBox(hiveActiveRegionCountryId, region.country.id);
    putDataInSettingBox(hiveActiveRegionCityId, region.city.id);
    putDataInSettingBox(hiveDeclinedRegionCityId, '');
    putDataInSettingBox(hiveSelectedCurrency, region.country.currencySymbol);
    putDataInSettingBox(hiveFareNegotiationStep, region.country.fareNegotiationStep);
    putDataInSettingBox(hiveRegionMinFare, region.country.minFare);
    putDataInUserPrefBox(hiveSelectedLanguageCode, region.country.defaultLanguageCode);
  }

  static void declineCity(ResolvedXistiRegion resolved) {
    putDataInSettingBox(hiveDeclinedRegionCityId, resolved.city.id);
  }
}
