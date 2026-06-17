import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:app_xisti/hive/hive_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie_animation;

import '../../../blocs/bloc.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/driver_status_button.dart';
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
      onForegroundGained: () => _bloc?.getCurrentLocation(),
      child: ScaffoldWithSafeArea(
        appBar: CommonAppBar(toolbarHeight: 0),
        body: Stack(
          children: [
            StreamBuilder<bool>(
              stream: _bloc?.statusSwitchSubject,
              builder: (context, snapOnline) {
                final online = snapOnline.data ?? false;
                if (!online) {
                  return Positioned.fill(
                    child: ColoredBox(
                      color: getCurrentTheme(context).colorScaffoldBg,
                      child: lottie_animation.Lottie.asset(
                        setLottieAnimationBasedOnTheme(context, 'offline.json'),
                        fit: BoxFit.cover,
                        alignment: AlignmentDirectional.center,
                      ),
                    ),
                  );
                }
                return Positioned.fill(child: _driverMap());
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: commonHorizontalPadding,
                    end: commonHorizontalPadding,
                    top: 8.h,
                    bottom: 8.h,
                  ),
                  child: _driverHeaderRow(),
                ),
              ),
            ),
            StreamBuilder<bool>(
              stream: _bloc?.statusSwitchSubject,
              builder: (context, snapOnline) {
                if (!(snapOnline.data ?? false)) return const SizedBox.shrink();
                return StreamBuilder<ApiResponse<AvailableRidePojo>>(
                  stream: _bloc?.availableRideSubject,
                  builder: (context, snapshot) {
                    final rideList = snapshot.data?.data?.rideList ?? [];
                    final status = snapshot.data?.status ?? Status.loading;
                    if (status == Status.error) {
                      return _driverBottomOverlay(
                        child: errorWidget(message: snapshot.data?.message ?? ''),
                      );
                    }
                    if (status == Status.loading) {
                      return _driverBottomOverlay(child: _searchingCompactBanner());
                    }
                    if (rideList.isEmpty) {
                      return _driverBottomOverlay(child: _searchingCompactBanner());
                    }
                    return _driverBottomOverlay(
                      child: rideListPanel(rideList: rideList),
                      expanded: true,
                    );
                  },
                );
              },
            ),
            StreamBuilder<bool>(
              stream: _bloc?.showHailRideSubject,
              builder: (context, snapShowHailRide) {
                if (!(snapShowHailRide.data ?? false)) return const SizedBox.shrink();
                return StreamBuilder<bool>(
                  stream: _bloc?.statusSwitchSubject,
                  builder: (context, snapSwitch) {
                    final online = snapSwitch.data ?? false;
                    return Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: GestureDetector(
                        onTap: () {
                          if (online) {
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
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _driverMap() {
    return StreamBuilder<String>(
      stream: _bloc?.mapStyleSubject,
      builder: (context, styleSnap) {
        return StreamBuilder<LatLng?>(
          stream: _bloc?.currentLocationSubject,
          builder: (context, locSnap) {
            final loc = locSnap.data ?? defaultLatLng;
            return GoogleMap(
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapType: MapType.normal,
              style: styleSnap.data,
              initialCameraPosition: CameraPosition(target: loc, zoom: 15),
              onMapCreated: (c) => _bloc?.onDriverMapCreated(c),
            );
          },
        );
      },
    );
  }

  Widget _driverHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder(
          stream: _bloc?.selectDistanceSubject,
          builder: (context, snapSelectDistance) {
            final selectDistance = snapSelectDistance.data ?? 0;
            return StreamBuilder<ApiResponse<DriverHomePojo>>(
              stream: _bloc?.driverHomeSubject,
              builder: (context, snapDriverHome) {
                final isLoading = snapDriverHome.hasData && snapDriverHome.data?.status == Status.loading;
                final isError = snapDriverHome.hasData && snapDriverHome.data?.status == Status.error;
                final searchRadius = snapDriverHome.data?.data?.searchRadius ?? [];
                return searchRadius.isNotEmpty
                    ? GestureDetector(
                        onTap: (isLoading || isError) ? null : () => _bloc?.openManageDistanceBottomSheet(),
                        child: _floatingIconButton(
                          child: Stack(
                            children: [
                              Icon(CustomIcons.radiusFilter, color: getCurrentTheme(context).colorIconCommon, size: 20.sp),
                              if (selectDistance > 0)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 7.sp,
                                    height: 7.sp,
                                    decoration: BoxDecoration(color: getCurrentTheme(context).colorPrimary, shape: BoxShape.circle),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(width: 40.w);
              },
            );
          },
        ),
        StreamBuilder<bool>(
          stream: _bloc?.statusSwitchSubject,
          builder: (context, snapStatus) {
            final status = snapStatus.data ?? getIntFromSettingBox(hiveDriverCurrentStatus) == 1;
            return StreamBuilder<ApiResponse<UpdateCurrentStatusPojo>>(
              stream: _bloc?.currentStatusSubject,
              builder: (context, snapCurrentStatus) {
                final isLoading = snapCurrentStatus.hasData && snapCurrentStatus.data?.status == Status.loading;
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
          onTap: () => openScreen(context, AccountScreen()),
          child: _floatingIconButton(child: Icon(CustomIcons.menu, color: getCurrentTheme(context).colorIconCommon, size: 20.sp)),
        ),
      ],
    );
  }

  Widget _floatingIconButton({required Widget child}) {
    return Container(
      padding: EdgeInsetsDirectional.all(10.sp),
      decoration: BoxDecoration(
        color: getCurrentTheme(context).colorScaffoldBg.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: getCurrentTheme(context).colorBorder),
        boxShadow: [
          BoxShadow(color: getCurrentTheme(context).colorBorder.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }

  Widget _driverBottomOverlay({required Widget child, bool expanded = false}) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        constraints: BoxConstraints(maxHeight: expanded ? MediaQuery.sizeOf(context).height * 0.52 : 120.h),
        decoration: BoxDecoration(
          color: getCurrentTheme(context).colorScaffoldBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(color: getCurrentTheme(context).colorBorder.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, -4)),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _searchingCompactBanner() {
    return StreamBuilder<dynamic>(
      stream: _bloc?.selectDistanceSubject,
      builder: (context, snapSelectDistance) {
        final selectDistance = snapSelectDistance.data ?? 0;
        return Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding, vertical: 16.h),
          child: Row(
            children: [
              SizedBox(
                width: 28.w,
                height: 28.w,
                child: CircularProgressIndicator(strokeWidth: 2.sp, color: getCurrentTheme(context).colorPrimary),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize14px),
                    children: [
                      TextSpan(text: languages.searchingForRideRequests.trim()),
                      if (selectDistance > 0) TextSpan(text: languages.distanceKm(getDoubleFromDynamic(selectDistance).toString())),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget rideListPanel({required List<RideList> rideList}) {
    return ListView.separated(
      padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 12.h, bottom: 90.h),
      itemCount: rideList.length,
      separatorBuilder: (_, _) => Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: 16.h),
        child: Divider(height: 0, thickness: 1.sp, color: getCurrentTheme(context).colorDivider),
      ),
      itemBuilder: (context, index) => _rideListTile(rideList[index]),
    );
  }

  Widget _rideListTile(RideList rideListItem) {
    return GestureDetector(
      onTap: () {
        _bloc?.rideListItemSubject.sink.add(rideListItem);
        _bloc?.openAcceptRequestBottomSheet(rideListItem: rideListItem);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    Icon(CustomIcons.locationRadius, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                    SizedBox(width: 8.w),
                    Text(languages.kmAway(rideListItem.distance.toString()), style: bodyText(context: context, fontWeight: FontWeight.w600)),
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
            padding: EdgeInsetsDirectional.only(top: 12.h),
            child: Row(
              children: [
                Icon(CustomIcons.pickupLocation, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                SizedBox(width: 10.w),
                Expanded(child: Text(rideListItem.addressList.first.address, maxLines: 2, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 10.h),
            child: Row(
              children: [
                Icon(CustomIcons.dropLocation, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                SizedBox(width: 10.w),
                Expanded(child: Text(rideListItem.addressList.last.address, maxLines: 2, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget errorWidget({required String message}) {
    return Padding(
      padding: EdgeInsetsDirectional.all(commonHorizontalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NoRecordFound(message: message),
          CustomRoundedButton(context, languages.retry, () => _bloc?.callAvailableRideApi(isLoading: true)),
        ],
      ),
    );
  }
}
