import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';

/*button size*/
final commonBtnHeight55h = 55.h;
final commonBtnHeight50h = 50.h;
final commonBtnHeight45h = 45.h;
final commonBtnHeight35h = 35.h;
final commonBtnHeight30h = 30.h;
final commonBtnHeight25h = 25.h;

//button height
double commonBtnWidth50w = 50.w;
double commonBtnWidth80w = 80.w;
double commonBtnWidth100w = 100.w;
double commonBtnWidth150w = 150.w;
double commonBtnWidth200w = 200.w;
double commonBtnWidth250w = 250.w;
double commonBtnWidth300w = 300.w;

final commonHorizontalPadding = 16.w;
final commonVerticalPadding = 16.h;

/// Accessible touch targets for rural / 60+ UX (plan categorías LATAM).
final accessibleMinTouch = 56.h;
final accessibleTitleSize = 18.sp;
final accessibleActionButtonHeight = 60.h;

//textSize
double textSize32px = 32.sp;
double textSize28px = 28.sp;
double textSize24px = 24.sp;
double textSize22px = 22.sp;
double textSize20px = 20.sp;
double textSize18px = 18.sp;
double textSize16px = 16.sp;
double textSize14px = 14.sp;
double textSize13px = 13.sp;
double textSize12px = 12.sp;
double textSize10px = 10.sp;

//  cpi stroke width
double cpiStrokeWidthRegular = 2.5.sp;
double cpiStrokeWidthSmall = 1.8.sp;
double cpiStrokeWidthSmallest = 1.3.sp;

//  cpi size
double cpiSizeSmallest = 13.sp;
double cpiSizeSmall = 18.sp;
double cpiSizeRegular = 21.sp;
double cpiSizeMediumBig = 24.sp;

//Common Bottom Sheet
BorderRadiusDirectional bottomSheetBorderRadius30r = BorderRadiusDirectional.only(topStart: Radius.circular(30.r), topEnd: Radius.circular(30.r));
EdgeInsets bottomSheetPadding = EdgeInsets.only(left: commonHorizontalPadding, right: commonHorizontalPadding, top: 30.h, bottom: getBottomMargin());
