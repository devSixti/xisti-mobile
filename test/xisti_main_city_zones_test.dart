import 'package:app_xisti/utils/xisti_region_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('XistiRegionCatalog', () {
    test('detects Medellín metro coordinates', () {
      final region = XistiRegionCatalog.resolveRegion(6.2086, -75.5671);
      expect(region.city.id, 'medellin');
      expect(region.country.id, 'co');
      expect(region.city.zones.first.label, 'El Poblado');
    });

    test('detects Bogotá coordinates', () {
      final region = XistiRegionCatalog.resolveRegion(4.6533, -74.0636);
      expect(region.city.id, 'bogota');
      expect(region.city.displayName, 'Bogotá');
    });

    test('detects Miami in United States', () {
      final region = XistiRegionCatalog.resolveRegion(25.7617, -80.1918);
      expect(region.country.id, 'us');
      expect(region.city.id, 'miami');
      expect(region.country.currencyCode, 'USD');
    });

    test('detects São Paulo in Brazil', () {
      final region = XistiRegionCatalog.resolveRegion(-23.5505, -46.6333);
      expect(region.country.id, 'br');
      expect(region.city.id, 'sao_paulo');
      expect(region.country.currencySymbol, 'R\$');
    });

    test('detects Buenos Aires in Argentina', () {
      final region = XistiRegionCatalog.resolveRegion(-34.6037, -58.3816);
      expect(region.country.id, 'ar');
      expect(region.city.id, 'buenos_aires');
      expect(region.country.minFare, 2500);
    });

    test('falls back to nearest city outside all metros', () {
      final region = XistiRegionCatalog.resolveRegion(5.5, -73.0);
      expect(region.city.id, isIn(['bucaramanga', 'bogota', 'medellin', 'manizales']));
    });

    test('zonesForLocation returns city-specific shortcuts', () {
      final zones = XistiMainCityZoneCatalog.zonesForLocation(4.7110, -74.0721);
      expect(zones.map((z) => z.label), contains('Chapinero'));
      expect(zones.map((z) => z.label), isNot(contains('El Poblado')));
    });
  });
}
