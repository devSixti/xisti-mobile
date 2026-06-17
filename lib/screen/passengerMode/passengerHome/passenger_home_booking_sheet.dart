import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';

/// Fixed bottom booking panel — wireframe: barrios, vehículos, envío, CTA.
class PassengerHomeBookingSheet extends StatelessWidget {
  final List<Widget> children;

  const PassengerHomeBookingSheet({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    return Material(
      color: theme.colorScaffoldBg,
      elevation: 16,
      shadowColor: theme.colorBorder.withValues(alpha: 0.55),
      borderRadius: BorderRadius.vertical(top: Radius.circular(XistiUiTokens.sheetRadius)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(XistiUiTokens.sheetRadius)),
          border: Border(
            top: BorderSide(color: XistiBrand.green.withValues(alpha: 0.85), width: 2.w),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(top: 6.h, bottom: 4.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
