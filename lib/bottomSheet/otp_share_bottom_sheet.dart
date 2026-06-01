import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../utils/utils.dart';

class OtpShareBottomSheet extends StatefulWidget {
  final String otp;

  const OtpShareBottomSheet({super.key, required this.otp});

  @override
  State<OtpShareBottomSheet> createState() => _OtpShareBottomSheetState();
}

class _OtpShareBottomSheetState extends State<OtpShareBottomSheet> {
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
                          languages.shareOTP,
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
                Text(widget.otp, textAlign: TextAlign.center, style: bodyText(context: context, fontSize: 40.sp, fontWeight: FontWeight.w600)),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: CustomRoundedButton(
                    context,
                    languages.continueTxt,
                    () async {
                      Navigator.pop(context);
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
    );
  }
}
