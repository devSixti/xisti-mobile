import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';

/// Small section heading used above chips and field groups.
class XistiSectionLabel extends StatelessWidget {
  final String label;
  final Color accent;

  const XistiSectionLabel({
    super.key,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: commonHorizontalPadding,
        end: commonHorizontalPadding,
        bottom: 8.h,
      ),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: bodyText(
              context: context,
              fontSize: textSize12px,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
