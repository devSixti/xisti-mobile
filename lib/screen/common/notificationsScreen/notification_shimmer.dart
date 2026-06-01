import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../appThemeManager/app_theme_colors.dart';
import '../../../constant/dimensions.dart';
import '../../../utils/custom_icons.dart';

class NotificationShimmer extends StatelessWidget {
  final bool enabled;

  const NotificationShimmer({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: enabled,
        child: ListView.separated(
          padding: EdgeInsetsDirectional.only(top: 15.h, bottom: 25.h),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 10.w),
                    child: Icon(CustomIcons.notification, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(height: 15.h, color: getCurrentTheme(context).colorBlack, margin: EdgeInsetsDirectional.only(bottom: 10.h)),
                        Container(height: 15.h, color: getCurrentTheme(context).colorBlack, margin: EdgeInsetsDirectional.only(bottom: 10.h, end: 70.w)),
                        Container(height: 15.h, color: getCurrentTheme(context).colorBlack, margin: EdgeInsetsDirectional.only(end: 100.w)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsetsDirectional.only(top: 15.h, bottom: 15.h),
              child: Divider(color: getCurrentTheme(context).colorBlack, thickness: 1.h, height: 0),
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }
}
