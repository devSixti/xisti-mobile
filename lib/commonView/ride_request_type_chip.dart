import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../constant/constant.dart';
import '../main.dart';
import '../utils/service_mode_util.dart';
import '../utils/utils.dart';
import '../utils/xisti_vehicle_catalog.dart';

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
    final label = _resolveLabel();
    if (label == null) return const SizedBox.shrink();
    final showTaxi = isTaxi == 1 &&
        XistiVehicleCatalog.taxiEligibleVariant(vehicleVariant);
    return Wrap(
      spacing: 6.w,
      runSpacing: 4.h,
      children: [
        _chip(context, label: label.$1, icon: label.$2, accent: label.$3),
        if (showTaxi)
          _chip(
            context,
            label: languages.taxiYellowTag,
            icon: Icons.local_taxi_outlined,
            accent: AppThemeColors.brandGreen,
          ),
      ],
    );
  }

  (String, IconData, Color)? _resolveLabel() {
    if (isEncomienda == 1 || serviceMode == ServiceModeKind.encomiendas) {
      return (languages.chipErrand, Icons.local_shipping_outlined, const Color(0xFF00838F));
    }
    if (serviceMode == ServiceModeKind.expreso) {
      return (languages.chipShare, Icons.bolt_outlined, const Color(0xFF6A1B9A));
    }
    if (ServiceModeKind.isDeliveryRideRequest(
      serviceId: serviceId,
      isDelivery: isDelivery,
    ) ||
        serviceMode == ServiceModeKind.delivery) {
      final name = XistiVehicleCatalog.labelFor(
        serviceId: serviceId,
        variant: vehicleVariant,
        fallbackServiceName: serviceName,
      );
      return (name, Icons.local_shipping_outlined, const Color(0xFFE65100));
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
        return (languages.vehicleBicicleta, Icons.pedal_bike_outlined, const Color(0xFFE65100));
      default:
        if (serviceMode == ServiceModeKind.transport) {
          return (transportLabel, CustomIcons.car, const Color(0xFF2E7D32));
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
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accent, size: 13.sp),
          SizedBox(width: 4.w),
          Text(
            label,
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
