import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../bottomSheet/vehicle_information_sheet.dart';
import 'passenger_home_dl.dart';

class ItemVehicleType extends StatelessWidget {
  final ServiceTypeItem serviceTypeItem;
  final bool isSelected;
  final String? serviceMode;
  final bool expanded;

  const ItemVehicleType({
    super.key,
    required this.serviceTypeItem,
    this.isSelected = false,
    this.serviceMode,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final accent = XistiUiTokens.accentForMode(serviceMode);

    return Container(
      alignment: AlignmentDirectional.center,
      width: expanded ? double.infinity : 100.w,
      margin: EdgeInsetsDirectional.only(end: expanded ? 0 : 12.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.h, bottom: 8.h),
                    decoration: XistiUiTokens.glassCard(
                      background: theme.colorScaffoldBg,
                      borderColor: theme.colorBorder,
                      accent: accent,
                      selected: isSelected,
                      radius: 18.r,
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
                      margin: EdgeInsetsDirectional.only(top: 4.h, end: 4.w),
                      padding: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                        color: theme.colorScaffoldBg.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(CustomIcons.information, size: 14.sp, color: accent),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            serviceTypeItem.serviceName ?? "-",
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: bodyText(
              context: context,
              textColor: isSelected ? accent : theme.colorTextCommon,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: textSize13px,
            ),
          ),
        ],
      ),
    );
  }
}
