import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../appThemeManager/app_theme_colors.dart';
import '../../../bottomSheet/vehicle_information_sheet.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../constant/dimensions.dart';
import '../../../utils/custom_icons.dart';
import '../../../utils/style_util.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: 80.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 10.h, bottom: 5.h),
                  decoration: BoxDecoration(
                    color:
                        _isSameServiceSelection(selectedServiceTypeItem, serviceTypeItem)
                            ? getCurrentTheme(context).colorSelectionPrimaryOpc
                            : getCurrentTheme(context).colorScaffoldBg,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color:
                          _isSameServiceSelection(selectedServiceTypeItem, serviceTypeItem)
                              ? getCurrentTheme(context).colorPrimary
                              : getCurrentTheme(context).colorBorder,
                      width: 0.5.sp,
                    ),
                  ),
                  child: LoadImageWithPlaceHolder(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    imageFit: BoxFit.contain,
                    image: serviceTypeItem.serviceIcon,
                    defaultAssetImage: "assets/images/app_icon.png",
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              if (_isSameServiceSelection(selectedServiceTypeItem, serviceTypeItem))
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) {
                          return VehicleInformationSheet(
                            serviceName: serviceTypeItem.serviceName,
                            serviceIcon: serviceTypeItem.serviceIcon,
                            serviceDescription: serviceTypeItem.serviceDescription,
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsetsDirectional.only(top: 3.h, end: 5.w),
                      child: Icon(CustomIcons.information, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 5.h),
          Flexible(
            child: Text(
              serviceTypeItem.serviceName,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: bodyText(context: context, textColor: getCurrentTheme(context).colorTextCommon, fontWeight: FontWeight.w500, fontSize: textSize14px),
            ),
          ),
        ],
      ),
    );
  }
}
