import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';
import 'passenger_home_barrio_shortcuts.dart';

/// Horizontal zone chips — tap to fly map camera to neighborhoods in the active main city.
/// Clipped with edge fade so items appear to enter/exit within the panel.
class PassengerHomeBarrioShortcuts extends StatelessWidget {
  final List<XistiBarrioShortcut> shortcuts;
  final ValueChanged<XistiBarrioShortcut> onBarrioSelected;
  final Color? accentColor;

  const PassengerHomeBarrioShortcuts({
    super.key,
    required this.shortcuts,
    required this.onBarrioSelected,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (shortcuts.isEmpty) return const SizedBox.shrink();

    final theme = getCurrentTheme(context);
    final accent = accentColor ?? XistiBrand.purple;

    return SizedBox(
      height: 24.h,
      child: ClipRect(
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) {
            return const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.black,
                Colors.black,
                Colors.transparent,
              ],
              stops: [0.0, 0.08, 0.92, 1.0],
            ).createShader(bounds);
          },
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.symmetric(horizontal: XistiUiTokens.overlayHorizontalPadding),
            clipBehavior: Clip.hardEdge,
            itemCount: shortcuts.length,
            separatorBuilder: (_, _) => SizedBox(width: 6.w),
            itemBuilder: (context, index) {
              final barrio = shortcuts[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onBarrioSelected(barrio),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 9.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: theme.colorScaffoldBg.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: accent.withValues(alpha: 0.45)),
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
        ),
      ),
    );
  }
}
