import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonView/load_image_with_placeholder.dart';
import '../../../../commonView/statusView/issue_status_view.dart';
import '../../../../utils/utils.dart';
import 'reported_issue_history_dl.dart';

class ItemIssueHistory extends StatelessWidget {
  final ReportIssueHistory reportIssueHistory;

  const ItemIssueHistory({super.key, required this.reportIssueHistory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Date
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
              Expanded(
                child: Text(
                  getDateTime(reportIssueHistory.reportIssueDateTime, returnFormat: "dd MMM, yyyy hh:mm aa"),
                  maxLines: 1,
                  style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70.sp,
              height: 70.sp,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5.sp, color: getCurrentTheme(context).colorDarkBorder),
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsetsDirectional.only(start: 5.w, end: 5.w, top: 5.w, bottom: 5.w),
              child: LoadImageWithPlaceHolder(
                width: double.maxFinite,
                height: double.maxFinite,
                image: reportIssueHistory.categoryIcon,
                imageFit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    reportIssueHistory.categoryName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: bodyText(context: context, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5.h),
                  if (reportIssueHistory.rideNo != 0)
                    Text(
                      "${reportIssueHistory.rideNo != 0 ? reportIssueHistory.rideNo : "-"}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyText(context: context, fontSize: textSize14px),
                    ),
                ],
              ),
            ),
            SizedBox(width: 5.w),
            IssueStatusView(issueStatus: reportIssueHistory.status),
          ],
        ),
        SizedBox(height: 15.h),

        RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: bodyText(context: context),
            children: [
              TextSpan(text: "${languages.ticketId} : ", style: bodyText(context: context, fontWeight: FontWeight.w600)),
              TextSpan(text: "#${reportIssueHistory.referenceNo}", style: bodyText(context: context)),
            ],
          ),
        ),
      ],
    );
  }
}
