import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../bottomSheet/vehicle_information_sheet.dart';
import 'passenger_home_dl.dart';

/// Vehicle tile for passenger home — large icon, transparent fill (ZIMO-style sizing).
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
    final tileW = expanded ? double.infinity : 88.w;
    final boxSize = photoTileHeight ?? 88.w;

    return SizedBox(
      width: tileW,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: isSelected ? accent.withValues(alpha: 0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected ? accent : theme.colorDarkBorder,
                width: isSelected ? 2.5.w : 1.5.w,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Transform.scale(
                      scale: 0.76,
                      child: _vehicleImage(boxSize - 20.w, serviceTypeItem),
                    ),
                  ),
                ),
                if (isSelected) _infoButton(context, theme, accent),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          SizedBox(
            width: boxSize + 12.w,
            height: 34.h,
            child: Center(
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
          ),
        ],
      ),
    );
  }

  Widget _vehicleImage(double size, ServiceTypeItem item) {
    final src = item.serviceIcon ?? '';
    final isAsset = src.startsWith('assets/');
    return LoadImageWithPlaceHolder(
      width: size,
      height: size,
      imageFit: BoxFit.contain,
      isNetworkImage: !isAsset,
      image: isAsset ? src : src,
      defaultAssetImage: 'assets/images/app_icon.png',
      borderRadius: BorderRadius.zero,
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
          margin: EdgeInsetsDirectional.only(top: 4.h, end: 4.w),
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
      width: expanded ? double.infinity : 88.w,
      margin: EdgeInsetsDirectional.only(end: expanded ? 0 : 10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                height: 72.h,
                width: double.infinity,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: XistiUiTokens.glassCard(
                  background: theme.colorScaffoldBg,
                  borderColor: theme.colorBorder,
                  accent: accent,
                  selected: isSelected,
                  radius: 16.r,
                ),
                child: Center(
                  child: Transform.scale(
                    scale: 0.76,
                    child: _vehicleImage(44.h, serviceTypeItem),
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
