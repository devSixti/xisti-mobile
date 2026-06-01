import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../commonView/statusView/passenger_ride_status_view.dart';
import '../../../../utils/utils.dart';

class ReportedIssueHistoryShimmer extends StatelessWidget {
  final bool enabled;

  const ReportedIssueHistoryShimmer({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: getCurrentTheme(context).colorShimmerBg,
      highlightColor: Colors.grey.shade100,
      enabled: enabled,
      child: ListView.separated(
        itemCount: 10,
        padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 5.h, bottom: 50.h),
        separatorBuilder: (context, index) {
          return Divider(height: 40.h, color: getCurrentTheme(context).colorDivider, thickness: 1.sp);
        },
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and Cost
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(minWidth: 200.w, maxWidth: 200.w),
                    margin: EdgeInsetsDirectional.symmetric(vertical: 0.5.sp),
                    // For Border
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: getCurrentTheme(context).colorContainerBorder, width: 0.5.sp),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CustomIcons.rideDatetime, size: 20.sp, color: getCurrentTheme(context).colorBlack),
                        SizedBox(width: 5.w),
                        Expanded(child: Container(height: 17.sp, width: 150.sp, color: getCurrentTheme(context).colorBlack)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              // Image And Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70.sp,
                    width: 70.sp,
                    decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack, borderRadius: BorderRadius.circular(15.r)),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 20.sp, width: 110.sp, color: getCurrentTheme(context).colorBlack),
                        SizedBox(height: 10.h),
                        Container(height: 17.sp, width: 50.sp, color: getCurrentTheme(context).colorBlack),
                      ],
                    ),
                  ),
                  // Status
                  PassengerRideStatusView(rideStatus: index),
                ],
              ),
              SizedBox(height: 15.h),
              Container(height: 20.sp, width: 110.sp, color: getCurrentTheme(context).colorBlack),
            ],
          );
        },
      ),
    );
  }
}
