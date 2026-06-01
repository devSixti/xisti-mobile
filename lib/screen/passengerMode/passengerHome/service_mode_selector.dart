import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/service_mode_util.dart';
import '../../../utils/utils.dart';

class ServiceModeSelector extends StatelessWidget {
  final String selectedMode;
  final List<ServiceModeGroup> groups;
  final ValueChanged<String> onModeSelected;

  const ServiceModeSelector({
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

    final cards = <Widget>[
      for (var i = 0; i < visible.length; i++)
        _ModeCard(
          context: context,
          title: visible[i].label,
          subtitle: _subtitleFor(visible[i].mode),
          icon: _iconFor(visible[i].mode),
          selected: selectedMode == visible[i].mode,
          onTap: () => onModeSelected(visible[i].mode),
          compact: visible.length > 2,
        ),
    ];

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

  String _subtitleFor(String mode) {
    switch (mode) {
      case ServiceModeKind.delivery:
        return 'Paquetes';
      case ServiceModeKind.expreso:
        return 'Larga distancia';
      case ServiceModeKind.encomiendas:
        return 'Compras';
      case ServiceModeKind.transport:
      default:
        return 'Movilidad';
    }
  }

  IconData _iconFor(String mode) {
    switch (mode) {
      case ServiceModeKind.delivery:
        return CustomIcons.description;
      case ServiceModeKind.encomiendas:
        return CustomIcons.description;
      case ServiceModeKind.expreso:
        return CustomIcons.locationRadius;
      case ServiceModeKind.transport:
      default:
        return CustomIcons.car;
    }
  }
}

class _ModeCard extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  const _ModeCard({
    required this.context,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    return Material(
      color: selected ? theme.colorPrimary.withValues(alpha: 0.12) : theme.colorWhite,
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
              color: selected ? theme.colorPrimary : theme.colorDarkBorder,
              width: selected ? 2.sp : 1.sp,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22.sp, color: selected ? theme.colorPrimary : theme.colorIconCommon),
              SizedBox(width: 6.w),
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
                        textColor: selected ? theme.colorPrimary : theme.colorTextCommon,
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
