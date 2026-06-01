import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';

class RideDetailItem extends StatelessWidget {
  final IconData iconData;
  final String titleText, mainText;

  const RideDetailItem({super.key, required this.iconData, required this.titleText, required this.mainText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 15.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titleText, style: bodyText(context: context, fontSize: textSize14px, textColor: getCurrentTheme(context).colorTextLight)),
                Text(mainText, style: bodyText(context: context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
