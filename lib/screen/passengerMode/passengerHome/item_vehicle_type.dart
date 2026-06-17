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
  final bool compact;

  const ItemVehicleType({
    super.key,
    required this.serviceTypeItem,
    this.isSelected = false,
    this.serviceMode,
    this.expanded = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final accent = XistiUiTokens.accentForMode(serviceMode);
    final cardHeight = compact ? 56.h : 72.h;
    final iconSize = compact ? 34.h : 44.h;
    final radius = compact ? 14.r : 16.r;

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
                height: cardHeight,
                width: double.infinity,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: XistiUiTokens.glassCard(
                  background: theme.colorScaffoldBg,
                  borderColor: theme.colorBorder,
                  accent: accent,
                  selected: isSelected,
                  radius: radius,
                ),
                child: Center(
                  child: SizedBox(
                    height: iconSize,
                    width: iconSize,
                    child: LoadImageWithPlaceHolder(
                      width: iconSize,
                      height: iconSize,
                      imageFit: BoxFit.contain,
                      image: serviceTypeItem.serviceIcon ?? "",
                      defaultAssetImage: "assets/images/app_icon.png",
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
              if (isSelected && !compact)
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
          SizedBox(height: compact ? 4.h : 5.h),
          Text(
            serviceTypeItem.serviceName ?? "-",
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: bodyText(
              context: context,
              textColor: isSelected ? accent : theme.colorTextCommon,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: compact ? textSize12px : textSize13px,
            ),
          ),
        ],
      ),
    );
  }
}
