import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';
import 'linear_percent_indicator.dart';

class CustomProgressButton extends StatefulWidget {
  final String text;
  final bool setProgress;
  final Function()? onTap;
  final Function()? onTimeExpired;
  final EdgeInsetsGeometry? margin;
  final double? minHeight;
  final double? progressSize;
  final int totalSeconds;
  final int leftSeconds;

  const CustomProgressButton({
    super.key,
    this.text = "",
    this.totalSeconds = 10,
    this.leftSeconds = 0,
    this.onTap,
    this.onTimeExpired,
    this.setProgress = false,
    this.margin,
    this.minHeight,
    this.progressSize,
  });

  @override
  State<CustomProgressButton> createState() => _CustomProgressButtonState();
}

class _CustomProgressButtonState extends State<CustomProgressButton> {
  Timer? _timer;
  late int _secondsLeft;

  @override
  void initState() {
    super.initState();
    _secondsLeft = _clampLeft(widget.leftSeconds);
    _startTicker();
  }

  @override
  void didUpdateWidget(CustomProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.leftSeconds != widget.leftSeconds ||
        oldWidget.totalSeconds != widget.totalSeconds) {
      _secondsLeft = _clampLeft(widget.leftSeconds);
      _startTicker();
    }
  }

  int _clampLeft(int value) {
    if (value < 0) return 0;
    if (value > widget.totalSeconds) return widget.totalSeconds;
    return value;
  }

  void _startTicker() {
    _timer?.cancel();
    if (_secondsLeft <= 0) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _secondsLeft = (_secondsLeft - 1).clamp(0, widget.totalSeconds);
      });
      if (_secondsLeft <= 0) {
        _timer?.cancel();
        widget.onTimeExpired?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.totalSeconds <= 0 ? 1 : widget.totalSeconds;
    final percent = (_secondsLeft / total).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: widget.setProgress ? null : widget.onTap,
      child: Container(
        margin: widget.margin,
        width: double.maxFinite,
        height: widget.minHeight ?? commonBtnHeight45h,
        decoration: BoxDecoration(
          color: getCurrentTheme(context).colorBorder,
          borderRadius: BorderRadius.circular(50.r),
        ),
        padding: EdgeInsetsDirectional.all(1.sp),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: LinearPercentIndicator(
            lineHeight: widget.minHeight ?? commonBtnHeight45h,
            linearGradient: LinearGradient(
              colors: [
                getCurrentTheme(context).colorBtnGradient1,
                getCurrentTheme(context).colorBtnGradient2,
              ],
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
            ),
            percent: percent,
            center: widget.setProgress
                ? SizedBox(
                    height: widget.progressSize ?? cpiSizeRegular,
                    width: widget.progressSize ?? cpiSizeRegular,
                    child: CircularProgressIndicator(
                      color: getCurrentTheme(context).colorTextCommon,
                      strokeWidth: 2.sp,
                    ),
                  )
                : Center(
                    child: Text(
                      widget.text,
                      style: bodyText(
                        context: context,
                        textColor: getCurrentTheme(context).colorTextCommon,
                        fontSize: textSize18px,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
            backgroundColor: getCurrentTheme(context).colorWhite,
            clipLinearGradient: true,
            fillColor: getCurrentTheme(context).colorWhite,
            progressBorderColor: getCurrentTheme(context).colorBorder,
            padding: EdgeInsets.only(right: 1.sp, left: 1.sp),
          ),
        ),
      ),
    );
  }
}
