import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/constant.dart';
import '../utils/service_mode_util.dart';
import '../utils/utils.dart';

/// Compact service label on driver request previews (list, sheet, push UI).
class RideRequestTypeChip extends StatelessWidget {
  final int? serviceId;
  final String? serviceMode;
  final int? isDelivery;
  final int? isEncomienda;

  const RideRequestTypeChip({
    super.key,
    this.serviceId,
    this.serviceMode,
    this.isDelivery,
    this.isEncomienda,
  });

  @override
  Widget build(BuildContext context) {
    final chip = _resolveChip();
    if (chip == null) return const SizedBox.shrink();
    return _chip(
      context,
      label: chip.$1,
      icon: chip.$2,
      accent: chip.$3,
    );
  }

  (String, IconData, Color)? _resolveChip() {
    if (isEncomienda == 1 || serviceMode == ServiceModeKind.encomiendas) {
      return ('Envío', Icons.local_shipping_outlined, const Color(0xFF00838F));
    }
    if (serviceMode == ServiceModeKind.expreso) {
      return ('Expreso', Icons.bolt_outlined, const Color(0xFF6A1B9A));
    }
    if (ServiceModeKind.isDeliveryRideRequest(
      serviceId: serviceId,
      isDelivery: isDelivery,
    ) ||
        serviceMode == ServiceModeKind.delivery) {
      return ('Envío', Icons.local_shipping_outlined, const Color(0xFFE65100));
    }
    switch (serviceId) {
      case ServiceType.taxi:
        return ('Carro', Icons.directions_car_outlined, const Color(0xFF1565C0));
      case ServiceType.bike:
        return ('Moto', Icons.two_wheeler_outlined, const Color(0xFF2E7D32));
      case ServiceType.rickshaw:
        return ('Motoratón', Icons.electric_rickshaw_outlined, const Color(0xFF558B2F));
      case ServiceType.courier:
        return ('Envío', Icons.local_shipping_outlined, const Color(0xFFE65100));
      default:
        if (serviceMode == ServiceModeKind.transport) {
          return ('Viaje', CustomIcons.car, const Color(0xFF2E7D32));
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
