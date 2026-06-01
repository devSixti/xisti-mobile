import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/utils.dart';

class SelectLanguageAndCurrencyShimmer extends StatelessWidget {
  final bool enabled;

  const SelectLanguageAndCurrencyShimmer({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: enabled,
        period: const Duration(milliseconds: 800),
        child: Wrap(
          spacing: 10.w,
          children: [1, 2, 3, 4, 5,6,7,8]
              .map(
                (s) => Container(
                  height: 44.sp,
                  margin: EdgeInsetsDirectional.only(top: 15.h),
                  width: s % 2 == 0 ? 100.sp : 80.sp,
                  decoration: BoxDecoration(
                    color: getCurrentTheme(context).colorWhite,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
