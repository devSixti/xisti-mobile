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
        return languages.sharedRideTownToCity;
      case puebloPueblo:
      default:
        return languages.sharedRideTownToTown;
    }
  }

  static String originHint(String kind) => languages.sharedRideOriginTownHint;

  static String destinationHint(String kind) {
    return normalize(kind) == puebloCiudad
        ? languages.sharedRideDestinationCityHint
        : languages.sharedRideDestinationTownHint;
  }

  static String destinationRequiredMessage(String kind) {
    return normalize(kind) == puebloCiudad
        ? languages.sharedRideDestinationRequiredCity
        : languages.sharedRideDestinationRequiredTown;
  }
}
