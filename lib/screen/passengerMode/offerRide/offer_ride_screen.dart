import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/child_size_notifier.dart';
import '../../../commonView/courier_detail_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/dash_line_view.dart';
import '../../../commonView/ripplesAnimationView/ripples_animation_view.dart';
import '../../../commonView/scaffold_with_safe_area.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/map_style_hot_reload.dart';
import '../../../utils/utils.dart';
import 'item_driver_bid.dart';
import 'offer_ride_bloc.dart';
import 'offer_ride_dl.dart';

class OfferRideScreen extends StatefulWidget {
  final List<AddressListItem> addressList;
  final String fareAmount, itemDesc, recipientName, recipientNumber, estimatedPrice;
  final int rideId, serviceType;
  final dynamic minFareAmount, maxFareAmount;

  final bool showCourierDetails;

  const OfferRideScreen({
    super.key,
    required this.rideId,
    required this.serviceType,
    this.showCourierDetails = false,
    required this.addressList,
    required this.fareAmount,
    required this.itemDesc,
    required this.recipientName,
    required this.recipientNumber,
    required this.minFareAmount,
    required this.maxFareAmount,
    required this.estimatedPrice,
  });

  @override
  State<OfferRideScreen> createState() => _OfferRideScreenState();
}

class _OfferRideScreenState extends State<OfferRideScreen> {
  OfferRideBloc? _bloc;
  MapStyleHotReloadHandle? _mapStyleHotReload;

  @override
  void didChangeDependencies() async {
    _bloc ??= OfferRideBloc(context, widget.rideId, offerFare: widget.fareAmount, minFareAmount: widget.minFareAmount, maxFareAmount: widget.maxFareAmount);
    _mapStyleHotReload?.dispose();
    _mapStyleHotReload = MapStyleHotReload.bind(
      context: context,
      onStyle: (changedStyle) => _bloc?.mapStyle.sink.add(changedStyle),
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _mapStyleHotReload?.dispose();
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ScaffoldWithSafeArea(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            googleMap(),
            StreamBuilder<List<ItemDriverBid>>(
              stream: _bloc?.driverListController,
              builder: (context, snapList) {
                List<ItemDriverBid> itemDriverBid = snapList.data ?? [];
                return itemDriverBid.isEmpty
                    ? Column(children: [Expanded(child: loadingView()), mainContent()])
                    : Container(
                      color: getCurrentTheme(context).colorAvailableDriverBg,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [availableDriverView(itemDriverBid), cancelBtn()],
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget cancelBtn() {
    return StreamBuilder<ApiResponse<BaseModel>>(
      stream: _bloc?.cancelRideSubject,
      builder: (context, snapLoad) {
        bool isLoading = snapLoad.hasData && snapLoad.data?.status == Status.loading;
        return CustomRoundedButton(
          context,
          languages.cancelRide,
          isLoading
              ? null
              : () {
                _bloc?.openCancelSheet();
              },
          setBorder: true,
          setProgress: isLoading,
          bgColor: Colors.transparent,
          borderColor: getCurrentTheme(context).colorBorder,
          textColor: getCurrentTheme(context).colorStaticWhite,
          borderWidth: 1.5.sp,
          margin: EdgeInsetsDirectional.only(bottom: getBottomMargin(), start: commonHorizontalPadding, end: commonHorizontalPadding, top: 30.h),
        );
      },
    );
  }

  Widget availableDriverView(List<ItemDriverBid> itemDriverBidList) {
    return Flexible(
      child: ListView.builder(
        itemCount: itemDriverBidList.length,
        shrinkWrap: true,
        padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 30.h),
        itemBuilder: (context, position) {
          ItemDriverBid itemDriverBid = itemDriverBidList[position];
          return ItemDriverBidView(itemDriverBid: itemDriverBid, offerRideBloc: _bloc!, timeOut: _bloc?.findDriverSubject.valueOrNull?.data?.timeOut ?? 10);
        },
      ),
    );
  }

  Widget mainContent() {
    return Container(
      color: getCurrentTheme(context).colorRippleAnimationBg,
      child: Container(
        padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 20.h),
        decoration: BoxDecoration(
          color: getCurrentTheme(context).colorScaffoldBg,
          borderRadius: BorderRadius.only(topRight: Radius.circular(30.r), topLeft: Radius.circular(30.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            addressDetails(),
            if (widget.showCourierDetails || widget.serviceType == ServiceType.courier) ...[
              Container(height: 1.h, margin: EdgeInsetsDirectional.only(bottom: 20.h), color: getCurrentTheme(context).colorIndicatorOff),
              CourierDetailView(
                itemDesc: widget.itemDesc,
                recipientName: widget.recipientName,
                recipientNumber: widget.recipientNumber,
                estimatedPrice: getDoubleFromDynamic(widget.estimatedPrice.isNotEmpty ? widget.estimatedPrice : "0"),
              ),
            ],
            raiseFareView(),
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<ApiResponse<BaseModel>>(
                    stream: _bloc?.cancelRideSubject,
                    builder: (context, snapLoad) {
                      bool isLoading = snapLoad.hasData && snapLoad.data?.status == Status.loading;
                      return CustomRoundedButton(
                        context,
                        languages.cancelRide,
                        isLoading
                            ? null
                            : () {
                              _bloc?.openCancelSheet();
                            },
                        setBorder: true,
                        setProgress: isLoading,
                        margin: EdgeInsetsDirectional.only(top: 25.h, bottom: 20.h),
                      );
                    },
                  ),
                ),
                SizedBox(width: commonHorizontalPadding),
                Expanded(
                  child: StreamBuilder<bool>(
                    stream: _bloc?.raiseFareBtnController,
                    builder: (context, snapEnable) {
                      bool enable = snapEnable.data ?? false;
                      return StreamBuilder<ApiResponse<BaseModel>>(
                        stream: _bloc?.updatePriceSubject,
                        builder: (context, snapLoad) {
                          bool isLoading = snapLoad.hasData && snapLoad.data?.status == Status.loading;
                          return CustomRoundedButton(
                            context,
                            languages.raiseFare,
                            (!enable || isLoading)
                                ? null
                                : () {
                                  _bloc?.updatePriceApi();
                                },
                            setProgress: isLoading,
                            margin: EdgeInsetsDirectional.only(top: 25.h, bottom: 20.h),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget raiseFareView() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: StreamBuilder<bool>(
            stream: _bloc?.minAvailableController,
            builder: (context, snapAvailable) {
              bool minAvailable = snapAvailable.data ?? false;
              return GestureDetector(
                onTap: () {
                  if (minAvailable) {
                    _bloc?.fareMinus();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: minAvailable ? getCurrentTheme(context).colorDarkBorder : getCurrentTheme(context).colorBorder, width: 1.w),
                  ),
                  height: 40.h,
                  alignment: AlignmentDirectional.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CustomIcons.minus,
                          size: 16.sp,
                          color: minAvailable ? getCurrentTheme(context).colorIconCommon : getCurrentTheme(context).colorIconLight,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          getAmountWithCurrency(_bloc?.fareNegotiationStep ?? getFareNegotiationStep(), numberAfterPoint: getCurrencyFractionDigits()),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: bodyText(
                            context: context,
                            fontWeight: FontWeight.w500,
                            fontSize: textSize14px,
                            textColor: minAvailable ? getCurrentTheme(context).colorTextCommon : getCurrentTheme(context).colorTextLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            margin: EdgeInsetsDirectional.only(start: 5.w, end: 5.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: StreamBuilder<dynamic>(
                        stream: _bloc?.totalAmountController,
                        builder: (context, snapTotal) {
                          return AutoSizeText(
                            getAmountWithCurrency(snapTotal.data ?? 0),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize18px),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        _bloc?.openRaiseFareSheet();
                      },
                      child: Icon(CustomIcons.edit, size: 15.sp, color: getCurrentTheme(context).colorIconLight),
                    ),
                  ],
                ),
                Text(
                  languages.currentFare,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: bodyText(context: context, fontWeight: FontWeight.normal, textColor: getCurrentTheme(context).colorTextLight, fontSize: textSize14px),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: StreamBuilder<bool>(
            stream: _bloc?.maxAvailableController,
            builder: (context, snapAvailable) {
              bool maxAvailable = snapAvailable.data ?? false;
              return GestureDetector(
                onTap: () {
                  _bloc?.farePlus();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: maxAvailable ? getCurrentTheme(context).colorDarkBorder : getCurrentTheme(context).colorBorder, width: 1.w),
                  ),
                  height: 40.h,
                  alignment: AlignmentDirectional.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CustomIcons.plus,
                          size: 16.sp,
                          color: maxAvailable ? getCurrentTheme(context).colorIconCommon : getCurrentTheme(context).colorIconLight,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          getAmountWithCurrency(_bloc?.fareNegotiationStep ?? getFareNegotiationStep(), numberAfterPoint: getCurrencyFractionDigits()),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: bodyText(
                            context: context,
                            fontWeight: FontWeight.w500,
                            fontSize: textSize14px,
                            textColor: maxAvailable ? getCurrentTheme(context).colorTextCommon : getCurrentTheme(context).colorTextLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget addressDetails() {
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
                  totalHeight:
                      widget.addressList.length <= 2
                          ? size.height / 3
                          : widget.addressList.length <= 4
                          ? size.height / 2.2
                          : size.height / 2,
                  dashHeight: 5.h,
                  dashWidth: 1.5.w,
                  emptyHeight: 4.h,
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.addressList.length,
                padding: EdgeInsetsDirectional.zero,
                separatorBuilder: (context, index) {
                  return Container(height: 15.h);
                },
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        color: getCurrentTheme(context).colorScaffoldBg,
                        padding: EdgeInsetsDirectional.all(2.sp),
                        margin: EdgeInsetsDirectional.only(end: 10.w),
                        child: Icon(
                          index == 0
                              ? CustomIcons.pickupLocation
                              : index == widget.addressList.length - 1
                              ? CustomIcons.dropLocation
                              : CustomIcons.stopPoint,
                          size: 20.sp,
                          color: getCurrentTheme(context).colorIconCommon,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.addressList[index].address,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: bodyText(context: context).copyWith(height: 0),
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

  Widget loadingView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: getCurrentTheme(context).colorRippleAnimationBg,
      child: Center(
        child: RipplesAnimationView(
          size: 50.sp,
          color: getCurrentTheme(context).colorRippleAnimation,
          child: Padding(padding: EdgeInsets.all(30.sp), child: Icon(CustomIcons.findDriver, size: 30.sp, color: getCurrentTheme(context).colorStaticBlack)),
        ),
      ),
    );
  }

  Widget googleMap() => StreamBuilder<String>(
    stream: _bloc?.mapStyle,
    builder: (context, mapStyle) {
      return GoogleMap(
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: initCameraPosition,
        padding: EdgeInsets.only(bottom: 200.h),
        onMapCreated: (value) {
          _bloc?.onMapCreated(value);
        },
        style: mapStyle.data,
        myLocationButtonEnabled: false,
      );
    },
  );
}
