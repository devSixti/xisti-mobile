import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';

/// Fixed bottom booking panel — vehicles, envío fields and CTA (not draggable).
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
      elevation: 12,
      shadowColor: theme.colorBorder.withValues(alpha: 0.5),
      borderRadius: BorderRadius.vertical(top: Radius.circular(XistiUiTokens.sheetRadius)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsetsDirectional.only(top: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}
