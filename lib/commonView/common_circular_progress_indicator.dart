import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../appThemeManager/app_theme_colors.dart';

class CommonCircularProgressIndicator extends StatelessWidget {
  final double? strokeWidth;
  final double? size;
  final Color? color;
  final double? value;

  const CommonCircularProgressIndicator({super.key, this.strokeWidth, this.size, this.color, this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 18.sp,
      width: size ?? 18.sp,
      child: Center(
        child: SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth ?? 1.8.sp,
            value: value,
            valueColor: AlwaysStoppedAnimation<Color>(color ?? getCurrentTheme(context).colorPrimary),
          ),
        ),
      ),
    );
  }
}
