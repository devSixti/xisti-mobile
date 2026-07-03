import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../main.dart';
import '../utils/utils.dart';

class FareTripSummary extends StatelessWidget {
  final double recommendedFare;
  final double minFare;
  final double maxFare;
  final String distanceLabel;
  final String durationLabel;
  final Color accent;
  final String? serviceCategoryLabel;
  final String? vehicleTypeLabel;

  const FareTripSummary({
    super.key,
    required this.recommendedFare,
    required this.minFare,
    required this.maxFare,
    required this.distanceLabel,
    required this.durationLabel,
    this.accent = const Color(0xFF80FF00),
    this.serviceCategoryLabel,
    this.vehicleTypeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    return Container(
      margin: EdgeInsetsDirectional.only(top: 10.h),
      padding: EdgeInsetsDirectional.all(12.w),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((serviceCategoryLabel ?? '').isNotEmpty || (vehicleTypeLabel ?? '').isNotEmpty) ...[
            Wrap(
              spacing: 8.w,
              runSpacing: 4.h,
              children: [
                if ((serviceCategoryLabel ?? '').isNotEmpty)
                  _tag(context, serviceCategoryLabel!, accent),
                if ((vehicleTypeLabel ?? '').isNotEmpty)
                  _tag(context, vehicleTypeLabel!, accent.withValues(alpha: 0.85)),
              ],
            ),
            SizedBox(height: 8.h),
          ],
          _bullet(context, languages.distanceKm(distanceLabel)),
          _bullet(context, '${languages.minutes}: $durationLabel min'),
          _bullet(context, '${languages.recommendedFare}: ${getAmountWithCurrency(recommendedFare)}'),
          _bullet(context, '${languages.minFare}: ${getAmountWithCurrency(minFare)}'),
          _bullet(context, '${languages.maxFare}: ${getAmountWithCurrency(maxFare)}'),
          SizedBox(height: 4.h),
          Text(
            languages.fareEstimateDisclaimer,
            style: bodyText(context: context, fontSize: textSize12px, textColor: theme.colorTextLight),
          ),
        ],
      ),
    );
  }

  Widget _bullet(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: bodyText(context: context, fontWeight: FontWeight.w700)),
          Expanded(child: Text(text, style: bodyText(context: context, fontWeight: FontWeight.w500, fontSize: textSize14px))),
        ],
      ),
    );
  }

  Widget _tag(BuildContext context, String text, Color color) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: bodyText(context: context, fontSize: textSize12px, fontWeight: FontWeight.w700, textColor: color),
      ),
    );
  }
}
