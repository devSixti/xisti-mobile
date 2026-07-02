import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/sos_number_bottom_sheet.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/live_ride_tracking_banner.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../commonView/statusView/passenger_ride_status_view.dart';
import '../../../constant/chat_constant.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/map_style_hot_reload.dart';
import '../../../utils/utils.dart';
import '../../common/chatting/chatting_screen.dart';
import 'passenger_running_ride_bloc.dart';
import 'passenger_running_ride_shimmer.dart';
import 'ps_running_ride_dl.dart';

class PassengerRunningRide extends StatefulWidget {
  final int rideId;
  final bool isFromNotification;

  const PassengerRunningRide({super.key, required this.rideId, this.isFromNotification = false});

  @override
  State<PassengerRunningRide> createState() => _PassengerRunningRideState();
}

class _PassengerRunningRideState extends State<PassengerRunningRide> {
  PassengerRunningRideBloc? _bloc;
  final controller = Completer<GoogleMapController>();
  bool isFirstClick = true;
  Timer? _timer;
  MapStyleHotReloadHandle? _mapStyleHotReload;

  @override
  void didChangeDependencies() async {
    _bloc ??= PassengerRunningRideBloc(context, widget.rideId, widget.isFromNotification);
    _mapStyleHotReload?.dispose();
    _mapStyleHotReload = MapStyleHotReload.bind(
      context: context,
      onStyle: (changedStyle) => _bloc?.mapStyle.sink.add(changedStyle),
      onExtras: () async {
        _bloc?.setMarkers();
        _bloc?.changePolylineColorPerTheme();
      },
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _mapStyleHotReload?.dispose();
    _bloc?.dispose();
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onForegroundGained: () {
        _bloc?.getRideDetailApi();
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            return;
          }
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        child: ScaffoldWithSafeArea(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              googleMap(),
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: StreamBuilder<ApiResponse<PassengerRunningRidePojo>>(
                  stream: _bloc?.subjectRideDetail,
                  builder: (context, snapRideDetail) {
                    if (snapRideDetail.hasData) {
                      switch (snapRideDetail.data?.status ?? Status.loading) {
                        case Status.loading:
                          return const DriverDetailShimmer(enabled: true);
                        case Status.completed:
                          PassengerRunningRidePojo? rideDetail = snapRideDetail.data?.data;
                          return Container(
                            decoration: BoxDecoration(
                              color: getCurrentTheme(context).colorScaffoldBg,
                              borderRadius: BorderRadius.circular(22.r),
                              border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 1.w),
                            ),
                            padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.h),
                            margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 50.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                driverDetail(rideDetail),
                                LiveRideTrackingBanner(
                                  rideStatus: rideDetail?.rideStatus ?? 0,
                                  etaStream: _bloc?.subjectTime,
                                  etaFallback: rideDetail?.estimatedTime,
                                ),
                              ],
                            ),
                          );
                        case Status.error:
                          return AppErrorWidget(
                            errorMessage: snapRideDetail.data?.message,
                            onRetryPressed: () {
                              _bloc?.getRideDetailApi();
                            },
                          );
                      }
                    }
                    return const DriverDetailShimmer(enabled: true);
                  },
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: StreamBuilder<ApiResponse<PassengerRunningRidePojo>>(
                  stream: _bloc?.subjectRideDetail,
                  builder: (context, snapRideDetail) {
                    if (snapRideDetail.hasData) {
                      switch (snapRideDetail.data?.status ?? Status.loading) {
                        case Status.loading:
                          return const VehicleDetailShimmer(enabled: true);
                        case Status.completed:
                          PassengerRunningRidePojo? rideDetail = snapRideDetail.data?.data;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if ((rideDetail?.sosContactList ?? []).isNotEmpty) sosBtn(rideDetail?.sosContactList ?? []),
                              gpsBtn(),
                              Container(
                                decoration: BoxDecoration(
                                  color: getCurrentTheme(context).colorScaffoldBg,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
                                ),
                                padding: EdgeInsetsDirectional.only(
                                  start: commonHorizontalPadding,
                                  end: commonHorizontalPadding,
                                  top: 20.h,
                                  bottom: getBottomMargin(),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    vehicleDetail(rideDetail),
                                    if ((rideDetail?.additionalRemark ?? "").isNotEmpty && ((rideDetail?.rideStatus ?? 0) <= passengerRunning))
                                      AdditionalNoteView(
                                        title: languages.yourAdditionalNote,
                                        additionalNote: rideDetail?.additionalRemark ?? "",
                                        sideMargin: EdgeInsetsDirectional.only(top: 20.h),
                                      ),
                                    if (canPassengerCancelRide(rideDetail?.rideStatus ?? 0)) cancelBtn(),
                                    if ((rideDetail?.rideStatus ?? 0) >= passengerPayment) processBtn(),
                                  ],
                                ),
                              ),
                            ],
                          );
                        case Status.error:
                          return AppErrorWidget(
                            errorMessage: snapRideDetail.data?.message,
                            onRetryPressed: () {
                              _bloc?.getRideDetailApi();
                            },
                          );
                      }
                    }
                    return const VehicleDetailShimmer(enabled: true);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
          margin: EdgeInsetsDirectional.only(top: 20.h),
        );
      },
    );
  }

  Widget processBtn() {
    return StreamBuilder<ApiResponse<PassengerRunningRidePojo>>(
      stream: _bloc?.subjectRideDetail,
      builder: (context, snapRideDetail) {
        PassengerRunningRidePojo? rideDetail = snapRideDetail.data?.data;
        return ((rideDetail?.rideStatus ?? 0) >= passengerPayment &&
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
                  margin: EdgeInsetsDirectional.only(top: 20.h),
                );
              },
            )
            : Container();
      },
    );
  }

  Widget vehicleDetail(PassengerRunningRidePojo? rideDetail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoadImageWithPlaceHolder(
          width: 70.sp,
          height: 70.sp,
          image: rideDetail?.vehicleImage ?? "",
          defaultAssetImage: "assets/images/app_icon.png",
          borderRadius: BorderRadius.circular(20.r),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(rideDetail?.vehicleManufactureName ?? "", style: bodyText(context: context, fontWeight: FontWeight.w600))),
                  ((rideDetail?.rideStatus ?? 0) <= 3)
                      ? ((rideDetail?.isOtp ?? 0) == 1)
                          ? RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "${languages.otp} : ",
                              style: bodyText(context: context),
                              children: [TextSpan(text: rideDetail?.otp ?? "--", style: bodyText(context: context, fontWeight: FontWeight.w600))],
                            ),
                          )
                          : Container()
                      : StreamBuilder<dynamic>(
                        stream: _bloc?.subjectTime,
                        builder: (context, snapTime) {
                          return Text("${snapTime.data ?? "--"}", style: bodyText(context: context, fontWeight: FontWeight.w600));
                        },
                      ),
                ],
              ),
              SizedBox(height: 5.h),
              Text(rideDetail?.vehicleModelName ?? "", style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w600)),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Text(rideDetail?.vehicleColor ?? "", style: bodyText(context: context, fontSize: textSize14px)),
                  Container(
                    margin: EdgeInsetsDirectional.only(start: 7.w, end: 7.w),
                    alignment: AlignmentDirectional.center,
                    padding: EdgeInsets.all(2.sp),
                    decoration: BoxDecoration(color: getCurrentTheme(context).colorTextCommon, shape: BoxShape.circle),
                  ),
                  Text(rideDetail?.vehiclePlatNo ?? "", style: bodyText(context: context, fontSize: textSize14px)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Align gpsBtn() {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: GestureDetector(
        onTap: () {
          _bloc?.fetchCurrentLocation();
        },
        child: Container(
          margin: EdgeInsetsDirectional.only(end: commonHorizontalPadding, bottom: 10.h),
          padding: EdgeInsetsDirectional.all(8.sp),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getCurrentTheme(context).colorScaffoldBg,
            border: Border.all(color: getCurrentTheme(context).colorBorder, width: 1.w),
          ),
          child: Icon(CustomIcons.pickupLocation, size: 22.sp, color: getCurrentTheme(context).colorIconCommon),
        ),
      ),
    );
  }

  Widget sosBtn(List<SosContactList> sosContactList) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: GestureDetector(
        onTap: () {
          openSosBottomSheet(
            context,
            sosContactList,
            triggerContext: SosTriggerContext(rideId: widget.rideId, userRole: 'passenger'),
          );
        },
        child: Container(
          margin: EdgeInsetsDirectional.only(end: commonHorizontalPadding, bottom: 10.h),
          padding: EdgeInsetsDirectional.all(8.sp),
          decoration: BoxDecoration(shape: BoxShape.circle, color: getCurrentTheme(context).colorSosBg),
          child: Icon(CustomIcons.sos, size: 22.sp, color: getCurrentTheme(context).colorStaticWhite),
        ),
      ),
    );
  }

  Widget driverDetail(PassengerRunningRidePojo? rideDetail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoadImageWithPlaceHolder(
          width: 70.sp,
          height: 70.sp,
          image: rideDetail?.driverProfile ?? "",
          defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
          borderRadius: BorderRadius.circular(16.r),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(rideDetail?.driverName ?? "", style: bodyText(context: context, fontWeight: FontWeight.w600).copyWith(height: 0)),
              SizedBox(height: 10.h),
              Text(
                getAmountWithCurrency(rideDetail?.totalPay ?? 0),
                style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w600, textColor: getCurrentTheme(context).colorPrimary),
              ),
            ],
          ),
        ),
        if ((rideDetail?.rideStatus ?? 0) < passengerCancel)
          GestureDetector(
            onTap: () {
              if (isFirstClick) {
                setState(() {
                  isFirstClick = false;
                });
                openUrl("tel:${rideDetail?.contactNumber ?? ""}");
                _timer = Timer(const Duration(milliseconds: 1500), () {
                  setState(() {
                    isFirstClick = true;
                  });
                });
              }
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
        if ((rideDetail?.rideStatus ?? 0) < passengerCancel)
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
    );
  }

  Widget googleMap() => StreamBuilder<List<Marker>>(
    stream: _bloc?.rotateMarkerListController,
    builder: (context, rotateMarkerSnap) {
      return StreamBuilder<List<Marker>>(
        stream: _bloc?.markersListController,
        builder: (context, markerSnap) {
          return StreamBuilder<Map<PolylineId, Polyline>>(
            stream: _bloc?.polyLinesController,
            builder: (context, polyLinesSnap) {
              return StreamBuilder<String>(
                stream: _bloc?.mapStyle,
                builder: (context, mapStyle) {
                  return Animarker(
                    useRotation: true,
                    shouldAnimateCamera: false,
                    curve: Curves.linear,
                    mapId: controller.future.then<int>((value) => value.mapId),
                    markers: (rotateMarkerSnap.data != null && rotateMarkerSnap.data!.isNotEmpty) ? Set<Marker>.of(rotateMarkerSnap.data!) : <Marker>{},
                    child: GoogleMap(
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: true,
                      mapType: MapType.normal,
                      polylines: (polyLinesSnap.data != null && polyLinesSnap.data!.isNotEmpty) ? Set<Polyline>.of(polyLinesSnap.data!.values) : <Polyline>{},
                      markers: (markerSnap.data != null && (markerSnap.data ?? []).isNotEmpty) ? Set<Marker>.of(markerSnap.data!) : <Marker>{},
                      initialCameraPosition: initCameraPosition,
                      style: mapStyle.data,
                      onMapCreated: (value) {
                        _bloc?.onMapCreated(value);
                        controller.complete(value);
                      },
                      myLocationButtonEnabled: true,
                    ),
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}
