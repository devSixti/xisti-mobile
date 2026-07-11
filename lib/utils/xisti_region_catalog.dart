import 'package:geolocator/geolocator.dart';

import '../screen/passengerMode/passengerHome/passenger_home_barrio_shortcuts.dart';

/// One operational city (zones, map center, metro bounding box).
class XistiMainCityProfile {
  final String id;
  final String countryId;
  final String displayName;
  final double centerLat;
  final double centerLng;
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;
  final List<XistiBarrioShortcut> zones;

  const XistiMainCityProfile({
    required this.id,
    required this.countryId,
    required this.displayName,
    required this.centerLat,
    required this.centerLng,
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    required this.zones,
  });

  bool contains(double lat, double lng) =>
      lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng;

  double distanceToCenterMeters(double lat, double lng) =>
      Geolocator.distanceBetween(lat, lng, centerLat, centerLng);
}

/// Country-level defaults: currency, fares, dial code, language hint.
class XistiCountryProfile {
  final String id;
  final String isoCode;
  final String displayName;
  final String currencyCode;
  final String currencySymbol;
  final String dialCode;
  final String defaultLanguageCode;
  final double minFare;
  final double fareNegotiationStep;
  final double centerLat;
  final double centerLng;
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;
  final List<XistiMainCityProfile> cities;

  const XistiCountryProfile({
    required this.id,
    required this.isoCode,
    required this.displayName,
    required this.currencyCode,
    required this.currencySymbol,
    required this.dialCode,
    required this.defaultLanguageCode,
    required this.minFare,
    required this.fareNegotiationStep,
    required this.centerLat,
    required this.centerLng,
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    required this.cities,
  });

  bool contains(double lat, double lng) =>
      lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng;

  double distanceToCenterKm(double lat, double lng) =>
      Geolocator.distanceBetween(lat, lng, centerLat, centerLng) / 1000;

  XistiMainCityProfile? cityContaining(double lat, double lng) {
    for (final city in cities) {
      if (city.contains(lat, lng)) return city;
    }
    return null;
  }

  XistiMainCityProfile nearestCity(double lat, double lng) {
    var nearest = cities.first;
    var nearestDistance = double.infinity;
    for (final city in cities) {
      final distance = city.distanceToCenterMeters(lat, lng);
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearest = city;
      }
    }
    return nearest;
  }

  XistiMainCityProfile resolveCity(double lat, double lng) =>
      cityContaining(lat, lng) ?? nearestCity(lat, lng);
}

class ResolvedXistiRegion {
  final XistiCountryProfile country;
  final XistiMainCityProfile city;
  final bool isInsideCityBounds;
  /// True when country/city came from reverse-geocode outside the bbox catalog.
  final bool isGeocodeDerived;

  const ResolvedXistiRegion({
    required this.country,
    required this.city,
    required this.isInsideCityBounds,
    this.isGeocodeDerived = false,
  });
}

/// ISO defaults for reverse-geocode when outside the operational catalog.
class XistiIsoMarketDefaults {
  final String currencyCode;
  final String currencySymbol;
  final String dialCode;
  final String language;
  final double minFare;
  final double fareStep;

  const XistiIsoMarketDefaults({
    required this.currencyCode,
    required this.currencySymbol,
    required this.dialCode,
    required this.language,
    required this.minFare,
    required this.fareStep,
  });
}

/// Global catalog: CO, US, BR, AR, MX, ES, CL, PE, EC (+ geocode fallback).
abstract final class XistiRegionCatalog {
  static const String colombiaId = 'co';
  static const String usaId = 'us';
  static const String brazilId = 'br';
  static const String argentinaId = 'ar';
  static const String mexicoId = 'mx';
  static const String spainId = 'es';
  static const String chileId = 'cl';
  static const String peruId = 'pe';
  static const String ecuadorId = 'ec';
  static const String medellinId = 'medellin';
  static const String catalogVersion = '2026-07-11';

  static const Map<String, XistiIsoMarketDefaults> isoDefaults = {
    'CO': XistiIsoMarketDefaults(currencyCode: 'COP', currencySymbol: 'COL\$', dialCode: '+57', language: 'es', minFare: 5000, fareStep: 500),
    'US': XistiIsoMarketDefaults(currencyCode: 'USD', currencySymbol: '\$', dialCode: '+1', language: 'en', minFare: 8, fareStep: 1),
    'BR': XistiIsoMarketDefaults(currencyCode: 'BRL', currencySymbol: 'R\$', dialCode: '+55', language: 'pt', minFare: 12, fareStep: 2),
    'AR': XistiIsoMarketDefaults(currencyCode: 'ARS', currencySymbol: 'AR\$', dialCode: '+54', language: 'es', minFare: 2500, fareStep: 500),
    'MX': XistiIsoMarketDefaults(currencyCode: 'MXN', currencySymbol: 'MX\$', dialCode: '+52', language: 'es', minFare: 45, fareStep: 5),
    'ES': XistiIsoMarketDefaults(currencyCode: 'EUR', currencySymbol: '€', dialCode: '+34', language: 'es', minFare: 6, fareStep: 1),
    'CL': XistiIsoMarketDefaults(currencyCode: 'CLP', currencySymbol: 'CL\$', dialCode: '+56', language: 'es', minFare: 1500, fareStep: 100),
    'PE': XistiIsoMarketDefaults(currencyCode: 'PEN', currencySymbol: 'S/', dialCode: '+51', language: 'es', minFare: 8, fareStep: 1),
    'EC': XistiIsoMarketDefaults(currencyCode: 'USD', currencySymbol: '\$', dialCode: '+593', language: 'es', minFare: 3, fareStep: 0.5),
    'GB': XistiIsoMarketDefaults(currencyCode: 'GBP', currencySymbol: '£', dialCode: '+44', language: 'en', minFare: 6, fareStep: 1),
    'CA': XistiIsoMarketDefaults(currencyCode: 'CAD', currencySymbol: 'CA\$', dialCode: '+1', language: 'en', minFare: 8, fareStep: 1),
    'DE': XistiIsoMarketDefaults(currencyCode: 'EUR', currencySymbol: '€', dialCode: '+49', language: 'en', minFare: 6, fareStep: 1),
    'FR': XistiIsoMarketDefaults(currencyCode: 'EUR', currencySymbol: '€', dialCode: '+33', language: 'fr', minFare: 6, fareStep: 1),
    'IT': XistiIsoMarketDefaults(currencyCode: 'EUR', currencySymbol: '€', dialCode: '+39', language: 'it', minFare: 6, fareStep: 1),
    'PT': XistiIsoMarketDefaults(currencyCode: 'EUR', currencySymbol: '€', dialCode: '+351', language: 'pt', minFare: 5, fareStep: 1),
    'UY': XistiIsoMarketDefaults(currencyCode: 'UYU', currencySymbol: 'UY\$', dialCode: '+598', language: 'es', minFare: 80, fareStep: 10),
    'PY': XistiIsoMarketDefaults(currencyCode: 'PYG', currencySymbol: '₲', dialCode: '+595', language: 'es', minFare: 15000, fareStep: 1000),
    'BO': XistiIsoMarketDefaults(currencyCode: 'BOB', currencySymbol: 'Bs', dialCode: '+591', language: 'es', minFare: 10, fareStep: 1),
    'CR': XistiIsoMarketDefaults(currencyCode: 'CRC', currencySymbol: '₡', dialCode: '+506', language: 'es', minFare: 1500, fareStep: 100),
    'PA': XistiIsoMarketDefaults(currencyCode: 'USD', currencySymbol: '\$', dialCode: '+507', language: 'es', minFare: 3, fareStep: 0.5),
  };

  static const XistiIsoMarketDefaults defaultIsoDefaults = XistiIsoMarketDefaults(
    currencyCode: 'USD',
    currencySymbol: '\$',
    dialCode: '+1',
    language: 'en',
    minFare: 5,
    fareStep: 1,
  );

  static XistiIsoMarketDefaults defaultsForIso(String? iso) {
    if (iso == null || iso.isEmpty) return defaultIsoDefaults;
    return isoDefaults[iso.toUpperCase()] ?? defaultIsoDefaults;
  }

  static const List<XistiCountryProfile> countries = [
    XistiCountryProfile(
      id: colombiaId,
      isoCode: 'CO',
      displayName: 'Colombia',
      currencyCode: 'COP',
      currencySymbol: 'COL\$',
      dialCode: '+57',
      defaultLanguageCode: 'es',
      minFare: 6000,
      fareNegotiationStep: 500,
      centerLat: 4.5709,
      centerLng: -74.2973,
      minLat: -4.5,
      maxLat: 13.5,
      minLng: -79.5,
      maxLng: -66.5,
      cities: _colombiaCities,
    ),
    XistiCountryProfile(
      id: usaId,
      isoCode: 'US',
      displayName: 'Estados Unidos',
      currencyCode: 'USD',
      currencySymbol: '\$',
      dialCode: '+1',
      defaultLanguageCode: 'en',
      minFare: 8,
      fareNegotiationStep: 1,
      centerLat: 39.8283,
      centerLng: -98.5795,
      minLat: 24.5,
      maxLat: 49.5,
      minLng: -125.0,
      maxLng: -66.5,
      cities: _usaCities,
    ),
    XistiCountryProfile(
      id: brazilId,
      isoCode: 'BR',
      displayName: 'Brasil',
      currencyCode: 'BRL',
      currencySymbol: 'R\$',
      dialCode: '+55',
      defaultLanguageCode: 'pt',
      minFare: 12,
      fareNegotiationStep: 2,
      centerLat: -14.2350,
      centerLng: -51.9253,
      minLat: -34.0,
      maxLat: 5.5,
      minLng: -74.0,
      maxLng: -34.0,
      cities: _brazilCities,
    ),
    XistiCountryProfile(
      id: argentinaId,
      isoCode: 'AR',
      displayName: 'Argentina',
      currencyCode: 'ARS',
      currencySymbol: 'AR\$',
      dialCode: '+54',
      defaultLanguageCode: 'es',
      minFare: 2500,
      fareNegotiationStep: 500,
      centerLat: -38.4161,
      centerLng: -63.6167,
      minLat: -55.0,
      maxLat: -21.5,
      minLng: -73.5,
      maxLng: -53.0,
      cities: _argentinaCities,
    ),
    XistiCountryProfile(
      id: mexicoId,
      isoCode: 'MX',
      displayName: 'México',
      currencyCode: 'MXN',
      currencySymbol: 'MX\$',
      dialCode: '+52',
      defaultLanguageCode: 'es',
      minFare: 45,
      fareNegotiationStep: 5,
      centerLat: 23.6345,
      centerLng: -102.5528,
      minLat: 14.5,
      maxLat: 32.7,
      minLng: -118.5,
      maxLng: -86.5,
      cities: _mexicoCities,
    ),
    XistiCountryProfile(
      id: spainId,
      isoCode: 'ES',
      displayName: 'España',
      currencyCode: 'EUR',
      currencySymbol: '€',
      dialCode: '+34',
      defaultLanguageCode: 'es',
      minFare: 6,
      fareNegotiationStep: 1,
      centerLat: 40.4637,
      centerLng: -3.7492,
      minLat: 36.0,
      maxLat: 43.8,
      minLng: -9.5,
      maxLng: 4.5,
      cities: _spainCities,
    ),
    XistiCountryProfile(
      id: chileId,
      isoCode: 'CL',
      displayName: 'Chile',
      currencyCode: 'CLP',
      currencySymbol: 'CL\$',
      dialCode: '+56',
      defaultLanguageCode: 'es',
      minFare: 1500,
      fareNegotiationStep: 100,
      centerLat: -35.6751,
      centerLng: -71.5430,
      minLat: -56.0,
      maxLat: -17.5,
      minLng: -76.0,
      maxLng: -66.0,
      cities: _chileCities,
    ),
    XistiCountryProfile(
      id: peruId,
      isoCode: 'PE',
      displayName: 'Perú',
      currencyCode: 'PEN',
      currencySymbol: 'S/',
      dialCode: '+51',
      defaultLanguageCode: 'es',
      minFare: 8,
      fareNegotiationStep: 1,
      centerLat: -9.1900,
      centerLng: -75.0152,
      minLat: -18.5,
      maxLat: 0.0,
      minLng: -81.5,
      maxLng: -68.5,
      cities: _peruCities,
    ),
    XistiCountryProfile(
      id: ecuadorId,
      isoCode: 'EC',
      displayName: 'Ecuador',
      currencyCode: 'USD',
      currencySymbol: '\$',
      dialCode: '+593',
      defaultLanguageCode: 'es',
      minFare: 3,
      fareNegotiationStep: 0.5,
      centerLat: -1.8312,
      centerLng: -78.1834,
      minLat: -5.0,
      maxLat: 1.7,
      minLng: -81.5,
      maxLng: -75.0,
      cities: _ecuadorCities,
    ),
  ];

  static List<XistiMainCityProfile> get allCities =>
      countries.expand((country) => country.cities).toList(growable: false);

  static XistiCountryProfile get defaultCountry =>
      countries.firstWhere((c) => c.id == colombiaId);

  static XistiMainCityProfile get defaultCity =>
      defaultCountry.cities.firstWhere((c) => c.id == medellinId);

  static XistiCountryProfile? countryContaining(double lat, double lng) {
    for (final country in countries) {
      if (country.contains(lat, lng)) return country;
    }
    return null;
  }

  static XistiCountryProfile nearestCountry(double lat, double lng) {
    var nearest = defaultCountry;
    var nearestDistance = double.infinity;
    for (final country in countries) {
      final distance = country.distanceToCenterKm(lat, lng);
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearest = country;
      }
    }
    return nearest;
  }

  /// Catalog-only resolve. Returns null when outside all country bboxes
  /// (caller should reverse-geocode instead of snapping to nearest market).
  static ResolvedXistiRegion? resolveRegionInCatalog(double lat, double lng) {
    final country = countryContaining(lat, lng);
    if (country == null) return null;
    final city = country.resolveCity(lat, lng);
    return ResolvedXistiRegion(
      country: country,
      city: city,
      isInsideCityBounds: city.contains(lat, lng),
    );
  }

  /// Legacy sync resolve: catalog hit, else nearest country (prefer
  /// [resolveRegionInCatalog] + geocode fallback for worldwide accuracy).
  static ResolvedXistiRegion resolveRegion(double lat, double lng) {
    return resolveRegionInCatalog(lat, lng) ??
        () {
          final country = nearestCountry(lat, lng);
          final city = country.resolveCity(lat, lng);
          return ResolvedXistiRegion(
            country: country,
            city: city,
            isInsideCityBounds: city.contains(lat, lng),
          );
        }();
  }

  /// Build a synthetic region from reverse-geocode ISO + locality.
  static ResolvedXistiRegion regionFromGeocode({
    required String isoCode,
    required String countryName,
    required String cityName,
    required double lat,
    required double lng,
  }) {
    final iso = isoCode.toUpperCase();
    XistiCountryProfile? catalogCountry;
    for (final c in countries) {
      if (c.isoCode == iso) {
        catalogCountry = c;
        break;
      }
    }
    if (catalogCountry != null) {
      final city = catalogCountry.resolveCity(lat, lng);
      return ResolvedXistiRegion(
        country: catalogCountry,
        city: city,
        isInsideCityBounds: city.contains(lat, lng),
        isGeocodeDerived: true,
      );
    }

    final defaults = defaultsForIso(iso);
    final countryId = 'geo_${iso.toLowerCase()}';
    final cityId = 'geo_${iso.toLowerCase()}_${cityName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_')}';
    final city = XistiMainCityProfile(
      id: cityId.isEmpty ? 'geo_${iso.toLowerCase()}_city' : cityId,
      countryId: countryId,
      displayName: cityName.isNotEmpty ? cityName : countryName,
      centerLat: lat,
      centerLng: lng,
      minLat: lat - 0.15,
      maxLat: lat + 0.15,
      minLng: lng - 0.15,
      maxLng: lng + 0.15,
      zones: const [],
    );
    final country = XistiCountryProfile(
      id: countryId,
      isoCode: iso,
      displayName: countryName.isNotEmpty ? countryName : iso,
      currencyCode: defaults.currencyCode,
      currencySymbol: defaults.currencySymbol,
      dialCode: defaults.dialCode,
      defaultLanguageCode: defaults.language,
      minFare: defaults.minFare,
      fareNegotiationStep: defaults.fareStep,
      centerLat: lat,
      centerLng: lng,
      minLat: lat - 5,
      maxLat: lat + 5,
      minLng: lng - 5,
      maxLng: lng + 5,
      cities: [city],
    );
    return ResolvedXistiRegion(
      country: country,
      city: city,
      isInsideCityBounds: true,
      isGeocodeDerived: true,
    );
  }

  static XistiCountryProfile resolveCountry(double lat, double lng) =>
      countryContaining(lat, lng) ?? nearestCountry(lat, lng);

  static XistiMainCityProfile? cityById(String? cityId) {
    if (cityId == null || cityId.isEmpty) return null;
    for (final city in allCities) {
      if (city.id == cityId) return city;
    }
    return null;
  }

  static XistiCountryProfile? countryById(String? countryId) {
    if (countryId == null || countryId.isEmpty) return null;
    for (final country in countries) {
      if (country.id == countryId) return country;
    }
    return null;
  }

  static const List<XistiMainCityProfile> _colombiaCities = [
    XistiMainCityProfile(
      id: 'bogota',
      countryId: colombiaId,
      displayName: 'Bogotá',
      centerLat: 4.7110,
      centerLng: -74.0721,
      minLat: 4.45,
      maxLat: 4.85,
      minLng: -74.25,
      maxLng: -73.95,
      zones: [
        XistiBarrioShortcut(label: 'Chapinero', lat: 4.6533, lng: -74.0636),
        XistiBarrioShortcut(label: 'Usaquén', lat: 4.7110, lng: -74.0303),
        XistiBarrioShortcut(label: 'Suba', lat: 4.7510, lng: -74.0886),
        XistiBarrioShortcut(label: 'Kennedy', lat: 4.6290, lng: -74.1578),
        XistiBarrioShortcut(label: 'Centro', lat: 4.5981, lng: -74.0758),
        XistiBarrioShortcut(label: 'Zona T', lat: 4.6690, lng: -74.0553),
      ],
    ),
    XistiMainCityProfile(
      id: medellinId,
      countryId: colombiaId,
      displayName: 'Medellín',
      centerLat: 6.2476,
      centerLng: -75.5658,
      minLat: 6.05,
      maxLat: 6.50,
      minLng: -75.75,
      maxLng: -75.30,
      zones: [
        XistiBarrioShortcut(label: 'El Poblado', lat: 6.2086, lng: -75.5671),
        XistiBarrioShortcut(label: 'Laureles', lat: 6.2442, lng: -75.5897),
        XistiBarrioShortcut(label: 'Envigado', lat: 6.1759, lng: -75.5917),
        XistiBarrioShortcut(label: 'Bello', lat: 6.3373, lng: -75.5580),
        XistiBarrioShortcut(label: 'Rionegro', lat: 6.1554, lng: -75.3737),
        XistiBarrioShortcut(label: 'Centro', lat: 6.2476, lng: -75.5658),
      ],
    ),
    XistiMainCityProfile(
      id: 'barranquilla',
      countryId: colombiaId,
      displayName: 'Barranquilla',
      centerLat: 10.9639,
      centerLng: -74.7964,
      minLat: 10.82,
      maxLat: 11.05,
      minLng: -74.98,
      maxLng: -74.65,
      zones: [
        XistiBarrioShortcut(label: 'El Prado', lat: 10.9970, lng: -74.8120),
        XistiBarrioShortcut(label: 'Riomar', lat: 11.0170, lng: -74.8260),
        XistiBarrioShortcut(label: 'Metropolitano', lat: 10.9639, lng: -74.7964),
        XistiBarrioShortcut(label: 'Norte-Centro', lat: 10.9878, lng: -74.7889),
        XistiBarrioShortcut(label: 'Suroccidente', lat: 10.9200, lng: -74.8100),
        XistiBarrioShortcut(label: 'Malambo', lat: 10.8590, lng: -74.7670),
      ],
    ),
    XistiMainCityProfile(
      id: 'cali',
      countryId: colombiaId,
      displayName: 'Cali',
      centerLat: 3.4516,
      centerLng: -76.5320,
      minLat: 3.25,
      maxLat: 3.55,
      minLng: -76.65,
      maxLng: -76.42,
      zones: [
        XistiBarrioShortcut(label: 'Granada', lat: 3.4540, lng: -76.5420),
        XistiBarrioShortcut(label: 'San Fernando', lat: 3.4210, lng: -76.5400),
        XistiBarrioShortcut(label: 'Ciudad Jardín', lat: 3.3840, lng: -76.5280),
        XistiBarrioShortcut(label: 'Limonar', lat: 3.4010, lng: -76.5440),
        XistiBarrioShortcut(label: 'Centro', lat: 3.4516, lng: -76.5320),
        XistiBarrioShortcut(label: 'Meléndez', lat: 3.3750, lng: -76.5370),
      ],
    ),
    XistiMainCityProfile(
      id: 'bucaramanga',
      countryId: colombiaId,
      displayName: 'Bucaramanga',
      centerLat: 7.1193,
      centerLng: -73.1227,
      minLat: 6.98,
      maxLat: 7.22,
      minLng: -73.28,
      maxLng: -73.05,
      zones: [
        XistiBarrioShortcut(label: 'Cabecera', lat: 7.1193, lng: -73.1227),
        XistiBarrioShortcut(label: 'Provenza', lat: 7.1040, lng: -73.1090),
        XistiBarrioShortcut(label: 'La Flora', lat: 7.1080, lng: -73.1320),
        XistiBarrioShortcut(label: 'Centro', lat: 7.1250, lng: -73.1190),
        XistiBarrioShortcut(label: 'Girón', lat: 7.0700, lng: -73.1680),
        XistiBarrioShortcut(label: 'Floridablanca', lat: 7.0620, lng: -73.0880),
      ],
    ),
    XistiMainCityProfile(
      id: 'cartagena',
      countryId: colombiaId,
      displayName: 'Cartagena',
      centerLat: 10.3910,
      centerLng: -75.4794,
      minLat: 10.28,
      maxLat: 10.48,
      minLng: -75.58,
      maxLng: -75.44,
      zones: [
        XistiBarrioShortcut(label: 'Bocagrande', lat: 10.3990, lng: -75.5540),
        XistiBarrioShortcut(label: 'Centro Histórico', lat: 10.4236, lng: -75.5480),
        XistiBarrioShortcut(label: 'Manga', lat: 10.4140, lng: -75.5360),
        XistiBarrioShortcut(label: 'Castillo', lat: 10.4270, lng: -75.5140),
        XistiBarrioShortcut(label: 'El Laguito', lat: 10.4050, lng: -75.5630),
        XistiBarrioShortcut(label: 'Manzanillo', lat: 10.3840, lng: -75.4870),
      ],
    ),
    XistiMainCityProfile(
      id: 'manizales',
      countryId: colombiaId,
      displayName: 'Manizales',
      centerLat: 5.0703,
      centerLng: -75.5138,
      minLat: 4.97,
      maxLat: 5.17,
      minLng: -75.58,
      maxLng: -75.42,
      zones: [
        XistiBarrioShortcut(label: 'Centro', lat: 5.0703, lng: -75.5138),
        XistiBarrioShortcut(label: 'Palogrande', lat: 5.0660, lng: -75.4890),
        XistiBarrioShortcut(label: 'Versalles', lat: 5.0750, lng: -75.5020),
        XistiBarrioShortcut(label: 'La Macarena', lat: 5.0680, lng: -75.5180),
        XistiBarrioShortcut(label: 'Chipre', lat: 5.0580, lng: -75.5060),
        XistiBarrioShortcut(label: 'Sultana', lat: 5.0820, lng: -75.5280),
      ],
    ),
  ];

  static const List<XistiMainCityProfile> _usaCities = [
    XistiMainCityProfile(
      id: 'miami',
      countryId: usaId,
      displayName: 'Miami',
      centerLat: 25.7617,
      centerLng: -80.1918,
      minLat: 25.55,
      maxLat: 26.05,
      minLng: -80.45,
      maxLng: -80.05,
      zones: [
        XistiBarrioShortcut(label: 'Brickell', lat: 25.7617, lng: -80.1918),
        XistiBarrioShortcut(label: 'Wynwood', lat: 25.8010, lng: -80.1990),
        XistiBarrioShortcut(label: 'South Beach', lat: 25.7907, lng: -80.1300),
        XistiBarrioShortcut(label: 'Coral Gables', lat: 25.7210, lng: -80.2680),
        XistiBarrioShortcut(label: 'Doral', lat: 25.8195, lng: -80.3553),
        XistiBarrioShortcut(label: 'Airport', lat: 25.7959, lng: -80.2870),
      ],
    ),
    XistiMainCityProfile(
      id: 'new_york',
      countryId: usaId,
      displayName: 'Nueva York',
      centerLat: 40.7128,
      centerLng: -74.0060,
      minLat: 40.45,
      maxLat: 40.95,
      minLng: -74.35,
      maxLng: -73.65,
      zones: [
        XistiBarrioShortcut(label: 'Manhattan', lat: 40.7580, lng: -73.9855),
        XistiBarrioShortcut(label: 'Brooklyn', lat: 40.6782, lng: -73.9442),
        XistiBarrioShortcut(label: 'Queens', lat: 40.7282, lng: -73.7949),
        XistiBarrioShortcut(label: 'Bronx', lat: 40.8448, lng: -73.8648),
        XistiBarrioShortcut(label: 'JFK', lat: 40.6413, lng: -73.7781),
        XistiBarrioShortcut(label: 'Midtown', lat: 40.7549, lng: -73.9840),
      ],
    ),
    XistiMainCityProfile(
      id: 'los_angeles',
      countryId: usaId,
      displayName: 'Los Ángeles',
      centerLat: 34.0522,
      centerLng: -118.2437,
      minLat: 33.70,
      maxLat: 34.35,
      minLng: -118.65,
      maxLng: -117.90,
      zones: [
        XistiBarrioShortcut(label: 'Downtown', lat: 34.0407, lng: -118.2468),
        XistiBarrioShortcut(label: 'Hollywood', lat: 34.0928, lng: -118.3287),
        XistiBarrioShortcut(label: 'Santa Monica', lat: 34.0195, lng: -118.4912),
        XistiBarrioShortcut(label: 'Beverly Hills', lat: 34.0736, lng: -118.4004),
        XistiBarrioShortcut(label: 'LAX', lat: 33.9416, lng: -118.4085),
        XistiBarrioShortcut(label: 'Pasadena', lat: 34.1478, lng: -118.1445),
      ],
    ),
    XistiMainCityProfile(
      id: 'chicago',
      countryId: usaId,
      displayName: 'Chicago',
      centerLat: 41.8781,
      centerLng: -87.6298,
      minLat: 41.65,
      maxLat: 42.05,
      minLng: -87.95,
      maxLng: -87.50,
      zones: [
        XistiBarrioShortcut(label: 'Loop', lat: 41.8819, lng: -87.6278),
        XistiBarrioShortcut(label: 'River North', lat: 41.8925, lng: -87.6341),
        XistiBarrioShortcut(label: 'Hyde Park', lat: 41.7948, lng: -87.5907),
        XistiBarrioShortcut(label: 'Wicker Park', lat: 41.9088, lng: -87.6796),
        XistiBarrioShortcut(label: 'O\'Hare', lat: 41.9742, lng: -87.9073),
        XistiBarrioShortcut(label: 'South Side', lat: 41.7508, lng: -87.6145),
      ],
    ),
    XistiMainCityProfile(
      id: 'houston',
      countryId: usaId,
      displayName: 'Houston',
      centerLat: 29.7604,
      centerLng: -95.3698,
      minLat: 29.45,
      maxLat: 30.10,
      minLng: -95.80,
      maxLng: -95.00,
      zones: [
        XistiBarrioShortcut(label: 'Downtown', lat: 29.7604, lng: -95.3698),
        XistiBarrioShortcut(label: 'Galleria', lat: 29.7400, lng: -95.4620),
        XistiBarrioShortcut(label: 'Medical Center', lat: 29.7050, lng: -95.4010),
        XistiBarrioShortcut(label: 'Heights', lat: 29.7940, lng: -95.3980),
        XistiBarrioShortcut(label: 'IAH', lat: 29.9902, lng: -95.3368),
        XistiBarrioShortcut(label: 'Sugar Land', lat: 29.6197, lng: -95.6349),
      ],
    ),
  ];

  static const List<XistiMainCityProfile> _brazilCities = [
    XistiMainCityProfile(
      id: 'sao_paulo',
      countryId: brazilId,
      displayName: 'São Paulo',
      centerLat: -23.5505,
      centerLng: -46.6333,
      minLat: -23.85,
      maxLat: -23.35,
      minLng: -46.95,
      maxLng: -46.35,
      zones: [
        XistiBarrioShortcut(label: 'Paulista', lat: -23.5614, lng: -46.6560),
        XistiBarrioShortcut(label: 'Pinheiros', lat: -23.5670, lng: -46.6910),
        XistiBarrioShortcut(label: 'Moema', lat: -23.6010, lng: -46.6720),
        XistiBarrioShortcut(label: 'Centro', lat: -23.5505, lng: -46.6333),
        XistiBarrioShortcut(label: 'Itaim', lat: -23.5860, lng: -46.6820),
        XistiBarrioShortcut(label: 'GRU', lat: -23.4356, lng: -46.4731),
      ],
    ),
    XistiMainCityProfile(
      id: 'rio_de_janeiro',
      countryId: brazilId,
      displayName: 'Río de Janeiro',
      centerLat: -22.9068,
      centerLng: -43.1729,
      minLat: -23.10,
      maxLat: -22.75,
      minLng: -43.65,
      maxLng: -43.10,
      zones: [
        XistiBarrioShortcut(label: 'Copacabana', lat: -22.9711, lng: -43.1822),
        XistiBarrioShortcut(label: 'Ipanema', lat: -22.9840, lng: -43.2040),
        XistiBarrioShortcut(label: 'Centro', lat: -22.9068, lng: -43.1729),
        XistiBarrioShortcut(label: 'Barra', lat: -23.0000, lng: -43.3650),
        XistiBarrioShortcut(label: 'Botafogo', lat: -22.9519, lng: -43.1825),
        XistiBarrioShortcut(label: 'GIG', lat: -22.8090, lng: -43.2506),
      ],
    ),
    XistiMainCityProfile(
      id: 'brasilia',
      countryId: brazilId,
      displayName: 'Brasília',
      centerLat: -15.7939,
      centerLng: -47.8828,
      minLat: -15.95,
      maxLat: -15.65,
      minLng: -48.10,
      maxLng: -47.65,
      zones: [
        XistiBarrioShortcut(label: 'Plano Piloto', lat: -15.7939, lng: -47.8828),
        XistiBarrioShortcut(label: 'Asa Sul', lat: -15.8260, lng: -47.9230),
        XistiBarrioShortcut(label: 'Asa Norte', lat: -15.7600, lng: -47.8900),
        XistiBarrioShortcut(label: 'Lago Sul', lat: -15.8400, lng: -47.8700),
        XistiBarrioShortcut(label: 'Taguatinga', lat: -15.8320, lng: -48.0530),
        XistiBarrioShortcut(label: 'BSB', lat: -15.8711, lng: -47.9186),
      ],
    ),
  ];

  static const List<XistiMainCityProfile> _argentinaCities = [
    XistiMainCityProfile(
      id: 'buenos_aires',
      countryId: argentinaId,
      displayName: 'Buenos Aires',
      centerLat: -34.6037,
      centerLng: -58.3816,
      minLat: -34.85,
      maxLat: -34.45,
      minLng: -58.65,
      maxLng: -58.30,
      zones: [
        XistiBarrioShortcut(label: 'Microcentro', lat: -34.6037, lng: -58.3816),
        XistiBarrioShortcut(label: 'Palermo', lat: -34.5880, lng: -58.4300),
        XistiBarrioShortcut(label: 'Recoleta', lat: -34.5875, lng: -58.3970),
        XistiBarrioShortcut(label: 'Puerto Madero', lat: -34.6100, lng: -58.3620),
        XistiBarrioShortcut(label: 'Belgrano', lat: -34.5620, lng: -58.4580),
        XistiBarrioShortcut(label: 'EZE', lat: -34.8222, lng: -58.5358),
      ],
    ),
    XistiMainCityProfile(
      id: 'cordoba',
      countryId: argentinaId,
      displayName: 'Córdoba',
      centerLat: -31.4201,
      centerLng: -64.1888,
      minLat: -31.55,
      maxLat: -31.30,
      minLng: -64.35,
      maxLng: -64.05,
      zones: [
        XistiBarrioShortcut(label: 'Centro', lat: -31.4201, lng: -64.1888),
        XistiBarrioShortcut(label: 'Güemes', lat: -31.4280, lng: -64.1850),
        XistiBarrioShortcut(label: 'Cerro', lat: -31.3950, lng: -64.2050),
        XistiBarrioShortcut(label: 'Nueva Cba', lat: -31.4100, lng: -64.1700),
        XistiBarrioShortcut(label: 'Villa Allende', lat: -31.2950, lng: -64.2950),
        XistiBarrioShortcut(label: 'COR', lat: -31.3236, lng: -64.2080),
      ],
    ),
    XistiMainCityProfile(
      id: 'rosario',
      countryId: argentinaId,
      displayName: 'Rosario',
      centerLat: -32.9442,
      centerLng: -60.6505,
      minLat: -33.10,
      maxLat: -32.80,
      minLng: -60.80,
      maxLng: -60.50,
      zones: [
        XistiBarrioShortcut(label: 'Centro', lat: -32.9442, lng: -60.6505),
        XistiBarrioShortcut(label: 'Pichincha', lat: -32.9550, lng: -60.6400),
        XistiBarrioShortcut(label: 'Fisherton', lat: -32.9200, lng: -60.7100),
        XistiBarrioShortcut(label: 'Puerto Norte', lat: -32.9100, lng: -60.6300),
        XistiBarrioShortcut(label: 'Funes', lat: -32.9150, lng: -60.8100),
        XistiBarrioShortcut(label: 'ROS', lat: -32.9036, lng: -60.7854),
      ],
    ),
  ];

  static const List<XistiMainCityProfile> _mexicoCities = [
    XistiMainCityProfile(
      id: 'mexico_city',
      countryId: mexicoId,
      displayName: 'Ciudad de México',
      centerLat: 19.4326,
      centerLng: -99.1332,
      minLat: 19.20,
      maxLat: 19.60,
      minLng: -99.35,
      maxLng: -98.95,
      zones: const [],
    ),
    XistiMainCityProfile(
      id: 'guadalajara',
      countryId: mexicoId,
      displayName: 'Guadalajara',
      centerLat: 20.6597,
      centerLng: -103.3496,
      minLat: 20.55,
      maxLat: 20.80,
      minLng: -103.50,
      maxLng: -103.20,
      zones: const [],
    ),
    XistiMainCityProfile(
      id: 'monterrey',
      countryId: mexicoId,
      displayName: 'Monterrey',
      centerLat: 25.6866,
      centerLng: -100.3161,
      minLat: 25.55,
      maxLat: 25.85,
      minLng: -100.45,
      maxLng: -100.15,
      zones: const [],
    ),
    XistiMainCityProfile(
      id: 'cancun',
      countryId: mexicoId,
      displayName: 'Cancún',
      centerLat: 21.1619,
      centerLng: -86.8515,
      minLat: 21.05,
      maxLat: 21.25,
      minLng: -86.95,
      maxLng: -86.75,
      zones: const [],
    ),
  ];

  static const List<XistiMainCityProfile> _spainCities = [
    XistiMainCityProfile(
      id: 'madrid',
      countryId: spainId,
      displayName: 'Madrid',
      centerLat: 40.4168,
      centerLng: -3.7038,
      minLat: 40.30,
      maxLat: 40.55,
      minLng: -3.85,
      maxLng: -3.55,
      zones: const [],
    ),
    XistiMainCityProfile(
      id: 'barcelona',
      countryId: spainId,
      displayName: 'Barcelona',
      centerLat: 41.3874,
      centerLng: 2.1686,
      minLat: 41.30,
      maxLat: 41.50,
      minLng: 2.05,
      maxLng: 2.30,
      zones: const [],
    ),
    XistiMainCityProfile(
      id: 'valencia',
      countryId: spainId,
      displayName: 'Valencia',
      centerLat: 39.4699,
      centerLng: -0.3763,
      minLat: 39.40,
      maxLat: 39.55,
      minLng: -0.45,
      maxLng: -0.28,
      zones: const [],
    ),
  ];

  static const List<XistiMainCityProfile> _chileCities = [
    XistiMainCityProfile(
      id: 'santiago',
      countryId: chileId,
      displayName: 'Santiago',
      centerLat: -33.4489,
      centerLng: -70.6693,
      minLat: -33.60,
      maxLat: -33.30,
      minLng: -70.85,
      maxLng: -70.50,
      zones: const [],
    ),
    XistiMainCityProfile(
      id: 'valparaiso',
      countryId: chileId,
      displayName: 'Valparaíso',
      centerLat: -33.0472,
      centerLng: -71.6127,
      minLat: -33.12,
      maxLat: -32.95,
      minLng: -71.70,
      maxLng: -71.50,
      zones: const [],
    ),
    XistiMainCityProfile(
      id: 'concepcion',
      countryId: chileId,
      displayName: 'Concepción',
      centerLat: -36.8201,
      centerLng: -73.0444,
      minLat: -36.90,
      maxLat: -36.75,
      minLng: -73.15,
      maxLng: -72.95,
      zones: const [],
    ),
  ];

  static const List<XistiMainCityProfile> _peruCities = [
    XistiMainCityProfile(
      id: 'lima',
      countryId: peruId,
      displayName: 'Lima',
      centerLat: -12.0464,
      centerLng: -77.0428,
      minLat: -12.25,
      maxLat: -11.90,
      minLng: -77.15,
      maxLng: -76.85,
      zones: const [],
    ),
    XistiMainCityProfile(
      id: 'arequipa',
      countryId: peruId,
      displayName: 'Arequipa',
      centerLat: -16.4090,
      centerLng: -71.5375,
      minLat: -16.50,
      maxLat: -16.30,
      minLng: -71.65,
      maxLng: -71.45,
      zones: const [],
    ),
    XistiMainCityProfile(
      id: 'cusco',
      countryId: peruId,
      displayName: 'Cusco',
      centerLat: -13.5319,
      centerLng: -71.9675,
      minLat: -13.60,
      maxLat: -13.45,
      minLng: -72.05,
      maxLng: -71.90,
      zones: const [],
    ),
  ];

  static const List<XistiMainCityProfile> _ecuadorCities = [
    XistiMainCityProfile(
      id: 'quito',
      countryId: ecuadorId,
      displayName: 'Quito',
      centerLat: -0.1807,
      centerLng: -78.4678,
      minLat: -0.35,
      maxLat: 0.05,
      minLng: -78.60,
      maxLng: -78.35,
      zones: const [],
    ),
    XistiMainCityProfile(
      id: 'guayaquil',
      countryId: ecuadorId,
      displayName: 'Guayaquil',
      centerLat: -2.1709,
      centerLng: -79.9224,
      minLat: -2.30,
      maxLat: -2.05,
      minLng: -80.05,
      maxLng: -79.80,
      zones: const [],
    ),
    XistiMainCityProfile(
      id: 'cuenca',
      countryId: ecuadorId,
      displayName: 'Cuenca',
      centerLat: -2.9001,
      centerLng: -79.0059,
      minLat: -2.98,
      maxLat: -2.82,
      minLng: -79.10,
      maxLng: -78.90,
      zones: const [],
    ),
  ];
}

/// Backward-compatible alias used by the home map shortcuts.
abstract final class XistiMainCityZoneCatalog {
  static String get medellinId => XistiRegionCatalog.medellinId;

  static List<XistiMainCityProfile> get cities => XistiRegionCatalog.allCities;

  static XistiMainCityProfile get defaultCity => XistiRegionCatalog.defaultCity;

  static XistiMainCityProfile? cityContaining(double lat, double lng) {
    final region = XistiRegionCatalog.resolveRegion(lat, lng);
    return region.city.contains(lat, lng) ? region.city : null;
  }

  static XistiMainCityProfile nearestCity(double lat, double lng) =>
      XistiRegionCatalog.resolveRegion(lat, lng).city;

  static XistiMainCityProfile resolveCity(double lat, double lng) =>
      XistiRegionCatalog.resolveRegion(lat, lng).city;

  static List<XistiBarrioShortcut> zonesForLocation(double lat, double lng) =>
      resolveCity(lat, lng).zones;
}
