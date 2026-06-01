import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/dimensions.dart';
import '../../main.dart';
import '../../utils/style_util.dart';
import '../../appThemeManager/app_theme_colors.dart';

const int referralPending = 0;
const int referralClaimed = 1;

class ReferralStatusView extends StatelessWidget {
  final int referralStatus;

  const ReferralStatusView({super.key, required this.referralStatus});

  @override
  Widget build(BuildContext context) {
    Color statusColor = getCurrentTheme(context).colorStatusCompleted;
    String status = "";

    switch (referralStatus) {
      case referralPending:
        statusColor = getCurrentTheme(context).colorReferralPending;
        status = languages.pending;
        break;
      case referralClaimed:
        statusColor = getCurrentTheme(context).colorReferralClaimed;
        status = languages.claimed;
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
