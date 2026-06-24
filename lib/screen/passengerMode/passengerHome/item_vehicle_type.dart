import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bottomSheet/vehicle_information_sheet.dart';
import '../../../commonView/xisti_vehicle_image.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';
import '../../../utils/custom_icons.dart';
import 'passenger_home_dl.dart';

/// Vehicle tile for passenger home — large transparent icon on app background.
class ItemVehicleType extends StatelessWidget {
  final ServiceTypeItem serviceTypeItem;
  final bool isSelected;
  final String? serviceMode;
  final bool expanded;
  final bool wireframeTile;
  final bool photoTile;
  final double? photoTileHeight;

  const ItemVehicleType({
    super.key,
    required this.serviceTypeItem,
    this.isSelected = false,
    this.serviceMode,
    this.expanded = false,
    this.wireframeTile = false,
    this.photoTile = false,
    this.photoTileHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (photoTile || wireframeTile) {
      return _panelTile(context);
    }
    return _legacyTile(context);
  }

  Widget _panelTile(BuildContext context) {
    final theme = getCurrentTheme(context);
    final accent = XistiUiTokens.accentForMode(serviceMode);
    final tileW = expanded ? double.infinity : 96.w;
    final iconSize = photoTileHeight ?? 96.w;

    return SizedBox(
      width: tileW,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
              border: isSelected
                  ? Border.all(color: accent, width: 2.w)
                  : Border.all(color: Colors.transparent, width: 2.w),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  Container(
                    width: iconSize * 0.72,
                    height: iconSize * 0.72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.35),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                XistiVehicleImage(
                  imagePath: serviceTypeItem.serviceIcon,
                  size: iconSize * 0.88,
                ),
                if (isSelected) _infoButton(context, theme, accent),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          SizedBox(
            width: iconSize + 16.w,
            child: Text(
              serviceTypeItem.serviceName ?? '-',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: bodyText(
                context: context,
                textColor: isSelected ? accent : theme.colorTextCommon,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: textSize12px,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoButton(BuildContext context, dynamic theme, Color accent) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return VehicleInformationSheet(
                serviceName: serviceTypeItem.serviceName ?? '',
                serviceIcon: serviceTypeItem.serviceIcon ?? '',
                serviceDescription: serviceTypeItem.serviceDescription ?? '',
              );
            },
          );
        },
        child: Container(
          margin: EdgeInsetsDirectional.only(top: 2.h, end: 2.w),
          padding: EdgeInsets.all(3.sp),
          decoration: BoxDecoration(
            color: theme.colorScaffoldBg.withValues(alpha: 0.92),
            shape: BoxShape.circle,
          ),
          child: Icon(CustomIcons.information, size: 11.sp, color: accent),
        ),
      ),
    );
  }

  Widget _legacyTile(BuildContext context) {
    final theme = getCurrentTheme(context);
    final accent = XistiUiTokens.accentForMode(serviceMode);

    return Container(
      alignment: AlignmentDirectional.center,
      width: expanded ? double.infinity : 96.w,
      margin: EdgeInsetsDirectional.only(end: expanded ? 0 : 10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80.h,
                width: double.infinity,
                child: Center(
                  child: XistiVehicleImage(
                    imagePath: serviceTypeItem.serviceIcon,
                    size: 72.w,
                  ),
                ),
              ),
              if (isSelected)
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 40.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              if (isSelected) _infoButton(context, theme, accent),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            serviceTypeItem.serviceName ?? '-',
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
