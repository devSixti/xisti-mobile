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
  /// Wireframe home: cuadrado compacto con icono + nombre dentro (Moto / Carro).
  final bool wireframeTile;
  /// Panel moderno: foto grande del vehículo ocupando altura disponible.
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
    if (photoTile) {
      return _photoTile(context);
    }
    if (wireframeTile) {
      return _wireframeTile(context);
    }
    return _legacyTile(context);
  }

  Widget _photoTile(BuildContext context) {
    final theme = getCurrentTheme(context);
    final accent = XistiUiTokens.accentForMode(serviceMode);
    final tileH = photoTileHeight ?? 56.h;

    return Container(
      width: expanded ? double.infinity : 88.w,
      height: tileH,
      margin: EdgeInsetsDirectional.only(end: expanded ? 0 : 8.w),
      decoration: BoxDecoration(
        color: theme.colorScaffoldBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? accent : theme.colorDarkBorder,
          width: isSelected ? 2.w : 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.w, 5.h, 5.w, 2.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: LoadImageWithPlaceHolder(
                  width: double.infinity,
                  height: double.infinity,
                  imageFit: BoxFit.contain,
                  image: serviceTypeItem.serviceIcon ?? "",
                  defaultAssetImage: "assets/images/app_icon.png",
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: 4.h, start: 3.w, end: 3.w),
            child: Text(
              serviceTypeItem.serviceName ?? "-",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: bodyText(
                context: context,
                textColor: isSelected ? accent : theme.colorTextCommon,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: textSize10px,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wireframeTile(BuildContext context) {
    final theme = getCurrentTheme(context);
    final accent = XistiUiTokens.accentForMode(serviceMode);
    final tileH = XistiUiTokens.wireframeVehicleTileHeight;

    return Container(
      width: expanded ? double.infinity : 88.w,
      height: tileH,
      margin: EdgeInsetsDirectional.only(end: expanded ? 0 : 8.w),
      decoration: BoxDecoration(
        color: theme.colorScaffoldBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? accent : theme.colorDarkBorder,
          width: isSelected ? 2.w : 1.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 22.h,
            width: 36.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LoadImageWithPlaceHolder(
                width: 36.w,
                height: 22.h,
                imageFit: BoxFit.contain,
                image: serviceTypeItem.serviceIcon ?? "",
                defaultAssetImage: "assets/images/app_icon.png",
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            serviceTypeItem.serviceName ?? "-",
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: bodyText(
              context: context,
              textColor: isSelected ? accent : theme.colorTextCommon,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: textSize10px,
            ),
          ),
        ],
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
                  child: SizedBox(
                    height: 44.h,
                    width: 44.h,
                    child: LoadImageWithPlaceHolder(
                      width: 44.h,
                      height: 44.h,
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
                      margin: EdgeInsetsDirectional.only(top: 3.h, end: 3.w),
                      padding: EdgeInsets.all(3.sp),
                      decoration: BoxDecoration(
                        color: theme.colorScaffoldBg.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(CustomIcons.information, size: 12.sp, color: accent),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 5.h),
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
