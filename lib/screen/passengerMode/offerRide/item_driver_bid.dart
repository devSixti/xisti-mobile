import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/gradient_box_border.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import 'offer_ride_bloc.dart';
import 'offer_ride_dl.dart';

class ItemDriverBidView extends StatelessWidget {
  const ItemDriverBidView({super.key, required this.itemDriverBid, required this.offerRideBloc, required this.timeOut});

  final OfferRideBloc offerRideBloc;
  final ItemDriverBid itemDriverBid;
  final int timeOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 20.h),
      padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.h, bottom: 10.h),
      decoration: BoxDecoration(
        color: getCurrentTheme(context).colorAvailableDriverCardBg,
        borderRadius: BorderRadius.circular(22.r),
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: [getCurrentTheme(context).colorAvailableDriverBorder1, getCurrentTheme(context).colorAvailableDriverBorder2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              LoadImageWithPlaceHolder(
                width: 20.sp,
                height: 20.sp,
                image: itemDriverBid.vehicleServiceIcon ?? "",
                defaultAssetImage: "assets/images/app_icon.png",
                imageFit: BoxFit.contain,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "${itemDriverBid.vehicleTypeName} - ${itemDriverBid.vehicleCompany} ${itemDriverBid.modelName}",
                  style: bodyText(context: context, textColor: getCurrentTheme(context).colorStaticOfferRideText, fontWeight: FontWeight.w600),
                ),
              ),
              if ((itemDriverBid.serviceId ?? 0) == ServiceType.taxi && (itemDriverBid.isTaxi ?? 0) == 1)
                Container(
                  margin: EdgeInsetsDirectional.only(start: 8.w),
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: getCurrentTheme(context).colorPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(languages.taxiLabel, style: bodyText(context: context, fontSize: textSize12px, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              LoadImageWithPlaceHolder(
                width: 100.sp,
                height: 100.sp,
                image: itemDriverBid.profileImage ?? "",
                defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
                borderRadius: BorderRadius.circular(20.r),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            itemDriverBid.userName ?? "",
                            style: bodyText(context: context, textColor: getCurrentTheme(context).colorStaticOfferRideText, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          getAmountWithCurrency(itemDriverBid.offeredPrice),
                          style: bodyText(context: context, textColor: getCurrentTheme(context).colorStaticOfferRideText, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CustomIcons.rating, color: getCurrentTheme(context).colorRating),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            (itemDriverBid.rating ?? 0) > 0 ? "${itemDriverBid.rating} (${itemDriverBid.totalRatings})" : "--",
                            style: bodyText(context: context, textColor: getCurrentTheme(context).colorStaticOfferRideText, fontSize: textSize14px),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(CustomIcons.dropLocation, color: getCurrentTheme(context).colorStaticOfferRideText),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            "${itemDriverBid.distance} ${languages.km}  •  ${itemDriverBid.time} ${languages.minute}",
                            style: bodyText(context: context, textColor: getCurrentTheme(context).colorStaticOfferRideText, fontSize: textSize14px),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: StreamBuilder<ApiResponse<BaseModel>>(
                  stream: offerRideBloc.rejectDriverSubject,
                  builder: (context, snapLoad) {
                    bool isLoading = snapLoad.hasData && snapLoad.data?.status == Status.loading;
                    return CustomRoundedButton(
                      context,
                      languages.reject,
                      isLoading
                          ? null
                          : () {
                            offerRideBloc.rejectDriverApi(itemDriverBid);
                          },
                      setBorder: true,
                      setProgress: itemDriverBid.rejectLoading,
                      bgColor: Colors.transparent,
                      borderColor: getCurrentTheme(context).colorStaticOfferRideText,
                      textColor: getCurrentTheme(context).colorStaticOfferRideText,
                      margin: EdgeInsetsDirectional.only(top: 15.h, bottom: 10.h),
                    );
                  },
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: StreamBuilder<ApiResponse<BaseModel>>(
                  stream: offerRideBloc.acceptDriverSubject,
                  builder: (context, snapLoad) {
                    bool isLoading = snapLoad.hasData && snapLoad.data?.status == Status.loading;
                    return CustomRoundedButton(
                      context,
                      languages.accept,
                      isLoading
                          ? null
                          : () {
                              offerRideBloc.acceptDriverApi(itemDriverBid);
                            },
                      setProgress: itemDriverBid.acceptLoading,
                      minWidth: double.maxFinite,
                      margin: EdgeInsetsDirectional.only(top: 15.h, bottom: 10.h),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
