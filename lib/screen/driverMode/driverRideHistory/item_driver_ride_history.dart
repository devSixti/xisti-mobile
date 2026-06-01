import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/child_size_notifier.dart';
import '../../../commonView/dash_line_view.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../commonView/statusView/driver_ride_status_view.dart';
import '../../../utils/utils.dart';
import 'driver_ride_history_dl.dart';

class ItemDriverRideHistory extends StatelessWidget {
  final DriverRideListItem item;

  const ItemDriverRideHistory({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date and Cost
        Row(
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 200.w, maxWidth: 200.w),
              margin: EdgeInsetsDirectional.symmetric(vertical: 0.5.sp),
              // For Border
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 7.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: getCurrentTheme(context).colorContainerBorder, width: 0.5.sp),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CustomIcons.rideDatetime, size: 20.sp, color: getCurrentTheme(context).colorBlack),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      getDateTime(item.serviceDateTime, returnFormat: "dd MMM, yyyy hh:mm aa"),
                      maxLines: 1,
                      style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                getAmountWithCurrency(item.rideAmount),
                textAlign: TextAlign.end,
                maxLines: 1,
                style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize16px, textColor: getCurrentTheme(context).colorPrimary),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),

        // Location
        ChildSizeNotifier(
          builder: (context, size, child) {
            return Stack(
              children: [
                Container(
                  alignment: AlignmentDirectional.topStart,
                  margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 11.w),
                  child: DashLineView(
                    dashColor: getCurrentTheme(context).colorBorder,
                    totalHeight: size.height / 3,
                    dashHeight: 5.h,
                    dashWidth: 1.5.w,
                    emptyHeight: 4.h,
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          color: getCurrentTheme(context).colorScaffoldBg,
                          padding: EdgeInsetsDirectional.all(2.sp),
                          margin: EdgeInsetsDirectional.only(end: 10.w),
                          child: Icon(CustomIcons.pickupLocation, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                        ),
                        Expanded(
                          child: Text(
                            item.pickupAddress,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: bodyText(context: context, fontWeight: FontWeight.w400).copyWith(height: 0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Container(
                          color: getCurrentTheme(context).colorScaffoldBg,
                          padding: EdgeInsetsDirectional.all(2.sp),
                          margin: EdgeInsetsDirectional.only(end: 10.w),
                          child: Icon(CustomIcons.stopPoint, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                        ),
                        Expanded(
                          child: Text(
                            item.destinationAddress,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: bodyText(context: context, fontWeight: FontWeight.w400).copyWith(height: 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        SizedBox(height: 15.h),

        // Image And Status
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoadImageWithPlaceHolder(
              image: item.userProfile,
              width: 70.sp,
              height: 70.sp,
              defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
              borderRadius: BorderRadius.circular(15.r),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (item.userName).isNotEmpty
                        ? item.userName
                        : (item.otherUserName).isNotEmpty
                        ? item.otherUserName
                        : "-",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize16px),
                  ),
                  SizedBox(height: 10.h),
                  Text(item.serviceName, maxLines: 1, overflow: TextOverflow.ellipsis, style: bodyText(context: context, fontSize: textSize14px)),
                ],
              ),
            ),

            // Status
            DriverRideStatusView(rideStatus: item.rideStatus),
          ],
        ),
      ],
    );
  }
}
