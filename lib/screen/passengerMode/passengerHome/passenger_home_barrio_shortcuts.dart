import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/xisti_main_city_zones.dart';

/// City zone shortcut for map fly-to (location-aware carousel).
class XistiBarrioShortcut {
  final String label;
  final double lat;
  final double lng;

  const XistiBarrioShortcut({required this.label, required this.lat, required this.lng});

  LatLng get latLng => LatLng(lat, lng);
}

/// Default zones shown before GPS resolves (Medellín).
List<XistiBarrioShortcut> get kXistiBarrioShortcutsDefault =>
    XistiMainCityZoneCatalog.defaultCity.zones;
