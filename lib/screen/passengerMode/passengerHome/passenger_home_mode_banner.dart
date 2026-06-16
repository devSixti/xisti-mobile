import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/service_mode_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';

String xistiModeBannerCopy(String? mode) {
  switch (mode) {
    case ServiceModeKind.delivery:
      return 'Envío urbano · Pago en destino disponible';
    case ServiceModeKind.encomiendas:
      return 'Encomiendas · Compramos y entregamos';
    case ServiceModeKind.expreso:
      return 'Expreso · Rutas intermunicipales';
    case ServiceModeKind.transport:
    default:
      return 'Viajes · Negocia tu tarifa en COP 500';
  }
}

IconData xistiModeBannerIcon(String? mode) {
  switch (mode) {
    case ServiceModeKind.delivery:
      return CustomIcons.orderId;
    case ServiceModeKind.encomiendas:
      return CustomIcons.myWallet;
    case ServiceModeKind.expreso:
      return CustomIcons.car;
    default:
      return CustomIcons.hailRide;
  }
}

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
