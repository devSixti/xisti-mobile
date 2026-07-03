import 'package:flutter/material.dart';

import '../main.dart';
import 'custom_icons.dart';
import 'service_mode_util.dart';

/// Shared copy and icons for XISTI service mode UI (rail, context strip, banners).
abstract final class XistiServiceModePresentation {
  static String title(String mode, {String? groupLabel}) {
    if (ServiceModeKind.isAcarreosMode(mode)) return languages.serviceModeHauling;
    if (mode == ServiceModeKind.delivery) return languages.serviceModeDelivery;
    if (ServiceModeKind.isSharedRideMode(mode)) return languages.serviceModeShare;
    return groupLabel?.isNotEmpty == true ? groupLabel! : languages.serviceModeTrips;
  }

  static String subtitle(String mode) {
    if (ServiceModeKind.isAcarreosMode(mode)) return languages.serviceModeHaulingSubtitle;
    switch (mode) {
      case ServiceModeKind.delivery:
        return languages.serviceModeDeliveryCardSubtitle;
      case ServiceModeKind.expreso:
        return languages.serviceModeShareSubtitle;
      case ServiceModeKind.transport:
      default:
        return languages.serviceModeTransportCardSubtitle;
    }
  }

  static IconData icon(String mode) {
    if (ServiceModeKind.isAcarreosMode(mode)) return Icons.local_shipping_outlined;
    switch (mode) {
      case ServiceModeKind.delivery:
        return CustomIcons.send;
      case ServiceModeKind.expreso:
        return Icons.people_outline;
      case ServiceModeKind.transport:
      default:
        return CustomIcons.car;
    }
  }

  static String? hintForMode(String? mode, {String? apiDisclaimer}) {
    final fromApi = (apiDisclaimer ?? '').trim();
    if (fromApi.isNotEmpty) return fromApi;
    switch (mode) {
      case ServiceModeKind.delivery:
        return languages.deliveryLegalNotice;
      case ServiceModeKind.expreso:
        return languages.modeBannerExpreso;
      case ServiceModeKind.acarreos:
      case ServiceModeKind.carga:
        return languages.serviceModeHaulingSubtitle;
      default:
        return null;
    }
  }

  static bool showsBarrioShortcuts(String? mode) {
    if (mode == null) return true;
    return mode == ServiceModeKind.transport || mode == ServiceModeKind.delivery;
  }
}
