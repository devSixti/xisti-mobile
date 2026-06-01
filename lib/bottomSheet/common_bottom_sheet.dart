import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../utils/utils.dart';

class CommonBottomSheet extends StatelessWidget {
  final String title, message, positiveButtonTxt, negativeButtonTxt;
  final bool cancelable;
  final Function() onPositivePress;
  final Function()? onNegativePress;
  final bool isLoading;
  final TextAlign textAlign;

  const CommonBottomSheet({
    super.key,
    required this.title,
    required this.positiveButtonTxt,
    required this.onPositivePress,
    this.message = "",
    this.negativeButtonTxt = "",
    this.onNegativePress,
    this.isLoading = false,
    this.cancelable = true,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: cancelable,
      child: ScaffoldWithSafeArea(
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
                padding: bottomSheetPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(title, textAlign: textAlign, style: bodyText(context: context, fontSize: textSize24px, fontWeight: FontWeight.w600)),
                        ),
                        if (cancelable)
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                          ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    if (message.trim().isNotEmpty) ...[
                      SizedBox(
                        width: double.infinity,
                        child: Text(message, textAlign: textAlign, style: bodyText(context: context, textColor: getCurrentTheme(context).colorTextCommon)),
                      ),
                      SizedBox(height: 25.h),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (negativeButtonTxt.trim().isNotEmpty)
                          Expanded(
                            child: CustomRoundedButton(context, negativeButtonTxt, () {
                              onNegativePress!();
                            }, setBorder: true),
                          ),
                        if (negativeButtonTxt.trim().isNotEmpty) SizedBox(width: 15.w),
                        Expanded(
                          child: CustomRoundedButton(
                            context,
                            positiveButtonTxt,
                            () {
                              onPositivePress();
                            },
                            setProgress: isLoading,
                            progressSize: cpiSizeRegular,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
