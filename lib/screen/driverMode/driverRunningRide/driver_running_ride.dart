import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/courier_detail_bottom_sheet.dart';
import '../../../bottomSheet/sos_number_bottom_sheet.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../commonView/primary_action_button.dart';
import '../../../commonView/statusView/driver_ride_status_view.dart';
import '../../../constant/chat_constant.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/app_mobile_settings.dart';
import '../../../utils/map_style_hot_reload.dart';
import '../../../utils/service_mode_util.dart';
import '../../../utils/utils.dart';
import '../../common/chatting/chatting_screen.dart';
import 'driver_running_ride_bloc.dart';
import 'driver_running_ride_dl.dart';
import 'driver_running_ride_shimmer.dart';

class DriverRunningRide extends StatefulWidget {
  final int rideId, serviceId;
  final bool isCourierDelivery;

  const DriverRunningRide({super.key, required this.rideId, this.isCourierDelivery = false, required this.serviceId});

  @override
  State<DriverRunningRide> createState() => _DriverRunningRideState();
}

class _DriverRunningRideState extends State<DriverRunningRide> {
  final completer = Completer<GoogleMapController>();
  DriverRunningRideBloc? _bloc;
  bool isFirstClick = true;
  Timer? _timer;
  MapStyleHotReloadHandle? _mapStyleHotReload;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    _bloc ??= DriverRunningRideBloc(context: context, rideId: widget.rideId, serviceId: widget.serviceId);
    _mapStyleHotReload?.dispose();
    _mapStyleHotReload = MapStyleHotReload.bind(
      context: context,
      onStyle: (changedStyle) => _bloc?.mapStyleController.sink.add(changedStyle),
      onExtras: () async {
        _bloc?.changePolylineColorPerTheme();
      },
    );
    await _bloc?.mapApiCall();
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
        _bloc?.callRideDetailsApi();
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        child: ScaffoldWithSafeArea(resizeToAvoidBottomInset: false, body: _buildDriverRunningRideScreen()),
      ),
    );
  }

  Widget _buildDriverRunningRideScreen() {
    return StreamBuilder<int>(
      stream: _bloc?.subjectStatus,
      builder: (context, snapshot) {
        return Stack(
          children: [
            _googleMapView(),
            StreamBuilder<ApiResponse<DriverRunningRidePojo>>(
              stream: _bloc?.subject,
              builder: (context, subject) {
                switch (subject.data?.status ?? Status.loading) {
                  case Status.loading:
                    return DriverRunningRideShimmer();
                  case Status.completed:
                    DriverRunningRidePojo? driverRunningRideData = subject.data?.data;
                    if (driverRunningRideData != null) {
                      return _buildDriverRunningRideDetailsView(driverRunningRideData);
                    } else {
                      return SizedBox(height: 0, width: 0);
                    }
                  case Status.error:
                    return AppErrorWidget(
                      errorMessage: subject.data?.message ?? languages.errorMessageCommon,
                      onRetryPressed: () {
                        _bloc?.callRideDetailsApi();
                      },
                    );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _googleMapView() {
    return StreamBuilder<List<Marker>>(
      stream: _bloc?.markersListController,
      builder: (context, snap) {
        return StreamBuilder<List<Marker>>(
          stream: _bloc?.rotateMarkerListController,
          builder: (context, rotateMarkerSnap) {
            return StreamBuilder<Map<PolylineId, Polyline>>(
              stream: _bloc?.polyLinesController,
              builder: (context, polyLinesSnap) {
                return StreamBuilder<String>(
                  stream: _bloc?.mapStyleController,
                  builder: (context, mapStyle) {
                    return Animarker(
                      useRotation: true,
                      shouldAnimateCamera: false,
                      curve: Curves.linear,
                      mapId: completer.future.then<int>((value) => value.mapId),
                      markers: (rotateMarkerSnap.data != null && rotateMarkerSnap.data!.isNotEmpty)
                          ? Set<Marker>.of(rotateMarkerSnap.data!)
                          : <Marker>{},
                      child: GoogleMap(
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        myLocationButtonEnabled: true,
                        compassEnabled: false,
                        mapToolbarEnabled: false,

                        mapType: MapType.normal,
                        style: mapStyle.data,
                        markers: (snap.data != null && snap.data!.isNotEmpty) ? Set<Marker>.of(snap.data!) : <Marker>{},
                        polylines: (polyLinesSnap.data != null && polyLinesSnap.data!.isNotEmpty)
                            ? Set<Polyline>.of(polyLinesSnap.data!.values)
                            : <Polyline>{},
                        initialCameraPosition: initCameraPosition,
                        onMapCreated: (controller) {
                          _bloc?.onMapCreated(controller);
                          completer.complete(controller);
                        },
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

  Widget _buildDriverRunningRideDetailsView(DriverRunningRidePojo driverRunningRideData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        CommonAppBar(backgroundColor: Colors.transparent, toolbarHeight: 0),
        SizedBox(height: 10.sp),
        _currentDestinationView(driverRunningRideData),
        Spacer(),
        _sosBtn(driverRunningRideData.rideDetails?.sosContactList ?? []),
        _getCurrentLocationBtn(),
        _bottomSheetView(driverRunningRideData),
      ],
    );
  }

  Widget _currentDestinationView(DriverRunningRidePojo driverRunningRideData) {
    return StreamBuilder<String>(
      stream: _bloc?.addressTitleController,
      builder: (context, addressTitleController) {
        return Container(
          margin: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
          padding: EdgeInsetsDirectional.symmetric(horizontal: 15.sp, vertical: 15.sp),
          decoration: BoxDecoration(
            color: getCurrentTheme(context).colorWhite,
            border: Border.all(color: getCurrentTheme(context).colorBlack, width: 1.sp),
            borderRadius: BorderRadiusDirectional.all(Radius.circular(22.r)),
          ),
          child: StreamBuilder<String>(
            stream: _bloc?.addressController,
            builder: (context, addressController) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addressTitleController.data ?? "",
                          style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w400),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          addressController.data ?? "",
                          style: bodyText(context: context, fontSize: textSize16px, fontWeight: FontWeight.w400),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      _bloc?.navigateTo();
                    },
                    child: Container(
                      margin: EdgeInsetsDirectional.only(start: 15.sp),
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 5.sp, vertical: 5.sp),
                      decoration: BoxDecoration(
                        color: getCurrentTheme(context).colorWhite,
                        border: Border.all(color: getCurrentTheme(context).colorBlack, width: 0.5.sp),
                        borderRadius: BorderRadiusDirectional.all(Radius.circular(8.r)),
                      ),
                      child: Icon(CustomIcons.navigation, size: 16.sp, color: getCurrentTheme(context).colorIconCommon),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _sosBtn(List<SosContactList> sosContactList) {
    if (sosContactList.isEmpty) return SizedBox(height: 0, width: 0);
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: GestureDetector(
        onTap: () {
          openSosBottomSheet(
            context,
            sosContactList,
            triggerContext: SosTriggerContext(rideId: widget.rideId, userRole: 'driver'),
          );
        },
        child: Container(
          margin: EdgeInsetsDirectional.only(end: commonHorizontalPadding, bottom: 10.h),
          padding: EdgeInsetsDirectional.all(10.sp),
          decoration: BoxDecoration(
            color: getCurrentTheme(context).colorSosBg,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(100.r)),
          ),
          child: Icon(CustomIcons.sos, size: 20.sp, color: getCurrentTheme(context).colorStaticWhite),
        ),
      ),
    );
  }

  Widget _getCurrentLocationBtn() {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: GestureDetector(
        onTap: () {
          _bloc?.getCurrentLocation(isCallRideDetailsApi: false);
        },
        child: Container(
          margin: EdgeInsetsDirectional.only(end: commonHorizontalPadding, bottom: 10.h),
          padding: EdgeInsetsDirectional.all(10.sp),
          decoration: BoxDecoration(
            color: getCurrentTheme(context).colorWhite,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(100.r)),
            border: Border.all(color: getCurrentTheme(context).colorBorder, width: 1.sp),
          ),
          child: Icon(CustomIcons.pickupLocation, size: 20.sp, color: getCurrentTheme(context).colorBlack),
        ),
      ),
    );
  }

  bool _canCancelRide(RideDetails? details) {
    if ((details?.driverCanCancel ?? 0) == 1) {
      return true;
    }
    final status = details?.rideStatus ?? 0;
    return status <= getDriverCancelUntilStatus();
  }

  Widget _bottomSheetView(DriverRunningRidePojo driverRunningRideData) {
    final rideDetails = driverRunningRideData.rideDetails;
    final showCancel = _canCancelRide(rideDetails);
    return StreamBuilder<ApiResponse<UpdateRideStatusPojo>>(
      stream: _bloc?.subjectUpdateRideStatus,
      builder: (context, snap) {
        var isLoading = snap.hasData && snap.data?.status == Status.loading;
        return Container(
          padding: EdgeInsetsDirectional.only(
            start: commonHorizontalPadding,
            end: commonHorizontalPadding,
            top: 30.h,
            bottom: getBottomMargin(),
          ),
          decoration: BoxDecoration(
            color: getCurrentTheme(context).colorWhite,
            border: Border.all(color: getCurrentTheme(context).colorWhite, width: 0),
            borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20.r), topStart: Radius.circular(20.r)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ((driverRunningRideData.rideDetails?.otherUserName ?? "").isNotEmpty)
                  ? _otherUserDetailsView(driverRunningRideData)
                  : _userDetailsView(driverRunningRideData),
              SizedBox(height: 20.h),
              if (ServiceModeKind.isDeliveryRideRequest(
                serviceId: driverRunningRideData.rideDetails?.serviceId,
                itemDescription: driverRunningRideData.rideDetails?.itemDescription,
                recipientName: driverRunningRideData.rideDetails?.recipientName,
              ))
                courierDetailView(driverRunningRideData.rideDetails),
              if ((driverRunningRideData.rideDetails?.additionalRemark ?? "").isNotEmpty &&
                  ((driverRunningRideData.rideDetails?.rideStatus ?? 0) <= DriverRideStatus.driverRunning))
                AdditionalNoteView(
                  title: languages.noteFromCustomer,
                  additionalNote: driverRunningRideData.rideDetails?.additionalRemark ?? "",
                  sideMargin: EdgeInsetsDirectional.only(bottom: 20.h),
                ),
              if ((rideDetails?.rideStatus ?? 0) <= DriverRideStatus.driverSchedule) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (showCancel)
                      Expanded(
                        child: StreamBuilder<ApiResponse<BaseModel>>(
                          stream: _bloc?.subjectCancelRide,
                          builder: (context, cancelRideSnap) {
                            return CustomRoundedButton(
                              context,
                              languages.cancelRide,
                              () {
                                _bloc?.openCancelRideConfirmationSheet();
                              },
                              minWidth: commonBtnWidth150w,
                              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 10.h),
                              margin: EdgeInsetsDirectional.only(bottom: getBottomMargin()),
                              setBorder: true,
                              setProgress: cancelRideSnap.data?.status == Status.loading,
                              fontWeight: FontWeight.w600,
                              textColor: getCurrentTheme(context).colorBlack,
                            );
                          },
                        ),
                      ),
                    if (showCancel) SizedBox(width: 20.w),
                    Expanded(
                      child: CustomRoundedButton(
                        context,
                        languages.arrived,
                        () {
                          _bloc?.rideButtonOnTapAction(callRideDetailsApi: true);
                        },
                        minWidth: commonBtnWidth150w,
                        padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 10.h),
                        margin: EdgeInsetsDirectional.only(bottom: getBottomMargin()),
                        fontWeight: FontWeight.w600,
                        setProgress: isLoading,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                if (showCancel) ...[
                  StreamBuilder<ApiResponse<BaseModel>>(
                    stream: _bloc?.subjectCancelRide,
                    builder: (context, cancelRideSnap) {
                      return CustomRoundedButton(
                        context,
                        languages.cancelRide,
                        () {
                          _bloc?.openCancelRideConfirmationSheet();
                        },
                        minWidth: double.maxFinite,
                        padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 10.h),
                        margin: EdgeInsetsDirectional.only(bottom: 12.h),
                        setBorder: true,
                        setProgress: cancelRideSnap.data?.status == Status.loading,
                        fontWeight: FontWeight.w600,
                        textColor: getCurrentTheme(context).colorBlack,
                      );
                    },
                  ),
                ],
                StreamBuilder<String>(
                  stream: _bloc?.actionBtnTextController,
                  builder: (context, snapText) {
                    return Container(
                      margin: EdgeInsetsDirectional.only(bottom: getBottomMargin()),
                      child: PrimaryActionButton(
                        context: context,
                        text: snapText.data ?? languages.continueTxt,
                        onPressed: () {
                          _bloc?.rideButtonOnTapAction();
                        },
                        setProgress: isLoading,
                      ),
                    );
                  },
                ),
              ],
              // SizedBox(height: getBottomMargin()),
            ],
          ),
        );
      },
    );
  }

  Widget courierDetailView(RideDetails? rideDetails) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          enableDrag: false,
          isDismissible: false,
          isScrollControlled: true,
          builder: (context) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: MediaQueryData.fromView(View.of(context)).padding.top + 10.h,
              ),
              child: CourierDetailBottomSheet(
                itemDescription: rideDetails?.itemDescription ?? "",
                recipientName: rideDetails?.recipientName ?? "",
                recipientContactNumber: rideDetails?.recipientContactNumber ?? "",
                estimatePrice: "${rideDetails?.estimatePrice ?? "0"}",
              ),
            );
          },
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              height: 1.h,
              margin: EdgeInsetsDirectional.only(bottom: 15.h),
              color: getCurrentTheme(context).colorLoginLine,
            ),
            Row(
              children: [
                Icon(CustomIcons.orderId, color: getCurrentTheme(context).colorIconCommon, size: 20.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(languages.courierDetail, style: bodyText(context: context)),
                ),
                SizedBox(width: 10.w),
                Transform(
                  alignment: AlignmentDirectional.center,
                  transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
                  child: Icon(CustomIcons.arrowForward, color: getCurrentTheme(context).colorIconCommon, size: 15.sp),
                ),
              ],
            ),
            Container(
              height: 1.h,
              margin: EdgeInsetsDirectional.only(top: 15.h, bottom: 15.h),
              color: getCurrentTheme(context).colorLoginLine,
            ),
          ],
        ),
      ),
    );
  }

  Widget _userDetailsView(DriverRunningRidePojo driverRunningRideData) {
    if (driverRunningRideData.rideDetails?.userName.trim().isEmpty ?? false) {
      return SizedBox(width: 0, height: 0);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        LoadImageWithPlaceHolder(
          width: 70.sp,
          height: 70.sp,
          image: driverRunningRideData.rideDetails?.userProfileImage ?? "",
          defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                (driverRunningRideData.rideDetails?.userName ?? ""),
                style: bodyText(context: context, fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.h),
              Text(
                getAmountWithCurrency(driverRunningRideData.rideDetails?.totalAmount ?? ""),
                style: bodyText(
                  context: context,
                  fontWeight: FontWeight.w600,
                  textColor: getCurrentTheme(context).colorPrimary,
                  fontSize: textSize14px,
                ),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if ((driverRunningRideData.rideDetails?.rideStatus ?? 0) < DriverRideStatus.driverCancel)
          buildChatAndCallButton(context, CustomIcons.call, () {
            if (isFirstClick) {
              setState(() {
                isFirstClick = false;
              });
              openUrl("tel:${driverRunningRideData.rideDetails?.contactNumber ?? ""}");
              _timer = Timer(const Duration(milliseconds: 1500), () {
                setState(() {
                  isFirstClick = true;
                });
              });
            }
          }),
        SizedBox(width: 10.w),
        if ((driverRunningRideData.rideDetails?.rideStatus ?? 0) < DriverRideStatus.driverCancel)
          buildChatAndCallButton(context, CustomIcons.driverChat, () {
            openScreen(
              context,
              ChattingScreen(
                chatWithId: "${ChatConstant.userIdCode}${driverRunningRideData.rideDetails?.userId ?? 0}",
                chatWithName: driverRunningRideData.rideDetails?.userName ?? "",
                chatWithImage: driverRunningRideData.rideDetails?.userProfileImage ?? "",
                chatNo: driverRunningRideData.rideDetails?.orderChatNumber ?? "",
                chatWithUserType: ChatWithType.user,
              ),
            );
          }),
      ],
    );
  }

  Widget _otherUserDetailsView(DriverRunningRidePojo driverRunningRideData) {
    if (driverRunningRideData.rideDetails?.otherUserName.trim().isEmpty ?? false) {
      return SizedBox(width: 0, height: 0);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(CustomIcons.name, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                driverRunningRideData.rideDetails?.otherUserName ?? "",
                style: bodyText(context: context, fontWeight: FontWeight.w600),
              ),
            ),
            if ((driverRunningRideData.rideDetails?.rideStatus ?? 0) < DriverRideStatus.driverCancel)
              buildChatAndCallButton(context, CustomIcons.call, () {
                if (isFirstClick) {
                  setState(() {
                    isFirstClick = false;
                  });
                  openUrl("tel:${driverRunningRideData.rideDetails?.contactNumber ?? ""}");
                  _timer = Timer(const Duration(milliseconds: 1500), () {
                    setState(() {
                      isFirstClick = true;
                    });
                  });
                }
              }),
            SizedBox(width: 10.w),
            if ((driverRunningRideData.rideDetails?.rideStatus ?? 0) < DriverRideStatus.driverCancel)
              buildChatAndCallButton(context, CustomIcons.driverChat, () {
                openScreen(
                  context,
                  ChattingScreen(
                    chatWithId: "${ChatConstant.userIdCode}${driverRunningRideData.rideDetails?.userId ?? 0}",
                    chatWithName: driverRunningRideData.rideDetails?.userName ?? "",
                    chatWithImage: driverRunningRideData.rideDetails?.userProfileImage ?? "",
                    chatNo: driverRunningRideData.rideDetails?.orderChatNumber ?? "",
                    chatWithUserType: ChatWithType.user,
                  ),
                );
              }),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(CustomIcons.call, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
            SizedBox(width: 10.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  openUrl("tel:${driverRunningRideData.rideDetails?.otherUserContactNumber ?? ""}");
                },
                child: Text(
                  driverRunningRideData.rideDetails?.otherUserContactNumber ?? "",
                  style: bodyText(context: context, fontWeight: FontWeight.w600).copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ),
            Text(
              getAmountWithCurrency(driverRunningRideData.rideDetails?.totalAmount),
              style: bodyText(
                context: context,
                fontWeight: FontWeight.w600,
                fontSize: textSize14px,
                textColor: getCurrentTheme(context).colorPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
