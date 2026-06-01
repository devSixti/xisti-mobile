import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/utils.dart';

class ManageAddressShimmer extends StatelessWidget {
  final bool enabled;

  const ManageAddressShimmer({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: enabled,
        period: const Duration(milliseconds: 800),
        child: ListView.builder(
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 10.h),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(margin: EdgeInsetsDirectional.only(bottom: 15.h), color: getCurrentTheme(context).colorWhite, width: 80.w, height: 20.h),
                ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 20.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(color: getCurrentTheme(context).colorWhite, borderRadius: BorderRadius.circular(20.r)),
                            width: 40.sp,
                            height: 40.sp,
                            margin: EdgeInsetsDirectional.only(end: 10.w),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(width: double.maxFinite, height: 15.h, color: getCurrentTheme(context).colorWhite),
                                SizedBox(height: 5.h),
                                Container(
                                  width: double.maxFinite,
                                  height: 15.h,
                                  margin: EdgeInsetsDirectional.only(end: 50.w),
                                  color: getCurrentTheme(context).colorWhite,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Icon(CustomIcons.delete, color: getCurrentTheme(context).colorWhite, size: 20.sp),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
