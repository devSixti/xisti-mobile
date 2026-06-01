import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../commonView/child_size_notifier.dart';
import '../../../commonView/dash_line_view.dart';
import '../../../commonView/statusView/passenger_ride_status_view.dart';
import '../../../utils/utils.dart';

class DriverHistoryShimmer extends StatelessWidget {
  final bool enabled;

  const DriverHistoryShimmer({super.key, required this.enabled});

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

                  SizedBox(width: 10.w),
                  Expanded(child: Container(height: 20.sp, width: 60.sp, color: getCurrentTheme(context).colorBlack)),
                ],
              ),
              SizedBox(height: 15.h),

              // Location
              _addressDetail(),
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
            ],
          );
        },
      ),
    );
  }

  Widget _addressDetail() {
    return ChildSizeNotifier(
      builder: (context, size, child) {
        return Container(
          padding: EdgeInsetsDirectional.only(bottom: 20.h),
          child: Stack(
            children: [
              Container(
                alignment: AlignmentDirectional.topStart,
                margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 11.w),
                child: DashLineView(
                  dashColor: getCurrentTheme(context).colorBorder,
                  // totalHeight: addressList.length <= 2 ? size.height / 3 : size.height / 2.1,
                  totalHeight: size.height / 3,
                  dashHeight: 5.h,
                  dashWidth: 1.5.w,
                  emptyHeight: 4.h,
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                padding: EdgeInsetsDirectional.zero,
                separatorBuilder: (context, index) {
                  return Container(height: 15.h);
                },
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.all(2.sp),
                        margin: EdgeInsetsDirectional.only(end: 10.w),
                        child: Icon(
                          index == 0 ? CustomIcons.pickupLocation : CustomIcons.dropLocation,
                          size: 20.sp,
                          color: getCurrentTheme(context).colorIconCommon,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: double.infinity, height: 15.h, color: getCurrentTheme(context).colorBlack),
                            SizedBox(height: 5.h),
                            Container(width: 100.w, height: 15.h, color: getCurrentTheme(context).colorBlack),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
