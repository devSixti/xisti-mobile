import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';

const int passengerPending = 0;
const int passengerApproved = 1;
const int passengerSchedule = 2;
const int passengerArrive = 3;
const int passengerCancel = 4;
const int passengerRunning = 5;
const int passengerDrop = 6;
const int passengerPayment = 7;
const int passengerRating = 8;
const int passengerCompleted = 9;
const int passengerFailed = 10;

/// Passenger may cancel while the trip has not started yet (before status 5).
bool canPassengerCancelRide(int rideStatus) {
  return rideStatus >= passengerPending && rideStatus < passengerRunning;
}

class PassengerRideStatusView extends StatelessWidget {
  final int rideStatus;

  const PassengerRideStatusView({super.key, required this.rideStatus});

  @override
  Widget build(BuildContext context) {
    Color statusColor = getCurrentTheme(context).colorStatusCompleted;
    String status = "";

    switch (rideStatus) {
      case passengerPending: //0
        statusColor = getCurrentTheme(context).colorStatusOnGoing;
        status = languages.pending;
        break;
      case passengerApproved: //1
      case passengerSchedule: //2
        statusColor = getCurrentTheme(context).colorStatusOnGoing;
        status = languages.accepted;
        break;
      case passengerArrive: //3
        statusColor = getCurrentTheme(context).colorStatusOnGoing;
        status = languages.running;
        break;
      case passengerCancel: //4
        statusColor = getCurrentTheme(context).colorStatusCancel;
        status = languages.cancelled;
        break;
      case passengerRunning: //5
      case passengerDrop: //6
      case passengerPayment: //7
      case passengerRating: //8
        statusColor = getCurrentTheme(context).colorStatusOnGoing;
        status = languages.running;
        break;
      case passengerCompleted: //9
        statusColor = getCurrentTheme(context).colorStatusCompleted;
        status = languages.completed;
        break;
      case passengerFailed: //10
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
