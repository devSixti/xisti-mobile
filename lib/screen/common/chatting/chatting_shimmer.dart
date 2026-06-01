import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../appThemeManager/app_theme_colors.dart';

class ChattingShimmer extends StatelessWidget {
  final bool enabled;

  const ChattingShimmer({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: enabled,
        period: const Duration(milliseconds: 800),
        child: ListView(
          children:
              List.generate(20, (index) => index)
                  .map(
                    (e) =>
                        (e % 2 == 0)
                            ? Container(
                              alignment: AlignmentDirectional.centerEnd,
                              margin: EdgeInsetsDirectional.only(top: 10.h, end: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.h, bottom: 10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadiusDirectional.only(
                                        topStart: Radius.circular(8.sp),
                                        topEnd: Radius.circular(8.sp),
                                        bottomStart: Radius.circular(8.sp),
                                        bottomEnd: Radius.zero,
                                      ),
                                      color: const Color(0xffFDEDED),
                                    ),
                                    child: SizedBox(width: 200.sp, height: 20.sp),
                                  ),
                                  Container(margin: EdgeInsetsDirectional.only(top: 10.h), width: 130.sp, color: Colors.black, height: 14.sp),
                                ],
                              ),
                            )
                            : Container(
                              alignment: AlignmentDirectional.centerStart,
                              margin: EdgeInsetsDirectional.only(top: 10.h, start: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.h, bottom: 10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadiusDirectional.only(
                                        topStart: Radius.circular(8.sp),
                                        topEnd: Radius.circular(8.sp),
                                        bottomStart: Radius.zero,
                                        bottomEnd: Radius.circular(8.sp),
                                      ),
                                      color: const Color(0xffF5F5F5),
                                    ),
                                    child: SizedBox(width: 200.sp, height: 20.h),
                                  ),
                                  Container(margin: EdgeInsetsDirectional.only(top: 10.h), width: 130.sp, color: Colors.black, height: 14.sp),
                                ],
                              ),
                            ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
