import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
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
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _chip(
            context,
            DeliveryDirectionKind.receive,
            DeliveryDirectionKind.label(DeliveryDirectionKind.receive),
          ),
        ),
      ],
    );
  }

  Widget _chip(BuildContext context, String value, String label) {
    final active = selected == value;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: active ? XistiUiTokens.deliveryAccent : getCurrentTheme(context).colorTextFieldBorder,
            width: active ? 2 : 1,
          ),
          color: active ? XistiUiTokens.deliveryAccent.withValues(alpha: 0.08) : getCurrentTheme(context).colorTextFieldBg,
          boxShadow: active ? XistiUiTokens.neonGlow(XistiUiTokens.deliveryAccent, alpha: 0.12) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: bodyText(
            context: context,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            textColor: active ? XistiUiTokens.deliveryAccent : getCurrentTheme(context).colorTextCommon,
          ),
        ),
      ),
    );
  }
}
