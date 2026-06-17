import 'package:geolocator/geolocator.dart';

import '../screen/passengerMode/passengerHome/passenger_home_barrio_shortcuts.dart';

/// Profile for one of Colombia's main XISTI cities and its map zone shortcuts.
class XistiMainCityProfile {
  final String id;
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

/// Static zone catalog for Colombia's 7 main cities (location-aware carousel v1).
abstract final class XistiMainCityZoneCatalog {
  static const String medellinId = 'medellin';

  static const List<XistiMainCityProfile> cities = [
    XistiMainCityProfile(
      id: 'bogota',
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

  static XistiMainCityProfile get defaultCity =>
      cities.firstWhere((c) => c.id == medellinId);

  static XistiMainCityProfile? cityContaining(double lat, double lng) {
    for (final city in cities) {
      if (city.contains(lat, lng)) return city;
    }
    return null;
  }

  static XistiMainCityProfile nearestCity(double lat, double lng) {
    var nearest = defaultCity;
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

  /// Prefer metro bounding box; otherwise pick the closest main city.
  static XistiMainCityProfile resolveCity(double lat, double lng) =>
      cityContaining(lat, lng) ?? nearestCity(lat, lng);

  static List<XistiBarrioShortcut> zonesForLocation(double lat, double lng) =>
      resolveCity(lat, lng).zones;
}
