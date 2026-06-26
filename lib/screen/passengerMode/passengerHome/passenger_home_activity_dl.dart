/// Snapshot for the home activity hub card (active ride or recent destination).
import '../../../main.dart';

class PassengerActivitySnapshot {
  final bool isActive;
  final int? rideId;
  final int? rideStatus;
  final int? serviceId;
  final String title;
  final String subtitle;
  final String? destinationName;
  final double? destinationLat;
  final double? destinationLng;

  const PassengerActivitySnapshot({
    required this.isActive,
    this.rideId,
    this.rideStatus,
    this.serviceId,
    required this.title,
    required this.subtitle,
    this.destinationName,
    this.destinationLat,
    this.destinationLng,
  });

  factory PassengerActivitySnapshot.active({
    required int rideId,
    required int rideStatus,
    required int? serviceId,
    required String title,
    required String subtitle,
  }) =>
      PassengerActivitySnapshot(
        isActive: true,
        rideId: rideId,
        rideStatus: rideStatus,
        serviceId: serviceId,
        title: title,
        subtitle: subtitle,
      );

  factory PassengerActivitySnapshot.recent({
    required String destinationName,
    required double destinationLat,
    required double destinationLng,
    required String serviceLabel,
  }) =>
      PassengerActivitySnapshot(
        isActive: false,
        title: languages.repeatActivityTitle(serviceLabel),
        subtitle: destinationName,
        destinationName: destinationName,
        destinationLat: destinationLat,
        destinationLng: destinationLng,
      );
}
