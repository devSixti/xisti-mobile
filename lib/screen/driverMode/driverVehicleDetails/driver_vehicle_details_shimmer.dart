import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../appThemeManager/app_theme_colors.dart';
import '../../../commonView/custom_text_field.dart';
import '../../../constant/dimensions.dart';
import '../../../utils/custom_icons.dart';

class DriverVehicleDetailsShimmer extends StatelessWidget {
  const DriverVehicleDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildManageVehicleShimmer(context);
  }

  Widget _buildManageVehicleShimmer(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(top: 20.h, bottom: 80.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey[100]!,
        period: const Duration(milliseconds: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(width: 200.w, height: 30.h, color: getCurrentTheme(context).colorWhite),
            SizedBox(height: 15.h),
            _vehicleServiceSelectionView(context),
            _vehicleServiceDataView(context),
          ],
        ),
      ),
    );
  }

  Widget _vehicleServiceSelectionView(BuildContext context) {
    return Container(
      height: 102.h,
      margin: EdgeInsetsDirectional.only(bottom: 20.h),
      child: ListView.separated(
        padding: EdgeInsetsDirectional.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
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
                          color: getCurrentTheme(context).colorWhite.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: getCurrentTheme(context).colorBorder, width: 0.5.sp),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Container(
                        margin: EdgeInsetsDirectional.only(top: 3.h, end: 5.w),
                        child: Icon(CustomIcons.information, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Flexible(child: Container(height: 10.h, width: 50.w, color: getCurrentTheme(context).colorWhite)),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 15.w);
        },
        itemCount: 4,
      ),
    );
  }

  Widget _vehicleServiceDataView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(padding: EdgeInsetsDirectional.only(bottom: 20.h), child: _textFieldsShimmer(context, CustomIcons.vehicleInformation, showSuffix: true)),
        Padding(padding: EdgeInsetsDirectional.only(bottom: 20.h), child: _textFieldsShimmer(context, CustomIcons.manufactureName)),
        Padding(padding: EdgeInsetsDirectional.only(bottom: 20.h), child: _textFieldsShimmer(context, CustomIcons.modelName)),
        Padding(padding: EdgeInsetsDirectional.only(bottom: 20.h), child: _textFieldsShimmer(context, CustomIcons.modelYear, showSuffix: true)),

        Padding(padding: EdgeInsetsDirectional.only(bottom: 20.h), child: _textFieldsShimmer(context, CustomIcons.referralCode)),
        Padding(padding: EdgeInsetsDirectional.only(bottom: 20.h), child: _textFieldsShimmer(context, CustomIcons.vehicleColor)),

        Padding(padding: EdgeInsetsDirectional.only(bottom: 20.h), child: _textFieldsShimmer(context, CustomIcons.imageIcon)),

        Padding(
          padding: EdgeInsetsDirectional.only(bottom: 20.h),
          child: Row(
            children: [
              Container(width: 200.w, height: 20.h, color: getCurrentTheme(context).colorWhite),
              Spacer(),
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  tristate: false,
                  value: false,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  checkColor: getCurrentTheme(context).colorWhite,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                  side: BorderSide(color: getCurrentTheme(context).colorBorder, width: 1.sp),
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(bottom: 20.h),
          child: Row(
            children: [
              Container(width: 200.w, height: 20.h, color: getCurrentTheme(context).colorWhite),
              Spacer(),
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  tristate: false,
                  value: false,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  checkColor: getCurrentTheme(context).colorWhite,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                  side: BorderSide(color: getCurrentTheme(context).colorBorder, width: 1.sp),
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _textFieldsShimmer(BuildContext context, IconData prefixIcon, {bool showSuffix = false}) {
    return TextFormFieldCustom(
      readOnly: true,
      backgroundColor: getCurrentTheme(context).colorWhite.withValues(alpha: 0.2),
      suffix:
          showSuffix
              ? Padding(
                padding: EdgeInsetsDirectional.only(end: 15.sp),
                child: Icon(CustomIcons.arrowDown, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
              )
              : null,
      commonPrefixIcon: prefixIcon,
    );
  }
}
