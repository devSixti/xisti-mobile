import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/custom_text_field.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../utils/utils.dart';
import '../utils/validator.dart';

class CancelRideBottomSheet extends StatefulWidget {
  final Function(String cancelReason) onSubmit;

  const CancelRideBottomSheet({super.key, required this.onSubmit});

  @override
  State<CancelRideBottomSheet> createState() => _CancelRideBottomSheetState();
}

class _CancelRideBottomSheetState extends State<CancelRideBottomSheet> {
  final cancelReasonController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(top: 25.h, bottom: 20.h),
                          child: Text(
                            languages.cancelRide,
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
                  Text(languages.sureToCancel, style: bodyText(context: context, fontWeight: FontWeight.w500, fontSize: textSize18px)),
                  SizedBox(height: 20.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: getCurrentTheme(context).colorTextFieldBorder, width: 1.sp),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsetsDirectional.only(start: 15.w, top: 10.h, bottom: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(CustomIcons.description, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                        Expanded(
                          child: TextFormFieldCustom(
                            controller: cancelReasonController,
                            maxLine: 5,
                            minLine: 3,
                            keyboardType: TextInputType.multiline,
                            backgroundColor: Colors.transparent,
                            hint: languages.enterCancelReason,
                            setError: true,
                            validator: (value) {
                              return validateEmptyField(value, languages.enterCancelReason);
                            },
                            contentPadding: EdgeInsetsDirectional.only(start: 10.w),
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: CustomRoundedButton(
                      context,
                      languages.submit,
                      () {
                        if (formKey.currentState!.validate()) {
                          String cancelReason = cancelReasonController.text.trim();
                          widget.onSubmit(cancelReason);
                          Navigator.pop(context, true);
                        }
                      },
                      minWidth: double.maxFinite,
                      margin: EdgeInsetsDirectional.only(top: 20.h, bottom: getBottomMargin()),
                    ),
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
