import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';
import 'passenger_home_activity_dl.dart';

/// Compact card for active ride or recent trip repeat — lives in sheet peek.
class PassengerHomeActivityHub extends StatelessWidget {
  final PassengerActivitySnapshot? snapshot;
  final VoidCallback? onTap;

  const PassengerHomeActivityHub({super.key, this.snapshot, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (snapshot == null) return const SizedBox.shrink();

    final theme = getCurrentTheme(context);
    final accent = snapshot!.isActive ? XistiBrand.green : XistiBrand.purple;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: XistiUiTokens.overlayHorizontalPadding,
        end: XistiUiTokens.overlayHorizontalPadding,
        bottom: 8.h,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(XistiUiTokens.cardRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: double.infinity,
            padding: EdgeInsetsDirectional.all(12.w),
            decoration: XistiUiTokens.glassCard(
              background: theme.colorScaffoldBg,
              borderColor: theme.colorDarkBorder,
              accent: accent,
              selected: snapshot!.isActive,
            ),
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    snapshot!.isActive ? CustomIcons.car : CustomIcons.dropLocation,
                    size: 20.sp,
                    color: accent,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bodyText(context: context, fontSize: textSize13px, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        snapshot!.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bodyText(context: context, fontSize: textSize12px, textColor: theme.colorTextLight),
                      ),
                    ],
                  ),
                ),
                Icon(CustomIcons.arrowForward, size: 18.sp, color: theme.colorIconLight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
