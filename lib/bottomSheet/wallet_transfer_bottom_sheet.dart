import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../utils/utils.dart';

class WalletTransferBottomSheet extends StatelessWidget {
  final double amount;

  const WalletTransferBottomSheet({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ScaffoldWithSafeArea(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
            padding: bottomSheetPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  languages.success,
                  textAlign: TextAlign.center,
                  style: bodyText(context: context, fontSize: textSize18px, textColor: getCurrentTheme(context).colorTextCommon, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 20.h),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: bodyText(context: context, fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(text: "${languages.successTransaction}\n"),
                      TextSpan(
                        text: getAmountWithCurrency(amount),
                        style: bodyText(context: context, textColor: getCurrentTheme(context).colorPrimary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                CustomRoundedButton(
                  context,
                  languages.ok,
                  () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                  minWidth: double.maxFinite,
                  textSize: textSize16px,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
