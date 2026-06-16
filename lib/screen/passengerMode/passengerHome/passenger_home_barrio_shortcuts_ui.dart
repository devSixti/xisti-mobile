import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';
import 'passenger_home_barrio_shortcuts.dart';

/// Horizontal zone chips — tap to fly map camera to Medellín neighborhoods.
class PassengerHomeBarrioShortcuts extends StatelessWidget {
  final ValueChanged<XistiBarrioShortcut> onBarrioSelected;

  const PassengerHomeBarrioShortcuts({super.key, required this.onBarrioSelected});

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);

    return SizedBox(
      height: 34.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(horizontal: XistiUiTokens.overlayHorizontalPadding),
        itemCount: kXistiBarrioShortcuts.length,
        separatorBuilder: (_, _) => SizedBox(width: 6.w),
        itemBuilder: (context, index) {
          final barrio = kXistiBarrioShortcuts[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onBarrioSelected(barrio),
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: theme.colorScaffoldBg.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: XistiBrand.purple.withValues(alpha: 0.45)),
                ),
                child: Text(
                  barrio.label,
                  style: bodyText(context: context, fontSize: textSize10px, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
