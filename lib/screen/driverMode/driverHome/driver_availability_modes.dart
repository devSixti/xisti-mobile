import '../../../hive/hive_helper.dart';
import '../../../utils/service_mode_util.dart';

void persistDriverAvailabilityModes(bool transport, bool delivery) {
  putDataInSettingBox(hiveDriverAcceptTransport, transport);
  putDataInSettingBox(hiveDriverAcceptDelivery, delivery);
  putDataInSettingBox(hiveDriverRequestFilter, '');
}

(bool, bool) loadDriverAvailabilityModes() {
  final transport = getBoolFromSettingBox(hiveDriverAcceptTransport, defaultValue: true);
  final delivery = getBoolFromSettingBox(hiveDriverAcceptDelivery, defaultValue: false);
  return (transport, delivery);
}

/// Matches backend `allowedServiceModes` (driver-home / available rides).
bool driverAcceptsRideServiceMode(String serviceMode, {int isEncomienda = 0, int isDelivery = 0}) {
  final (acceptTransport, acceptDelivery) = loadDriverAvailabilityModes();

  if (isEncomienda == 1 || serviceMode == ServiceModeKind.encomiendas) {
    return acceptDelivery;
  }

  if (isDelivery == 1 || serviceMode == ServiceModeKind.delivery) {
    return acceptDelivery;
  }

  if (serviceMode == ServiceModeKind.expreso) {
    return acceptTransport;
  }

  if (serviceMode == ServiceModeKind.acarreos) {
    return acceptDelivery;
  }

  return acceptTransport;
}
