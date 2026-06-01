import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import 'on_boarding_pages_dl.dart';

class ItemOnBoardingPages extends StatelessWidget {
  final OnBoardingPojo data;

  const ItemOnBoardingPages({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(padding: EdgeInsets.only(right: 5.w, left: 5.w), child: Image.asset(data.image, width: double.maxFinite, fit: BoxFit.fitWidth)),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 50.h),
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: headerText(context:context,fontWeight: FontWeight.w600, fontSize: textSize24px, textColor: getCurrentTheme(context).colorTextCommon),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 20.h),
            child: Text(
              data.msg,
              textAlign: TextAlign.center,
              style: bodyText(context:context,fontSize: textSize16px, textColor: getCurrentTheme(context).colorTextCommon, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
