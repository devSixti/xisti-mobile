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
    final imagePath = (image ?? '').isNotEmpty ? image! : 'empty_ride_history.png';
    final illustrationHeight = size ?? 250.h;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: commonHorizontalPadding,
                end: commonHorizontalPadding,
              ),
              child: Image.asset(
                setImagesBasedOnTheme(context, imagePath),
                width: double.infinity,
                height: illustrationHeight,
                fit: BoxFit.fitHeight,
              ),
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
