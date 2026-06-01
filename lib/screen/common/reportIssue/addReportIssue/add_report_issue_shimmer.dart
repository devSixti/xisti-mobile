import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/utils.dart';

class AddReportIssueShimmer extends StatelessWidget {
  final bool enabled;

  const AddReportIssueShimmer({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: enabled,
        period: const Duration(milliseconds: 800),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 20.h, bottom: 10.h),
                    child: Column(
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: 55.h,
                          decoration: BoxDecoration(color: getCurrentTheme(context).colorWhite, borderRadius: BorderRadius.circular(20.r)),
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          width: double.maxFinite,
                          height: 55.h,
                          decoration: BoxDecoration(color: getCurrentTheme(context).colorWhite, borderRadius: BorderRadius.circular(20.r)),
                        ),
                        SizedBox(height: 20.h),
                        GridView.builder(
                          itemCount: 6,
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 20.sp, mainAxisSpacing: 15.sp),
                          itemBuilder: (context, index) {
                            return Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: getCurrentTheme(context).colorScaffoldBg),
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin()),
                alignment: Alignment.bottomCenter,
                width: double.maxFinite,
                height: commonBtnHeight50h,
                decoration: BoxDecoration(color: getCurrentTheme(context).colorWhite, borderRadius: BorderRadius.circular(20.r)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
