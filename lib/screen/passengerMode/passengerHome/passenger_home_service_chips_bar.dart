import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/service_mode_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';

/// Compact horizontal chips for service modes — floats on the map (Xisti identity).
class PassengerHomeServiceChipsBar extends StatelessWidget {
  final String selectedMode;
  final List<ServiceModeGroup> groups;
  final ValueChanged<String> onModeSelected;

  const PassengerHomeServiceChipsBar({
    super.key,
    required this.selectedMode,
    required this.groups,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final visible = groups.isNotEmpty
        ? groups
        : [
            ServiceModeGroup(mode: ServiceModeKind.transport, label: 'Viajes', displayOrder: 1, services: []),
            ServiceModeGroup(mode: ServiceModeKind.delivery, label: 'Envío', displayOrder: 2, services: []),
          ];

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(horizontal: XistiUiTokens.overlayHorizontalPadding),
        itemCount: visible.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final group = visible[index];
          final selected = selectedMode == group.mode;
          final theme = getCurrentTheme(context);
          final accent = XistiUiTokens.accentForMode(group.mode);

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: selected ? 1.0 : 0.95, end: selected ? 1.0 : 0.95),
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
            child: Material(
              elevation: selected ? 2 : 0,
              shadowColor: accent.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(XistiUiTokens.chipRadius),
              color: selected ? accent : theme.colorScaffoldBg.withValues(alpha: 0.94),
              child: InkWell(
                onTap: () => onModeSelected(group.mode),
                borderRadius: BorderRadius.circular(XistiUiTokens.chipRadius),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(XistiUiTokens.chipRadius),
                    border: Border.all(
                      color: selected ? accent : theme.colorDarkBorder,
                      width: selected ? 1.5.sp : 1.sp,
                    ),
                    boxShadow: selected ? XistiUiTokens.neonGlow(accent, alpha: 0.2) : null,
                  ),
                  child: Text(
                    group.label,
                    style: bodyText(
                      context: context,
                      fontSize: textSize13px,
                      fontWeight: FontWeight.w600,
                      textColor: selected ? theme.colorBlack : theme.colorTextCommon,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
