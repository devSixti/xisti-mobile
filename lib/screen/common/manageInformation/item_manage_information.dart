import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../account/account_dl.dart';

class ItemManageInformation extends StatelessWidget {
  final ManageInformationItem accountItem;

  const ItemManageInformation({super.key, required this.accountItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          SizedBox(
            height: 40.sp,
            child: Icon(accountItem.icon, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
          ),
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
          accountItem.status
              ? Padding(
                  padding: EdgeInsetsDirectional.only(start: 8.w, end: 8.w),
                  child: Icon(Icons.verified, color: getCurrentTheme(context).colorGreen, size: 20.sp),
                )
              : Container(),
          Transform(
            alignment: AlignmentDirectional.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: Icon(CustomIcons.arrowForward, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
          ),
        ],
      ),
    );
  }
}
