import 'acarreo_icon_util.dart';
import '../main.dart';
import '../screen/passengerMode/passengerHome/passenger_home_dl.dart';
import 'app_mobile_settings.dart';
import 'xisti_vehicle_catalog.dart';

/// Passenger acarreo vehicle cards (motocarguero, camión, jaula).
class AcarreoVehicleUtil {
  static const String iconBase = AcarreoIconUtil.iconBase;

  static const String _iconVersion = AcarreoIconUtil.iconVersion;

  static List<DeliveryVehicleOption> fallbackOptions() {
    return [
      DeliveryVehicleOption.fromJson({
        'vehicle_service_id': 5,
        'acarreo_variant': 'motocarguero',
        'label': languages.haulMotocarguero,
        'service_icon': XistiVehicleCatalog.iconAsset(XistiVehicleCatalog.motocarguero),
      }),
      DeliveryVehicleOption.fromJson({
        'vehicle_service_id': 5,
        'acarreo_variant': 'camion',
        'label': languages.haulTruck,
        'service_icon': XistiVehicleCatalog.iconAsset(XistiVehicleCatalog.camionAcarreo),
      }),
      DeliveryVehicleOption.fromJson({
        'vehicle_service_id': 5,
        'acarreo_variant': 'jaula',
        'label': languages.haulCage,
        'service_icon': XistiVehicleCatalog.iconAsset(XistiVehicleCatalog.jaulaAcarreo),
      }),
    ];
  }

  /// Remote URLs for admin-served icons (driver panel, admin dashboard).
  static String remoteIconUrl(String variant) {
    return '$iconBase/${_remoteFilename(variant)}?v=$_iconVersion';
  }

  static String _remoteFilename(String variant) {
    switch (variant) {
      case 'motocarguero':
        return 'motocarguero.png';
      case 'camion':
        return 'camion_acarreo.png';
      case 'jaula':
        return 'jaula_acarreo.png';
      default:
        return '$variant.png';
    }
  }

  static List<DeliveryVehicleOption> effectiveOptions(
    List<DeliveryVehicleOption> fromApi,
  ) {
    if (fromApi.isNotEmpty) return fromApi;
    if (!isAcarreosMobileEnabled()) return [];
    return fallbackOptions();
  }
}
