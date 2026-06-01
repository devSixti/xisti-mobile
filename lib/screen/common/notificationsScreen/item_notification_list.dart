import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

import '../../../appThemeManager/app_theme_colors.dart';
import '../../../constant/dimensions.dart';
import '../../../main.dart';
import '../../../utils/custom_icons.dart';
import '../../../utils/style_util.dart';
import '../../../utils/time_util.dart';
import 'notifications_dl.dart';

class ItemNotificationList extends StatelessWidget {
  final MassNotificationItem massNotificationItem;

  const ItemNotificationList({super.key, required this.massNotificationItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(top: 2.5.h),
          child: Icon(CustomIcons.notification, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
        ),
        SizedBox(width: 10.w),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if ((massNotificationItem.title).trim().isNotEmpty)
                Text(
                  massNotificationItem.title,
                  textAlign: TextAlign.start,
                  style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600),
                ),
              if ((massNotificationItem.title).trim().isNotEmpty) SizedBox(height: 10.h),
              // Flexible(child: Text(massNotificationItem.message, textAlign: TextAlign.start, style: bodyText(context: context))),
              ReadMoreText(
                massNotificationItem.message,
                trimLines: 2,
                style: bodyText(context: context),
                trimMode: TrimMode.Line,
                trimCollapsedText: languages.showMore,
                trimExpandedText: languages.showLess,
                lessStyle: bodyText(context: context, fontWeight: FontWeight.w600),
                moreStyle: bodyText(context: context, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5.h),
              Text(
                timeAgo(getTimeAndDateObj(massNotificationItem.datetime)),
                textAlign: TextAlign.start,
                style: bodyText(context: context, textColor: getCurrentTheme(context).colorTimeAgo),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
