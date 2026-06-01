import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';

class ProgressButton extends StatefulWidget {
  final Duration duration;
  final String text;
  final bool setProgress;
  final Function()? onTap;
  final Function()? onTimeExpired;
  final EdgeInsetsGeometry? margin;
  final double? minHeight;
  final double? progressSize;

  const ProgressButton({
    super.key,
    this.duration = const Duration(seconds: 5),
    this.text = "",
    this.onTap,
    this.onTimeExpired,
    this.setProgress = false,
    this.margin,
    this.minHeight,
    this.progressSize,
  });

  @override
  State<ProgressButton> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ProgressButton> {
  late final AnimationController _controller = AnimationController(vsync: this, duration: widget.duration);

  late final Animation<double> _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.forward().whenComplete(() {
      widget.onTimeExpired?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap:
          widget.setProgress
              ? null
              : () {
                widget.onTap?.call();
              },
      child: Container(
        height: widget.minHeight ?? commonBtnHeight45h,
        margin: widget.margin ?? EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [getCurrentTheme(context).colorBtnGradient1, getCurrentTheme(context).colorBtnGradient2],
            begin: AlignmentDirectional.centerStart,
            end: AlignmentDirectional.centerEnd,
          ),
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: getCurrentTheme(context).colorTextFieldBorder, width: 1.sp),
        ),
        child: Stack(
          children: [
            Center(
              child:
                  widget.setProgress
                      ? SizedBox(
                        height: widget.progressSize ?? cpiSizeRegular,
                        width: widget.progressSize ?? cpiSizeRegular,
                        child: CircularProgressIndicator(color: getCurrentTheme(context).colorStaticBlack, strokeWidth: 2.sp),
                      )
                      : Text(
                        widget.text,
                        style: bodyText(
                          context: context,
                          textColor: getCurrentTheme(context).colorStaticBlack,
                          fontSize: textSize18px,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
            SizeTransition(
              sizeFactor: _animation,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: Container(
                height: widget.minHeight ?? commonBtnHeight45h,
                width: double.infinity,
                decoration: BoxDecoration(color: getCurrentTheme(context).colorProgressBtnBg, borderRadius: BorderRadius.circular(50.r)),
                child: Center(
                  child:
                      widget.setProgress
                          ? SizedBox(
                            height: widget.progressSize ?? cpiSizeRegular,
                            width: widget.progressSize ?? cpiSizeRegular,
                            child: CircularProgressIndicator(color: getCurrentTheme(context).colorTextCommon, strokeWidth: 2.sp),
                          )
                          : Text(
                            widget.text,
                            style: bodyText(
                              context: context,
                              textColor: getCurrentTheme(context).colorStaticBlack,
                              fontSize: textSize18px,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
