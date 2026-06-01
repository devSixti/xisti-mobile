import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../appThemeManager/app_theme_colors.dart';
import '../../../commonView/statusView/referral_status_view.dart';
import '../../../utils/custom_icons.dart';

class ReferralShimmer extends StatelessWidget {
  final bool enabled;

  const ReferralShimmer({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: getCurrentTheme(context).colorShimmerBg,
      highlightColor: Colors.grey.shade100,
      enabled: enabled,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsetsDirectional.symmetric(vertical: 20.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 12.w),
                  child: Container(
                    width: 70.sp,
                    height: 70.sp,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: getCurrentTheme(context).colorBlack),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(height: 15.h, color: getCurrentTheme(context).colorBlack, margin: EdgeInsetsDirectional.only(bottom: 10.h, top: 2.h)),
                      Flexible(
                        child: Row(
                          children: [
                            Icon(CustomIcons.discountPercent, color: getCurrentTheme(context).colorIconCommon, size: 16.sp),
                            SizedBox(width: 5.w),
                            Flexible(child: Container(height: 15.h, color: getCurrentTheme(context).colorBlack, margin: EdgeInsetsDirectional.only(top: 2.h))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                ReferralStatusView(referralStatus: 0),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(color: getCurrentTheme(context).colorBlack, thickness: 1.h, height: 0);
        },
        itemCount: 10,
      ),
    );
  }
}
