import 'acarreo_icon_util.dart';
import '../main.dart';
import '../screen/passengerMode/passengerHome/passenger_home_dl.dart';
import 'app_mobile_settings.dart';

/// Passenger acarreo vehicle cards (motocarguero, camión, jaula).
class AcarreoVehicleUtil {
  static const String iconBase =
      'https://admin.appzimo.com/assets/images/vehicle-service';

  static const String _iconVersion = AcarreoIconUtil.iconVersion;

  static List<DeliveryVehicleOption> fallbackOptions() {
    const v = _iconVersion;
    return [
      DeliveryVehicleOption.fromJson({
        'vehicle_service_id': 5,
        'acarreo_variant': 'motocarguero',
        'label': languages.haulMotocarguero,
        'service_icon': '$iconBase/motocarguero.png?v=$v',
      }),
      DeliveryVehicleOption.fromJson({
        'vehicle_service_id': 5,
        'acarreo_variant': 'camion',
        'label': languages.haulTruck,
        'service_icon': '$iconBase/camion_acarreo.png?v=$v',
      }),
      DeliveryVehicleOption.fromJson({
        'vehicle_service_id': 5,
        'acarreo_variant': 'jaula',
        'label': languages.haulCage,
        'service_icon': '$iconBase/jaula_acarreo.png?v=$v',
      }),
    ];
  }

  static List<DeliveryVehicleOption> effectiveOptions(
    List<DeliveryVehicleOption> fromApi,
  ) {
    if (fromApi.isNotEmpty) return fromApi;
    if (!isAcarreosMobileEnabled()) return [];
    return fallbackOptions();
  }
}
