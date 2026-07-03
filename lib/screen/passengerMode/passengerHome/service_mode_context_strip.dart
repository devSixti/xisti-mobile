import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/service_mode_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_service_mode_presentation.dart';
import '../../../utils/xisti_ui_tokens.dart';

/// Mode hero strip — icon, title and subtitle with accent (distinctive XISTI identity).
class ServiceModeContextStrip extends StatelessWidget {
  final String? mode;
  final String? groupLabel;

  const ServiceModeContextStrip({
    super.key,
    required this.mode,
    this.groupLabel,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = mode ?? ServiceModeKind.transport;
    final accent = XistiUiTokens.accentForMode(resolved);
    final theme = getCurrentTheme(context);

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: commonHorizontalPadding,
        end: commonHorizontalPadding,
        top: 6.h,
        bottom: 4.h,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: LinearGradient(
            begin: AlignmentDirectional.centerStart,
            end: AlignmentDirectional.centerEnd,
            colors: [
              accent.withValues(alpha: 0.14),
              accent.withValues(alpha: 0.05),
            ],
          ),
          border: Border.all(color: accent.withValues(alpha: 0.35)),
          boxShadow: XistiUiTokens.neonGlow(accent, alpha: 0.12),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.18),
                border: Border.all(color: accent.withValues(alpha: 0.45)),
              ),
              child: Icon(
                XistiServiceModePresentation.icon(resolved),
                size: 20.sp,
                color: accent,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    XistiServiceModePresentation.title(resolved, groupLabel: groupLabel),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: bodyText(
                      context: context,
                      fontSize: textSize14px,
                      fontWeight: FontWeight.w700,
                      textColor: accent,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    XistiServiceModePresentation.subtitle(resolved),
                    maxLines: 2,
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
    );
  }
}
