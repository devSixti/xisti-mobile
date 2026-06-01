import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../appThemeManager/app_theme_colors.dart';
import '../../../constant/dimensions.dart';

class RequireDocumentShimmer extends StatelessWidget {
  final bool enabled;

  const RequireDocumentShimmer({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: enabled,
        period: const Duration(milliseconds: 800),
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsetsDirectional.only(top: 10.h, bottom: 80.h),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 15.h, bottom: 15.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80.sp,
                    height: 80.sp,
                    decoration: BoxDecoration(color: getCurrentTheme(context).colorWhite, borderRadius: BorderRadius.circular(30.r)),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(margin: EdgeInsetsDirectional.only(bottom: 5.h), width: 100.w, height: 15.h, color: getCurrentTheme(context).colorWhite),
                        Container(margin: EdgeInsetsDirectional.only(bottom: 5.h), width: 140.w, height: 15.h, color: getCurrentTheme(context).colorWhite),
                        Container(
                          margin: EdgeInsetsDirectional.only(bottom: 5.h),
                          decoration: BoxDecoration(color: getCurrentTheme(context).colorWhite, borderRadius: BorderRadius.circular(30.r)),
                          width: 87.w,
                          height: 30.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 80.w,
                    height: 35.h,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r), color: getCurrentTheme(context).colorWhite),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Container(height: 1.h, width: double.infinity, color: getCurrentTheme(context).colorBorder);
          },
          itemCount: 5,
        ),
      ),
    );
  }
}
