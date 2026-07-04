import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:just_audio/just_audio.dart';

import '../../blocs/bloc.dart';
import '../../commonView/common_view.dart';
import '../../commonView/courier_detail_view.dart';
import '../../commonView/delivery_request_badge.dart';
import '../../commonView/ride_request_type_chip.dart';
import '../../commonView/load_image_with_placeholder.dart';
import '../../commonView/ride_detail_item.dart';
import '../../commonView/primary_action_button.dart';
import '../../screen/driverMode/driverHome/driver_home_dl.dart';
import '../../screen/driverMode/driverNewRequest/driver_new_request_dl.dart';
import '../../hive/hive_helper.dart';
import '../../utils/alert_feedback_util.dart';
import '../../utils/destination_payment_util.dart';
import '../../utils/map_style_hot_reload.dart';
import '../../utils/service_mode_util.dart';
import '../../utils/utils.dart';
import 'accept_request_bottom_sheet_bloc.dart';
import 'accept_request_bottom_sheet_dl.dart';
import 'item_offer_rate.dart';

class AcceptRequestBottomSheet extends StatefulWidget {
  final RideList rideListItem;
  final bool isNearestRide;
  final List<int> rideIdList;
  final double offerRateAmount;

  const AcceptRequestBottomSheet({super.key, required this.rideListItem, required this.isNearestRide, required this.rideIdList, required this.offerRateAmount});

  @override
  State<AcceptRequestBottomSheet> createState() => _AcceptRequestBottomSheetState();
}

class _AcceptRequestBottomSheetState extends State<AcceptRequestBottomSheet> {
  final controller = Completer<GoogleMapController>();
  AcceptRequestBottomSheetBloc? _bloc;
  MapStyleHotReloadHandle? _mapStyleHotReload;

  @override
  void didUpdateWidget(covariant AcceptRequestBottomSheet oldWidget) {
    _bloc?.setNewRideItem(widget.rideListItem);
    if (oldWidget.rideListItem.offeredPrice != widget.rideListItem.offeredPrice) {
      _bloc?.selectedAmountSubject.sink.add(widget.rideListItem.offeredPrice ?? 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    acceptRequestBottomSheetState = null;
    acceptRequestBottomSheetState = this;
    unawaited(_startRequestAlert());
    super.initState();
  }

  Future<void> _startRequestAlert() async {
    unawaited(triggerRideAlertFeedback());
    if (player.playing) {
      return;
    }
    try {
      if (player.processingState == ProcessingState.idle) {
        await player.setLoopMode(LoopMode.all);
        await player.setAsset('assets/audio/new_request.mp3');
      }
      await player.play();
    } catch (_) {}
  }

  @override
  void didChangeDependencies() async {
    acceptRequestBottomSheetState = this;
    _bloc ??= AcceptRequestBottomSheetBloc(context, widget.rideListItem, widget.isNearestRide, widget.rideIdList);
    _mapStyleHotReload?.dispose();
    _mapStyleHotReload = MapStyleHotReload.bind(
      context: context,
      onStyle: (changedStyle) => _bloc?.mapStyleSubject.sink.add(changedStyle),
      onExtras: () async {
        _bloc?.setMarkers();
        _bloc?.changePolylineColorPerTheme();
      },
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    player.stop();
    _mapStyleHotReload?.dispose();
    _bloc?.dispose();
    acceptRequestBottomSheetState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onForegroundGained: () {
        acceptRequestBottomSheetState = this;
      },
      onVisibilityGained: () {
        acceptRequestBottomSheetState = this;
      },
      onFocusGained: () {
        acceptRequestBottomSheetState = this;
      },
      child: ScaffoldWithSafeArea(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Container(
            width: ScreenUtil().screenWidth,
            constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.9),
            decoration: BoxDecoration(
              color: getCurrentTheme(context).colorScaffoldBg,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _indicatorWidget(),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 10.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  languages.rideDetail,
                                  textAlign: TextAlign.start,
                                  style: bodyText(context: context, fontSize: textSize24px, fontWeight: FontWeight.w600),
                                ),
                              ),
                              RideRequestTypeChip(
                                serviceId: widget.rideListItem.serviceId,
                                serviceMode: widget.rideListItem.serviceMode,
                                isDelivery: widget.rideListItem.isDelivery,
                                isEncomienda: widget.rideListItem.isEncomienda,
                                serviceName: widget.rideListItem.serviceName,
                                vehicleVariant: widget.rideListItem.vehicleVariant,
                                isTaxi: widget.rideListItem.isTaxi,
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                              ),
                            ],
                          ),
                        ),
                        _googleMapWidget(),
                        _addressListWidget(),
                        if (widget.rideListItem.scheduleDate.isNotEmpty && widget.rideListItem.rideType == 1) ...[
                          Padding(
                            padding: EdgeInsetsDirectional.only(bottom: 20.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
                            child: Row(
                              children: [
                                Text(
                                  "${languages.schedule} : ",
                                  style: bodyText(context: context, fontWeight: FontWeight.w600),
                                ),
                                Expanded(
                                  child: Text(
                                    getDateTime(widget.rideListItem.scheduleDate, returnFormat: "dd MMM, yyyy hh:mm aa"),
                                    style: bodyText(context: context, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        _userDetailsWidget(),
                        if (widget.rideListItem.destinationPaymentMethod.isNotEmpty)
                          Container(
                            margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 20.h),
                            child: RideDetailItem(
                              iconData: CustomIcons.paymentMethod,
                              titleText: "${languages.paymentMethod} :",
                              mainText: widget.rideListItem.destinationPaymentLabel.isNotEmpty
                                  ? widget.rideListItem.destinationPaymentLabel
                                  : DestinationPaymentUtil.labelForCode(
                                      widget.rideListItem.destinationPaymentMethod,
                                      isSpanish: getLanguageFromUserPrefBox().startsWith('es'),
                                    ),
                            ),
                          ),
                        if (ServiceModeKind.isDeliveryRideRequest(
                          serviceId: widget.rideListItem.serviceId,
                          isDelivery: widget.rideListItem.isDelivery,
                          itemDescription: widget.rideListItem.itemDescription,
                          recipientName: widget.rideListItem.recipientName,
                        ))
                          Container(
                            margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
                            child: CourierDetailView(
                              itemDesc: widget.rideListItem.itemDescription,
                              recipientName: widget.rideListItem.recipientName,
                              recipientNumber: widget.rideListItem.recipientContactNumber,
                              estimatedPrice: getDoubleFromDynamic("${widget.rideListItem.estimatePrice ?? 0}"),
                              packageWeightKg: widget.rideListItem.packageWeightKg,
                              packageHeightCm: widget.rideListItem.packageHeightCm,
                              packageWidthCm: widget.rideListItem.packageWidthCm,
                              packageLengthCm: widget.rideListItem.packageLengthCm,
                            ),
                          ),
                        if ((widget.rideListItem.otherUserName).isNotEmpty) otherContactDetail(),
                        if (widget.rideListItem.additionalRemarks.isNotEmpty)
                          AdditionalNoteView(
                            title: languages.noteFromCustomer,
                            additionalNote: widget.rideListItem.additionalRemarks,
                            sideMargin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 20.h),
                          ),
                        _offerRateListWidget(),
                        _acceptButtonWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget otherContactDetail() => Container(
    margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languages.bookForOther,
          style: bodyText(context: context, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5.h),
        if ((widget.rideListItem.otherUserName).isNotEmpty)
          RideDetailItem(iconData: CustomIcons.name, titleText: languages.passengerName, mainText: widget.rideListItem.otherUserName),
        if ((widget.rideListItem.otherUserContactNumber).isNotEmpty)
          RideDetailItem(iconData: CustomIcons.call, titleText: languages.contactNumber, mainText: widget.rideListItem.otherUserContactNumber),
      ],
    ),
  );

  Widget _indicatorWidget() {
    return Center(
      child: Container(
        width: 80.w,
        height: 4.h,
        margin: EdgeInsetsDirectional.symmetric(vertical: 15.h, horizontal: 15.w),
        decoration: BoxDecoration(color: getCurrentTheme(context).colorStaticIndicator, borderRadius: BorderRadius.circular(4.r)),
      ),
    );
  }

  Widget _googleMapWidget() {
    return SizedBox(
      width: ScreenUtil().screenWidth,
      height: 250.h,
      child: StreamBuilder<List<Marker>>(
        stream: _bloc?.markersListSubject,
        builder: (context, snapMarkerList) {
          return StreamBuilder<Map<PolylineId, Polyline>>(
            stream: _bloc?.polyLinesSubject,
            builder: (context, snapPolyLine) {
              return StreamBuilder<String>(
                stream: _bloc?.mapStyleSubject,
                builder: (context, snapMapStyle) {
                  return GoogleMap(
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    mapType: MapType.normal,
                    polylines: (snapPolyLine.data != null && snapPolyLine.data!.isNotEmpty) ? Set<Polyline>.of(snapPolyLine.data!.values) : <Polyline>{},
                    markers: (snapMarkerList.data != null && (snapMarkerList.data ?? []).isNotEmpty) ? Set<Marker>.of(snapMarkerList.data!) : <Marker>{},
                    initialCameraPosition: initCameraPosition,
                    onMapCreated: (value) {
                      _bloc?.onMapCreated(value);
                      controller.complete(value);
                    },
                    myLocationEnabled: false,
                    tiltGesturesEnabled: false,
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    myLocationButtonEnabled: false,
                    style: snapMapStyle.data,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _addressListWidget() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.rideListItem.addressList.length,
      padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 20.h, bottom: 20.h),
      separatorBuilder: (context, index) {
        return Container(height: 15.h);
      },
      itemBuilder: (context, index) {
        return Column(
          children: [
            Row(
              children: [
                Container(width: 30.w),
                Expanded(
                  child: Text(
                    index == 0
                        ? languages.pickUpLocation
                        : index == widget.rideListItem.addressList.length - 1
                        ? languages.dropLocation
                        : languages.stopPoint,
                    style: bodyText(context: context, textColor: getCurrentTheme(context).colorTextLight, fontSize: textSize14px),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(end: 10.w),
                  child: Icon(
                    index == 0
                        ? CustomIcons.pickupLocation
                        : index == widget.rideListItem.addressList.length - 1
                        ? CustomIcons.dropLocation
                        : CustomIcons.stopPoint,
                    size: 20.sp,
                    color: getCurrentTheme(context).colorIconCommon,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.rideListItem.addressList[index].address,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: bodyText(context: context, fontWeight: FontWeight.w400).copyWith(height: 0),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _userDetailsWidget() {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 20.h),
      child: Row(
        children: [
          LoadImageWithPlaceHolder(
            width: 100.sp,
            height: 100.sp,
            image: widget.rideListItem.profileImage,
            borderRadius: BorderRadius.circular(20.r),
            defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.rideListItem.userName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: bodyText(context: context, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(end: 2.w),
                        child: Text(
                          getAmountWithCurrency(widget.rideListItem.offeredPrice),
                          style: bodyText(context: context, fontWeight: FontWeight.w600, textColor: getCurrentTheme(context).colorPrimary),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 7.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CustomIcons.rating, size: 20.sp, color: getCurrentTheme(context).colorRating),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 2.w),
                          child: Text(
                            widget.rideListItem.rating > 0 ? "${widget.rideListItem.rating} (${widget.rideListItem.totalRatings})" : "--",
                            style: bodyText(
                              context: context,
                              fontWeight: FontWeight.w400,
                              fontSize: textSize14px,
                              textColor: getCurrentTheme(context).colorTextCommon,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<int>(
                    stream: _bloc?.etaSubject,
                    builder: (context, snapEta) {
                      return StreamBuilder<double>(
                        stream: _bloc?.distanceSubject,
                        builder: (context, snapDistance) {
                          return Row(
                            children: [
                              Icon(CustomIcons.dropLocation, size: 20.sp, color: getCurrentTheme(context).colorIconLight),
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 2.w),
                                child: Text(
                                  "${snapDistance.data ?? "--"} ${languages.km} 󠁯•󠁏 ${snapEta.data ?? "--"} ${languages.min}",
                                  style: bodyText(
                                    context: context,
                                    textColor: getCurrentTheme(context).colorKmAndTimeText,
                                    fontWeight: FontWeight.w400,
                                    fontSize: textSize14px,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _offerRateListWidget() {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 30.h),
      child: ItemOfferRate(
        offerList: [
          OfferRatePojo(offerAmount: (widget.rideListItem.offeredPrice ?? 0) + (widget.offerRateAmount * 1), isCustom: 0),
          OfferRatePojo(offerAmount: (widget.rideListItem.offeredPrice ?? 0) + (widget.offerRateAmount * 2), isCustom: 0),
          OfferRatePojo(offerAmount: (widget.rideListItem.offeredPrice ?? 0) + (widget.offerRateAmount * 3), isCustom: 0),
          OfferRatePojo(offerAmount: (0), isCustom: 1),
        ],
        onSelectionChanged: (selectedAmount) {
          if (selectedAmount == 0) {
            _bloc?.selectedAmountSubject.sink.add(widget.rideListItem.offeredPrice ?? 0);
          } else {
            _bloc?.selectedAmountSubject.sink.add(selectedAmount);
          }
        },
      ),
    );
  }

  Widget _acceptButtonWidget() {
    return StreamBuilder<ApiResponse<DriverBidPojo>>(
      stream: _bloc?.driverBidSubject,
      builder: (context, snapDriverBid) {
        var isLoading = snapDriverBid.hasData && snapDriverBid.data?.status == Status.loading;
        return StreamBuilder<dynamic>(
          stream: _bloc?.selectedAmountSubject,
          builder: (context, snapSelectedAmount) {
            return Padding(
              padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin()),
              child: PrimaryActionButton(
                context: context,
                setProgress: isLoading,
                text:
                    "${languages.accept} ${getAmountWithCurrency(((snapSelectedAmount.data ?? 0) > 0 ? snapSelectedAmount.data : widget.rideListItem.offeredPrice))}",
                onPressed: () {
                  if ((widget.rideListItem.isAutoAccept == 1 &&
                      (getDoubleFromDynamic(widget.rideListItem.offeredPrice) ==
                          getDoubleFromDynamic((snapSelectedAmount.data ?? 0) > 0 ? snapSelectedAmount.data : widget.rideListItem.offeredPrice)))) {
                    _bloc?.acceptRideApi();
                  } else {
                    _bloc?.callDriverBidApi();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
