import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/bloc.dart';
import '../utils/utils.dart';
import 'common_circular_progress_indicator.dart';

class DriverStatusButton extends StatefulWidget {
  final bool defaultSelected;
  final bool isLoading;
  final Function(bool status) onSelect;

  const DriverStatusButton({super.key, required this.onSelect, required this.defaultSelected, required this.isLoading});

  @override
  State<DriverStatusButton> createState() => _DriverStatusButtonState();
}

class _DriverStatusButtonState extends State<DriverStatusButton> {
  double onlineAlign = 1;
  double offlineAlign = -1;
  BehaviorSubject<double> mainAlignSubject = BehaviorSubject<double>();

  @override
  Widget build(BuildContext context) {
    mainAlignSubject.sink.add(widget.defaultSelected ? onlineAlign : offlineAlign);
    return StreamBuilder<double>(
      stream: mainAlignSubject,
      builder: (context, snapshot) {
        double mainAlign = snapshot.data ?? 0;
        return snapshot.hasData
            ? Center(
              child: Container(
                width: 150.w,
                height: 40.h,
                padding: EdgeInsetsDirectional.all(3.sp),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: getCurrentTheme(context).colorDriverStatusContainerBg),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      alignment: Alignment(mainAlign, 0),
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        width: 72.w,
                        height: 34.h,
                        decoration: BoxDecoration(
                          color:
                              mainAlign == offlineAlign
                                  ? getCurrentTheme(context).colorOfflineContainerRed
                                  : getCurrentTheme(context).colorOnlineContainerGreen,
                          borderRadius: BorderRadius.circular(19.r),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (mainAlign != offlineAlign) {
                          widget.onSelect(false);
                          mainAlignSubject.sink.add(offlineAlign);
                        }
                      },
                      child: Align(
                        alignment: const Alignment(-1, 0),
                        child: Container(
                          width: 60.w,
                          height: 29.h,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          margin: EdgeInsetsDirectional.only(start: 7.sp),
                          child:
                              (widget.isLoading && mainAlign == offlineAlign)
                                  ? CommonCircularProgressIndicator(
                                    color:
                                        mainAlign == offlineAlign ? getCurrentTheme(context).colorStaticWhite : getCurrentTheme(context).colorActiveOfflineText,
                                  )
                                  : AutoSizeText(
                                    languages.offline,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: bodyText(
                                      context: context,
                                      textColor:
                                          mainAlign == offlineAlign
                                              ? getCurrentTheme(context).colorStaticWhite
                                              : getCurrentTheme(context).colorActiveOfflineText,
                                      fontSize: textSize14px,
                                      fontWeight: FontWeight.w600,
                                    ).copyWith(height: 0),
                                  ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (mainAlign != onlineAlign) {
                          widget.onSelect(true);
                          mainAlignSubject.sink.add(onlineAlign);
                        }
                      },
                      child: Align(
                        alignment: const Alignment(1, 0),
                        child: Container(
                          width: 60.w,
                          height: 29.h,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          margin: EdgeInsetsDirectional.only(end: 7.sp),
                          child:
                              (widget.isLoading && mainAlign == onlineAlign)
                                  ? CommonCircularProgressIndicator(
                                    color:
                                        mainAlign == onlineAlign
                                            ? getCurrentTheme(context).colorActiveOnlineText
                                            : getCurrentTheme(context).colorInActiveOnlineText,
                                  )
                                  : AutoSizeText(
                                    languages.online,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: bodyText(
                                      context: context,
                                      textColor:
                                          mainAlign == onlineAlign
                                              ? getCurrentTheme(context).colorActiveOnlineText
                                              : getCurrentTheme(context).colorInActiveOnlineText,
                                      fontSize: textSize14px,
                                      fontWeight: FontWeight.w600,
                                    ).copyWith(height: 0),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            : Container();
      },
    );
  }
}
