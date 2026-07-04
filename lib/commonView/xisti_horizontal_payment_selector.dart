import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/offer_payment_icon.dart';
import '../utils/utils.dart';
import '../utils/xisti_ui_tokens.dart';

/// Horizontal scrolleable payment chips (courier / destination payment).
class XistiHorizontalPaymentSelector<T> extends StatelessWidget {
  final List<T> options;
  final T? selected;
  final ValueChanged<T> onSelected;
  final String Function(T item) labelOf;
  final int Function(T item) paymentTypeOf;
  final String Function(T item) destinationCodeOf;

  const XistiHorizontalPaymentSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.labelOf,
    required this.paymentTypeOf,
    required this.destinationCodeOf,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    if (options.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final item = options[index];
          final isSelected = selected == item;
          return GestureDetector(
            onTap: () => onSelected(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: XistiUiTokens.glassCard(
                background: theme.colorScaffoldBg,
                borderColor: theme.colorDarkBorder,
                accent: XistiBrand.green,
                selected: isSelected,
                radius: XistiUiTokens.chipRadius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildOfferPaymentIcon(
                    context,
                    paymentType: paymentTypeOf(item),
                    destinationPaymentCode: destinationCodeOf(item),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    labelOf(item),
                    style: bodyText(
                      context: context,
                      fontSize: textSize13px,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
