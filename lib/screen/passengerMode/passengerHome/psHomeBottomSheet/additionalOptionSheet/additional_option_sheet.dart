import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../commonView/custom_rounded_button.dart';
import '../../../../../commonView/custom_text_field.dart';
import '../../../../../commonView/scaffold_with_safe_area.dart';
import '../../../../../hive/hive_helper.dart';
import '../../../../../utils/utils.dart';
import '../../../../../utils/validator.dart';
import 'additional_option_bloc.dart';

class AdditionalOptionSheet extends StatefulWidget {
  final Function(String comment, bool childSafety, bool handicap, bool bookForOther, String otherContact, String otherContactName) onSubmit;
  final bool childSafety, handicap, bookForOther;
  final String comment, otherContact, otherContactName;
  final int selectedService;

  const AdditionalOptionSheet({
    super.key,
    required this.selectedService,
    required this.comment,
    required this.childSafety,
    required this.handicap,
    required this.bookForOther,
    required this.otherContact,
    required this.otherContactName,
    required this.onSubmit,
  });

  @override
  State<AdditionalOptionSheet> createState() => _AdditionalOptionSheetState();
}

class _AdditionalOptionSheetState extends State<AdditionalOptionSheet> {
  AdditionalOptionBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= AdditionalOptionBloc(
      context,
      comment: widget.comment,
      childSafety: widget.childSafety,
      handicap: widget.handicap,
      bookForOther: widget.bookForOther,
      otherContact: widget.otherContact,
      otherContactName: widget.otherContactName,
      onSubmit: widget.onSubmit,
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 25.h, bottom: 15.h),
                        child: Text(
                          languages.comments,
                          textAlign: TextAlign.start,
                          style: bodyText(context: context, fontSize: textSize22px, fontWeight: FontWeight.w600),
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: getCurrentTheme(context).colorTextFieldBorder, width: 1.sp),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 10.h, bottom: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(CustomIcons.description, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                      Expanded(
                        child: TextFormFieldCustom(
                          controller: _bloc?.commentController,
                          maxLine: 5,
                          minLine: 3,
                          keyboardType: TextInputType.multiline,
                          backgroundColor: Colors.transparent,
                          contentPadding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.selectedService == ServiceType.taxi) ...[
                  SizedBox(height: 20.h),
                  StreamBuilder<bool>(
                    stream: _bloc?.childSafetyController,
                    builder: (context, snap) {
                      bool value = snap.data ?? false;
                      return GestureDetector(
                        onTap: () {
                          _bloc?.childSafetyController.sink.add(!value);
                        },
                        child: Row(
                          children: [
                            Expanded(child: Text(languages.childSeatSafety, style: bodyText(context: context, fontWeight: FontWeight.w500))),
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                tristate: false,
                                value: snap.data ?? false,
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                checkColor: getCurrentTheme(context).colorWhite,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                side: BorderSide(color: getCurrentTheme(context).colorBorder, width: 1.sp),
                                onChanged: (value) {
                                  _bloc?.childSafetyController.sink.add(value ?? false);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                if (widget.selectedService == ServiceType.taxi) ...[
                  SizedBox(height: 15.h),
                  StreamBuilder<bool>(
                    stream: _bloc?.handyCapAccessibilityController,
                    builder: (context, snap) {
                      bool value = snap.data ?? false;
                      return GestureDetector(
                        onTap: () {
                          _bloc?.handyCapAccessibilityController.sink.add(!value);
                        },
                        child: Row(
                          children: [
                            Expanded(child: Text(languages.handicapAccess, style: bodyText(context: context, fontWeight: FontWeight.w500))),
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                tristate: false,
                                value: snap.data ?? false,
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                checkColor: getCurrentTheme(context).colorWhite,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                side: BorderSide(color: getCurrentTheme(context).colorBorder, width: 1.sp),
                                onChanged: (value) {
                                  _bloc?.handyCapAccessibilityController.sink.add(value ?? false);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                if (getBoolFromSettingBox(hivePaymentTypeCash)) ...[
                  SizedBox(height: 15.h),
                  StreamBuilder<bool>(
                    stream: _bloc?.bookForOtherController,
                    builder: (context, snap) {
                      bool value = snap.data ?? false;
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _bloc?.bookForOtherController.sink.add(!value);
                            },
                            child: Row(
                              children: [
                                Expanded(child: Text(languages.bookForOther, style: bodyText(context: context, fontWeight: FontWeight.w500))),
                                Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    tristate: false,
                                    value: snap.data ?? false,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                    checkColor: getCurrentTheme(context).colorWhite,
                                    side: BorderSide(color: getCurrentTheme(context).colorBorder, width: 1.sp),
                                    onChanged: (value) {
                                      _bloc?.bookForOtherController.sink.add(value ?? false);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (value) ...[
                            GestureDetector(
                              onTap: () {
                                _bloc?.pickContactNumber();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: getCurrentTheme(context).colorBorder, width: 1.sp),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                margin: EdgeInsetsDirectional.only(top: 10.h),
                                padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w),
                                height: commonBtnHeight50h,
                                child: Row(
                                  children: [
                                    Icon(CustomIcons.selectContact, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
                                    Container(
                                      margin: EdgeInsetsDirectional.only(start: 10.w),
                                      child: StreamBuilder<String>(
                                        stream: _bloc?.otherContactController,
                                        builder: (context, snapshot) {
                                          String value = snapshot.data ?? languages.selectContactNumber;
                                          return Text(
                                            value,
                                            style: bodyText(
                                              context: context,
                                              textColor:
                                                  snapshot.data == null ? getCurrentTheme(context).colorTextLight : getCurrentTheme(context).colorTextCommon,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            TextFormFieldCustom(
                              controller: _bloc?.otherNameController,
                              prefix: Container(
                                margin: EdgeInsetsDirectional.only(start: 15.w, end: 5.w),
                                child: Icon(CustomIcons.name, size: 25.sp, color: getCurrentTheme(context).colorIconLight),
                              ),
                              hint: languages.contactName,
                              setError: true,
                              validator: (value) {
                                return validateEmptyField(value, languages.enterContactName);
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
                CustomRoundedButton(context, languages.continueTxt, () {
                  _bloc?.onContinuePress();
                }, margin: EdgeInsetsDirectional.only(top: 20.h, bottom: getBottomMargin())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
