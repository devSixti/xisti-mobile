import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';

/// Fixed bottom booking panel — wireframe: barrios, vehículos, CTA.
class PassengerHomeBookingSheet extends StatelessWidget {
  final List<Widget>? children;
  final Widget? body;
  final bool expandToFill;

  const PassengerHomeBookingSheet({
    super.key,
    this.children,
    this.body,
    this.expandToFill = false,
  }) : assert(children != null || body != null, 'Provide children or body');

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final inner = body ??
        SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(
            top: 6.h,
            bottom: expandToFill ? bottomInset + 10.h : 4.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children!,
          ),
        );

    return Material(
      color: theme.colorScaffoldBg,
      elevation: 16,
      shadowColor: theme.colorBorder.withValues(alpha: 0.55),
      borderRadius: BorderRadius.vertical(top: Radius.circular(XistiUiTokens.sheetRadius)),
      child: Container(
        width: double.infinity,
        height: expandToFill ? double.infinity : null,
        decoration: BoxDecoration(
          color: theme.colorScaffoldBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(XistiUiTokens.sheetRadius)),
          border: Border(
            top: BorderSide(color: XistiBrand.green.withValues(alpha: 0.85), width: 2.w),
          ),
        ),
        child: expandToFill
            ? Padding(
                padding: EdgeInsetsDirectional.only(bottom: bottomInset),
                child: Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: inner,
                ),
              )
            : inner,
      ),
    );
  }
}
