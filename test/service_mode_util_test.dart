import 'package:app_xisti/constant/constant.dart';
import 'package:app_xisti/screen/passengerMode/passengerHome/passenger_home_dl.dart';
import 'package:app_xisti/utils/service_mode_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('modeForServiceId maps courier to delivery', () {
    expect(ServiceModeKind.modeForServiceId(ServiceType.courier), ServiceModeKind.delivery);
    expect(ServiceModeKind.modeForServiceId(ServiceType.taxi), ServiceModeKind.transport);
  });

  test('groupsFromFlatServices splits transport and delivery', () {
    final flat = [
      ServiceTypeItem(serviceId: 1, serviceName: 'Taxi'),
      ServiceTypeItem(serviceId: 4, serviceName: 'Courier'),
    ];
    final groups = ServiceModeKind.groupsFromFlatServices(flat);
    expect(groups.length, 2);
    expect(groups.first.mode, ServiceModeKind.transport);
    expect(groups.last.mode, ServiceModeKind.delivery);
  });

  test('isDeliveryRideRequest detects envíos by flag or courier fields', () {
    expect(
      ServiceModeKind.isDeliveryRideRequest(serviceId: ServiceType.courier),
      isTrue,
    );
    expect(
      ServiceModeKind.isDeliveryRideRequest(serviceId: ServiceType.taxi, isDelivery: 1),
      isTrue,
    );
    expect(
      ServiceModeKind.isDeliveryRideRequest(
        serviceId: ServiceType.taxi,
        recipientName: 'Ana',
      ),
      isTrue,
    );
    expect(
      ServiceModeKind.isDeliveryRideRequest(serviceId: ServiceType.taxi),
      isFalse,
    );
  });
}
