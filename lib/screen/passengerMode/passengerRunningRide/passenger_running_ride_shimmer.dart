import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/ride_status_msg.dart';
import '../../../utils/utils.dart';

class DriverDetailShimmer extends StatelessWidget {
  final bool enabled;

  const DriverDetailShimmer({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: getCurrentTheme(context).colorScaffoldBg,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 1.w),
      ),
      padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.h),
      margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 50.h),
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: enabled,
        period: const Duration(milliseconds: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70.sp,
                  height: 70.sp,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: getCurrentTheme(context).colorBlack),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: double.infinity, height: 20.h, color: getCurrentTheme(context).colorBlack),
                      SizedBox(height: 10.h),
                      Text(
                        getAmountWithCurrency(0),
                        style: bodyText(
                          context: context,
                          fontSize: textSize14px,
                          fontWeight: FontWeight.w600,
                          textColor: getCurrentTheme(context).colorPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(start: 10.w),
                  padding: EdgeInsetsDirectional.all(5.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 0.5.w),
                  ),
                  child: Icon(CustomIcons.call, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
                ),
                Container(
                  padding: EdgeInsetsDirectional.all(5.sp),
                  margin: EdgeInsetsDirectional.only(start: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 0.5.w),
                  ),
                  child: Icon(CustomIcons.chat, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
                ),
              ],
            ),
            RideStatusMsg(rideStatus: 0),
          ],
        ),
      ),
    );
  }
}

class VehicleDetailShimmer extends StatelessWidget {
  final bool enabled;

  const VehicleDetailShimmer({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getCurrentTheme(context).colorScaffoldBg,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
      ),
      padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 20.h, bottom: getBottomMargin()),
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: enabled,
        period: const Duration(milliseconds: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70.sp,
                  height: 70.sp,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: getCurrentTheme(context).colorBlack),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Container(margin: EdgeInsetsDirectional.only(end: 15.w), height: 20.h, color: getCurrentTheme(context).colorBlack)),
                          Container(width: 80.w, height: 20.h, color: getCurrentTheme(context).colorBlack),
                        ],
                      ),
                      SizedBox(height: 7.h),
                      Container(width: 60.w, height: 15.h, color: getCurrentTheme(context).colorBlack),
                      SizedBox(height: 7.h),
                      Row(
                        children: [
                          Container(width: 50.w, height: 15.h, color: getCurrentTheme(context).colorBlack),
                          Container(
                            margin: EdgeInsetsDirectional.only(start: 7.w, end: 7.w),
                            alignment: AlignmentDirectional.center,
                            padding: EdgeInsets.all(2.sp),
                            decoration: BoxDecoration(color: getCurrentTheme(context).colorTextCommon, shape: BoxShape.circle),
                          ),
                          Container(width: 40.w, height: 15.h, color: getCurrentTheme(context).colorBlack),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CustomRoundedButton(context, languages.proceedToPay, () {}, setBorder: false, margin: EdgeInsetsDirectional.only(top: 20.h)),
          ],
        ),
      ),
    );
  }
}
