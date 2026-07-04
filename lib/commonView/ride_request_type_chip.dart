import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../constant/constant.dart';
import '../main.dart';
import '../utils/service_mode_util.dart';
import '../utils/utils.dart';
import '../utils/xisti_vehicle_catalog.dart';
import '../utils/xisti_ui_tokens.dart';

/// Compact service labels on driver request previews (list, sheet, push UI).
class RideRequestTypeChip extends StatelessWidget {
  final int? serviceId;
  final String? serviceMode;
  final int? isDelivery;
  final int? isEncomienda;
  final String? serviceName;
  final String? vehicleVariant;
  final int? isTaxi;

  const RideRequestTypeChip({
    super.key,
    this.serviceId,
    this.serviceMode,
    this.isDelivery,
    this.isEncomienda,
    this.serviceName,
    this.vehicleVariant,
    this.isTaxi,
  });

  @override
  Widget build(BuildContext context) {
    final chips = _resolveChips();
    if (chips.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 6.w,
      runSpacing: 4.h,
      children: [
        for (final chip in chips)
          _chip(context, label: chip.$1, icon: chip.$2, accent: chip.$3),
      ],
    );
  }

  List<(String, IconData, Color)> _resolveChips() {
    final chips = <(String, IconData, Color)>[];
    final modeChip = _serviceModeChip();
    if (modeChip != null) chips.add(modeChip);

    final vehicle = _vehicleChip();
    if (vehicle != null) chips.add(vehicle);

    final showTaxi = isTaxi == 1 && XistiVehicleCatalog.taxiEligibleVariant(vehicleVariant);
    if (showTaxi) {
      chips.add((languages.taxiYellowTag, Icons.local_taxi_outlined, AppThemeColors.brandGreen));
    }
    return chips;
  }

  (String, IconData, Color)? _serviceModeChip() {
    if (isEncomienda == 1 || serviceMode == ServiceModeKind.encomiendas) {
      return (languages.chipErrand, Icons.local_shipping_outlined, XistiBrand.purpleMedium);
    }
    if (ServiceModeKind.isExpresoMode(serviceMode)) {
      return (languages.chipShare, Icons.people_outline, const Color(0xFF6A1B9A));
    }
    if (ServiceModeKind.isAcarreosMode(serviceMode)) {
      return (languages.chipHauling, Icons.local_shipping_outlined, XistiBrand.purpleDeep);
    }
    if (ServiceModeKind.isDeliveryRideRequest(serviceId: serviceId, isDelivery: isDelivery) ||
        serviceMode == ServiceModeKind.delivery) {
      return (languages.chipDelivery, Icons.inventory_2_outlined, XistiBrand.purple);
    }
    if (serviceMode == ServiceModeKind.transport || serviceId != null) {
      return (languages.serviceModeTrips, Icons.directions_car_outlined, const Color(0xFF2E7D32));
    }
    return null;
  }

  (String, IconData, Color)? _vehicleChip() {
    if (isEncomienda == 1 || serviceMode == ServiceModeKind.encomiendas) return null;
    if (serviceMode == ServiceModeKind.expreso) return null;

    if (ServiceModeKind.isDeliveryRideRequest(serviceId: serviceId, isDelivery: isDelivery) ||
        serviceMode == ServiceModeKind.delivery) {
      final name = XistiVehicleCatalog.labelFor(
        serviceId: serviceId,
        variant: vehicleVariant,
        fallbackServiceName: serviceName,
      );
      return (name, Icons.two_wheeler_outlined, const Color(0xFF6A1B9A));
    }

    final transportLabel = XistiVehicleCatalog.labelFor(
      serviceId: serviceId,
      variant: vehicleVariant,
      fallbackServiceName: serviceName,
    );
    switch (serviceId) {
      case ServiceType.taxi:
        return (transportLabel, Icons.directions_car_outlined, const Color(0xFF1565C0));
      case ServiceType.bike:
        return (transportLabel, Icons.two_wheeler_outlined, const Color(0xFF2E7D32));
      case ServiceType.courier:
        return (languages.vehicleBicicleta, Icons.pedal_bike_outlined, XistiBrand.purpleMedium);
      default:
        if (serviceMode == ServiceModeKind.transport && transportLabel.isNotEmpty) {
          return (transportLabel, CustomIcons.car, const Color(0xFF1565C0));
        }
        return null;
    }
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color accent,
  }) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accent, size: 11.sp),
          SizedBox(width: 3.w),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: bodyText(
                context: context,
                fontSize: textSize10px,
                fontWeight: FontWeight.w700,
                textColor: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
