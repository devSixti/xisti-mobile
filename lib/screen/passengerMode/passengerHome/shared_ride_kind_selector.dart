import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/service_mode_util.dart';
import '../../../utils/shared_ride_kind.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';

class SharedRideKindSelector extends StatelessWidget {
  final String selectedKind;
  final ValueChanged<String> onKindChanged;

  const SharedRideKindSelector({
    super.key,
    required this.selectedKind,
    required this.onKindChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: commonHorizontalPadding,
        end: commonHorizontalPadding,
        bottom: 6.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: _chip(context, SharedRideKind.puebloPueblo, Icons.place_outlined),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _chip(context, SharedRideKind.puebloCiudad, Icons.location_city_outlined),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String kind, IconData icon) {
    final isSelected = selectedKind == kind;
    final theme = getCurrentTheme(context);
    final accent = XistiUiTokens.accentForMode(ServiceModeKind.expreso);
    return GestureDetector(
      onTap: () => onKindChanged(kind),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsetsDirectional.symmetric(vertical: 8.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: isSelected ? accent.withValues(alpha: 0.12) : theme.colorScaffoldBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? accent : theme.colorTextFieldBorder,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? XistiUiTokens.neonGlow(accent, alpha: 0.15) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: isSelected ? accent : theme.colorIconCommon),
            SizedBox(width: 5.w),
            Flexible(
              child: Text(
                SharedRideKind.label(kind),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: bodyText(
                  context: context,
                  fontSize: 11.5.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  textColor: isSelected ? accent : theme.colorTextCommon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
