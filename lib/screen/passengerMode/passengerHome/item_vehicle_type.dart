import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/utils.dart';
import '../../../bottomSheet/vehicle_information_sheet.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import 'passenger_home_dl.dart';

class ItemVehicleType extends StatelessWidget {
  final ServiceTypeItem serviceTypeItem;
  final bool isSelected;

  const ItemVehicleType({
    super.key,
    required this.serviceTypeItem,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: 96.w,
      margin: EdgeInsetsDirectional.only(end: 12.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsetsDirectional.only(start: 12.w, end: 12.w, top: 8.h, bottom: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? getCurrentTheme(context).colorSelectionPrimaryOpc
                        : getCurrentTheme(context).colorScaffoldBg,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: isSelected
                          ? getCurrentTheme(context).colorPrimary
                          : getCurrentTheme(context).colorBorder,
                      width: isSelected ? 1.5.sp : 0.5.sp,
                    ),
                  ),
                  child: LoadImageWithPlaceHolder(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    imageFit: BoxFit.contain,
                    image: serviceTypeItem.serviceIcon ?? "",
                    defaultAssetImage: "assets/images/app_icon.png",
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              if (isSelected)
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
                            serviceName: serviceTypeItem.serviceName ?? "",
                            serviceIcon: serviceTypeItem.serviceIcon ?? "",
                            serviceDescription: serviceTypeItem.serviceDescription ?? "",
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsetsDirectional.only(top: 3.h, end: 5.w),
                      child: Icon(
                        CustomIcons.information,
                        size: 15.sp,
                        color: getCurrentTheme(context).colorIconCommon,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            serviceTypeItem.serviceName ?? "-",
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: bodyText(
              context: context,
              textColor: getCurrentTheme(context).colorTextCommon,
              fontWeight: FontWeight.w500,
              fontSize: textSize13px,
            ),
          ),
        ],
      ),
    );
  }
}
