// internet_connection_loss

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../constant/dimensions.dart';
import '../main.dart';
import '../utils/custom_icons.dart';
import '../utils/style_util.dart';

bool isServerErrorDialogOpen = false;

class ServerErrorSheet extends StatelessWidget {
  final bool isShowMapSessionMsg;

  const ServerErrorSheet({super.key, this.isShowMapSessionMsg = false});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
              child: Padding(
                padding: bottomSheetPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isShowMapSessionMsg ? languages.usageLimitReached : languages.serverError,
                            style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize24px),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 20.h, bottom: 20.h),
                      child: SvgPicture.asset(
                        "assets/svgs/server_error.svg",
                        fit: BoxFit.contain,
                        height: 100.h,
                        colorFilter: ColorFilter.mode(getCurrentTheme(navigatorKey.currentContext!).colorPrimary, BlendMode.srcIn),
                      ),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(top: 10.h),
                      child: Text(
                        isShowMapSessionMsg ? languages.googleMapsLimitMessage : languages.serverErrorMessage,
                        textAlign: TextAlign.center,
                        style: bodyText(context: context, fontWeight: FontWeight.w500),
                      ),
                    ),
                    CustomRoundedButton(context, languages.ok, () async {
                      Navigator.pop(context);
                    }, margin: EdgeInsetsDirectional.only(top: 20.h)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showServerErrorDialog(BuildContext context, {bool isShowMapSessionMsg = false}) {
  if (!isServerErrorDialogOpen) {
    isServerErrorDialogOpen = true;
    showModalBottomSheet(
      enableDrag: false,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ServerErrorSheet(isShowMapSessionMsg: isShowMapSessionMsg);
      },
    ).then((value) => isServerErrorDialogOpen = false);
  } else {
    return;
  }
}
