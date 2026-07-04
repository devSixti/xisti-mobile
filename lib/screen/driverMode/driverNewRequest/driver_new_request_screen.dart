import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:just_audio/just_audio.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/acceptRequestBottomSheet/accept_request_bottom_sheet_dl.dart';
import '../../../bottomSheet/acceptRequestBottomSheet/item_offer_rate.dart';
import '../../../commonView/child_size_notifier.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/dash_line_view.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../commonView/courier_detail_view.dart';
import '../../../commonView/delivery_request_badge.dart';
import '../../../commonView/ride_request_type_chip.dart';
import '../../../commonView/ride_detail_item.dart';
import '../../../commonView/no_record_found.dart';
import '../../../commonView/primary_action_button.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/alert_feedback_util.dart';
import '../../../utils/destination_payment_util.dart';
import '../../../utils/map_style_hot_reload.dart';
import '../../../utils/service_mode_util.dart';
import '../../../utils/shared_pref_util.dart';
import '../../../utils/utils.dart';
import '../driverHome/driver_home.dart';
import 'driver_new_request_bloc.dart';
import 'driver_new_request_dl.dart';
import 'driver_new_request_shimmer.dart';

class DriverNewRequestScreen extends StatefulWidget {
  final int rideId;

  const DriverNewRequestScreen({super.key, required this.rideId});

  @override
  State<DriverNewRequestScreen> createState() => _DriverNewRequestScreenState();
}

class _DriverNewRequestScreenState extends State<DriverNewRequestScreen> with WidgetsBindingObserver {
  DriverNewRequestBloc? _bloc;
  MapStyleHotReloadHandle? _mapStyleHotReload;

  @override
  void initState() {
    isNewRequestScreenOpen = true;
    _initRing();
    WidgetsBinding.instance.addObserver(this);
    setPrefNotificationData(null, tag: "Notification");
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    _bloc ??= DriverNewRequestBloc(context, widget.rideId);
    if (!player.playing) {
      player.play();
    }
    _mapStyleHotReload?.dispose();
    _mapStyleHotReload = MapStyleHotReload.bind(
      context: context,
      onStyle: (changedStyle) => _bloc?.mapStyleSubject.sink.add(changedStyle),
      onExtras: () async {
        final data = _bloc?.newRequestSubject.valueOrNull?.data;
        if (_bloc != null && data != null) {
          _bloc?.setMarkers(data);
        }
        _bloc?.changePolylineColorPerTheme();
      },
    );
    super.didChangeDependencies();
  }

  @override
  void activate() {
    isNewRequestScreenOpen = true;
    super.activate();
  }

  @override
  void dispose() {
    isNewRequestScreenOpen = false;
    player.stop();
    _mapStyleHotReload?.dispose();
    _bloc?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void deactivate() {
    isNewRequestScreenOpen = false;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityGained: () {
        isNewRequestScreenOpen = true;
        player.play();
      },
      onForegroundGained: () {
        isNewRequestScreenOpen = true;
        player.play();
      },
      onVisibilityLost: () {
        player.stop();
      },
      onForegroundLost: () {
        player.stop();
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            openScreenWithClearPrevious(context, const DriverHome());
          }
        },
        child: ScaffoldWithSafeArea(
          appBar: CommonAppBar(
            automaticallyImplyLeading: false,
            titleTextStyle: toolbarStyle(context: context),
            title: Text(languages.newRequest),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _googleMapWidget(),
                StreamBuilder<ApiResponse<NewRequestPojo>>(
                  stream: _bloc?.newRequestSubject,
                  builder: (context, snapNewRequest) {
                    if (snapNewRequest.hasData) {
                      NewRequestPojo newRequestPojo = snapNewRequest.data?.data ?? NewRequestPojo();
                      return switch (snapNewRequest.data?.status ?? Status.loading) {
                        Status.loading => DriverNewRequestShimmer(),
                        Status.completed => SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                  start: commonHorizontalPadding,
                                  end: commonHorizontalPadding,
                                  bottom: 10.h,
                                ),
                                child: RideRequestTypeChip(
                                  serviceId: newRequestPojo.serviceId,
                                  isDelivery: newRequestPojo.isDelivery,
                                  serviceName: newRequestPojo.serviceName,
                                  vehicleVariant: newRequestPojo.vehicleVariant,
                                  isTaxi: newRequestPojo.isTaxi,
                                ),
                              ),
                              if (ServiceModeKind.isDeliveryRideRequest(
                                serviceId: newRequestPojo.serviceId,
                                isDelivery: newRequestPojo.isDelivery,
                                itemDescription: newRequestPojo.itemDescription,
                                recipientName: newRequestPojo.recipientName,
                              ))
                              _addressListWidget(addressList: newRequestPojo.addressList),
                              if (newRequestPojo.scheduleDate.isNotEmpty && newRequestPojo.rideType == 1) ...[
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
                                          getDateTime(newRequestPojo.scheduleDate, returnFormat: "dd MMM, yyyy hh:mm aa"),
                                          style: bodyText(context: context, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              _userDetailsWidget(newRequestPojo: newRequestPojo),
                              if (newRequestPojo.destinationPaymentMethod.isNotEmpty)
                                _destinationPaymentWidget(newRequestPojo: newRequestPojo),
                              if (ServiceModeKind.isDeliveryRideRequest(
                                serviceId: newRequestPojo.serviceId,
                                isDelivery: newRequestPojo.isDelivery,
                                itemDescription: newRequestPojo.itemDescription,
                                recipientName: newRequestPojo.recipientName,
                              ))
                                Container(
                                  margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 20.h),
                                  child: CourierDetailView(
                                    itemDesc: newRequestPojo.itemDescription,
                                    recipientName: newRequestPojo.recipientName,
                                    recipientNumber: newRequestPojo.recipientContactNumber,
                                    estimatedPrice: getDoubleFromDynamic("${newRequestPojo.estimatePrice}"),
                                    packageWeightKg: newRequestPojo.packageWeightKg,
                                    packageHeightCm: newRequestPojo.packageHeightCm,
                                    packageWidthCm: newRequestPojo.packageWidthCm,
                                    packageLengthCm: newRequestPojo.packageLengthCm,
                                  ),
                                ),
                              _offerRateListWidget(newRequestPojo: newRequestPojo),
                              if (newRequestPojo.additionalRemarks.isNotEmpty)
                                AdditionalNoteView(
                                  title: languages.noteFromCustomer,
                                  additionalNote: newRequestPojo.additionalRemarks,
                                  sideMargin: EdgeInsetsDirectional.only(bottom: 20.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
                                ),
                              _acceptButtonWidget(newRequestPojo: newRequestPojo),
                              _goBackButtonWidget(),
                            ],
                          ),
                        ),
                        Status.error => Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NoRecordFound(message: snapNewRequest.data?.message ?? ""),
                              CustomRoundedButton(
                                context,
                                languages.retry,
                                () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  } else {
                                    openScreenWithClearPrevious(context, const DriverHome());
                                  }
                                },
                                margin: EdgeInsetsDirectional.only(bottom: 10.h, top: 10.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
                              ),
                            ],
                          ),
                        ),
                      };
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
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

  Widget _addressListWidget({required List<AddressListItem> addressList}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 20.h),
      child: ChildSizeNotifier(
        builder: (context, size, child) {
          return Padding(
            padding: EdgeInsetsDirectional.only(bottom: 20.h),
            child: Stack(
              children: [
                Container(
                  alignment: AlignmentDirectional.topStart,
                  margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 11.w),
                  child: DashLineView(
                    dashColor: getCurrentTheme(context).colorBorder,
                    totalHeight: addressList.length <= 2
                        ? size.height / 3
                        : addressList.length <= 4
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
                  itemCount: addressList.length,
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
                                : index == addressList.length - 1
                                ? CustomIcons.dropLocation
                                : CustomIcons.stopPoint,
                            size: 20.sp,
                            color: getCurrentTheme(context).colorIconCommon,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            addressList[index].address,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: bodyText(context: context, fontWeight: FontWeight.w400).copyWith(height: 0),
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
      ),
    );
  }

  Widget _userDetailsWidget({required NewRequestPojo newRequestPojo}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 20.h),
      child: Row(
        children: [
          LoadImageWithPlaceHolder(
            width: 100.sp,
            height: 100.sp,
            image: newRequestPojo.profileImage,
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
                          newRequestPojo.userName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: bodyText(context: context, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(end: 2.w),
                        child: Text(
                          getAmountWithCurrency(newRequestPojo.offeredPrice),
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
                            newRequestPojo.rating > 0 ? "${newRequestPojo.rating} (${newRequestPojo.totalRatings})" : "--",
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

  Widget _destinationPaymentWidget({required NewRequestPojo newRequestPojo}) {
    final isSpanish = getLanguageFromUserPrefBox().startsWith('es');
    final label = newRequestPojo.destinationPaymentLabel.isNotEmpty
        ? newRequestPojo.destinationPaymentLabel
        : DestinationPaymentUtil.labelForCode(newRequestPojo.destinationPaymentMethod, isSpanish: isSpanish);
  return Container(
      margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 20.h),
      child: RideDetailItem(
        iconData: CustomIcons.paymentMethod,
        titleText: "${languages.paymentMethod} :",
        mainText: label,
      ),
    );
  }

  Widget _offerRateListWidget({required NewRequestPojo newRequestPojo}) {
    return StreamBuilder<dynamic>(
      stream: _bloc?.selectedAmountSubject,
      builder: (context, snapSelectedAmount) {
        return Padding(
          padding: EdgeInsetsDirectional.only(bottom: 30.h),
          child: ItemOfferRate(
            offerList: [
              OfferRatePojo(offerAmount: (newRequestPojo.offeredPrice ?? 0) + (newRequestPojo.driverPriceSuggestion * 1), isCustom: 0),
              OfferRatePojo(offerAmount: (newRequestPojo.offeredPrice ?? 0) + (newRequestPojo.driverPriceSuggestion * 2), isCustom: 0),
              OfferRatePojo(offerAmount: (newRequestPojo.offeredPrice ?? 0) + (newRequestPojo.driverPriceSuggestion * 3), isCustom: 0),
              OfferRatePojo(offerAmount: (0), isCustom: 1),
            ],
            onSelectionChanged: (selectedAmount) {
              if (selectedAmount == 0) {
                _bloc?.selectedAmountSubject.sink.add(newRequestPojo.offeredPrice ?? 0);
              } else {
                _bloc?.selectedAmountSubject.sink.add(selectedAmount);
              }
            },
          ),
        );
      },
    );
  }

  Widget _acceptButtonWidget({required NewRequestPojo newRequestPojo}) {
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
                    "${languages.accept} ${getAmountWithCurrency(((snapSelectedAmount.data ?? 0) > 0 ? snapSelectedAmount.data : newRequestPojo.offeredPrice))}",
                onPressed: () {
                  if ((newRequestPojo.isAutoAccept == 1 &&
                      (getDoubleFromDynamic(newRequestPojo.offeredPrice) ==
                          ((snapSelectedAmount.data ?? 0) > 0 ? snapSelectedAmount.data : newRequestPojo.offeredPrice)))) {
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

  Widget _goBackButtonWidget() {
    return Align(
      alignment: AlignmentDirectional.center,
      child: CustomRoundedButton(
        context,
        languages.goBack,
        minWidth: commonBtnWidth200w,
        setBorder: true,
        () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            openScreenWithClearPrevious(context, const DriverHome());
          }
        },
        margin: EdgeInsetsDirectional.only(bottom: getBottomMargin(), start: commonHorizontalPadding, end: commonHorizontalPadding),
      ),
    );
  }
}

Future<void> _initRing() async {
  try {
    unawaited(triggerRideAlertFeedback());
    await player.pause();
    await player.stop();

    if (player.processingState == ProcessingState.loading || player.processingState == ProcessingState.buffering) {
      return;
    }

    await player.setLoopMode(LoopMode.all);
    await player.setAsset('assets/audio/new_request.mp3');
    await player.play();
  } catch (e) {
    debugPrint('Audio error: $e');
  }
}
