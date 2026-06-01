import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/custom_text_field.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../utils/utils.dart';
import '../utils/validator.dart';

class EnterTollAmountBottomSheet extends StatefulWidget {
  final int tollType;
  final Function(String)? onPositiveBtnClick;
  final Function? onNegativeClick;

  const EnterTollAmountBottomSheet({super.key, required this.tollType, this.onPositiveBtnClick, this.onNegativeClick});

  @override
  State<EnterTollAmountBottomSheet> createState() => _EnterTollAmountBottomSheet();
}

class _EnterTollAmountBottomSheet extends State<EnterTollAmountBottomSheet> {
  final TextEditingController _textEditingController = TextEditingController();
  var formKey = GlobalKey<FormState>();

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
                              widget.tollType == 2 ? languages.numberOfToll : languages.tollAmount,
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
                      Form(
                        key: formKey,
                        child: TextFormFieldCustom(
                          commonPrefixIcon: CustomIcons.paymentMethod,
                          controller: _textEditingController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [widget.tollType == 2 ? FilteringTextInputFormatter.allow(RegExp('^[0-9]*\$')) : getDecimalInputFormatter()],
                          hint: widget.tollType == 2 ? languages.enterNumberOfToll : languages.enterTollAmount,
                          setError: true,
                          validator: (value) {
                            return validateToll(
                              value: value,
                              tollType: widget.tollType,
                              message: widget.tollType == 2 ? languages.enterValidateNoTolls : languages.enterValidateTollCharge,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomRoundedButton(
                              context,
                              languages.cancel,
                              () {
                                widget.onNegativeClick?.call();
                              },
                              progressSize: cpiSizeRegular,
                              margin: EdgeInsetsDirectional.only(top: 20.h),
                              setBorder: true,
                              textColor: getCurrentTheme(context).colorTextCommon,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: CustomRoundedButton(
                              context,
                              languages.continueTxt,
                              () {
                                if (formKey.currentState!.validate()) {
                                  widget.onPositiveBtnClick?.call(_textEditingController.text);
                                }
                              },
                              progressSize: cpiSizeRegular,
                              margin: EdgeInsetsDirectional.only(top: 20.h),
                            ),
                          ),
                        ],
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
