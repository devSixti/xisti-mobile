import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import 'account_dl.dart';

class ItemAccount extends StatelessWidget {
  final AccountItem accountItem;

  const ItemAccount({super.key, required this.accountItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      constraints: BoxConstraints(minHeight: 40.h),
      child: Row(
        children: [
          Icon(accountItem.icon, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 10.w),
              child: Text(
                accountItem.name,
                textAlign: TextAlign.start,
                style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize18px),
              ),
            ),
          ),
          Transform(
            alignment: AlignmentDirectional.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: Icon(CustomIcons.arrowForward, size: 18.sp, color: getCurrentTheme(context).colorIconCommon),
          ),
        ],
      ),
    );
  }
}
