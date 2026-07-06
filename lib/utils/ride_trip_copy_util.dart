import '../constant/constant.dart';
import '../main.dart';
import 'service_mode_util.dart';

class RideTripCopy {
  static bool isPackageOrCargoTrip({
    int? serviceId,
    String? itemDescription,
    String? recipientName,
  }) {
    if (ServiceModeKind.isDeliveryServiceId(serviceId)) {
      return true;
    }
    if ((itemDescription ?? '').trim().isNotEmpty) {
      return true;
    }
    if ((recipientName ?? '').trim().isNotEmpty) {
      return true;
    }

    return false;
  }

  static String driverAtPickupMessage({
    int? serviceId,
    String? itemDescription,
    String? recipientName,
  }) {
    return isPackageOrCargoTrip(
      serviceId: serviceId,
      itemDescription: itemDescription,
      recipientName: recipientName,
    )
        ? languages.cargoAtPickup
        : languages.driverIsAtPickup;
  }

  static String headingToDestinationMessage({
    int? serviceId,
    String? itemDescription,
    String? recipientName,
  }) {
    return isPackageOrCargoTrip(
      serviceId: serviceId,
      itemDescription: itemDescription,
      recipientName: recipientName,
    )
        ? languages.cargoHeadingDestination
        : languages.driverHeadingDestination;
  }

  static String reachedDestinationMessage({
    int? serviceId,
    String? itemDescription,
    String? recipientName,
  }) {
    return isPackageOrCargoTrip(
      serviceId: serviceId,
      itemDescription: itemDescription,
      recipientName: recipientName,
    )
        ? languages.cargoReachedDestination
        : languages.reachYourDestination;
  }
}
