import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../utils/utils.dart';
import 'xisti_brand_placeholder.dart';

class NoRecordFound extends StatelessWidget {
  final String? image;
  final String? message;
  final String? title;
  final double? size;
  final Widget? widget;

  const NoRecordFound({super.key, this.image, this.message, this.size, this.widget, this.title});

  @override
  Widget build(BuildContext context) {
    final dimension = size ?? 200.sp;
    final useBrandPlaceholder = (image ?? '').isEmpty || (image ?? '').contains('empty_ride_history');

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (useBrandPlaceholder)
              xistiDocumentEmptyIllustration(context, size: dimension / 1.sp)
            else
              Image.asset(
                setImagesBasedOnTheme(context, image ?? 'empty_ride_history.png'),
                width: dimension,
                height: dimension,
                color: AppThemeColors.brandGreen.withValues(alpha: 0.92),
                colorBlendMode: BlendMode.srcIn,
              ),
            ?widget,
            if (title != null)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: commonHorizontalPadding,
                  end: commonHorizontalPadding,
                  top: 12.h,
                ),
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: bodyText(
                    context: context,
                    textColor: getCurrentTheme(context).colorTextCommon,
                    fontWeight: FontWeight.w700,
                    fontSize: textSize18px,
                  ),
                ),
              ),
            if (message != null)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: commonHorizontalPadding,
                  end: commonHorizontalPadding,
                  top: title != null ? 6.h : 12.h,
                ),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: bodyText(
                    context: context,
                    textColor: getCurrentTheme(context).colorTextLight,
                    fontWeight: FontWeight.w500,
                    fontSize: textSize14px,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
