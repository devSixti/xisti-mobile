import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../utils/utils.dart';

class WalletTransactionShimmer extends StatelessWidget {
  final bool enabled;

  const WalletTransactionShimmer({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: enabled,
        child: ListView.separated(
          itemCount: 10,
          padding: EdgeInsetsDirectional.only(top: 10.h, bottom: 50.h),
          separatorBuilder: (context, index) {
            return Divider(height: 40.h, color: getCurrentTheme(context).colorDivider, thickness: 1.sp);
          },
          itemBuilder: (context, index) {
            return Row(
              spacing: 10.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 28.sp, width: 28.sp, color: getCurrentTheme(context).colorBlack),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 22.sp, width: 200.sp, color: getCurrentTheme(context).colorBlack),
                      SizedBox(height: 10.h),
                      Container(height: 17.sp, width: 150.sp, color: getCurrentTheme(context).colorBlack),
                    ],
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(height: 22.sp, width: 80.sp, color: getCurrentTheme(context).colorBlack),
                      SizedBox(height: 10.h),
                      Container(height: 20.sp, width: 60.sp, color: getCurrentTheme(context).colorBlack),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
