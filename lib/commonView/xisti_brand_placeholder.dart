import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../utils/custom_icons.dart';
import '../utils/utils.dart';

Widget xistiProfilePlaceholder(
  BuildContext context, {
  required double size,
  BorderRadius? borderRadius,
}) {
  final radius = borderRadius ?? BorderRadius.circular(12.r);
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: AppThemeColors.brandPurple.withValues(alpha: 0.18),
      borderRadius: radius,
      border: Border.all(color: AppThemeColors.brandGreen.withValues(alpha: 0.55), width: 1.2.w),
    ),
    child: Icon(
      CustomIcons.manageAccount,
      size: size * 0.48,
      color: AppThemeColors.brandGreen,
    ),
  );
}

Widget xistiDocumentEmptyIllustration(BuildContext context, {double size = 180}) {
  final dimension = size.sp;
  return Container(
    width: dimension,
    height: dimension,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppThemeColors.brandPurple.withValues(alpha: 0.16),
      border: Border.all(color: AppThemeColors.brandGreen.withValues(alpha: 0.45), width: 2.w),
    ),
    child: Icon(
      CustomIcons.description,
      size: dimension * 0.42,
      color: AppThemeColors.brandGreen,
    ),
  );
}

bool isXistiAvatarAsset(String? assetPath) {
  return (assetPath ?? '').contains('avatar.png');
}
