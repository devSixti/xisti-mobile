import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_xisti/commonView/common_view.dart';
import 'package:permission_handler/permission_handler.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/custom_switch.dart';
import '../utils/utils.dart';

class OverlayPermissionBottomSheet extends StatefulWidget {
  const OverlayPermissionBottomSheet({super.key});

  @override
  State<OverlayPermissionBottomSheet> createState() => _OverlayPermissionBottomSheetState();
}

class _OverlayPermissionBottomSheetState extends State<OverlayPermissionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Container(
          width: ScreenUtil().screenWidth,
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 25.h),
          decoration: BoxDecoration(borderRadius: bottomSheetBorderRadius30r, color: getCurrentTheme(context).colorWhite),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languages.permissionText1(languages.appName),
                style: bodyText(context: context, textColor: getCurrentTheme(context).colorTextCommon, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                child: Text(
                  languages.permissionText2(languages.appName),
                  style: bodyText(context: context, textColor: getCurrentTheme(context).colorTextCommon, fontSize: textSize14px, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10.sp,
                      height: 10.sp,
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(color: getCurrentTheme(context).colorPrimary, shape: BoxShape.circle),
                    ),
                    Flexible(
                      child: Text(
                        languages.permissionText3,
                        textAlign: TextAlign.start,
                        style: bodyText(
                          context: context,
                          textColor: getCurrentTheme(context).colorTextCommon,
                          fontSize: textSize14px,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10.sp,
                      height: 10.sp,
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(color: getCurrentTheme(context).colorPrimary, shape: BoxShape.circle),
                    ),
                    Flexible(
                      child: Text(
                        languages.permissionText4,
                        textAlign: TextAlign.start,
                        style: bodyText(
                          context: context,
                          textColor: getCurrentTheme(context).colorTextCommon,
                          fontSize: textSize14px,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 35.sp,
                      height: 35.sp,
                      margin: EdgeInsets.only(right: 8.w),
                      child: Image.asset('assets/images/app_icon.png', fit: BoxFit.contain),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        languages.quickAccessIcon,
                        textAlign: TextAlign.start,
                        style: bodyText(
                          context: context,
                          textColor: getCurrentTheme(context).colorTextCommon,
                          fontSize: textSize14px,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    CustomSwitch(
                      width: 40.w,
                      radius: 30.r,
                      activeColor: getCurrentTheme(context).colorPrimary,
                      disableColor: getCurrentTheme(context).colorBorder,
                      thumbColor: getCurrentTheme(context).colorWhite,
                      innerPadding: EdgeInsets.all(3.5.sp),
                      thumbSize: 18.sp,
                      value: true,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
              CustomRoundedButton(context, languages.settingsPermission, () async {
                await _requestPermissions();
                if (!context.mounted) return;
                Navigator.pop(context);
              }, margin: EdgeInsetsDirectional.only(bottom: getBottomMargin())),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    await Permission.systemAlertWindow.request();
  }
}
