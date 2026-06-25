import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../constant/dimensions.dart';
import '../utils/style_util.dart';

class CustomRoundedButton extends StatelessWidget {
  final BuildContext context;
  final String text;
  final GestureTapCallback? onPressed;
  final Color? bgColor;
  final Color? textColor;
  final Color? progressColor;
  final Color? borderColor;
  final Widget? icon;
  final Widget? widget;
  final double? textSize;
  final double? progressSize;
  final double? progressStrokeWidth;
  final double? elevation;
  final double? iconTextSpacing;
  final double? borderWidth;
  final bool setBorder;
  final bool setProgress;
  final int maxLine;
  final TextOverflow overFlow;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final RoundedRectangleBorder? roundedRectangleBorder;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;
  final MaterialTapTargetSize materialTapTargetSize;
  final double? minHeight;
  final double? minWidth;

  const CustomRoundedButton(
    this.context,
    this.text,
    this.onPressed, {
    this.bgColor,
    this.textColor,
    this.progressColor,
    this.borderColor,
    this.icon,
    this.widget,
    this.textSize,
    this.progressSize,
    this.progressStrokeWidth,
    this.elevation,
    this.iconTextSpacing,
    this.borderWidth,
    this.setBorder = false,
    this.setProgress = false,
    this.maxLine = 3,
    this.overFlow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.center,
    this.fontWeight = FontWeight.w600,
    this.roundedRectangleBorder,
    this.margin = EdgeInsetsDirectional.zero,
    this.padding,
    this.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
    this.minHeight,
    this.minWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final Color? resolvedBg;
    if (!setBorder && bgColor == null) {
      resolvedBg = null;
    } else {
      final base = bgColor ?? (setBorder ? theme.colorScaffoldBg : theme.colorPrimary);
      resolvedBg = onPressed == null ? lighten(base) : base;
    }

    return Container(
      margin: margin,
      child: CustomBorderRoundedButton(
        onPressed: setProgress ? null : onPressed,
        border: roundedRectangleBorder ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
        borderColor: setBorder ? (borderColor ?? theme.colorTextCommon) : null,
        bgColor: resolvedBg,
        icon: icon,
        minHeight: minHeight ?? commonBtnHeight45h,
        minWidth: minWidth ?? double.maxFinite,
        setBorder: setBorder,
        tapTargetSize: materialTapTargetSize,
        padding: padding ?? EdgeInsetsDirectional.only(start: 1.w, end: 1.w),
        elevation: elevation,
        borderWidth: borderWidth,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            setProgress
                ? Flexible(
                  child: SizedBox(
                    width: progressSize ?? cpiSizeRegular,
                    height: progressSize ?? cpiSizeRegular,
                    child: CircularProgressIndicator(
                      strokeWidth: progressStrokeWidth ?? cpiStrokeWidthSmall,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progressColor ??
                            (setBorder ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorStaticBlack),
                      ),
                    ),
                  ),
                )
                : Flexible(
                  child:
                      widget ??
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null)
                            Flexible(
                              child: Container(margin: EdgeInsetsDirectional.only(end: iconTextSpacing ?? 5.w), child: icon),
                            ),
                          Flexible(
                            child: Text(
                              text,
                              maxLines: maxLine,
                              textAlign: textAlign,
                              overflow: overFlow,
                              style: bodyText(
                                context: context,
                                fontSize: textSize ?? textSize18px,
                                fontWeight: fontWeight,
                                textColor:
                                    textColor ??
                                    (setBorder
                                        ? getCurrentTheme(context).colorTextCommon
                                        : getCurrentTheme(context).colorStaticBlack),
                              ).copyWith(letterSpacing: 0.5.sp),
                            ),
                          ),
                        ],
                      ),
                ),
          ],
        ),
      ),
    );
  }
}

class CustomBorderRoundedButton extends StatelessWidget {
  final GestureTapCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final Color? bgColor;
  final Color? borderColor;
  final double? borderWidth;
  final double minHeight;
  final double minWidth;
  final double? elevation;
  final EdgeInsetsGeometry padding;
  final bool setBorder;
  final MaterialTapTargetSize tapTargetSize;
  final RoundedRectangleBorder? border;

  const CustomBorderRoundedButton({
    super.key,
    this.onPressed,
    required this.child,
    this.bgColor,
    this.borderColor,
    this.borderWidth,
    this.border,
    this.icon,
    this.minHeight = 0,
    this.setBorder = false,
    this.padding = EdgeInsetsDirectional.zero,
    this.minWidth = 0,
    this.tapTargetSize = MaterialTapTargetSize.shrinkWrap,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    var borderRadiusDirectional = BorderRadiusDirectional.circular(8.sp);
    if (!setBorder && bgColor != null) {
      return ElevatedButton(
        style: OutlinedButton.styleFrom(
          tapTargetSize: tapTargetSize,
          backgroundColor: onPressed != null ? bgColor : lighten(bgColor!),
          surfaceTintColor: Colors.transparent,
          elevation: elevation ?? 0,
          padding: padding,
          minimumSize: Size(minWidth, minHeight),
          shape: border ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
        ),
        onPressed: onPressed != null
            ? () {
                FocusManager.instance.primaryFocus?.unfocus();
                onPressed?.call();
              }
            : null,
        child: child,
      );
    }
    return !setBorder
        ? Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  onPressed != null
                      ? [getCurrentTheme(context).colorBtnGradient1, getCurrentTheme(context).colorBtnGradient2]
                      : [
                        lighten(getCurrentTheme(context).colorBtnGradient1),
                        lighten(getCurrentTheme(context).colorBtnGradient2),
                      ],
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
            ),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
              // backgroundColor: bgColor ?? getCurrentTheme(context).colorPrimary,
              // surfaceTintColor: bgColor ?? getCurrentTheme(context).colorPrimary,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              tapTargetSize: tapTargetSize,
              elevation: elevation ?? 0,
              padding: padding,
              minimumSize: Size(minWidth, minHeight),
              shape: border ?? RoundedRectangleBorder(borderRadius: borderRadiusDirectional),
            ),
            onPressed:
                onPressed != null
                    ? () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      onPressed?.call();
                    }
                    : null,
            child: child,
          ),
        )
        : OutlinedButton(
          style: OutlinedButton.styleFrom(
            tapTargetSize: tapTargetSize,
            backgroundColor: bgColor,
            minimumSize: Size(minWidth, minHeight),
            padding: padding,
            foregroundColor: bgColor ?? getCurrentTheme(context).colorPrimary,
            shape: border ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
            side: BorderSide(color: borderColor ?? getCurrentTheme(context).colorTextCommon, width: borderWidth ?? 1.sp),
          ),
          onPressed:
              onPressed != null
                  ? () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onPressed?.call();
                  }
                  : null,
          child: child,
        );
  }
}
