import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/service_mode_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';
import 'passenger_home_dl.dart';

String xistiHomeHeroSubtitleForMode(String? mode) {
  switch (mode) {
    case ServiceModeKind.delivery:
      return 'Paquetes y envíos en Medellín';
    case ServiceModeKind.encomiendas:
      return 'Compramos y te lo llevamos';
    case ServiceModeKind.expreso:
      return 'Viajes intermunicipales';
    case ServiceModeKind.transport:
    default:
      return 'Viaje urbano · Fácil y Seguro';
  }
}

/// Floating search card on top of the map (Xisti multiservice entry point).
class PassengerHomeSearchCard extends StatelessWidget {
  final String? serviceMode;
  final SearchedLocation? pickup;
  final SearchedLocation? dropoff;
  final List<Map<String, dynamic>> recentTrips;
  final VoidCallback onPickupTap;
  final VoidCallback onDropoffTap;
  final VoidCallback? onClearPickup;
  final VoidCallback? onClearDropoff;
  final void Function(Map<String, dynamic> entry)? onRecentDestinationTap;

  const PassengerHomeSearchCard({
    super.key,
    required this.serviceMode,
    required this.pickup,
    required this.dropoff,
    required this.recentTrips,
    required this.onPickupTap,
    required this.onDropoffTap,
    this.onClearPickup,
    this.onClearDropoff,
    this.onRecentDestinationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final accent = XistiUiTokens.accentForMode(serviceMode);
    final pickupHint = serviceMode == ServiceModeKind.encomiendas ? 'Dónde comprar' : languages.pickUpLocation;
    final dropHint = serviceMode == ServiceModeKind.encomiendas ? 'Dónde entregar' : languages.dropLocation;
    final showRecents = (dropoff?.name ?? '').isEmpty && recentTrips.isNotEmpty;

    return Container(
      margin: EdgeInsetsDirectional.only(
        start: XistiUiTokens.overlayHorizontalPadding,
        end: XistiUiTokens.overlayHorizontalPadding + 48.w,
      ),
      padding: EdgeInsetsDirectional.fromSTEB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: theme.colorScaffoldBg.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(XistiUiTokens.searchCardRadius),
        border: Border.all(color: accent.withValues(alpha: 0.45), width: 1.sp),
        boxShadow: XistiUiTokens.floatingShadow(context, theme.colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'XISTI',
                style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w800, textColor: XistiBrand.green),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child: Text(
                    xistiHomeHeroSubtitleForMode(serviceMode),
                    key: ValueKey(serviceMode ?? 'transport'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: bodyText(context: context, fontSize: textSize12px, textColor: theme.colorTextLight),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _routeRow(
            context: context,
            icon: CustomIcons.pickupLocation,
            iconColor: XistiBrand.green,
            label: pickup?.name ?? pickupHint,
            hasValue: (pickup?.name ?? '').isNotEmpty,
            onTap: onPickupTap,
            onClear: onClearPickup,
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 12.w),
            child: Container(width: 2.w, height: 14.h, color: theme.colorDarkBorder),
          ),
          _routeRow(
            context: context,
            icon: CustomIcons.dropLocation,
            iconColor: XistiBrand.purple,
            label: dropoff?.name ?? dropHint,
            hasValue: (dropoff?.name ?? '').isNotEmpty,
            onTap: onDropoffTap,
            onClear: onClearDropoff,
            emphasized: true,
          ),
          if (showRecents) ...[
            SizedBox(height: 10.h),
            SizedBox(
              height: 36.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recentTrips.length > 3 ? 3 : recentTrips.length,
                separatorBuilder: (_, _) => SizedBox(width: 6.w),
                itemBuilder: (context, index) {
                  final entry = recentTrips[index];
                  final dest = entry['destination_name']?.toString() ?? '';
                  final isDelivery = entry['is_delivery'] == 1 || entry['is_delivery'] == true;
                  return GestureDetector(
                    onTap: () => onRecentDestinationTap?.call(entry),
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: (isDelivery ? XistiBrand.purple : XistiBrand.green).withValues(alpha: 0.1),
                        border: Border.all(color: (isDelivery ? XistiBrand.purple : XistiBrand.green).withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isDelivery ? CustomIcons.orderId : CustomIcons.hailRide,
                            size: 14.sp,
                            color: isDelivery ? XistiBrand.purple : XistiBrand.green,
                          ),
                          SizedBox(width: 6.w),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 120.w),
                            child: Text(
                              dest,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: bodyText(context: context, fontSize: textSize12px, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _routeRow({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required bool hasValue,
    required VoidCallback onTap,
    VoidCallback? onClear,
    bool emphasized = false,
  }) {
    final theme = getCurrentTheme(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Icon(icon, size: 22.sp, color: iconColor),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: bodyText(
                    context: context,
                    fontWeight: emphasized ? FontWeight.w600 : FontWeight.w500,
                    textColor: hasValue ? theme.colorTextCommon : theme.colorTextLight,
                  ),
                ),
              ),
              if (hasValue && onClear != null)
                GestureDetector(
                  onTap: onClear,
                  child: Icon(CustomIcons.remove, size: 22.sp, color: theme.colorIconLight),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
