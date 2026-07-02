import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../commonView/custom_text_field.dart';
import '../../../../../hive/hive_helper.dart';
import '../../../../../utils/utils.dart';
import '../../../../../utils/validator.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';

class RaiseFareSheet extends StatefulWidget {
  final double minFare, maxFare, currentFare;
  final String btnTitle, km, min;
  final bool isFromDriver, isShowFareDetail;

  final Function(String offerFare) onSubmit;

  const RaiseFareSheet({
    super.key,
    this.currentFare = 0,
    this.minFare = 0,
    this.maxFare = 0,
    required this.onSubmit,
    this.isFromDriver = false,
    this.btnTitle = "",
    this.km = "",
    this.min = "",
    this.isShowFareDetail = false,
  });

  @override
  State<RaiseFareSheet> createState() => _RaiseFareSheetState();
}

class _RaiseFareSheetState extends State<RaiseFareSheet> {
  final formKey = GlobalKey<FormState>();
  final offerFareController = TextEditingController();

  @override
  void didChangeDependencies() {
    offerFareController.text = widget.isFromDriver ? "" : getEditableAmount(widget.currentFare);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin()),
            child: SingleChildScrollView(
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
                            padding: EdgeInsetsDirectional.only(top: 25.h, bottom: 15.h),
                            child: Text(
                              languages.offerAmount,
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
                    offerFare(),
                    Divider(height: 0, thickness: 2.h, color: getCurrentTheme(context).colorTextFieldBorder),
                    if (widget.isShowFareDetail) fareInfo(),
                    CustomRoundedButton(
                      context,
                      widget.btnTitle.isNotEmpty
                          ? widget.btnTitle
                          : widget.isFromDriver
                          ? languages.offerFare
                          : languages.findDrive,
                      () {
                        if (formKey.currentState?.validate() ?? false) {
                          widget.onSubmit(offerFareController.text.trim());
                        }
                      },
                      margin: EdgeInsetsDirectional.only(top: 20.h),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container fareInfo() {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 10.h),
      padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.w, bottom: 10.w),
      decoration: BoxDecoration(
        color: getCurrentTheme(context).colorSelectionPrimaryOpc,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: getCurrentTheme(context).colorPrimary, width: 0.5.sp),
      ),
      child: Text(
        "${languages.recommendedFare} ${getAmountWithCurrency(widget.currentFare)}, ${languages.minFare} ${getAmountWithCurrency(widget.minFare)}, ${languages.maxFare} ${getAmountWithCurrency(widget.maxFare)}, ${widget.km}, ${widget.min}",
        style: bodyText(context: context, fontWeight: FontWeight.w500, fontSize: textSize14px),
      ),
    );
  }

  Widget offerFare() {
    return Container(
      color: getCurrentTheme(context).colorTextFieldBg,
      alignment: AlignmentDirectional.center,
      child: IntrinsicWidth(
        child: TextFormFieldCustom(
          controller: offerFareController,
          setError: true,
          validator: (value) {
            String val = validateEmptyField(value, languages.enterFareValue);
            if (val.isEmpty) {
              double amount = parseSafeDouble(value);
              if (amount < getDoubleFromDynamic(widget.minFare) && !widget.isFromDriver) {
                val = languages.offerFareMin(getAmountWithCurrency(widget.minFare));
              } else if (amount > widget.maxFare && !widget.isFromDriver) {
                val = languages.offerFareMax(getAmountWithCurrency(widget.maxFare));
              }
            }
            return val;
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
          inputFormatters: [getDecimalInputFormatter(decimalRange: getCurrencyFractionDigits())],
          style: bodyText(context: context, fontSize: 40.sp, fontWeight: FontWeight.w600),
          contentPadding: EdgeInsetsDirectional.zero,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
          textAlign: TextAlign.center,
          prefix: Container(
            margin: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
            child: Text(
              getStringFromSettingBox(hiveSelectedCurrency, defaultValue: defaultCurrency),
              style: bodyText(context: context, fontSize: 40.sp, fontWeight: FontWeight.w600),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
