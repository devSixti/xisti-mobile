import 'package:app_xisti/utils/xisti_region_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('XistiRegionCatalog', () {
    test('detects Medellín metro coordinates', () {
      final region = XistiRegionCatalog.resolveRegionInCatalog(6.2086, -75.5671)!;
      expect(region.city.id, 'medellin');
      expect(region.country.id, 'co');
      expect(region.city.zones.first.label, 'El Poblado');
    });

    test('detects Bogotá coordinates', () {
      final region = XistiRegionCatalog.resolveRegionInCatalog(4.6533, -74.0636)!;
      expect(region.city.id, 'bogota');
      expect(region.city.displayName, 'Bogotá');
    });

    test('detects Miami in United States', () {
      final region = XistiRegionCatalog.resolveRegionInCatalog(25.7617, -80.1918)!;
      expect(region.country.id, 'us');
      expect(region.city.id, 'miami');
      expect(region.country.currencyCode, 'USD');
    });

    test('detects São Paulo in Brazil', () {
      final region = XistiRegionCatalog.resolveRegionInCatalog(-23.5505, -46.6333)!;
      expect(region.country.id, 'br');
      expect(region.city.id, 'sao_paulo');
      expect(region.country.currencySymbol, 'R\$');
    });

    test('detects Buenos Aires in Argentina', () {
      final region = XistiRegionCatalog.resolveRegionInCatalog(-34.6037, -58.3816)!;
      expect(region.country.id, 'ar');
      expect(region.city.id, 'buenos_aires');
      expect(region.country.minFare, 2500);
    });

    test('detects Mexico City', () {
      final region = XistiRegionCatalog.resolveRegionInCatalog(19.4326, -99.1332)!;
      expect(region.country.id, 'mx');
      expect(region.city.id, 'mexico_city');
      expect(region.country.currencyCode, 'MXN');
    });

    test('detects Madrid in Spain', () {
      final region = XistiRegionCatalog.resolveRegionInCatalog(40.4168, -3.7038)!;
      expect(region.country.id, 'es');
      expect(region.city.id, 'madrid');
      expect(region.country.currencySymbol, '€');
    });

    test('detects Lima in Peru', () {
      final region = XistiRegionCatalog.resolveRegionInCatalog(-12.0464, -77.0428)!;
      expect(region.country.id, 'pe');
      expect(region.city.id, 'lima');
    });

    test('outside catalog returns null (no snap)', () {
      // Tokyo — outside all market bboxes
      expect(XistiRegionCatalog.resolveRegionInCatalog(35.6762, 139.6503), isNull);
    });

    test('geocode-derived region for unknown ISO uses USD defaults', () {
      final region = XistiRegionCatalog.regionFromGeocode(
        isoCode: 'JP',
        countryName: 'Japan',
        cityName: 'Tokyo',
        lat: 35.6762,
        lng: 139.6503,
      );
      expect(region.isGeocodeDerived, isTrue);
      expect(region.country.isoCode, 'JP');
      expect(region.country.currencyCode, 'USD');
      expect(region.city.displayName, 'Tokyo');
    });

    test('geocode-derived for catalog ISO maps to catalog country', () {
      final region = XistiRegionCatalog.regionFromGeocode(
        isoCode: 'CL',
        countryName: 'Chile',
        cityName: 'Santiago',
        lat: -33.4489,
        lng: -70.6693,
      );
      expect(region.country.id, 'cl');
      expect(region.city.id, 'santiago');
    });

    test('rio_de_janeiro id aligned with markets.php', () {
      final city = XistiRegionCatalog.cityById('rio_de_janeiro');
      expect(city, isNotNull);
      expect(city!.displayName, contains('Janeiro'));
    });

    test('zonesForLocation returns city-specific shortcuts', () {
      final zones = XistiMainCityZoneCatalog.zonesForLocation(4.7110, -74.0721);
      expect(zones.map((z) => z.label), contains('Chapinero'));
      expect(zones.map((z) => z.label), isNot(contains('El Poblado')));
    });
  });
}
