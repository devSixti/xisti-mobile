import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../blocs/bloc.dart';
import '../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../utils/utils.dart';

class EnterOtpBottomSheet extends StatefulWidget {
  final String preFillOTP;
  final Function(String otp)? onSubmit;

  const EnterOtpBottomSheet({super.key, this.preFillOTP = "", this.onSubmit});

  @override
  State<EnterOtpBottomSheet> createState() => _EnterOtpBottomSheetState();
}

class _EnterOtpBottomSheetState extends State<EnterOtpBottomSheet> {
  final otpController = BehaviorSubject<String>();
  PinInputController pinInputController = PinInputController();

  @override
  void initState() {
    pinInputController.text = widget.preFillOTP;
    otpController.sink.add(pinInputController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
                child: Padding(
                  padding: bottomSheetPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              languages.enterOtp,
                              textAlign: TextAlign.start,
                              style: bodyText(context: context, fontSize: textSize22px, fontWeight: FontWeight.w600),
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
                      SizedBox(height: 20.h),
                      Center(
                        child: MaterialPinField(
                          length: 4,
                          obscureText: false,
                          autoDismissKeyboard: true,
                          enableAutofill: true,
                          pinController: pinInputController,
                          keyboardType: TextInputType.number,
                          enablePaste: false,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('^[0-9]*\$'))],
                          theme: MaterialPinTheme(
                            animateCursor: true,
                            showCursor: true,
                            cursorColor: getCurrentTheme(context).colorPrimary,
                            animationDuration: const Duration(milliseconds: 300),
                            completeFillColor: getCurrentTheme(context).colorScaffoldBg,
                            fillColor: getCurrentTheme(context).colorScaffoldBg,
                            focusedFillColor: getCurrentTheme(context).colorScaffoldBg,
                            filledFillColor: getCurrentTheme(context).colorScaffoldBg,
                            shape: MaterialPinShape.outlined,
                            borderRadius: BorderRadius.circular(20.r),
                            errorBorderColor: getCurrentTheme(context).colorRed,
                            disabledColor: getCurrentTheme(context).colorTextFieldBorder,
                            borderColor: getCurrentTheme(context).colorTextFieldBorder,
                            borderWidth: 1.sp,
                            focusedBorderWidth: 1.sp,
                            cellSize: Size(50.sp, 50.sp),
                            spacing: 20.sp,
                            focusedBorderColor: getCurrentTheme(context).colorPrimary,
                            textStyle: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w500),
                          ),
                          onChanged: (value) {
                            otpController.add(value);
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                      StreamBuilder<String>(
                        stream: otpController,
                        builder: (context, otpText) {
                          return CustomRoundedButton(
                            context,
                            languages.submitOTP,
                            ((otpText.data?.trim().isNotEmpty ?? false) && (otpText.data?.length == 4))
                                ? () {
                                    widget.onSubmit?.call(otpText.data ?? pinInputController.text);
                                  }
                                : null,
                            progressSize: cpiSizeRegular,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
