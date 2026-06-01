import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../appThemeManager/app_theme_colors.dart';
import '../../../utils/custom_icons.dart';

class FeedbackShimmer extends StatelessWidget {
  const FeedbackShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: getCurrentTheme(context).colorShimmerBg,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      period: const Duration(milliseconds: 800),
      child: ListView.separated(
        itemCount: 6,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsetsDirectional.symmetric(vertical: 15.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 70.sp,
                      width: 70.sp,
                      decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack, borderRadius: BorderRadiusDirectional.circular(15.r)),
                    ),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 17.sp, width: 140.sp, decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack)),
                          Container(
                            margin: EdgeInsetsDirectional.only(top: 5.h),
                            height: 17.sp,
                            width: 140.sp,
                            decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(top: 5.h),
                            child: Row(
                              children: [
                                Icon(CustomIcons.rating, color: getCurrentTheme(context).colorRating, size: 20.sp),
                                Container(height: 16.h, width: 50.w, decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack)),
                                Container(
                                  margin: EdgeInsetsDirectional.only(start: 8.w),
                                  height: 4.sp,
                                  width: 4.sp,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: getCurrentTheme(context).colorIconCommon),
                                ),
                                Container(
                                  margin: EdgeInsetsDirectional.only(start: 8.w),
                                  height: 16.h,
                                  width: 50.w,
                                  decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      height: 30.h,
                      width: 80.w,
                      decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack, borderRadius: BorderRadiusDirectional.circular(15.r)),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(top: 10.h),
                  height: 16.h,
                  width: double.maxFinite,
                  decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack),
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(top: 10.h),
                  height: 16.h,
                  width: double.maxFinite,
                  decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(color: getCurrentTheme(context).colorManageAddressDivider);
        },
      ),
    );
  }
}
