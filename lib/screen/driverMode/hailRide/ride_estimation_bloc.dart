import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/utils.dart';
import '../../passengerMode/passengerHome/passenger_home_dl.dart';
import '../driverRunningRide/driver_running_ride.dart';
import 'hail_ride_dl.dart';
import 'ride_estimation_repo.dart';

class RideEstimationBloc extends Bloc {
  BuildContext context;
  final List<SearchedLocation> addressList;
  final double offerPrice, distance;
  final int time;
  final String customerName, customerNumber;
  final RideEstimationRepo _repo = RideEstimationRepo();

  RideEstimationBloc(
    this.context, {
    required this.addressList,
    required this.offerPrice,
    required this.distance,
    required this.time,
    required this.customerName,
    required this.customerNumber,
  });

  final subject = BehaviorSubject<ApiResponse<HailRideBookingPojo>>();

  Future<void> rideBookApiCall() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        rideBookApiCall();
      },
    )) {
      subject.sink.add(ApiResponse.loading());
      try {
        var response = HailRideBookingPojo.fromJson(
          await _repo.rideBookApi(
            totalDistance: distance,
            estimatedTime: time,
            addressList: jsonEncode(addressList),
            offeredFare: offerPrice,
            otherContactNumber: customerNumber,
            otherUserName: customerName,
          ),
        );

        if (!context.mounted) return;
        String message = getApiMsg(response.message);
        if (isApiStatus(context, response.status, message, true)) {
          subject.sink.add(ApiResponse.completed(response));
          openScreenWithClearPrevious(context, DriverRunningRide(rideId: response.rideId ?? 0, serviceId: ServiceType.taxi));
        } else {
          subject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        debugPrint(e.toString());
        subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    subject.close();
  }
}
