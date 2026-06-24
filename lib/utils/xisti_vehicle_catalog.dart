import '../constant/constant.dart';
import '../screen/driverMode/driverVehicleDetails/driver_vehicle_details_dl.dart';
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

  /// Local bundled icon for a driver service row (variant slug or service id).
  static String iconForDriver({
    int? serviceId,
    String? variant,
    String? fallbackUrl,
  }) {
    final v = (variant ?? '').trim();
    if (v.isNotEmpty) {
      for (final e in [...transportOptions(), ...deliveryServiceItems()]) {
        if ((e.deliveryVariant ?? '') == v && (e.serviceIcon ?? '').startsWith('assets/')) {
          return e.serviceIcon!;
        }
      }
    }
    switch (serviceId) {
      case ServiceType.taxi:
        return iconAsset(carroEco);
      case ServiceType.bike:
        return iconAsset(motoMedio);
      case ServiceType.courier:
        return iconAsset(bicicleta);
      default:
        break;
    }
    return (fallbackUrl ?? '').trim();
  }

  static List<_DriverCatalogRow> _driverCatalogRows() => [
        _DriverCatalogRow(ServiceType.taxi, 'Carro eco', carroEco, false, true),
        _DriverCatalogRow(ServiceType.taxi, 'Carro cómodo', carroComodo, false, false),
        _DriverCatalogRow(ServiceType.taxi, 'Carro económico', carroEconomico, false, true),
        _DriverCatalogRow(ServiceType.bike, 'Moto alto cilindraje', motoAlto, false, false),
        _DriverCatalogRow(ServiceType.bike, 'Moto bajo cilindraje', motoBajo, false, false),
        _DriverCatalogRow(ServiceType.bike, 'Moto', motoMedio, true, false),
        _DriverCatalogRow(ServiceType.taxi, 'Carro', carroEconomico, true, false),
        _DriverCatalogRow(ServiceType.courier, 'Bicicleta', bicicleta, true, false),
      ];

  /// Ensures every catalog vehicle appears for drivers with transparent local icons.
  static List<ServiceList> mergeDriverServiceApi(List<ServiceList> apiRows) {
    final byVariant = <String, ServiceList>{};
    final typesByServiceId = <int, List<VehicleTypeList>>{};
    for (final row in apiRows) {
      final v = row.deliveryVariant.trim();
      if (v.isNotEmpty) byVariant[v] = row;
      if (row.vehicleTypeList.isNotEmpty) {
        typesByServiceId.putIfAbsent(row.serviceId, () => row.vehicleTypeList);
      }
    }

    final merged = <ServiceList>[];
    for (final c in _driverCatalogRows()) {
      final existing = byVariant[c.variant];
      final vehicleTypes = existing?.vehicleTypeList ??
          typesByServiceId[c.serviceId] ??
          typesByServiceId[ServiceType.taxi] ??
          [];
      merged.add(ServiceList(
        serviceId: c.serviceId,
        serviceName: existing?.serviceName.isNotEmpty == true ? existing!.serviceName : c.label,
        serviceIcon: iconAsset(c.variant),
        serviceDescription: existing?.serviceDescription ?? '',
        vehicleTypeList: vehicleTypes,
        supportsPassengerTransportToggle: existing?.supportsPassengerTransportToggle ?? c.deliveryOnly,
        isDeliveryOnlyService: existing?.isDeliveryOnlyService ?? c.deliveryOnly,
        requiresTechnicalInspection:
            existing?.requiresTechnicalInspection ?? (c.serviceId == ServiceType.taxi && !c.deliveryOnly),
        deliveryVariant: c.variant,
      ));
    }
    return merged;
  }
}

class _DriverCatalogRow {
  final int serviceId;
  final String label;
  final String variant;
  final bool deliveryOnly;
  final bool isTaxi;

  const _DriverCatalogRow(this.serviceId, this.label, this.variant, this.deliveryOnly, this.isTaxi);
}