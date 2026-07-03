import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/service_mode_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_service_mode_presentation.dart';
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

    final cards = <Widget>[
      for (var i = 0; i < visible.length; i++)
        _ModeCard(
          context: context,
          title: _titleFor(visible[i]),
          subtitle: _subtitleFor(visible[i].mode),
          icon: _iconFor(visible[i].mode),
          mode: visible[i].mode,
          selected: selectedMode == visible[i].mode,
          onTap: () => onModeSelected(visible[i].mode),
          compact: visible.length > 2,
        ),
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
                      icon: _iconFor(visible[i].mode),
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

    if (visible.length <= 2) {
      return Padding(
        padding: EdgeInsetsDirectional.only(
          start: commonHorizontalPadding,
          end: commonHorizontalPadding,
          bottom: 6.h,
        ),
        child: Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) SizedBox(width: 8.w),
              Expanded(child: cards[i]),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 6.h),
      child: SizedBox(
        height: 72.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsetsDirectional.only(
            start: commonHorizontalPadding,
            end: commonHorizontalPadding,
          ),
          itemCount: cards.length,
          separatorBuilder: (_, _) => SizedBox(width: 8.w),
          itemBuilder: (_, index) => SizedBox(width: 148.w, child: cards[index]),
        ),
      ),
    );
  }

  String _titleFor(ServiceModeGroup group) =>
      XistiServiceModePresentation.title(group.mode, groupLabel: group.label);

  String _subtitleFor(String mode) => XistiServiceModePresentation.subtitle(mode);

  IconData? _iconFor(String mode) => XistiServiceModePresentation.icon(mode);
}

class _SlimModePill extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String mode;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _SlimModePill({
    required this.context,
    required this.title,
    required this.mode,
    required this.icon,
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: selected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: XistiUiTokens.neonGlow(accent, alpha: 0.22),
                )
              : null,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.sp, color: selected ? XistiBrand.dark : theme.colorIconCommon),
                SizedBox(width: 6.w),
              ],
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: bodyText(
                    context: context,
                    fontSize: textSize13px,
                    fontWeight: FontWeight.w700,
                    textColor: selected ? XistiBrand.dark : theme.colorTextCommon,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String subtitle;
  final IconData? icon;
  final String mode;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  const _ModeCard({
    required this.context,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.mode,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final accent = XistiUiTokens.accentForMode(mode);
    return Material(
      color: selected ? accent.withValues(alpha: 0.12) : theme.colorWhite,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          constraints: BoxConstraints(minHeight: compact ? 64.h : accessibleMinTouch * 0.72),
          padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected ? accent : theme.colorDarkBorder,
              width: selected ? 2.sp : 1.sp,
            ),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 22.sp, color: selected ? accent : theme.colorIconCommon),
                SizedBox(width: 6.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyText(
                        context: context,
                        fontSize: textSize14px,
                        fontWeight: FontWeight.w700,
                        textColor: selected ? accent : theme.colorTextCommon,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyText(
                        context: context,
                        fontSize: textSize12px,
                        textColor: theme.colorTextLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
