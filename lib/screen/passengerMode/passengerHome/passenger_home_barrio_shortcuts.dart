import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Medellín metro area shortcuts for map fly-to (static v1).
class XistiBarrioShortcut {
  final String label;
  final double lat;
  final double lng;

  const XistiBarrioShortcut({required this.label, required this.lat, required this.lng});

  LatLng get latLng => LatLng(lat, lng);
}

const List<XistiBarrioShortcut> kXistiBarrioShortcuts = [
  XistiBarrioShortcut(label: 'El Poblado', lat: 6.2086, lng: -75.5671),
  XistiBarrioShortcut(label: 'Laureles', lat: 6.2442, lng: -75.5897),
  XistiBarrioShortcut(label: 'Envigado', lat: 6.1759, lng: -75.5917),
  XistiBarrioShortcut(label: 'Bello', lat: 6.3373, lng: -75.5580),
  XistiBarrioShortcut(label: 'Rionegro', lat: 6.1554, lng: -75.3737),
  XistiBarrioShortcut(label: 'Centro', lat: 6.2476, lng: -75.5658),
];
