import '../main.dart';

class SharedRideKind {
  static const String puebloPueblo = 'pueblo_a_pueblo';
  static const String puebloCiudad = 'pueblo_a_ciudad';

  static const String defaultKind = puebloPueblo;

  static String normalize(String? kind) {
    final value = (kind ?? '').trim();
    if (value == puebloCiudad) return puebloCiudad;
    return puebloPueblo;
  }

  static String label(String kind) {
    switch (normalize(kind)) {
      case puebloCiudad:
        return 'Ciudad → Municipio';
      case puebloPueblo:
      default:
        return 'Municipio → Ciudad';
    }
  }

  static String originHint(String kind) {
    return normalize(kind) == puebloCiudad
        ? 'Ciudad de origen (ej. Medellín)'
        : 'Municipio de origen (ej. Santa Fe de Antioquia)';
  }

  static String destinationHint(String kind) {
    return normalize(kind) == puebloCiudad
        ? 'Municipio de destino'
        : 'Ciudad de destino';
  }

  static String destinationRequiredMessage(String kind) {
    return normalize(kind) == puebloCiudad
        ? languages.sharedRideDestinationRequiredCity
        : languages.sharedRideDestinationRequiredTown;
  }
}
