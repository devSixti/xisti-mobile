import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../main.dart';
import '../utils/utils.dart';

class WarningBottomSheet extends StatefulWidget {
  const WarningBottomSheet({super.key});

  @override
  State<WarningBottomSheet> createState() => _WarningBottomSheetState();
}

class _WarningBottomSheetState extends State<WarningBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(child: Container()),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.95),
            decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
            padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(top: 25.h, bottom: 20.h),
                          child: Text(
                            languages.securityWarningTitle,
                            textAlign: TextAlign.start,
                            style: bodyText(
                              context: context,
                              fontSize: textSize24px,
                              fontWeight: FontWeight.w600,
                              textColor: getCurrentTheme(context).colorSosBg,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                      ),
                    ],
                  ),
                  Image.asset(setImagesBasedOnTheme(context, 'warning.png'), height: 210.h, fit: BoxFit.fitHeight),
                  SizedBox(height: 20.h),
                  Text(
                    languages.securityWarningOfficial,
                    textAlign: TextAlign.start,
                    style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize18px),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    languages.securityWarningBody,
                    textAlign: TextAlign.start,
                    style: bodyText(context: context, fontSize: textSize14px),
                  ),
                  SizedBox(height: 30.h),
                  CustomRoundedButton(context, languages.understood, () => Navigator.pop(context), margin: EdgeInsetsDirectional.only(bottom: getBottomMargin())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
