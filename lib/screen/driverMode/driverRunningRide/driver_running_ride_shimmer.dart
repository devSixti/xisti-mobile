import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../utils/utils.dart';

class DriverRunningRideShimmer extends StatefulWidget {
  const DriverRunningRideShimmer({super.key});

  @override
  State<DriverRunningRideShimmer> createState() => _DriverRunningRideShimmer();
}

class _DriverRunningRideShimmer extends State<DriverRunningRideShimmer> {
  @override
  Widget build(BuildContext context) {
    return _buildDriverRunningRideDetailsShimmer();
  }

  Widget _buildDriverRunningRideDetailsShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        CommonAppBar(backgroundColor: Colors.transparent, toolbarHeight: 0),
        SizedBox(height: 10.sp),
        _pickupDropLocation(),
        Spacer(),
        _bottomSheetView(),
      ],
    );
  }

  Widget _pickupDropLocation() {
    return Container(
      margin: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 15.sp, vertical: 15.sp),
      decoration: BoxDecoration(
        color: getCurrentTheme(context).colorWhite,
        border: Border.all(color: getCurrentTheme(context).colorBlack, width: 1.sp),
        borderRadius: BorderRadiusDirectional.all(Radius.circular(22.r)),
      ),
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        period: const Duration(milliseconds: 800),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100.w, height: 20.h, color: getCurrentTheme(context).colorBlack),
                  SizedBox(height: 5.h),
                  Container(width: double.infinity, height: 20.h, color: getCurrentTheme(context).colorBlack),
                  SizedBox(height: 5.h),
                  Container(width: double.infinity, height: 20.h, color: getCurrentTheme(context).colorBlack),
                ],
              ),
            ),

            Container(
              margin: EdgeInsetsDirectional.only(start: 15.sp),
              padding: EdgeInsetsDirectional.symmetric(horizontal: 5.sp, vertical: 5.sp),
              decoration: BoxDecoration(
                color: getCurrentTheme(context).colorWhite.withValues(alpha: 0.2),
                border: Border.all(color: getCurrentTheme(context).colorBlack, width: 0.5.sp),
                borderRadius: BorderRadiusDirectional.all(Radius.circular(8.r)),
              ),
              child: Icon(CustomIcons.navigation, size: 16.sp, color: getCurrentTheme(context).colorIconCommon),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheetView() {
    return Container(
      padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 30.h),
      decoration: BoxDecoration(
        color: getCurrentTheme(context).colorWhite,
        border: Border.all(color: getCurrentTheme(context).colorWhite, width: 0),
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20.r), topStart: Radius.circular(20.r)),
      ),
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        period: const Duration(milliseconds: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _userDetailsView(),
            SizedBox(height: 20.h),
            CustomRoundedButton(
              context,
              languages.arrived,
              () {},
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 10.h),
              fontWeight: FontWeight.w600,
              bgColor: getCurrentTheme(context).colorBlack.withValues(alpha: 0.2),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _userDetailsView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 70.sp,
          height: 70.sp,
          decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack, borderRadius: BorderRadius.all(Radius.circular(16.r))),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(height: 20.h, color: getCurrentTheme(context).colorBlack, margin: EdgeInsetsDirectional.only(end: 30.w)),
              SizedBox(height: 10.h),
              Text(
                getAmountWithCurrency("0"),
                style: bodyText(context: context, fontWeight: FontWeight.w600, textColor: getCurrentTheme(context).colorPrimary, fontSize: textSize14px),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        chatAndCallButtonShimmer(context, CustomIcons.call),
        SizedBox(width: 10.w),
        chatAndCallButtonShimmer(context, CustomIcons.chat),
      ],
    );
  }

  Widget chatAndCallButtonShimmer(BuildContext context, IconData icon) {
    return Container(
      padding: EdgeInsetsDirectional.all(5.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(8.r)),
        border: Border.all(color: getCurrentTheme(context).colorIconCommon),
      ),
      child: Icon(icon, color: getCurrentTheme(context).colorIconCommon, size: 14.sp),
    );
  }
}
