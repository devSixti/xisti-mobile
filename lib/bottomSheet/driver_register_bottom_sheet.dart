import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../utils/utils.dart';

class DriverRegisterBottomSheet extends StatefulWidget {
  final Function() onProceed;

  const DriverRegisterBottomSheet({super.key, required this.onProceed});

  @override
  State<DriverRegisterBottomSheet> createState() => _DriverRegisterBottomSheetState();
}

class _DriverRegisterBottomSheetState extends State<DriverRegisterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(child: Container()),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
            padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 25.h, bottom: 20.h),
                        child: Text(
                          languages.fillYourInformation,
                          textAlign: TextAlign.start,
                          style: bodyText(context: context, fontSize: textSize24px, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                    ),
                  ],
                ),
                Text(languages.driverRegisterMsg(languages.appName), style: bodyText(context: context, fontWeight: FontWeight.w500)),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomRoundedButton(
                          context,
                          languages.close,
                          () {
                            Navigator.pop(context);
                          },
                          setBorder: true,
                          minWidth: double.maxFinite,
                          margin: EdgeInsetsDirectional.only(top: 20.h, bottom: getBottomMargin()),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: CustomRoundedButton(
                          context,
                          languages.proceed,
                          () async {
                            widget.onProceed.call();
                          },
                          minWidth: double.maxFinite,
                          margin: EdgeInsetsDirectional.only(top: 20.h, bottom: getBottomMargin()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
