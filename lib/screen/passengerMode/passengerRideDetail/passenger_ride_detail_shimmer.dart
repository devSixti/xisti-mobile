import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../commonView/child_size_notifier.dart';
import '../../../commonView/dash_line_view.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../commonView/statusView/passenger_ride_status_view.dart';
import '../../../utils/utils.dart';

class PassengerRideDetailShimmer extends StatelessWidget {
  final bool enabled;

  const PassengerRideDetailShimmer({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: getCurrentTheme(context).colorShimmerBg,
        highlightColor: Colors.grey.shade100,
        enabled: enabled,
        period: const Duration(milliseconds: 800),
        child: Container(
          alignment: AlignmentDirectional.topStart,
          margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PassengerRideStatusView(rideStatus: 9),
              SizedBox(height: 20.h),
              addressDetail(),
              buildRideDetail(context),
              vehicleDetail(context),
              driverDetail(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget addressDetail() {
    return ChildSizeNotifier(
      builder: (context, size, child) {
        return Container(
          padding: EdgeInsetsDirectional.only(bottom: 20.h),
          child: Stack(
            children: [
              Container(
                alignment: AlignmentDirectional.topStart,
                margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 11.w),
                child: DashLineView(
                  dashColor: getCurrentTheme(context).colorBorder,
                  // totalHeight: addressList.length <= 2 ? size.height / 3 : size.height / 2.1,
                  totalHeight: size.height / 3,
                  dashHeight: 5.h,
                  dashWidth: 1.5.w,
                  emptyHeight: 4.h,
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                padding: EdgeInsetsDirectional.zero,
                separatorBuilder: (context, index) {
                  return Container(height: 15.h);
                },
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.all(2.sp),
                        margin: EdgeInsetsDirectional.only(end: 10.w),
                        child: Icon(
                          index == 0 ? CustomIcons.pickupLocation : CustomIcons.dropLocation,
                          size: 20.sp,
                          color: getCurrentTheme(context).colorIconCommon,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: double.infinity, height: 15.h, color: getCurrentTheme(context).colorBlack),
                            SizedBox(height: 5.h),
                            Container(width: 100.w, height: 15.h, color: getCurrentTheme(context).colorBlack),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildRideDetail(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(languages.rideDetail, textAlign: TextAlign.start, style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600)),
      SizedBox(height: 20.h),
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5,
        padding: EdgeInsetsDirectional.zero,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsetsDirectional.only(bottom: 15.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CustomIcons.rideDatetime, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 120.w, height: 12.h, color: getCurrentTheme(context).colorBlack),
                      SizedBox(height: 7.h),
                      Container(width: 200.w, height: 15.h, color: getCurrentTheme(context).colorBlack),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ],
  );

  Widget driverDetail(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(top: 20.h, bottom: 15.h),
          child: Text(
            languages.driverDetails,
            textAlign: TextAlign.start,
            style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            LoadImageWithPlaceHolder(
              width: 70.sp,
              height: 70.sp,
              image: "",
              defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
              borderRadius: BorderRadius.circular(15.r),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 135.w, height: 15.h, color: getCurrentTheme(context).colorBlack),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.all(5.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 0.5.w),
                        ),
                        child: Icon(CustomIcons.call, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.all(5.sp),
                        margin: EdgeInsetsDirectional.only(start: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 0.5.w),
                        ),
                        child: Icon(CustomIcons.chat, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Icon(CustomIcons.rating, color: getCurrentTheme(context).colorRating),
            SizedBox(width: 2.w),
            Text("0.0", style: bodyText(context: context, fontSize: textSize14px)),
          ],
        ),
      ],
    );
  }

  Widget vehicleDetail(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(top: 5.h, bottom: 15.h),
          child: Text(
            languages.vehicleInformation,
            textAlign: TextAlign.start,
            style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600),
          ),
        ),
        Row(
          children: [
            LoadImageWithPlaceHolder(
              width: 70.sp,
              height: 70.sp,
              image: "",
              defaultAssetImage: "assets/images/app_icon.png",
              borderRadius: BorderRadius.circular(15.r),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 160.w, height: 20.h, color: getCurrentTheme(context).colorBlack),
                  SizedBox(height: 10.h),
                  Container(width: 100.w, height: 15.h, color: getCurrentTheme(context).colorBlack),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
