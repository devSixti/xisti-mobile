import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_home_ui_tokens.dart';

/// Draggable bottom sheet shell for vehicles, encomiendas fields and CTA.
class PassengerHomeBookingSheet extends StatelessWidget {
  final ScrollController scrollController;
  final List<Widget> children;

  const PassengerHomeBookingSheet({
    super.key,
    required this.scrollController,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScaffoldBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(XistiHomeUiTokens.sheetRadius)),
        boxShadow: [
          BoxShadow(
            color: theme.colorBorder.withValues(alpha: 0.45),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: EdgeInsetsDirectional.only(bottom: getBottomMargin()),
        children: [
          Center(
            child: Container(
              margin: EdgeInsetsDirectional.only(top: 10.h, bottom: 8.h),
              width: 48.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorIndicatorOff,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
