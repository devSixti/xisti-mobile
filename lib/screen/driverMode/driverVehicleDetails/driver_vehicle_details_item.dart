import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bottomSheet/vehicle_information_sheet.dart';
import '../../../commonView/xisti_vehicle_image.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_vehicle_catalog.dart';
import 'driver_vehicle_details_dl.dart';

class DriverVehicleServiceIcon extends StatelessWidget {
  final ServiceList serviceTypeItem;
  final ServiceList? selectedServiceTypeItem;

  const DriverVehicleServiceIcon({super.key, required this.serviceTypeItem, this.selectedServiceTypeItem});

  bool _isSameServiceSelection(ServiceList? selected, ServiceList item) {
    if (selected == null) {
      return false;
    }
    return selected.serviceId == item.serviceId && selected.deliveryVariant == item.deliveryVariant;
  }

  String _resolvedIcon() {
    final local = serviceTypeItem.serviceIcon;
    if (local.startsWith('assets/')) return local;
    return XistiVehicleCatalog.iconForDriver(
      serviceId: serviceTypeItem.serviceId,
      variant: serviceTypeItem.deliveryVariant,
      fallbackUrl: local,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = _isSameServiceSelection(selectedServiceTypeItem, serviceTypeItem);
    final theme = getCurrentTheme(context);
    final accent = theme.colorPrimary;

    return SizedBox(
      width: 92.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 88.w,
            height: 88.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18.r),
              border: selected
                  ? Border.all(color: accent, width: 2.w)
                  : Border.all(color: theme.colorBorder.withValues(alpha: 0.5), width: 1.w),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (selected)
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.35),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                XistiVehicleImage(
                  imagePath: _resolvedIcon(),
                  size: 76.w,
                ),
                if (selected)
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => VehicleInformationSheet(
                            serviceName: serviceTypeItem.serviceName,
                            serviceIcon: _resolvedIcon(),
                            serviceDescription: serviceTypeItem.serviceDescription,
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 4.h, end: 4.w),
                        child: Icon(CustomIcons.information, size: 14.sp, color: theme.colorIconCommon),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            serviceTypeItem.serviceName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: bodyText(
              context: context,
              textColor: selected ? accent : theme.colorTextCommon,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: textSize12px,
            ),
          ),
        ],
      ),
    );
  }
}
