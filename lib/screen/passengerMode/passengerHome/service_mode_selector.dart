import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main.dart';
import '../../../utils/service_mode_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';

class ServiceModeSelector extends StatelessWidget {
  final String selectedMode;
  final List<ServiceModeGroup> groups;
  final ValueChanged<String> onModeSelected;
  final bool useSlimRail;

  const ServiceModeSelector({
    super.key,
    required this.selectedMode,
    required this.groups,
    required this.onModeSelected,
    this.useSlimRail = false,
  });

  @override
  Widget build(BuildContext context) {
    final visible = groups.isNotEmpty
        ? groups
        : [
            ServiceModeGroup(mode: ServiceModeKind.transport, label: languages.serviceModeTrips, displayOrder: 1, services: []),
            ServiceModeGroup(mode: ServiceModeKind.delivery, label: languages.serviceModeDelivery, displayOrder: 2, services: []),
          ];

    if (useSlimRail) {
      return Padding(
        padding: EdgeInsetsDirectional.only(
          start: commonHorizontalPadding,
          end: commonHorizontalPadding,
          bottom: 8.h,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: getCurrentTheme(context).colorScaffoldBg,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: getCurrentTheme(context).colorDarkBorder.withValues(alpha: 0.6)),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                for (var i = 0; i < visible.length; i++) ...[
                  if (i > 0) SizedBox(width: 4.w),
                  Expanded(
                    child: _SlimModePill(
                      context: context,
                      title: _titleFor(visible[i]),
                      mode: visible[i].mode,
                      selected: selectedMode == visible[i].mode,
                      onTap: () => onModeSelected(visible[i].mode),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: commonHorizontalPadding,
        end: commonHorizontalPadding,
        bottom: 6.h,
      ),
      child: Row(
        children: [
          for (var i = 0; i < visible.length; i++) ...[
            if (i > 0) SizedBox(width: 6.w),
            Expanded(
              child: _ModeChip(
                context: context,
                title: _titleFor(visible[i]),
                mode: visible[i].mode,
                selected: selectedMode == visible[i].mode,
                onTap: () => onModeSelected(visible[i].mode),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _titleFor(ServiceModeGroup group) {
    final mode = group.mode;
    if (ServiceModeKind.isAcarreosMode(mode)) return 'Carga';
    if (mode == ServiceModeKind.delivery) return languages.serviceModeDelivery;
    if (ServiceModeKind.isSharedRideMode(mode)) return languages.serviceModeShare;
    if (mode == ServiceModeKind.encomiendas) return languages.serviceModeErrand;
    return group.label;
  }
}

class _SlimModePill extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String mode;
  final bool selected;
  final VoidCallback onTap;

  const _SlimModePill({
    required this.context,
    required this.title,
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final accent = XistiUiTokens.accentForMode(mode);
    return Material(
      color: selected ? accent : Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: bodyText(
              context: context,
              fontSize: textSize12px,
              fontWeight: FontWeight.w700,
              textColor: selected ? XistiBrand.dark : theme.colorTextCommon,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String mode;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.context,
    required this.title,
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final accent = XistiUiTokens.accentForMode(mode);
    return Material(
      color: selected ? accent.withValues(alpha: 0.14) : theme.colorWhite,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: selected ? accent : theme.colorDarkBorder, width: selected ? 1.5 : 1),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: bodyText(
              context: context,
              fontSize: textSize12px,
              fontWeight: FontWeight.w700,
              textColor: selected ? accent : theme.colorTextCommon,
            ),
          ),
        ),
      ),
    );
  }
}
