import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/utils.dart';

class ReportIssueHomeShimmer extends StatelessWidget {
  final bool enabled;

  const ReportIssueHomeShimmer({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return _reportIssueHomeShimmer(context);
  }

  Widget _reportIssueHomeShimmer(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: enabled,
        child: Container(
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(languages.faq, style: bodyText(context: context, fontSize: textSize22px, fontWeight: FontWeight.w600)),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsetsDirectional.only(top: 15.h, bottom: 25.h),
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Container(color: getCurrentTheme(context).colorBlack, height: 35.h)),
                        Icon(CustomIcons.arrowDown, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsetsDirectional.only(top: 15.h, bottom: 15.h),
                      child: Divider(color: getCurrentTheme(context).colorBlack, thickness: 1.h, height: 0),
                    );
                  },
                  itemCount: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
