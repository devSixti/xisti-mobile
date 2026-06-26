import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_xisti/commonView/scaffold_with_safe_area.dart';
import 'package:url_launcher/url_launcher.dart';

import '../commonView/custom_rounded_button.dart';
import '../main.dart';
import '../utils/utils.dart';

class ProductBottomSheet extends StatefulWidget {
  const ProductBottomSheet({super.key});

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(top: 25.h, bottom: 20.h),
                          child: Text(
                            'XISTI',
                            textAlign: TextAlign.start,
                            style: bodyText(context: context, fontSize: textSize24px, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                      ),
                    ],
                  ),
                  Image.asset('assets/images/xisti/logo.png', height: 120.h, fit: BoxFit.contain),
                  SizedBox(height: 20.h),
                  Text(
                    languages.demoProductSubtitle,
                    textAlign: TextAlign.start,
                    style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    languages.demoProductBody,
                    textAlign: TextAlign.start,
                    style: bodyText(context: context, fontSize: textSize14px),
                  ),
                  SizedBox(height: 30.h),
                  CustomRoundedButton(context, languages.continueTxt, () => Navigator.pop(context)),
                  CustomRoundedButton(
                    context,
                    languages.demoProductSupport,
                    () {
                      openUrl('mailto:soporte@xistiapp.com', launchMode: LaunchMode.externalApplication);
                    },
                    setBorder: true,
                    margin: EdgeInsetsDirectional.only(top: 15.h, bottom: getBottomMargin()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
