import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';
import 'common_circular_progress_indicator.dart';

class FullScreenProgress extends StatelessWidget {
  final String message;

  const FullScreenProgress({super.key, this.message = ""});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        color: Colors.black54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonCircularProgressIndicator(
              strokeWidth: cpiStrokeWidthRegular,
              size: cpiSizeRegular,
              color: getCurrentTheme(context).colorBlack,
            ),
            Container(
              margin: EdgeInsetsDirectional.only(top: 10.sp),
              child: Text(message, maxLines: 1, textAlign: TextAlign.center, style: bodyText(context: context)),
            ),
          ],
        ),
      ),
    );
  }
}
