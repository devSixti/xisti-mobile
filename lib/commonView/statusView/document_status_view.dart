import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../appThemeManager/app_theme_colors.dart';
import '../../constant/dimensions.dart';
import '../../main.dart';
import '../../utils/style_util.dart';

const int documentPending = 0;
const int documentApprove = 1;
const int documentRejected = 2;
const int documentExpire = 3;
const int documentNotUpdate = 4;

class DocumentStatusView extends StatelessWidget {
  final int docStatus;

  const DocumentStatusView({super.key, required this.docStatus});

  @override
  Widget build(BuildContext context) {
    Color statusColor = getCurrentTheme(context).colorStatusCompleted;
    String status = "";

    switch (docStatus) {
      case documentPending:
        statusColor = getCurrentTheme(context).colorReferralPending;
        status = languages.pending;
        break;
      case documentApprove:
        statusColor = getCurrentTheme(context).colorReferralClaimed;
        status = languages.approved;
        break;
      case documentRejected:
        statusColor = getCurrentTheme(context).colorReferralRejected;
        status = languages.rejected;
        break;
      case documentExpire:
        statusColor = getCurrentTheme(context).colorReferralRejected;
        status = languages.expired;
        break;
      case documentNotUpdate:
        statusColor = getCurrentTheme(context).colorReferralRejected;
        status = languages.noDocument;
        break;
    }
    return Container(
      padding: EdgeInsetsDirectional.only(start: 7.w, end: 7.w, top: 3.h, bottom: 3.h),
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
