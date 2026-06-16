import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/service_mode_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_home_ui_tokens.dart';

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
        padding: EdgeInsetsDirectional.symmetric(horizontal: XistiHomeUiTokens.overlayHorizontalPadding),
        itemCount: visible.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final group = visible[index];
          final selected = selectedMode == group.mode;
          final theme = getCurrentTheme(context);
          return Material(
            elevation: selected ? 2 : 0,
            shadowColor: theme.colorPrimary.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(XistiHomeUiTokens.chipRadius),
            color: selected ? theme.colorPrimary : theme.colorScaffoldBg.withValues(alpha: 0.94),
            child: InkWell(
              onTap: () => onModeSelected(group.mode),
              borderRadius: BorderRadius.circular(XistiHomeUiTokens.chipRadius),
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(XistiHomeUiTokens.chipRadius),
                  border: Border.all(
                    color: selected ? theme.colorPrimary : theme.colorDarkBorder,
                    width: selected ? 1.5.sp : 1.sp,
                  ),
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
          );
        },
      ),
    );
  }
}
