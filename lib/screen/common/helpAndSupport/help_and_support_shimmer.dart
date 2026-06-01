import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/utils.dart';

class HelpAndSupportShimmer extends StatelessWidget {
  final bool enabled;

  const HelpAndSupportShimmer({super.key, this.enabled = true});

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
          separatorBuilder: (context, index) {
            return Padding(padding: EdgeInsets.symmetric(vertical: 20.h));
          },
          shrinkWrap: true,
          padding: EdgeInsetsDirectional.only(top: 10.h, bottom: 10.h),
          itemCount: 5,
          itemBuilder: (BuildContext context, position) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsetsDirectional.only(end: (position % 2 == 0) ? 120.sp : 40.sp, start: 20.w),
                    height: 20.h,
                    width: double.infinity,
                    color: Colors.black,
                  ),
                ),
                Transform(
                  alignment: AlignmentDirectional.center,
                  transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
                  child: Icon(CustomIcons.arrowForward, size: 19.sp, color: getCurrentTheme(context).colorIconCommon),
                ),
                SizedBox(width: 20.h),
              ],
            );
          },
        ),
      ),
    );
  }
}
