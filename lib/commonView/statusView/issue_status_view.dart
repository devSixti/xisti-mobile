import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';

class IssueStatus {
  static const int unresolved = 1;
  static const int resolved = 2;
}

class IssueStatusView extends StatelessWidget {
  final int issueStatus;

  const IssueStatusView({super.key, required this.issueStatus});

  @override
  Widget build(BuildContext context) {
    Color statusColor = getCurrentTheme(context).colorStatusCompleted;
    String status = "";

    switch (issueStatus) {
      case IssueStatus.unresolved:
        statusColor = getCurrentTheme(context).colorIssueUnResolved;
        status = languages.unResolved;
        break;
      case IssueStatus.resolved:
        statusColor = getCurrentTheme(context).colorIssueResolved;
        status = languages.resolved;
        break;

      default:
        statusColor = getCurrentTheme(context).colorIssueUnResolved;
        status = languages.unResolved;
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
