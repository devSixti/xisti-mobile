import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../appThemeManager/app_theme_colors.dart';
import '../../../constant/dimensions.dart';

class BankDetailsShimmer extends StatelessWidget {
  const BankDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: getCurrentTheme(context).colorShimmerBg,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      period: const Duration(milliseconds: 800),
      child: ListView.separated(
        itemCount: 6,
        padding: EdgeInsetsDirectional.only(top: 30.sp, start: commonHorizontalPadding, end: commonHorizontalPadding),
        separatorBuilder: (context, index) {
          return SizedBox(height: 20.sp);
        },
        itemBuilder: (context, index) {
          return Container(
            height: 50.sp,
            decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack, borderRadius: BorderRadiusDirectional.circular(15.sp)),
          );
        },
      ),
    );
  }
}
