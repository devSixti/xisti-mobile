import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../appThemeManager/app_theme_colors.dart';
import '../../../commonView/child_size_notifier.dart';
import '../../../commonView/dash_line_view.dart';
import '../../../constant/dimensions.dart';
import '../../../utils/custom_icons.dart';

class DriverNewRequestShimmer extends StatelessWidget {
  const DriverNewRequestShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        period: const Duration(milliseconds: 800),
        child: Container(
          alignment: AlignmentDirectional.topStart,
          margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              addressDetail(),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70.sp,
                    width: 70.sp,
                    decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack, borderRadius: BorderRadius.circular(15.r)),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 20.sp, width: 110.sp, color: getCurrentTheme(context).colorBlack),
                        SizedBox(height: 10.h),
                        Container(height: 17.sp, width: 50.sp, color: getCurrentTheme(context).colorBlack),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addressDetail() {
    return ChildSizeNotifier(
      builder: (context, size, child) {
        return Container(
          padding: EdgeInsetsDirectional.only(bottom: 20.h),
          child: Stack(
            children: [
              Container(
                alignment: AlignmentDirectional.topStart,
                margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 11.w),
                child: DashLineView(
                  dashColor: getCurrentTheme(context).colorBorder,
                  // totalHeight: addressList.length <= 2 ? size.height / 3 : size.height / 2.1,
                  totalHeight: size.height / 3,
                  dashHeight: 5.h,
                  dashWidth: 1.5.w,
                  emptyHeight: 4.h,
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                padding: EdgeInsetsDirectional.zero,
                separatorBuilder: (context, index) {
                  return Container(height: 15.h);
                },
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.all(2.sp),
                        margin: EdgeInsetsDirectional.only(end: 10.w),
                        child: Icon(
                          index == 0 ? CustomIcons.pickupLocation : CustomIcons.dropLocation,
                          size: 20.sp,
                          color: getCurrentTheme(context).colorIconCommon,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: double.infinity, height: 15.h, color: getCurrentTheme(context).colorBlack),
                            SizedBox(height: 5.h),
                            Container(width: 100.w, height: 15.h, color: getCurrentTheme(context).colorBlack),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
