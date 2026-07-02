import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../constant/constant.dart';
import '../hive/hive_helper.dart';
import '../screen/common/splash/splash_dl.dart';
import 'active_ride_offline_service.dart';
import 'app_telemetry.dart';

enum RideSessionPhase {
  idle,
  negotiating,
  active,
}

class RideSessionState {
  const RideSessionState({
    required this.phase,
    this.rideId,
    this.rideStatus = 0,
    this.serviceId = ServiceType.taxi,
    this.isDriver = false,
    this.passengerOffer,
    this.updatedAt,
  });

  const RideSessionState.idle()
      : phase = RideSessionPhase.idle,
        rideId = null,
        rideStatus = 0,
        serviceId = ServiceType.taxi,
        isDriver = false,
        passengerOffer = null,
        updatedAt = null;

  final RideSessionPhase phase;
  final int? rideId;
  final int rideStatus;
  final int serviceId;
  final bool isDriver;
  final RideDetails? passengerOffer;
  final DateTime? updatedAt;

  bool get hasRide => (rideId ?? 0) > 0;

  bool get isActiveTrip => hasRide && rideStatus > 0 && rideStatus < 6;

  RideSessionState copyWith({
    RideSessionPhase? phase,
    int? rideId,
    int? rideStatus,
    int? serviceId,
    bool? isDriver,
    RideDetails? passengerOffer,
    DateTime? updatedAt,
  }) {
    return RideSessionState(
      phase: phase ?? this.phase,
      rideId: rideId ?? this.rideId,
      rideStatus: rideStatus ?? this.rideStatus,
      serviceId: serviceId ?? this.serviceId,
      isDriver: isDriver ?? this.isDriver,
      passengerOffer: passengerOffer ?? this.passengerOffer,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Single source of truth for the active ride lifecycle across splash, push, and polling.
class RideSessionManager {
  RideSessionManager._();

  static final RideSessionManager instance = RideSessionManager._();

  final BehaviorSubject<RideSessionState> _subject = BehaviorSubject<RideSessionState>.seeded(const RideSessionState.idle());

  Stream<RideSessionState> get stream => _subject.stream;

  RideSessionState get current => _subject.value;

  void restoreFromOfflineCache() {
    final snapshot = ActiveRideOfflineService.instance.readRideSnapshot();
    if (snapshot == null) {
      return;
    }

    final rideId = _readInt(snapshot['ride_id']);
    final rideStatus = _readInt(snapshot['ride_status']) ?? 0;
    final serviceId = _readInt(snapshot['service_id']) ?? ServiceType.taxi;
    if (rideId == null || rideId <= 0) {
      return;
    }

    final isDriver = getIntFromSettingBox(hiveAppMode) == AppMode.driver;
    final phase = rideStatus == 0 ? RideSessionPhase.negotiating : RideSessionPhase.active;
    _emit(
      RideSessionState(
        phase: phase,
        rideId: rideId,
        rideStatus: rideStatus,
        serviceId: serviceId,
        isDriver: isDriver,
        updatedAt: DateTime.now(),
      ),
      funnelStep: 'offline_cache_restored',
    );
  }

  void applyPassengerRunning(PassengerRunningPojo response) {
    final rideId = response.rideId ?? 0;
    if (rideId <= 0) {
      markIdle(funnelStep: 'passenger_idle');
      return;
    }

    final rideStatus = response.rideStatus ?? 0;
    RideDetails? offer;
    if (rideStatus == 0 && (response.rideDetails ?? []).isNotEmpty) {
      offer = response.rideDetails!.first;
    }

    _emit(
      RideSessionState(
        phase: rideStatus == 0 ? RideSessionPhase.negotiating : RideSessionPhase.active,
        rideId: rideId,
        rideStatus: rideStatus,
        serviceId: offer?.serviceId ?? ServiceType.taxi,
        isDriver: false,
        passengerOffer: offer,
        updatedAt: DateTime.now(),
      ),
      funnelStep: rideStatus == 0 ? 'passenger_negotiating' : 'passenger_active_ride',
      rideId: rideId,
      rideStatus: rideStatus,
    );
  }

  void applyDriverRunning(GetRunningServicePojo response) {
    final rides = response.runningRides ?? [];
    if (rides.isEmpty) {
      markIdle(funnelStep: 'driver_idle');
      return;
    }

    final ride = rides.first;
    final rideId = ride.rideId ?? 0;
    if (rideId <= 0) {
      markIdle(funnelStep: 'driver_idle');
      return;
    }

    _emit(
      RideSessionState(
        phase: RideSessionPhase.active,
        rideId: rideId,
        rideStatus: ride.rideStatus ?? 0,
        serviceId: ride.rideServiceCatId ?? ServiceType.taxi,
        isDriver: true,
        updatedAt: DateTime.now(),
      ),
      funnelStep: 'driver_active_ride',
      rideId: rideId,
      rideStatus: ride.rideStatus ?? 0,
    );
  }

  void applyPushNotification({required int notificationType, required int rideId}) {
    if (rideId <= 0) {
      return;
    }

    final isDriver = getIntFromSettingBox(hiveAppMode) == AppMode.driver;
    if (notificationType == 7 && isDriver) {
      _emit(
        current.copyWith(
          phase: RideSessionPhase.negotiating,
          rideId: rideId,
          isDriver: true,
          updatedAt: DateTime.now(),
        ),
        funnelStep: 'driver_push_new_request',
        rideId: rideId,
      );
      return;
    }

    if (isActiveRideNotificationType(notificationType)) {
      _emit(
        current.copyWith(
          phase: RideSessionPhase.active,
          rideId: rideId,
          isDriver: isDriver,
          updatedAt: DateTime.now(),
        ),
        funnelStep: 'ride_push_alert',
        rideId: rideId,
        extra: {'notification_type': notificationType},
      );
    }
  }

  void markIdle({String? funnelStep}) {
    ActiveRideOfflineService.instance.clearRideSnapshot();
    _emit(const RideSessionState.idle(), funnelStep: funnelStep ?? 'ride_idle');
  }

  void syncActiveRide({
    required int rideId,
    required int rideStatus,
    required int serviceId,
    required bool isDriver,
    String funnelStep = 'ride_status_sync',
  }) {
    if (rideId <= 0 || rideStatus <= 0 || rideStatus >= 6) {
      markIdle(funnelStep: 'ride_completed_or_cancelled');
      return;
    }

    _emit(
      RideSessionState(
        phase: rideStatus == 0 ? RideSessionPhase.negotiating : RideSessionPhase.active,
        rideId: rideId,
        rideStatus: rideStatus,
        serviceId: serviceId,
        isDriver: isDriver,
        updatedAt: DateTime.now(),
      ),
      funnelStep: funnelStep,
      rideId: rideId,
      rideStatus: rideStatus,
    );
  }

  void _emit(
    RideSessionState next, {
    String? funnelStep,
    int? rideId,
    int? rideStatus,
    Map<String, Object?> extra = const {},
  }) {
    _subject.add(next);
    if (funnelStep == null) {
      return;
    }
    AppTelemetry.instance.logRideFunnel(
      funnelStep,
      rideId: rideId ?? next.rideId,
      rideStatus: rideStatus ?? next.rideStatus,
      extra: {
        'is_driver': next.isDriver,
        'phase': next.phase.name,
        ...extra,
      },
    );
  }

  int? _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}

bool isActiveRideNotificationType(int type) => const {1, 6, 7, 8, 14}.contains(type);
