import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';

/// Uniform bordered box fields (same look as origin/destination address rows).
class PassengerBoxTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final String? label;
  final IconData? icon;
  final TextInputType keyboardType;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const PassengerBoxTextField({
    super.key,
    this.controller,
    required this.hint,
    this.label,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final fieldLabel = label ?? hint;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 4.w, bottom: 6.h),
          child: Text(
            fieldLabel,
            style: bodyText(
              context: context,
              textColor: theme.colorTextCommon,
              fontWeight: FontWeight.w600,
              fontSize: textSize13px,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: theme.colorDarkBorder, width: 1.sp),
          ),
          padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 4.h, bottom: 4.h),
          child: Row(
            crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Padding(
                  padding: EdgeInsetsDirectional.only(top: maxLines > 1 ? 8.h : 0),
                  child: Icon(icon, color: theme.colorIconCommon, size: 25.sp),
                ),
                SizedBox(width: 10.w),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  minLines: 1,
                  inputFormatters: inputFormatters,
                  onChanged: onChanged,
                  style: bodyText(
                    context: context,
                    textColor: theme.colorTextCommon,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsetsDirectional.symmetric(vertical: 10.h),
                    hintStyle: bodyText(
                      context: context,
                      textColor: theme.colorTextLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PassengerBoxDateField extends StatelessWidget {
  final String hint;
  final String valueLabel;
  final IconData? icon;
  final VoidCallback onTap;

  const PassengerBoxDateField({
    super.key,
    required this.hint,
    required this.valueLabel,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final hasValue = valueLabel != hint;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: theme.colorDarkBorder, width: 1.sp),
        ),
        padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 12.h, bottom: 12.h),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: theme.colorIconCommon, size: 25.sp),
              SizedBox(width: 10.w),
            ],
            Expanded(
              child: Text(
                valueLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: bodyText(
                  context: context,
                  textColor: hasValue ? theme.colorTextCommon : theme.colorTextLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
