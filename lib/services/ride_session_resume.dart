import 'package:flutter/material.dart';

import '../screen/common/splash/splash_dl.dart';
import '../screen/driverMode/driverHome/driver_home.dart';
import '../screen/driverMode/driverRunningRide/driver_running_ride.dart';
import '../screen/passengerMode/offerRide/offer_ride_screen.dart';
import '../screen/passengerMode/passengerHome/passenger_home.dart';
import '../screen/passengerMode/passengerRunningRide/passenger_running_ride.dart';
import 'ride_session_manager.dart';

/// Maps [RideSessionState] or running-service API payloads to the screen that should open.
class RideSessionResume {
  const RideSessionResume._();

  static Widget driverHome({bool isFromLogin = false}) => DriverHome(isFromLogin: isFromLogin);

  static Widget passengerHome() => const PassengerHome();

  static Widget? screenForState(RideSessionState state) {
    if (!state.hasRide) {
      return state.isDriver ? driverHome() : passengerHome();
    }

    if (state.isDriver) {
      return DriverRunningRide(
        rideId: state.rideId ?? 0,
        serviceId: state.serviceId,
      );
    }

    if (state.phase == RideSessionPhase.negotiating && state.passengerOffer != null) {
      final offer = state.passengerOffer!;
      return OfferRideScreen(
        rideId: offer.rideId ?? state.rideId ?? 0,
        serviceType: offer.serviceId ?? state.serviceId,
        addressList: offer.addressList ?? [],
        fareAmount: '${offer.offeredPrice ?? 0}',
        itemDesc: offer.itemDescription ?? '',
        recipientName: offer.recipientName ?? '',
        recipientNumber: offer.recipientContactNumber ?? '',
        minFareAmount: offer.minBargainAmt ?? 0,
        maxFareAmount: offer.maxBargainAmt ?? 0,
        estimatedPrice: '${offer.estimatePrice ?? offer.offeredPrice ?? 0}',
      );
    }

    return PassengerRunningRide(rideId: state.rideId ?? 0);
  }

  static Widget? screenForPassengerResponse(PassengerRunningPojo response) {
    RideSessionManager.instance.applyPassengerRunning(response);
    return screenForState(RideSessionManager.instance.current);
  }

  static Widget? screenForDriverResponse(GetRunningServicePojo response) {
    RideSessionManager.instance.applyDriverRunning(response);
    return screenForState(RideSessionManager.instance.current);
  }
}
