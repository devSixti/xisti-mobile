import '../constant/constant.dart';
import '../screen/passengerMode/passengerHome/passenger_home_dl.dart';
import 'service_mode_util.dart';

/// Passenger home vehicle matrix (viajes + envíos) with bundled icons.
abstract final class XistiVehicleCatalog {
  static const String carroEco = 'carro_eco';
  static const String carroComodo = 'carro_comodo';
  static const String carroEconomico = 'carro_economico';
  static const String motoAlto = 'moto_alto_cilindraje';
  static const String motoBajo = 'moto_bajo_cilindraje';
  static const String motoMedio = 'moto_medio_cilindraje';
  static const String bicicleta = 'bicicleta';

  static const _iconBase = 'assets/images/vehicle_home';

  static String iconAsset(String variant) => '$_iconBase/$variant.png';

  static List<ServiceTypeItem> transportOptions() => [
        _item(ServiceType.taxi, 'Carro eco', carroEco, 1),
        _item(ServiceType.taxi, 'Carro cómodo', carroComodo, 2),
        _item(ServiceType.taxi, 'Carro económico', carroEconomico, 3),
        _item(ServiceType.bike, 'Moto alto cilindraje', motoAlto, 4),
        _item(ServiceType.bike, 'Moto bajo cilindraje', motoBajo, 5),
      ];

  static List<DeliveryVehicleOption> deliveryOptions() => [
        DeliveryVehicleOption(
          vehicleServiceId: ServiceType.bike,
          label: 'Moto',
          serviceIcon: iconAsset(motoMedio),
          deliveryVariant: motoMedio,
        ),
        DeliveryVehicleOption(
          vehicleServiceId: ServiceType.taxi,
          label: 'Carro',
          serviceIcon: iconAsset(carroEconomico),
          deliveryVariant: carroEconomico,
        ),
        DeliveryVehicleOption(
          vehicleServiceId: ServiceType.courier,
          label: 'Bicicleta',
          serviceIcon: iconAsset(bicicleta),
          deliveryVariant: bicicleta,
        ),
      ];

  static List<ServiceTypeItem> deliveryServiceItems() =>
      ServiceModeKind.serviceItemsFromDeliveryOptions(deliveryOptions());

  static ServiceTypeItem _item(
    int serviceId,
    String name,
    String variant,
    int order,
  ) =>
      ServiceTypeItem(
        serviceId: serviceId,
        serviceName: name,
        serviceIcon: iconAsset(variant),
        serviceMode: ServiceModeKind.transport,
        displayOrder: order,
        deliveryVariant: variant,
      );

  /// Prefer catalog icons/labels; keep API pricing fields when present.
  static List<ServiceTypeItem> mergeTransportApi(List<ServiceTypeItem> apiRows) {
    final catalog = transportOptions();
    if (apiRows.isEmpty) return catalog;
    final byVariant = {for (final c in catalog) c.deliveryVariant ?? '': c};
    final byService = <int, ServiceTypeItem>{};
    for (final row in apiRows) {
      byService[row.serviceId ?? 0] = row;
    }
    return catalog.map((c) {
      final api = byService[c.serviceId ?? 0];
      return ServiceTypeItem(
        serviceId: c.serviceId,
        serviceName: c.serviceName,
        serviceIcon: c.serviceIcon,
        serviceMode: c.serviceMode,
        displayOrder: c.displayOrder,
        deliveryVariant: c.deliveryVariant,
        costForKm: api?.costForKm ?? c.costForKm,
        minOfferFareAmount: api?.minOfferFareAmount ?? c.minOfferFareAmount,
        serviceDescription: api?.serviceDescription ?? c.serviceDescription,
      );
    }).toList();
  }

  static List<ServiceTypeItem> mergeDeliveryApi(
    List<DeliveryVehicleOption> apiOptions, {
    String serviceMode = ServiceModeKind.delivery,
  }) {
    final catalog = deliveryServiceItems();
    if (apiOptions.isEmpty) {
      return catalog
          .map((c) => ServiceTypeItem(
                serviceId: c.serviceId,
                serviceName: c.serviceName,
                serviceIcon: c.serviceIcon,
                serviceMode: serviceMode,
                displayOrder: c.displayOrder,
                deliveryVariant: c.deliveryVariant,
              ))
          .toList();
    }
    final apiByVariant = {
      for (final o in apiOptions) o.deliveryVariant ?? '': o,
    };
    return catalog.map((c) {
      final variant = c.deliveryVariant ?? '';
      return ServiceTypeItem(
        serviceId: c.serviceId,
        serviceName: c.serviceName,
        serviceIcon: c.serviceIcon ?? iconAsset(variant),
        serviceMode: serviceMode,
        displayOrder: c.displayOrder,
        deliveryVariant: variant,
      );
    }).toList();
  }

  /// Driver chip label from service id + variant slug.
  static String labelFor({
    required int? serviceId,
    String? variant,
    String? fallbackServiceName,
  }) {
    final v = variant ?? '';
    if (v.isNotEmpty) {
      for (final e in [...transportOptions(), ...deliveryServiceItems()]) {
        if ((e.deliveryVariant ?? '') == v) {
          final name = e.serviceName;
          if (name != null && name.isNotEmpty) return name;
        }
      }
    }
    if ((fallbackServiceName ?? '').trim().isNotEmpty) {
      return fallbackServiceName!.trim();
    }
    switch (serviceId) {
      case ServiceType.taxi:
        return 'Carro';
      case ServiceType.bike:
        return 'Moto';
      case ServiceType.courier:
        return 'Bicicleta';
      default:
        return 'Viaje';
    }
  }

  /// Taxi drivers registered on eco/económico receive those requests.
  static bool taxiEligibleVariant(String? variant) {
    final v = variant ?? '';
    return v == carroEco || v == carroEconomico;
  }
}