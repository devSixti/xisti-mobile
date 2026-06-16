import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Visual tokens for the Xisti multiservice home (distinct from Zimo bottom-panel layout).
abstract final class XistiHomeUiTokens {
  static const double brandGreen = 0xFF39FF14;
  static const double brandPurple = 0xFF9333EA;

  static double get searchCardRadius => 20.r;
  static double get chipRadius => 24.r;
  static double get sheetRadius => 24.r;
  static double get floatingElevation => 8;
  static double get searchCardTopInset => 12.h;
  static double get overlayHorizontalPadding => 16.w;

  static double sheetInitialSize(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return h < 700 ? 0.26 : 0.22;
  }

  static double sheetMinSize(BuildContext context) => 0.16;

  static double sheetMaxSize(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return h < 700 ? 0.78 : 0.72;
  }

  static List<BoxShadow> floatingShadow(BuildContext context, Color borderColor) => [
        BoxShadow(
          color: borderColor.withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
}
