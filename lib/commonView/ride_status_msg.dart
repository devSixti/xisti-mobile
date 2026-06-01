import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';
import 'statusView/passenger_ride_status_view.dart';

class RideStatusMsg extends StatelessWidget {
  final int rideStatus;

  const RideStatusMsg({super.key, required this.rideStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 10.h, bottom: 10.h),
      padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 8.h, bottom: 8.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), border: Border.all(color: getCurrentTheme(context).colorBorder, width: 1.w)),
      child: Row(
        children: [
          Container(
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(color: getIconBorderColor(context, rideStatus), shape: BoxShape.circle),
            margin: EdgeInsetsDirectional.only(end: 5.w),
            padding: EdgeInsets.all(2.5.sp),
            child: Container(
              width: 28.sp,
              height: 28.sp,
              alignment: AlignmentDirectional.center,
              decoration: BoxDecoration(
                color: getIconBgColor(context, rideStatus),
                shape: BoxShape.circle,
                border: Border.all(color: getIconBorderColor(context, rideStatus), width: 2.w),
              ),
              child: Icon(getIcon(rideStatus), size: 18.sp, color: getCurrentTheme(context).colorPsRunningIcon),
            ),
          ),
          Expanded(child: Text(getRideMsg(rideStatus), style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  String getRideMsg(int status) {
    if (status < passengerArrive) {
      return languages.yourDriverIsOnWay;
    } else if (status <= passengerArrive) {
      return languages.driverIsAtPickup;
    } else if (status < passengerDrop) {
      return languages.driverHeadingDestination;
    } else {
      return languages.reachYourDestination;
    }
  }

  IconData getIcon(int status) {
    if (status < passengerArrive) {
      return CustomIcons.driverOnWay;
    } else if (status <= passengerArrive) {
      return CustomIcons.driverPickup;
    } else if (status < passengerDrop) {
      return CustomIcons.driverOnWay;
    } else {
      return CustomIcons.reachedDestination;
    }
  }

  Color getIconBgColor(BuildContext context, int status) {
    if (status < passengerDrop) {
      return getCurrentTheme(context).colorPsRunningIconBg;
    } else {
      return getCurrentTheme(context).colorPsCompletedIconBg;
    }
  }

  Color getIconBorderColor(BuildContext context, int status) {
    if (status < passengerDrop) {
      return getCurrentTheme(context).colorPsRunningIconBg.withValues(alpha: 0.5);
    } else {
      return getCurrentTheme(context).colorPsCompletedIconBg.withValues(alpha: 0.5);
    }
  }
}
