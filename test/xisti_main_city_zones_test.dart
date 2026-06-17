import 'package:app_xisti/utils/xisti_main_city_zones.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('XistiMainCityZoneCatalog', () {
    test('detects Medellín metro coordinates', () {
      final city = XistiMainCityZoneCatalog.resolveCity(6.2086, -75.5671);
      expect(city.id, 'medellin');
      expect(city.zones.first.label, 'El Poblado');
    });

    test('detects Bogotá coordinates', () {
      final city = XistiMainCityZoneCatalog.resolveCity(4.6533, -74.0636);
      expect(city.id, 'bogota');
      expect(city.displayName, 'Bogotá');
    });

    test('detects Cali coordinates', () {
      final city = XistiMainCityZoneCatalog.resolveCity(3.4516, -76.5320);
      expect(city.id, 'cali');
    });

    test('detects Barranquilla coordinates', () {
      final city = XistiMainCityZoneCatalog.resolveCity(10.9639, -74.7964);
      expect(city.id, 'barranquilla');
    });

    test('detects Bucaramanga coordinates', () {
      final city = XistiMainCityZoneCatalog.resolveCity(7.1193, -73.1227);
      expect(city.id, 'bucaramanga');
    });

    test('detects Cartagena coordinates', () {
      final city = XistiMainCityZoneCatalog.resolveCity(10.4236, -75.5480);
      expect(city.id, 'cartagena');
    });

    test('detects Manizales coordinates', () {
      final city = XistiMainCityZoneCatalog.resolveCity(5.0703, -75.5138);
      expect(city.id, 'manizales');
    });

    test('falls back to nearest city outside all metros', () {
      final city = XistiMainCityZoneCatalog.resolveCity(5.5, -73.0);
      expect(city.id, isIn(['bucaramanga', 'bogota', 'medellin', 'manizales']));
    });

    test('zonesForLocation returns city-specific shortcuts', () {
      final zones = XistiMainCityZoneCatalog.zonesForLocation(4.7110, -74.0721);
      expect(zones.map((z) => z.label), contains('Chapinero'));
      expect(zones.map((z) => z.label), isNot(contains('El Poblado')));
    });
  });
}
