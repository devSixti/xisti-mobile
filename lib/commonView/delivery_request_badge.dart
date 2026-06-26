import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../main.dart';
import '../utils/utils.dart';

/// Prominent label so drivers can tell envíos apart from passenger transport.
class DeliveryRequestBadge extends StatelessWidget {
  final bool expanded;

  const DeliveryRequestBadge({super.key, this.expanded = false});

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final accent = const Color(0xFFE65100);

    if (expanded) {
      return Container(
        width: double.infinity,
        margin: EdgeInsetsDirectional.only(
          start: commonHorizontalPadding,
          end: commonHorizontalPadding,
          bottom: 12.h,
        ),
        padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: accent.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Icon(Icons.local_shipping_outlined, color: accent, size: 22.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languages.serviceModeDelivery,
                    style: bodyText(
                      context: context,
                      fontSize: textSize16px,
                      fontWeight: FontWeight.w700,
                      textColor: accent,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    languages.deliveryNotPassengerTransport,
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
      );
    }

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_shipping_outlined, color: accent, size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            languages.serviceModeDelivery,
            style: bodyText(
              context: context,
              fontSize: textSize12px,
              fontWeight: FontWeight.w700,
              textColor: accent,
            ),
          ),
        ],
      ),
    );
  }
}
