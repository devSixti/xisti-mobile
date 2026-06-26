import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../constant/dimensions.dart';
import '../main.dart';
import '../utils/style_util.dart';

class TextFormFieldCustom extends StatefulWidget {
  final String? hint;
  final bool setError, setBottomError, setPassword, readOnly, setClear;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextStyle? style;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final Color? backgroundColor;
  final Widget? suffix, prefix;
  final InputDecoration? decoration;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final String Function(String)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final Function()? onClear;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final BorderRadius? borderRadius;
  final int maxLine;
  final int minLine;
  final int? maxLength;
  final AutovalidateMode autoValidateMode;
  final IconData? commonPrefixIcon;
  final EdgeInsetsDirectional? contentPadding;
  final String separateLabelText;

  const TextFormFieldCustom({
    super.key,
    this.hint,
    this.setPassword = false,
    this.readOnly = false,
    this.textInputAction = TextInputAction.next,
    this.decoration,
    this.textDirection,
    this.backgroundColor,
    this.style,
    this.textAlignVertical,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.suffix,
    this.setClear = false,
    this.prefix,
    this.setError = false,
    this.setBottomError = false,
    this.onChanged,
    this.onSubmit,
    this.controller,
    this.borderRadius,
    this.onTap,
    this.validator,
    this.maxLength,
    this.minLine = 1,
    this.maxLine = 1,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.commonPrefixIcon,
    this.onClear,
    this.contentPadding,
    this.separateLabelText = "",
  });

  @override
  State<StatefulWidget> createState() => TextFormFieldCustomState();
}

class TextFormFieldCustomState extends State<TextFormFieldCustom> {
  bool _passwordVisible = false;
  bool isError = false;
  bool isClear = false;
  bool isShowClear = false;
  String errorText = "";
  final GlobalKey _passKey = GlobalKey();
  final _formKey = GlobalKey<EditableTextState>();
  final FocusNode phoneNumberFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    InputDecoration? decoration = widget.decoration;
    OutlineInputBorder outlineFocusedInputBorderStyle = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(20.r),
      borderSide: BorderSide(width: 1.w, color: getCurrentTheme(context).colorDarkBorder),
    );
    OutlineInputBorder outlineInputBorderStyle = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(20.r),
      borderSide: BorderSide(width: 1.w, color: getCurrentTheme(context).colorTextFieldBorder),
    );
    var eyeButton = GestureDetector(
      child: Container(
        padding: EdgeInsetsDirectional.only(end: 10.w),
        constraints: const BoxConstraints(),
        child: Icon(
          _passwordVisible ? Icons.visibility_off : Icons.visibility,
          color: getCurrentTheme(context).colorIconCommon,
          size: 20.sp,
        ),
      ),
      onTap: () {
        setState(() {
          _passwordVisible = !_passwordVisible;
        });
      },
    );

    var errorButton = Tooltip(
      key: _passKey,
      message: errorText,
      margin: EdgeInsetsDirectional.only(end: 10.w),
      decoration: BoxDecoration(color: getCurrentTheme(context).colorBlack, borderRadius: BorderRadius.circular(10.r)),
      textStyle: bodyText(
        context: context,
        fontWeight: FontWeight.w500,
        textColor: getCurrentTheme(context).colorWhite,
        fontSize: textSize14px,
      ),
      child: GestureDetector(
        child: Container(
          padding: EdgeInsetsDirectional.only(end: 10.w),
          constraints: const BoxConstraints(),
          child: Icon(Icons.error, color: Colors.red, size: 20.sp),
        ),
        onTap: () async {
          final dynamic tooltip = _passKey.currentState;
          tooltip.ensureTooltipVisible();
          await Future.delayed(const Duration(seconds: 3));
          tooltip.deactivate();
        },
      ),
    );

    var clearButton = InkWell(
      onTap: () {
        isClear = false;
        widget.controller?.text = "";
        widget.onChanged?.call("");
        widget.onClear?.call();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 10.w),
        child: Icon(Icons.close, color: getCurrentTheme(context).colorIconCommon, size: 20.sp),
      ),
    );

    var e = (isError && widget.setError);

    InputDecoration inputDecoration = InputDecoration(
      border: decoration?.border ?? InputBorder.none,
      counterText: "",
      contentPadding:
          widget.contentPadding ??
          decoration?.contentPadding ??
          EdgeInsetsDirectional.only(start: 10.w, end: 10.w, bottom: 13.5.h, top: 13.5.h),
      labelText: (widget.separateLabelText.trim().isNotEmpty) ? null : decoration?.labelText,
      floatingLabelBehavior: decoration?.floatingLabelBehavior,
      labelStyle: decoration?.labelStyle,
      errorStyle: (widget.setBottomError) ? null : const TextStyle(height: 0, fontSize: 0.01),
      errorMaxLines: 2,
      fillColor: widget.backgroundColor ?? getCurrentTheme(context).colorTextFieldBg,
      filled: true,
      enabledBorder: decoration?.enabledBorder ?? outlineInputBorderStyle,
      errorBorder: decoration?.errorBorder ?? outlineInputBorderStyle,
      focusedBorder: decoration?.focusedBorder ?? outlineFocusedInputBorderStyle,
      focusedErrorBorder: decoration?.focusedErrorBorder ?? outlineFocusedInputBorderStyle,
      floatingLabelStyle: decoration?.floatingLabelStyle,
      hintStyle:
          decoration?.hintStyle ??
          bodyText(
            context: context,
            fontSize: textSize16px,
            textColor: getCurrentTheme(context).colorTextLight,
            fontWeight: FontWeight.w500,
          ),
      hintText: widget.hint ?? decoration?.hintText ?? "",
      isDense: decoration?.isDense ?? false,
      suffixIconConstraints: const BoxConstraints(),
      prefixIconConstraints: const BoxConstraints(),
      isCollapsed: decoration?.isCollapsed ?? true,
      alignLabelWithHint: true,
      prefixIcon: widget.prefix ?? _commonPrefixIcon(widget.commonPrefixIcon),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (e && !widget.setBottomError) errorButton,
          if (widget.setPassword) eyeButton,
          if (widget.suffix != null) widget.suffix ?? const SizedBox(width: 0, height: 0),
          if (isClear && widget.setClear) clearButton,
        ],
      ),
    );

    validate(value) {
      if (widget.validator != null) {
        errorText = widget.validator?.call(value) ?? "";
        isError = errorText.isNotEmpty;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.separateLabelText.trim().isNotEmpty)
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: 10.h),
            child: Text(
              widget.separateLabelText,
              style: bodyText(
                context: context,
                fontSize: textSize14px,
                textColor: getCurrentTheme(context).colorTextLight,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        TextFormField(
          key: _formKey,

          readOnly: widget.readOnly,
          style:
              widget.style ??
              bodyText(
                context: context,
                fontWeight: FontWeight.w500,
              ).copyWith(height: widget.commonPrefixIcon != null ? 1.25 : null),
          textAlignVertical: widget.textAlignVertical,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          cursorColor: getCurrentTheme(context).colorPrimary,
          cursorErrorColor: getCurrentTheme(context).colorPrimary,
          controller: widget.controller,
          textDirection: widget.textDirection,
          textAlign: widget.textAlign,
          maxLines: widget.maxLine,
          maxLength: widget.maxLength ?? TextField.noMaxLength,
          minLines: widget.minLine,
          obscuringCharacter: "*",
          autocorrect: false,
          obscureText: !_passwordVisible && widget.setPassword,
          inputFormatters: widget.inputFormatters,
          autovalidateMode:
              (widget.setBottomError || widget.setError) ? AutovalidateMode.onUserInteraction : widget.autoValidateMode,
          validator: (value) {
            validate(value);
            if (!widget.setBottomError) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() {});
              });
            }
            return isError
                ? widget.setBottomError
                    ? errorText
                    : ""
                : null;
          },
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
            isClear = value.isNotEmpty;
            validate(value);
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() {});
            });
          },
          onFieldSubmitted: widget.onSubmit,
          onTap: widget.onTap,
          decoration: inputDecoration,
        ),
      ],
    );
  }

  Widget? _commonPrefixIcon(IconData? icon) {
    return icon != null
        ? Padding(
          padding: EdgeInsetsDirectional.only(start: 15.w, end: 10.w, top: 10.h, bottom: 10.h),
          child: Icon(icon, color: getCurrentTheme(context).colorIconCommon, size: 24.sp),
        )
        : null;
  }

  @override
  void initState() {
    _passwordVisible = false;
    if (Platform.isIOS && widget.keyboardType == TextInputType.number) {
      phoneNumberFocusNode.addListener(() {
        bool hasFocus = phoneNumberFocusNode.hasFocus;
        if (hasFocus) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    phoneNumberFocusNode.dispose();
    super.dispose();
  }
}

class InputDoneView extends StatelessWidget {
  const InputDoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
          child: CupertinoButton(
            padding: const EdgeInsets.only(right: 24.0, top: 6.0, bottom: 6.0),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Text(languages.done, style: bodyText(context: context, textColor: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

OverlayEntry? overlayEntry;

void showOverlay(BuildContext context) {
  if (overlayEntry != null) return;
  OverlayState? overlayState = Overlay.of(context);
  overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(bottom: MediaQuery.of(context).viewInsets.bottom, right: 0.0, left: 0.0, child: const InputDoneView());
    },
  );

  overlayState.insert(overlayEntry!);
}

void removeOverlay() {
  if (overlayEntry != null) {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}
