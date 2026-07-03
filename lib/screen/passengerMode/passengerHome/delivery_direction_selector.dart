import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/delivery_direction_kind.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';

class DeliveryDirectionSelector extends StatelessWidget {
  const DeliveryDirectionSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _chip(
            context,
            DeliveryDirectionKind.send,
            DeliveryDirectionKind.label(DeliveryDirectionKind.send),
            Icons.call_made_rounded,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _chip(
            context,
            DeliveryDirectionKind.receive,
            DeliveryDirectionKind.label(DeliveryDirectionKind.receive),
            Icons.call_received_rounded,
          ),
        ),
      ],
    );
  }

  Widget _chip(BuildContext context, String value, String label, IconData icon) {
    final active = selected == value;
    final accent = XistiUiTokens.deliveryAccent;
    final theme = getCurrentTheme(context);
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: active ? accent.withValues(alpha: 0.12) : theme.colorScaffoldBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: active ? accent : theme.colorTextFieldBorder,
            width: active ? 1.5 : 1,
          ),
          boxShadow: active ? XistiUiTokens.neonGlow(accent, alpha: 0.15) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: active ? accent : theme.colorIconCommon),
            SizedBox(width: 5.w),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: bodyText(
                  context: context,
                  fontSize: 11.5.sp,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  textColor: active ? accent : theme.colorTextCommon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
