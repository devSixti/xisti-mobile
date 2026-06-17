import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';

/// Fixed bottom booking panel — wireframe: barrios, vehículos, envío, CTA.
class PassengerHomeBookingSheet extends StatelessWidget {
  final List<Widget> children;
  final bool expandToFill;

  const PassengerHomeBookingSheet({
    super.key,
    required this.children,
    this.expandToFill = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final content = SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(
        top: 6.h,
        bottom: expandToFill ? bottomInset + 10.h : 4.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
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
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: content),
                ],
              )
            : content,
      ),
    );
  }
}
