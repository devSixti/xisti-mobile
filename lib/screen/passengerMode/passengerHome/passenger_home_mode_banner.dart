import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_service_mode_presentation.dart';

String xistiModeBannerCopy(String? mode) => XistiServiceModePresentation.subtitle(mode ?? ServiceModeKind.transport);

IconData xistiModeBannerIcon(String? mode) => XistiServiceModePresentation.icon(mode ?? ServiceModeKind.transport);

/// Animated accent strip reflecting the active service mode.
class PassengerHomeModeBanner extends StatelessWidget {
  final String? serviceMode;

  const PassengerHomeModeBanner({super.key, required this.serviceMode});

  @override
  Widget build(BuildContext context) {
    final accent = XistiUiTokens.accentForMode(serviceMode);
    final theme = getCurrentTheme(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: EdgeInsetsDirectional.only(
        start: XistiUiTokens.overlayHorizontalPadding,
        end: XistiUiTokens.overlayHorizontalPadding,
        top: 6.h,
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: XistiUiTokens.modeBannerDecoration(accent, theme.colorScaffoldBg),
      child: Row(
        children: [
          Icon(xistiModeBannerIcon(serviceMode), size: 18.sp, color: accent),
          SizedBox(width: 8.w),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: Text(
                xistiModeBannerCopy(serviceMode),
                key: ValueKey(serviceMode ?? 'transport'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: bodyText(context: context, fontSize: textSize12px, fontWeight: FontWeight.w500, textColor: accent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
