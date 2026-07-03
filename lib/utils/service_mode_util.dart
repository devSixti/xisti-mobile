import '../constant/constant.dart';
import '../main.dart';
import '../screen/passengerMode/passengerHome/passenger_home_dl.dart';
import 'app_mobile_settings.dart';

/// Top-level service categories (transport vs delivery).
class ServiceModeKind {
  static const String transport = 'transport';
  static const String delivery = 'delivery';
  static const String expreso = 'expreso';
  static const String encomiendas = 'encomiendas';
  static const String acarreos = 'acarreos';
  static const String carga = 'carga';

  static bool isEncomiendasMode(String? mode) => mode == encomiendas;

  static bool isDeliveryLikeMode(String? mode) =>
      mode == delivery || mode == encomiendas;

  static const Set<int> transportServiceIds = {
    ServiceType.taxi,
    ServiceType.bike,
  };

  static const Set<int> deliveryServiceIds = {ServiceType.courier};

  static String modeForServiceId(int? serviceId) {
    if (serviceId == null) return transport;
    if (deliveryServiceIds.contains(serviceId)) return delivery;
    return transport;
  }

  static bool isExpresoMode(String? mode) =>
      mode == expreso || mode == 'viajes_compartidos';

  static bool isAcarreosMode(String? mode) =>
      mode == acarreos || mode == carga;

  static bool isSharedRideMode(String? mode) => isExpresoMode(mode);

  static bool isDeliveryServiceId(int? serviceId) =>
      serviceId != null && deliveryServiceIds.contains(serviceId);

  /// Driver-facing: transport ride vs envío (courier), including API `is_delivery`.
  static bool isDeliveryRideRequest({
    int? serviceId,
    int? isDelivery,
    String? itemDescription,
    String? recipientName,
  }) {
    if (isDelivery == 1) return true;
    if (isDeliveryServiceId(serviceId)) return true;
    if ((itemDescription ?? '').trim().isNotEmpty) return true;
    if ((recipientName ?? '').trim().isNotEmpty) return true;
    return false;
  }

  static List<ServiceTypeItem> filterByMode(
    List<ServiceTypeItem> services,
    String mode,
  ) {
    return services
        .where((s) => resolveItemMode(s) == mode)
        .toList();
  }

  static String resolveItemMode(ServiceTypeItem item) {
    if (item.serviceMode != null && item.serviceMode!.isNotEmpty) {
      return item.serviceMode!;
    }
    return modeForServiceId(item.serviceId);
  }

  /// Builds grouped modes from API `service_modes` or legacy flat `services`.
  static List<ServiceModeGroup> parseServiceModesFromHomeJson(dynamic json) {
    if (json == null) return [];
    if (json['service_modes'] != null) {
      final groups = <ServiceModeGroup>[];
      for (final raw in json['service_modes'] as List) {
        final mode = raw['mode']?.toString() ?? transport;
        final services = <ServiceTypeItem>[];
        if (raw['services'] != null) {
          for (final v in raw['services'] as List) {
            services.add(ServiceTypeItem.fromJson(v));
          }
        }
        groups.add(
          ServiceModeGroup(
            mode: mode,
            label: raw['label']?.toString() ?? _defaultLabel(mode),
            displayOrder: raw['display_order'] is int
                ? raw['display_order'] as int
                : int.tryParse('${raw['display_order']}') ?? 0,
            services: services,
          ),
        );
      }
      groups.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      return filterServiceModeGroupsForFeatureFlags(groups);
    }

    final flat = <ServiceTypeItem>[];
    if (json['services'] != null) {
      for (final v in json['services'] as List) {
        flat.add(ServiceTypeItem.fromJson(v));
      }
    }
    return filterServiceModeGroupsForFeatureFlags(groupsFromFlatServices(flat));
  }

  static List<ServiceModeGroup> filterServiceModeGroupsForFeatureFlags(
    List<ServiceModeGroup> groups,
  ) {
    return groups
        .where((g) {
          if (g.mode == expreso && !isExpresoMobileEnabled()) return false;
          if (g.mode == encomiendas && !isEncomiendasMobileEnabled()) return false;
          if ((g.mode == acarreos || g.mode == carga) && !isAcarreosMobileEnabled()) return false;
          return true;
        })
        .map(_filterActiveVehicleServicesInGroup)
        .toList();
  }

  static ServiceModeGroup _filterActiveVehicleServicesInGroup(ServiceModeGroup g) {
    if (g.mode != transport) {
      return g;
    }
    final filtered = g.services
        .where((s) => s.serviceId != ServiceType.rickshaw)
        .toList();
    return ServiceModeGroup(
      mode: g.mode,
      label: g.label,
      displayOrder: g.displayOrder,
      services: filtered,
    );
  }

  /// Ensures Expreso / Encomiendas tabs exist when admin flags are on (single service per mode).
  static List<ServiceModeGroup> enrichFlaggedModeGroups(
    List<ServiceModeGroup> groups,
    List<ServiceTypeItem> allServices,
  ) {
    final result = List<ServiceModeGroup>.from(groups);
    final existing = result.map((g) => g.mode).toSet();

    void addIfMissing(String mode, String label, int order) {
      if (existing.contains(mode)) return;
      if (mode == expreso && !isExpresoMobileEnabled()) return;
      if (mode == encomiendas && !isEncomiendasMobileEnabled()) return;
      final services = allServices.where((s) => resolveItemMode(s) == mode).toList();
      if (services.isEmpty) return;
      result.add(
        ServiceModeGroup(
          mode: mode,
          label: label,
          displayOrder: order,
          services: services.length == 1 ? services : [services.first],
        ),
      );
      existing.add(mode);
    }

    addIfMissing(expreso, languages.serviceModeShare, 3);
    addIfMissing(encomiendas, languages.serviceModeErrand, 4);
    if (isAcarreosMobileEnabled()) {
      addIfMissing(acarreos, languages.serviceModeHauling, 5);
    }
    result.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return result;
  }

  static List<ServiceModeGroup> groupsFromFlatServices(List<ServiceTypeItem> flat) {
    final transportServices = filterByMode(flat, transport)
        .where((s) => s.serviceId != ServiceType.rickshaw)
        .toList();
    final deliveryServices = filterByMode(flat, delivery);
    final groups = <ServiceModeGroup>[];
    if (transportServices.isNotEmpty) {
      groups.add(
        ServiceModeGroup(
          mode: transport,
          label: _defaultLabel(transport),
          displayOrder: 1,
          services: transportServices,
        ),
      );
    }
    if (deliveryServices.isNotEmpty) {
      groups.add(
        ServiceModeGroup(
          mode: delivery,
          label: _defaultLabel(delivery),
          displayOrder: 2,
          services: deliveryServices,
        ),
      );
    }
    return filterServiceModeGroupsForFeatureFlags(groups);
  }

  static String _defaultLabel(String mode) {
    String localized(String Function() getter, String fallback) {
      try {
        return getter();
      } catch (_) {
        return fallback;
      }
    }
    switch (mode) {
      case delivery:
        return localized(() => languages.serviceModeDelivery, 'Entregas');
      case expreso:
        return localized(() => languages.serviceModeShare, 'Compartido');
      case encomiendas:
        return localized(() => languages.serviceModeErrand, 'Encomiendas');
      case acarreos:
      case carga:
        return localized(() => languages.serviceModeHauling, 'Carga');
      case transport:
      default:
        return localized(() => languages.serviceModeTrips, 'Viajes');
    }
  }

  /// Envío / Encomiendas: moto y carro (delivery_vehicle_options desde API).
  static List<ServiceTypeItem> serviceItemsFromDeliveryOptions(
    List<DeliveryVehicleOption> options, {
    String serviceMode = delivery,
  }) {
    final items = <ServiceTypeItem>[];
    for (final o in options) {
      items.add(
        ServiceTypeItem(
          serviceId: o.vehicleServiceId,
          serviceName: o.label,
          serviceIcon: o.serviceIcon,
          serviceMode: serviceMode,
          deliveryVariant: o.deliveryVariant,
        ),
      );
    }
    return items;
  }

  static List<ServiceTypeItem> serviceItemsFromAcarreoOptions(
    List<DeliveryVehicleOption> options,
  ) {
    final items = <ServiceTypeItem>[];
    for (final o in options) {
      items.add(
        ServiceTypeItem(
          serviceId: o.vehicleServiceId,
          serviceName: o.label,
          serviceIcon: o.serviceIcon,
          serviceMode: acarreos,
          deliveryVariant: o.acarreoVariant ?? o.deliveryVariant,
        ),
      );
    }
    return items;
  }
}

class ServiceModeGroup {
  final String mode;
  final String label;
  final int displayOrder;
  final List<ServiceTypeItem> services;

  const ServiceModeGroup({
    required this.mode,
    required this.label,
    required this.displayOrder,
    required this.services,
  });
}
