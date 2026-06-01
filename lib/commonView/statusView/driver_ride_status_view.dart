import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';

// const int driverPending = 0;
// const int driverApproved = 1;
// const int driverSchedule = 2;
// const int driverArrive = 3;
// const int driverCancel = 4;
// const int driverRunning = 5;
// const int driverDrop = 6;
// const int driverPayment = 7;
// const int driverRating = 8;
// const int driverCompleted = 9;
// const int driverFailed = 10;


class DriverRideStatus {
  /// 0=pending
  static const driverPending = 0;

  /// 1=accepted
  static const driverApproved = 1;

  /// 2=scheduleAccepted
  static const driverSchedule = 2;

  /// 3=arrived
  static const driverArrive = 3;

  /// 4=cancelled
  static const driverCancel = 4;

  /// 5=runningRide
  static const driverRunning = 5;

  /// 6=drop
  static const driverDrop = 6;

  /// 7=payment
  static const driverPayment = 7;

  /// 8=rating
  static const driverRating = 8;

  /// 9=completed
  static const driverCompleted = 9;

  /// 10=failed
  static const driverFailed = 10;
}

class DriverRideStatusView extends StatelessWidget {
  final int rideStatus;

  const DriverRideStatusView({super.key, required this.rideStatus});

  @override
  Widget build(BuildContext context) {
    Color statusColor = getCurrentTheme(context).colorStatusCompleted;
    String status = "";

    switch (rideStatus) {
      case DriverRideStatus.driverPending: //0
        statusColor = getCurrentTheme(context).colorStatusOnGoing;
        status = languages.pending;
        break;
      case DriverRideStatus.driverApproved: //1
      case DriverRideStatus.driverSchedule: //2
        statusColor = getCurrentTheme(context).colorStatusOnGoing;
        status = languages.accepted;
        break;
      case DriverRideStatus.driverArrive: //3
        statusColor = getCurrentTheme(context).colorStatusOnGoing;
        status = languages.running;
        break;
      case DriverRideStatus.driverCancel: //4
        statusColor = getCurrentTheme(context).colorStatusCancel;
        status = languages.cancelled;
        break;
      case DriverRideStatus.driverRunning: //5
      case DriverRideStatus.driverDrop: //6
      case DriverRideStatus.driverPayment: //7
      case DriverRideStatus.driverRating: //8
        statusColor = getCurrentTheme(context).colorStatusOnGoing;
        status = languages.running;
        break;
      case DriverRideStatus.driverCompleted: //9
        statusColor = getCurrentTheme(context).colorStatusCompleted;
        status = languages.completed;
        break;
      case DriverRideStatus.driverFailed: //10
        statusColor = getCurrentTheme(context).colorStatusCancel;
        status = languages.cancelled;
        break;
      default:
        statusColor = getCurrentTheme(context).colorStatusOnGoing;
        status = languages.pending;
        break;
    }

    return Container(
      padding: EdgeInsetsDirectional.only(start: 7.w, end: 7.w, top: 5.h, bottom: 5.h),
      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(15.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.3), shape: BoxShape.circle),
            margin: EdgeInsetsDirectional.only(end: 5.w),
            padding: EdgeInsets.all(2.5.sp),
            child: Container(
              width: 5.sp,
              height: 5.sp,
              alignment: AlignmentDirectional.center,
              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.5), shape: BoxShape.circle),
            ),
          ),
          Text(status, style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
