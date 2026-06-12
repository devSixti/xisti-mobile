import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:app_xisti/hive/hive_helper.dart';
import 'package:lottie/lottie.dart' as lottie_animation;

import '../../../blocs/bloc.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/driver_status_button.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../commonView/no_record_found.dart';
import '../../../commonView/ride_request_type_chip.dart';
import '../../../utils/utils.dart';
import '../../common/account/account_screen.dart';
import '../../common/selectLocation/select_location.dart';
import 'driver_home_bloc.dart';
import 'driver_home_dl.dart';

class DriverHome extends StatefulWidget {
  final bool isFromLogin;

  const DriverHome({super.key, this.isFromLogin = false});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> with WidgetsBindingObserver {
  DriverHomeBloc? _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc ??= DriverHomeBloc(context, widget.isFromLogin);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onForegroundGained: () {
        _bloc?.getCurrentLocation();
      },
      child: ScaffoldWithSafeArea(
        appBar: CommonAppBar(toolbarHeight: 0),
        body: Stack(
          children: [
            RefreshIndicator(
              backgroundColor: getCurrentTheme(context).colorStaticWhite,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              notificationPredicate: (ScrollNotification notification) {
                return true;
              },
              onRefresh: () async {
                _bloc?.callAvailableRideApi(isLoading: true);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 30.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder(
                          stream: _bloc?.selectDistanceSubject,
                          builder: (context, snapSelectDistance) {
                            dynamic selectDistance = snapSelectDistance.data ?? 0;
                            return StreamBuilder<ApiResponse<DriverHomePojo>>(
                              stream: _bloc?.driverHomeSubject,
                              builder: (context, snapDriverHome) {
                                var isLoading = snapDriverHome.hasData && snapDriverHome.data?.status == Status.loading;
                                var isError = snapDriverHome.hasData && snapDriverHome.data?.status == Status.error;
                                List<SearchRadius>? searchRadius = snapDriverHome.data?.data?.searchRadius ?? [];
                                return searchRadius.isNotEmpty
                                    ? GestureDetector(
                                  onTap: (isLoading || isError)
                                      ? null
                                      : () {
                                    _bloc?.openManageDistanceBottomSheet();
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsetsDirectional.all(10.sp),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.r),
                                          border: Border.all(color: getCurrentTheme(context).colorBorder),
                                        ),
                                        child: Icon(CustomIcons.radiusFilter, color: getCurrentTheme(context).colorIconCommon, size: 20.sp),
                                      ),
                                      if (selectDistance > 0)
                                        Positioned.fill(
                                          child: Align(
                                            alignment: AlignmentDirectional.topEnd,
                                            child: Container(
                                              margin: EdgeInsetsDirectional.only(top: 2.h),
                                              width: 7.sp,
                                              height: 7.sp,
                                              decoration: BoxDecoration(color: getCurrentTheme(context).colorIconCommon, shape: BoxShape.circle),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                                    : Container(width: 40.w);
                              },
                            );
                          },
                        ),

                        StreamBuilder<bool>(
                          stream: _bloc?.statusSwitchSubject,
                          builder: (context, snapStatus) {
                            bool status = snapStatus.data ?? getIntFromSettingBox(hiveDriverCurrentStatus) == 1;
                            debugPrint("home status 1: ${snapStatus.data}");
                            return StreamBuilder<ApiResponse<UpdateCurrentStatusPojo>>(
                              stream: _bloc?.currentStatusSubject,
                              builder: (context, snapCurrentStatus) {
                                var isLoading = snapCurrentStatus.hasData && snapCurrentStatus.data?.status == Status.loading;
                                debugPrint("home status 2: ${snapStatus.data}");
                                return DriverStatusButton(
                                  isLoading: isLoading,
                                  defaultSelected: status,
                                  onSelect: (value) {
                                    openRequiredInfoBottomSheet(context, () {
                                      _bloc?.callUpdateCurrentStatusApi(updateStatus: value ? 1 : 0);
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            openScreen(context, AccountScreen());
                          },
                          child: Container(
                            padding: EdgeInsetsDirectional.all(10.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(color: getCurrentTheme(context).colorBorder),
                            ),
                            child: Icon(CustomIcons.menu, color: getCurrentTheme(context).colorIconCommon, size: 20.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: _bloc?.statusSwitchSubject,
                    builder: (context, snapStatus) {
                      bool status = snapStatus.data ?? false;
                      if (status) {
                        return Expanded(
                          child: StreamBuilder<ApiResponse<AvailableRidePojo>>(
                            stream: _bloc?.availableRideSubject,
                            builder: (context, snapshot) {
                              List<RideList> rideList = snapshot.data?.data?.rideList ?? [];
                              return switch (snapshot.data?.status ?? Status.loading) {
                                Status.loading => driverOnlineWidget(),
                                Status.completed => rideListWidget(rideList: rideList),
                                Status.error => errorWidget(message: snapshot.data?.message ?? ""),
                              };
                            },
                          ),
                        );
                      } else {
                        return Expanded(
                          child: lottie_animation.Lottie.asset(setLottieAnimationBasedOnTheme(context, "offline.json"), alignment: AlignmentDirectional.center),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            StreamBuilder<bool>(
              stream: _bloc?.showHailRideSubject,
              builder: (context, snapShowHailRide) {
                bool showHailRide = snapShowHailRide.data ?? false;
                if (showHailRide) {
                  return StreamBuilder<bool>(
                    stream: _bloc?.statusSwitchSubject,
                    builder: (context, snapSwitch) {
                      bool status = snapSwitch.hasData ? snapSwitch.data ?? false : false;
                      return Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: GestureDetector(
                          onTap: () {
                            if (status) {
                              openRequiredInfoBottomSheet(context, () {
                                openScreen(context, SelectLocation(showFilledLocation: false, isHailRide: true));
                              });
                            } else {
                              openSimpleSnackbar(context, languages.hailModule);
                            }
                          },
                          child: Container(
                            margin: EdgeInsetsDirectional.only(end: commonHorizontalPadding, bottom: 16.h),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: getCurrentTheme(context).colorPrimary),
                            padding: EdgeInsetsDirectional.all(13.sp),
                            child: Icon(CustomIcons.hailRide, color: getCurrentTheme(context).colorHailIcon, size: 35.sp),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget rideListWidget({required List<RideList> rideList}) {
    if (rideList.isNotEmpty) {
      return Expanded(
        child: ListView.separated(
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 90.h),
          itemBuilder: (context, index) {
            RideList rideListItem = rideList[index];
            return GestureDetector(
              onTap: () {
                _bloc?.rideListItemSubject.sink.add(rideListItem);
                _bloc?.openAcceptRequestBottomSheet(rideListItem: rideListItem);
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: getCurrentTheme(context).colorContainerBorder, width: 0.5.sp),
                            borderRadius: BorderRadius.circular(17.5.r),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(end: 8.w),
                                child: Icon(CustomIcons.locationRadius, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                              ),
                              Text(
                                languages.kmAway(rideListItem.distance.toString()),
                                style: bodyText(context: context, fontWeight: FontWeight.w600, textColor: getCurrentTheme(context).colorTextCommon),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RideRequestTypeChip(
                              serviceId: rideListItem.serviceId,
                              serviceMode: rideListItem.serviceMode,
                              isDelivery: rideListItem.isDelivery,
                              isEncomienda: rideListItem.isEncomienda,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              getAmountWithCurrency(rideListItem.offeredPrice),
                              style: bodyText(context: context, fontWeight: FontWeight.w600, textColor: getCurrentTheme(context).colorPrimary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 15.h),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(end: 10.w),
                            child: Icon(CustomIcons.pickupLocation, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                          ),
                          Expanded(
                            child: Text(
                              rideListItem.addressList.first.address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: bodyText(context: context, fontWeight: FontWeight.w400, textColor: getCurrentTheme(context).colorTextCommon),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 15.h),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(end: 10.w),
                            child: Icon(CustomIcons.dropLocation, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                          ),
                          Expanded(
                            child: Text(
                              rideListItem.addressList.last.address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: bodyText(context: context, fontWeight: FontWeight.w400, textColor: getCurrentTheme(context).colorTextCommon),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (rideListItem.scheduleDate.isNotEmpty && rideListItem.rideType == 1) ...[
                      Padding(
                        padding: EdgeInsetsDirectional.only(top: 20.h),
                        child: Row(
                          children: [
                            Text(
                              "${languages.schedule} : ",
                              style: bodyText(context: context, fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                getDateTime(rideListItem.scheduleDate, returnFormat: "dd MMM, yyyy hh:mm aa"),
                                style: bodyText(context: context, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 20.h),
                      child: Row(
                        children: [
                          LoadImageWithPlaceHolder(
                            width: 70.sp,
                            height: 70.sp,
                            borderRadius: BorderRadius.circular(15.r),
                            image: rideListItem.profileImage,
                            defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(top: 3.h, bottom: 3.h, start: 10.w),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.only(end: 1.w),
                                          child: Text(
                                            rideListItem.userName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: bodyText(context: context, fontWeight: FontWeight.w600, textColor: getCurrentTheme(context).colorTextCommon),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(CustomIcons.rating, size: 20.sp, color: getCurrentTheme(context).colorRating),
                                          Text(
                                            rideListItem.rating > 0 ? "${rideListItem.rating} (${rideListItem.totalRatings})" : "--",
                                            style: bodyText(context: context, fontWeight: FontWeight.w400, textColor: getCurrentTheme(context).colorTextCommon),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(top: 10.h),
                                    child: Row(
                                      children: [
                                        Icon(CustomIcons.time, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                                        Padding(
                                          padding: EdgeInsetsDirectional.only(start: 5.w),
                                          child: Text(
                                            rideListItem.orderTime,
                                            style: bodyText(
                                              context: context,
                                              fontWeight: FontWeight.w400,
                                              textColor: getCurrentTheme(context).colorTextCommon,
                                              fontSize: textSize14px,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: 20.h),
              child: Divider(height: 0, thickness: 1.sp, color: getCurrentTheme(context).colorDivider),
            );
          },
          itemCount: rideList.length,
        ),
      );
    } else {
      return driverOnlineWidget();
    }
  }

  Widget errorWidget({required String message}) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NoRecordFound(message: message),
          CustomRoundedButton(context, languages.retry, () {
            _bloc?.callAvailableRideApi(isLoading: true);
          }, margin: EdgeInsetsDirectional.only(bottom: 10.h, top: 10.h, start: commonHorizontalPadding, end: commonHorizontalPadding)),
        ],
      ),
    );
  }

  Widget driverOnlineWidget() {
    final bg = getCurrentTheme(context).colorScaffoldBg;
    return Expanded(
      child: ColoredBox(
        color: bg,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ColoredBox(
            color: bg,
            child: lottie_animation.Lottie.asset(
              setLottieAnimationBasedOnTheme(context, "online.json"),
              alignment: AlignmentDirectional.center,
              backgroundLoading: false,
              fit: BoxFit.contain,
            ),
          ),
          StreamBuilder<dynamic>(
            stream: _bloc?.selectDistanceSubject,
            builder: (context, snapSelectDistance) {
              dynamic selectDistance = snapSelectDistance.data ?? 0;
              return Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
                child: RichText(
                  textAlign: TextAlign.center,

                  text: TextSpan(
                    style: bodyText(
                      context: context,
                      fontWeight: FontWeight.w600,
                      fontSize: textSize18px,
                      textColor: getCurrentTheme(context).colorStaticGreyText,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: languages.searchingForRideRequests),
                      if (selectDistance > 0) TextSpan(text: languages.distanceKm(getDoubleFromDynamic(selectDistance).toString())),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        ),
      ),
    );
  }
}
