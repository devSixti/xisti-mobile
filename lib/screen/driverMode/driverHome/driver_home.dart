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
import '../../../utils/app_mobile_settings.dart';
import '../../../utils/utils.dart';
import '../../common/account/account_screen.dart';
import '../../common/selectLocation/select_location.dart';
import 'driver_home_bloc.dart';
import 'driver_home_dl.dart';
import 'driver_ride_request_overlay.dart';
import 'driver_ride_request_detail_panel.dart';
import 'shared_ride_create_sheet.dart';

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
                      child: SafeArea(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final side = constraints.maxWidth * 0.82;
                            final height = (constraints.maxHeight * 0.58).clamp(220.0, constraints.maxHeight - 120);
                            return Center(
                              child: SizedBox(
                                width: side,
                                height: height,
                                child: lottie_animation.Lottie.asset(
                                  setLottieAnimationBasedOnTheme(context, 'offline.json'),
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                ),
                              ),
                            );
                          },
                        ),
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
                      return Positioned(
                        left: commonHorizontalPadding,
                        right: commonHorizontalPadding,
                        top: MediaQuery.paddingOf(context).top + 72.h,
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(16.r),
                          color: getCurrentTheme(context).colorScaffoldBg,
                          child: errorWidget(message: snapshot.data?.message ?? ''),
                        ),
                      );
                    }
                    return StreamBuilder<RideList?>(
                      stream: _bloc?.selectedDriverRideSubject,
                      builder: (context, selectedSnap) {
                        final selected = selectedSnap.data;
                        return StreamBuilder<dynamic>(
                          stream: _bloc?.selectDistanceSubject,
                          builder: (context, distSnap) {
                            final isSearching = status == Status.loading || rideList.isEmpty;
                            return Positioned.fill(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: MediaQuery.paddingOf(context).top + 64.h,
                                    child: DriverRideRequestOverlay(
                                      rideList: rideList,
                                      selectedRide: selected,
                                      isSearching: isSearching,
                                      selectDistance: distSnap.data ?? 0,
                                      onSelectRide: (ride) {
                                        if (selected?.rideId == ride.rideId) {
                                          _bloc?.selectedDriverRideSubject.sink.add(null);
                                        } else {
                                          _bloc?.selectedDriverRideSubject.sink.add(ride);
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: AnimatedSlide(
                                      duration: const Duration(milliseconds: 280),
                                      curve: Curves.easeOutCubic,
                                      offset: selected != null ? Offset.zero : const Offset(0, 1),
                                      child: selected == null
                                          ? const SizedBox.shrink()
                                          : DriverRideRequestDetailPanel(
                                              ride: selected,
                                              onClearSelection: () => _bloc?.selectedDriverRideSubject.sink.add(null),
                                onAcceptRide: (ride) {
                                  _bloc?.selectedDriverRideSubject.sink.add(null);
                                  _bloc?.rideListItemSubject.sink.add(ride);
                                  _bloc?.openAcceptRequestBottomSheet(rideListItem: ride);
                                },
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
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
            if (isExpresoMobileEnabled())
              StreamBuilder<bool>(
                stream: _bloc?.statusSwitchSubject,
                builder: (context, snapSwitch) {
                  final online = snapSwitch.data ?? false;
                  return Positioned(
                    left: commonHorizontalPadding,
                    bottom: 16.h,
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(14.r),
                      color: getCurrentTheme(context).colorScaffoldBg,
                      child: InkWell(
                        onTap: online
                            ? () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => const SharedRideCreateSheet(),
                                );
                              }
                            : () => openSimpleSnackbar(
                                  context,
                                  languages.goOnlineToPublishSharedRides,
                                ),
                        borderRadius: BorderRadius.circular(14.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: getCurrentTheme(context).colorPrimary.withValues(alpha: 0.55),
                              width: 1.5.w,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.route_outlined,
                                color: getCurrentTheme(context).colorPrimary,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                languages.sharedRide,
                                style: bodyText(
                                  context: context,
                                  textColor: getCurrentTheme(context).colorPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: textSize13px,
                                ),
                              ),
                            ],
                          ),
                        ),
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
