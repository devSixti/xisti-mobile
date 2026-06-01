import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/child_size_notifier.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/courier_detail_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/dash_line_view.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../commonView/no_record_found.dart';
import '../../../commonView/ride_detail_item.dart';
import '../../../commonView/statusView/passenger_ride_status_view.dart';
import '../../../constant/chat_constant.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/file_downloader.dart';
import '../../../utils/map_style_hot_reload.dart';
import '../../../utils/utils.dart';
import '../../common/chatting/chatting_screen.dart';
import '../../common/reportIssue/addReportIssue/add_report_issue_screen.dart';
import '../passengerHome/passenger_home.dart';
import '../passengerRunningRide/passenger_running_ride.dart';
import '../passengerRunningRide/ps_running_ride_dl.dart';
import 'passenger_ride_detail_bloc.dart';
import 'passenger_ride_detail_shimmer.dart';

class PassengerRideDetail extends StatefulWidget {
  final int rideId;

  const PassengerRideDetail({super.key, required this.rideId});

  @override
  State<PassengerRideDetail> createState() => _PassengerRideDetailState();
}

class _PassengerRideDetailState extends State<PassengerRideDetail> {
  PassengerRideDetailBloc? _bloc;
  MapStyleHotReloadHandle? _mapStyleHotReload;

  @override
  void didChangeDependencies() async {
    _bloc ??= PassengerRideDetailBloc(context, widget.rideId);
    _mapStyleHotReload?.dispose();
    _mapStyleHotReload = MapStyleHotReload.bind(
      context: context,
      onStyle: (changedStyle) => _bloc?.mapStyle.sink.add(changedStyle),
      onExtras: () async {
        _bloc?.setMarkers();
      },
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
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (!Navigator.canPop(context)) {
          openScreenWithClearPrevious(context, const PassengerHome());
        } else {
          Navigator.pop(context);
        }
      },
      child: ScaffoldWithSafeArea(
        appBar: CommonAppBar(
          centerTitle: true,
          title: Text(languages.rideDetail, style: toolbarStyle(context: context)),
          leading: backButtonForAppBarCustom(
            context: context,
            onBackPress: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                openScreenWithClearPrevious(context, PassengerHome());
              }
            },
          ),
          actions: [actionMenu()],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(bottom: 80.h),
              child: Column(
                children: [
                  googleMap(),
                  StreamBuilder<ApiResponse<PassengerRunningRidePojo>>(
                    stream: _bloc?.subjectRideDetail,
                    builder: (context, snapRideDetail) {
                      switch (snapRideDetail.data?.status ?? Status.loading) {
                        case Status.loading:
                          return const PassengerRideDetailShimmer();

                        case Status.error:
                          return NoRecordFound(message: languages.noRecordFound);

                        case Status.completed:
                          PassengerRunningRidePojo? rideDetail = snapRideDetail.data?.data;
                          return Container(
                            alignment: AlignmentDirectional.topStart,
                            margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                PassengerRideStatusView(rideStatus: rideDetail?.rideStatus ?? 0),
                                if (rideDetail?.rideStatus == passengerCancel && (rideDetail?.cancelReason ?? "").isNotEmpty)
                                  cancelReasonView(rideDetail),
                                SizedBox(height: 20.h),
                                addressDetail(rideDetail),
                                buildRideDetail(rideDetail),
                                vehicleDetail(rideDetail),
                                driverDetail(rideDetail),
                              ],
                            ),
                          );
                      }
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: StreamBuilder<ApiResponse<PassengerRunningRidePojo>>(
                stream: _bloc?.subjectRideDetail,
                builder: (context, snapRideDetail) {
                  PassengerRunningRidePojo? rideDetail = snapRideDetail.data?.data;
                  return ((rideDetail?.rideStatus ?? 0) > 0)
                      ? Padding(
                          padding: EdgeInsetsDirectional.only(bottom: getBottomMargin()),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if ((rideDetail?.rideStatus ?? 0) == passengerPending) cancelBtn(),
                              if ((rideDetail?.rideStatus ?? 0) >= passengerDrop) processBtn(),
                            ],
                          ),
                        )
                      : Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cancelReasonView(PassengerRunningRidePojo? rideDetail) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          languages.cancellationReason,
          style: bodyText(context: context, fontSize: textSize18px),
        ),
        SizedBox(height: 5.h),
        if ((rideDetail?.cancelBy ?? "").isNotEmpty) ...[
          Text(
            "${languages.cancelBy} ${rideDetail?.cancelBy ?? ""}",
            style: bodyText(context: context, fontWeight: FontWeight.w500),
          ),
        ],
        Text(rideDetail?.cancelReason ?? "", style: bodyText(context: context)),
      ],
    );
  }

  Widget cancelBtn() {
    return StreamBuilder<ApiResponse<BaseModel>>(
      stream: _bloc?.subjectCancelOrder,
      builder: (context, snapLoad) {
        bool isLoading = snapLoad.hasData && snapLoad.data?.status == Status.loading;
        return CustomRoundedButton(
          context,
          languages.cancelRide,
          isLoading
              ? null
              : () {
                  _bloc?.openCancelRideSheet();
                },
          setProgress: isLoading,
          setBorder: true,
          margin: EdgeInsetsDirectional.only(top: 20.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
        );
      },
    );
  }

  Widget processBtn() {
    return StreamBuilder<ApiResponse<PassengerRunningRidePojo>>(
      stream: _bloc?.subjectRideDetail,
      builder: (context, snapRideDetail) {
        PassengerRunningRidePojo? rideDetail = snapRideDetail.data?.data;
        return ((rideDetail?.rideStatus ?? 0) > passengerRunning &&
                (rideDetail?.rideStatus ?? 0) <= passengerCompleted &&
                (rideDetail?.userRatingStatus != 1))
            ? StreamBuilder<ApiResponse<BaseModel>>(
                stream: _bloc?.subjectRating,
                builder: (context, snapRating) {
                  var isLoadingRating = snapRating.hasData && snapRating.data?.status == Status.loading;
                  return CustomRoundedButton(
                    context,
                    languages.rateDriver,
                    isLoadingRating
                        ? null
                        : () {
                            _bloc?.openRatingBottomSheet(rideDetail?.driverId ?? 0);
                          },
                    setBorder: false,
                    setProgress: isLoadingRating,
                    margin: EdgeInsetsDirectional.only(top: 20.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
                  );
                },
              )
            : Container();
      },
    );
  }

  Widget driverDetail(PassengerRunningRidePojo? rideDetail) {
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
              image: rideDetail?.driverProfile ?? "-",
              defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
              borderRadius: BorderRadius.circular(15.r),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rideDetail?.driverName ?? "-",
                    style: bodyText(context: context, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 15.h),
                  if ((rideDetail?.rideStatus ?? 0) < passengerCancel)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            openUrl("tel:${rideDetail?.contactNumber ?? ""}");
                          },
                          child: Container(
                            margin: EdgeInsetsDirectional.only(start: 10.w),
                            padding: EdgeInsetsDirectional.all(5.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 0.5.w),
                            ),
                            child: Icon(CustomIcons.call, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            openScreen(
                              context,
                              ChattingScreen(
                                chatWithId: "${ChatConstant.userIdCode}${rideDetail?.driverId ?? 0}",
                                chatWithName: rideDetail?.driverName ?? "",
                                chatWithImage: rideDetail?.driverProfile ?? "",
                                chatNo: rideDetail?.orderChatNumber ?? "",
                                chatWithUserType: ChatWithType.user,
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsetsDirectional.all(5.sp),
                            margin: EdgeInsetsDirectional.only(start: 10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 0.5.w),
                            ),
                            child: Icon(CustomIcons.chat, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Icon(CustomIcons.rating, color: getCurrentTheme(context).colorRating),
            SizedBox(width: 2.w),
            Text(
              (rideDetail?.driverRating ?? 0) > 0 ? "${rideDetail?.driverRating ?? 0} (${rideDetail?.totalRatings ?? 0})" : "--",
              style: bodyText(context: context, fontSize: textSize14px),
            ),
          ],
        ),
      ],
    );
  }

  Widget vehicleDetail(PassengerRunningRidePojo? rideDetail) {
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
              image: rideDetail?.vehicleImage ?? "",
              defaultAssetImage: "assets/images/app_icon.png",
              borderRadius: BorderRadius.circular(15.r),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rideDetail?.vehicleTypeName ?? "",
                    style: bodyText(context: context, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "${rideDetail?.vehicleManufactureName ?? ""} ${rideDetail?.vehicleModelName ?? ""}",
                    style: bodyText(context: context, fontWeight: FontWeight.w500, fontSize: textSize14px),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRideDetail(PassengerRunningRidePojo? rideDetail) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (rideDetail?.serviceId ?? 0) == ServiceType.courier ? languages.courierDetail : languages.rideDetail,
          textAlign: TextAlign.start,
          style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20.h),
        if ((rideDetail?.otherUserName ?? "").isNotEmpty)
          RideDetailItem(iconData: CustomIcons.name, titleText: languages.passengerName, mainText: rideDetail?.otherUserName ?? "-"),
        if ((rideDetail?.otherUserContactNumber ?? "").isNotEmpty)
          RideDetailItem(
            iconData: CustomIcons.call,
            titleText: languages.contactNumber,
            mainText: rideDetail?.otherUserContactNumber ?? "-",
          ),
        RideDetailItem(
          iconData: CustomIcons.rideDatetime,
          titleText: (rideDetail?.serviceId ?? 0) == ServiceType.courier ? languages.courierDateTime : languages.rideDateTime,
          mainText: getDateTime(rideDetail?.serviceDateTime ?? "", returnFormat: "dd MMM, yyyy hh:mm aa"),
        ),
        if ((rideDetail?.pickupDateTime ?? "").isNotEmpty && rideDetail?.rideType == 1)
          RideDetailItem(
            iconData: CustomIcons.rideDatetime,
            titleText: languages.schedule,
            mainText: getDateTime(rideDetail?.pickupDateTime ?? "", returnFormat: "dd MMM, yyyy hh:mm aa"),
          ),
        RideDetailItem(
          iconData: CustomIcons.paymentMethod,
          titleText: languages.paymentMethod,
          mainText: getPaymentType(paymentType: rideDetail?.payment ?? 0),
        ),
        RideDetailItem(
          iconData: CustomIcons.paymentStatus,
          titleText: languages.paymentStatus,
          mainText: rideDetail?.paymentStatus == 1 ? languages.completed : languages.pending,
        ),
        if ((rideDetail?.serviceId ?? 0) == ServiceType.courier)
          CourierDetailView(
            itemDesc: rideDetail?.itemDescription ?? "-",
            recipientName: rideDetail?.recipientName ?? "-",
            recipientNumber: rideDetail?.recipientContactNumber ?? "-",
            estimatedPrice: getDoubleFromDynamic("${rideDetail?.estimatePrice ?? 0}"),
          ),
        GestureDetector(
          onTap: () {
            _bloc?.openInvoiceBottomSheet();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RideDetailItem(iconData: CustomIcons.bookingId, titleText: languages.bookingId, mainText: rideDetail?.bookingNo ?? "-"),
              ),
              Text(
                getAmountWithCurrency(rideDetail?.totalPay ?? 0),
                style: bodyText(context: context, textColor: getCurrentTheme(context).colorPrimary, fontSize: textSize18px, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 5.w),
              Transform(
                alignment: AlignmentDirectional.center,
                transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
                child: Icon(CustomIcons.arrowForward, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget addressDetail(PassengerRunningRidePojo? rideDetail) {
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
                  totalHeight: (rideDetail?.addressList ?? []).length <= 2
                      ? size.height / 3
                      : (rideDetail?.addressList ?? []).length <= 4
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
                itemCount: (rideDetail?.addressList ?? []).length,
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
                              : index == (rideDetail?.addressList ?? []).length - 1
                              ? CustomIcons.dropLocation
                              : CustomIcons.stopPoint,
                          size: 20.sp,
                          color: getCurrentTheme(context).colorIconCommon,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          rideDetail?.addressList![index].address ?? "",
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

  Widget googleMap() {
    return StreamBuilder<List<Marker>>(
      stream: _bloc?.markersListController,
      builder: (context, marker) {
        return Container(
          margin: EdgeInsetsDirectional.only(top: 20.h, bottom: 20.h),
          height: 195.h,
          width: double.infinity,
          child: StreamBuilder<String>(
            stream: _bloc?.mapStyle,
            builder: (context, mapStyle) {
              return StreamBuilder<Map<PolylineId, Polyline>>(
                stream: _bloc?.polyLineController,
                builder: (context, polyLinesSnap) {
                  return GoogleMap(
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: false,
                    mapType: MapType.normal,
                    markers: (marker.data?.isNotEmpty ?? false) ? Set<Marker>.of(marker.data ?? []) : <Marker>{},
                    polylines: (polyLinesSnap.data?.length ?? 0) > 0 ? Set<Polyline>.of(polyLinesSnap.data!.values) : <Polyline>{},
                    initialCameraPosition: initCameraPosition,
                    onMapCreated: (value) {
                      _bloc?.onMapCreated(value);
                    },
                    style: mapStyle.data,
                    myLocationButtonEnabled: false,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget actionMenu() {
    return StreamBuilder<ApiResponse<PassengerRunningRidePojo>>(
      stream: _bloc?.subjectRideDetail,
      builder: (context, snapRideDetail) {
        PassengerRunningRidePojo? rideDetail = snapRideDetail.data?.data;
        return Theme(
          data: Theme.of(context).copyWith(
            dividerTheme: DividerThemeData(color: getCurrentTheme(context).colorBorder, thickness: 1.h),
          ),
          child: PopupMenuButton<int>(
            color: getCurrentTheme(context).colorScaffoldBg,
            padding: EdgeInsetsDirectional.zero,
            menuPadding: EdgeInsetsDirectional.zero,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                height: 20.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Text(
                  languages.reportIssue,
                  textAlign: TextAlign.end,
                  style: bodyText(context: context, fontSize: textSize14px),
                ),
              ),

              if ((rideDetail?.rideStatus == passengerCancel || rideDetail?.rideStatus == passengerCompleted) &&
                  (rideDetail?.invoiceDownloadLink ?? "").isNotEmpty) ...[
                const PopupMenuDivider(height: 0),
                PopupMenuItem(
                  value: 2,
                  height: 20.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: Text(
                    languages.downloadInvoice,
                    textAlign: TextAlign.end,
                    style: bodyText(context: context, fontSize: textSize14px),
                  ),
                ),
              ],

              if (((rideDetail?.rideStatus ?? 0) <= passengerRunning && (rideDetail?.rideStatus ?? 0) != passengerCancel)) ...[
                const PopupMenuDivider(height: 0),
                PopupMenuItem(
                  value: 3,
                  height: 20.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: Text(
                    languages.trackRide,
                    textAlign: TextAlign.end,
                    style: bodyText(context: context, fontSize: textSize14px),
                  ),
                ),
              ],
            ],
            initialValue: 0,
            onSelected: (value) {
              switch (value) {
                case 1:
                  openScreen(
                    context,
                    AddReportIssueScreen(
                      rideNo: rideDetail?.bookingNo ?? "",
                      rideId: rideDetail?.rideId ?? 0,
                      isFromIssueHistory: false,
                      isFromDetail: true,
                    ),
                  );
                  break;
                case 2:
                  downloadMyFile(
                    pdfUrl: rideDetail?.invoiceDownloadLink ?? "",
                    orderDate: rideDetail?.serviceDateTime ?? "",
                    bookingNo: rideDetail?.bookingNo ?? "",
                    orderId: rideDetail?.rideId ?? 0,
                  );
                  break;
                case 3:
                  openScreen(context, PassengerRunningRide(rideId: rideDetail?.rideId ?? 0));
                  break;
              }
            },
            elevation: 0,
            popUpAnimationStyle: AnimationStyle.noAnimation,
            offset: const Offset(0, 35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
              side: BorderSide(width: 1.sp, color: getCurrentTheme(context).colorBorder),
            ),
            surfaceTintColor: getCurrentTheme(context).colorScaffoldBg,
            child: Container(
              width: 30.sp,
              height: 30.sp,
              alignment: Alignment.center,
              margin: EdgeInsetsDirectional.only(end: commonHorizontalPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: getCurrentTheme(context).colorBorder, width: 1.sp),
              ),
              child: Icon(CustomIcons.menuIconDots, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
            ),
          ),
        );
      },
    );
  }
}
