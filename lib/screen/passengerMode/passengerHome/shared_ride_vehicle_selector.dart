import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';
import '../../../utils/xisti_vehicle_catalog.dart';
import 'xisti_section_label.dart';

/// Passenger filter: carro económico, eléctrico o cómodo for shared-ride search.
class SharedRideVehicleSelector extends StatelessWidget {
  final String? selectedVariant;
  final ValueChanged<String?> onChanged;

  const SharedRideVehicleSelector({
    super.key,
    required this.selectedVariant,
    required this.onChanged,
  });

  static const variants = [
    XistiVehicleCatalog.carroEconomico,
    XistiVehicleCatalog.carroEco,
    XistiVehicleCatalog.carroComodo,
  ];

  @override
  Widget build(BuildContext context) {
    final accent = XistiUiTokens.accentForMode('expreso');
    final theme = getCurrentTheme(context);

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: commonHorizontalPadding,
        end: commonHorizontalPadding,
        bottom: 8.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          XistiSectionLabel(label: 'Tipo de vehículo', accent: accent),
          SizedBox(height: 6.h),
          Row(
            children: [
              for (var i = 0; i < variants.length; i++) ...[
                if (i > 0) SizedBox(width: 8.w),
                Expanded(
                  child: _chip(
                    context,
                    variant: variants[i],
                    label: XistiVehicleCatalog.labelFor(serviceId: 1, variant: variants[i]),
                    selected: selectedVariant == variants[i],
                    accent: accent,
                    theme: theme,
                    onTap: () => onChanged(variants[i]),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 4.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: selectedVariant == null ? null : () => onChanged(null),
              child: Text(
                'Cualquier tipo',
                style: bodyText(context: context, fontSize: textSize12px, textColor: accent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String variant,
    required String label,
    required bool selected,
    required Color accent,
    required dynamic theme,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? accent.withValues(alpha: 0.14) : theme.colorScaffoldBg,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected ? accent : theme.colorDarkBorder,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Image.asset(
                XistiVehicleCatalog.iconAsset(variant),
                width: 36.w,
                height: 36.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: bodyText(
                  context: context,
                  fontSize: textSize10px,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  textColor: selected ? accent : theme.colorTextCommon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
