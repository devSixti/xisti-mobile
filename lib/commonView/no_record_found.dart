import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';

class NoRecordFound extends StatelessWidget {
  final String? image;
  final String? message;
  final String? title;
  final double? size;
  final Widget? widget;

  const NoRecordFound({super.key, this.image, this.message, this.size, this.widget, this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
          Image.asset((image ?? "").isNotEmpty ?  setImagesBasedOnTheme(context, image ?? "") : setImagesBasedOnTheme(context, "empty_ride_history.png"), width: size ?? 250.sp, height: size ?? 250.sp),
          ?widget,
          if (message != null)
            Padding(
              padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 5.h),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style: bodyText(context: context, textColor: getCurrentTheme(context).colorTextCommon, fontWeight: FontWeight.w600, fontSize: textSize18px),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
