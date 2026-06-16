import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../networking/api_response.dart';
import '../../../utils/app_mobile_settings.dart';
import '../../../utils/map_style_hot_reload.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_home_ui_tokens.dart';
import '../../common/account/account_screen.dart';
import 'item_vehicle_type.dart';
import 'passenger_home_bloc.dart';
import 'passenger_home_booking_sheet.dart';
import 'passenger_home_dl.dart';
import 'passenger_home_search_card.dart';
import 'passenger_home_service_chips_bar.dart';
import 'encomienda_quick_fields.dart';
import '../../../utils/service_mode_util.dart';
import 'service_mode_selector.dart';

class PassengerHome extends StatefulWidget {
  final bool isFromLogin;

  const PassengerHome({super.key, this.isFromLogin = false});

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  PassengerHomeBloc? _bloc;
  final controller = Completer<GoogleMapController>();
  MapStyleHotReloadHandle? _mapStyleHotReload;

  @override
  Future<void> didChangeDependencies() async {
    _bloc ??= PassengerHomeBloc(context, widget.isFromLogin);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(backgroundColor: Colors.transparent, toolbarHeight: 0),
      body: isXistiNewHomeLayoutEnabled() ? _modernBody() : _legacyBody(),
    );
  }

  Widget _legacyBody() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              googleMap(),
              accountBtn(),
              _legacyMapChrome(),
              _mapCenterPin(legacyOffset: true),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: getCurrentTheme(context).colorScaffoldBg,
            border: Border.all(width: 0, color: Colors.transparent),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              serviceModeSelector(),
              serviceData(),
              encomiendaFields(),
              addressSelection(),
              confirmBtnAndOtherOption(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _modernBody() {
    final sheetInitial = XistiHomeUiTokens.sheetInitialSize(context);
    final sheetMin = XistiHomeUiTokens.sheetMinSize(context);
    final sheetMax = XistiHomeUiTokens.sheetMaxSize(context);
    final topInset = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        Positioned.fill(child: googleMap()),
        _mapCenterPin(legacyOffset: false),
        Positioned(
          top: topInset + 8.h,
          left: 0,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<String>(
                stream: _bloc?.selectedServiceModeSubject,
                builder: (context, modeSnap) {
                  return StreamBuilder<SearchedLocation?>(
                    stream: _bloc?.fromAddressController,
                    builder: (context, fromSnap) {
                      return StreamBuilder<SearchedLocation?>(
                        stream: _bloc?.toAddressController,
                        builder: (context, toSnap) {
                          return StreamBuilder<List<Map<String, dynamic>>>(
                            stream: _bloc?.locationHistorySubject,
                            builder: (context, historySnap) {
                              return PassengerHomeSearchCard(
                                serviceMode: modeSnap.data,
                                pickup: fromSnap.data,
                                dropoff: toSnap.data,
                                recentTrips: historySnap.data ?? [],
                                onPickupTap: () => _bloc?.selectAddress(selectedIndex: 1),
                                onDropoffTap: () => _bloc?.selectAddress(selectedIndex: 2),
                                onClearPickup: () => _bloc?.fromAddressController.sink.add(null),
                                onClearDropoff: () {
                                  _bloc?.toAddressController.sink.add(null);
                                  _bloc?.clearMapData();
                                },
                                onRecentDestinationTap: (entry) => _bloc?.applyRecentDestinationEntry(entry),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 8.h),
              StreamBuilder<String>(
                stream: _bloc?.selectedServiceModeSubject,
                builder: (context, snapMode) {
                  return StreamBuilder<ApiResponse<ServiceTypeModel>>(
                    stream: _bloc?.subjectServiceData,
                    builder: (context, snapHome) {
                      final groups = snapHome.data?.data?.serviceModes ??
                          ServiceModeKind.groupsFromFlatServices(snapHome.data?.data?.services ?? []);
                      return PassengerHomeServiceChipsBar(
                        selectedMode: snapMode.data ?? ServiceModeKind.transport,
                        groups: groups,
                        onModeSelected: (mode) => _bloc?.selectServiceMode(mode),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        accountBtn(topOffset: topInset + 8.h),
        Positioned(
          right: commonHorizontalPadding,
          bottom: MediaQuery.sizeOf(context).height * sheetInitial + 12.h,
          child: GestureDetector(
            onTap: () => _bloc?.focusCurrentPosition(),
            child: Container(
              decoration: BoxDecoration(
                color: getCurrentTheme(context).colorWhite,
                borderRadius: BorderRadiusDirectional.all(Radius.circular(50.r)),
                boxShadow: XistiHomeUiTokens.floatingShadow(context, getCurrentTheme(context).colorBorder),
              ),
              padding: EdgeInsetsDirectional.all(10.sp),
              child: Icon(CustomIcons.pickupLocation, size: 28.sp, color: getCurrentTheme(context).colorIconCommon),
            ),
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: sheetInitial,
          minChildSize: sheetMin,
          maxChildSize: sheetMax,
          snap: true,
          snapSizes: [sheetMin, sheetInitial, sheetMax],
          builder: (context, scrollController) {
            return PassengerHomeBookingSheet(
              scrollController: scrollController,
              children: [
                serviceData(),
                encomiendaFields(),
                confirmBtnAndOtherOption(),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _legacyMapChrome() {
    return Stack(
      children: [
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Container(
            alignment: AlignmentDirectional.center,
            height: 25.h,
            decoration: BoxDecoration(
              color: getCurrentTheme(context).colorScaffoldBg,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
              border: Border.all(width: 0, color: Colors.transparent),
              boxShadow: [
                BoxShadow(color: getCurrentTheme(context).colorBorder.withValues(alpha: 0.5), blurRadius: 6, spreadRadius: 0.8, offset: Offset(0, 0)),
              ],
            ),
            child: Container(width: 80.w, height: 4.h, color: getCurrentTheme(context).colorIndicatorOff),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _bloc?.focusCurrentPosition(),
                child: Container(
                  alignment: AlignmentDirectional.bottomEnd,
                  margin: EdgeInsetsDirectional.only(end: commonHorizontalPadding, bottom: 40.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: getCurrentTheme(context).colorWhite,
                      borderRadius: BorderRadiusDirectional.all(Radius.circular(50.r)),
                    ),
                    padding: EdgeInsetsDirectional.all(10.sp),
                    child: Icon(CustomIcons.pickupLocation, size: 30.sp, color: getCurrentTheme(context).colorIconCommon),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mapCenterPin({required bool legacyOffset}) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: StreamBuilder<SearchedLocation?>(
        stream: _bloc?.fromAddressController,
        builder: (context, snapFrom) {
          return StreamBuilder<SearchedLocation?>(
            stream: _bloc?.toAddressController,
            builder: (context, snapTo) {
              final isDataAvailable = ((snapFrom.data?.name ?? "").isNotEmpty && (snapTo.data?.name ?? "").isNotEmpty);
              if (isDataAvailable) return const SizedBox.shrink();
              return StreamBuilder<bool>(
                stream: _bloc?.mapLoadController,
                builder: (context, snapshot) {
                  final isLoading = snapshot.data ?? false;
                  return Opacity(
                    opacity: isLoading ? 0.4 : 1,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(bottom: legacyOffset ? 35.h : 0),
                      child: Image.asset(setImagesBasedOnTheme(context, "map_pointer.png"), width: 35.sp, height: 35.sp),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget encomiendaFields() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, snap) {
      if (snap.data != ServiceModeKind.encomiendas) return const SizedBox.shrink();
      return EncomiendaQuickFields(
        purchaseDescriptionController: _bloc!.purchaseDescriptionTEC,
        priceCapController: _bloc!.priceCapTEC,
      );
    },
  );

  Widget addressSelection() {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
      child: Column(
        children: [
          fromAddress(),
          multiStopAddress(),
          SizedBox(height: 15.h),
          toAddress(),
        ],
      ),
    );
  }

  Widget multiStopAddress() {
    return StreamBuilder<ServiceTypeItem?>(
      stream: _bloc?.subjectSelectedServiceData,
      builder: (context, snapService) {
        ServiceTypeItem? selectedService = snapService.data;
        return StreamBuilder<List<SearchedLocation>>(
          stream: _bloc?.addStopAddressList,
          builder: (context, addStopAddressList) {
            return (((addStopAddressList.data?.length ?? 0) > 0) && (selectedService?.serviceId != ServiceType.courier))
                ? Column(
                    children: [
                      SizedBox(height: 15.h),
                      ListView.separated(
                        padding: EdgeInsetsDirectional.zero,
                        shrinkWrap: true,
                        itemCount: addStopAddressList.data?.length ?? 0,
                        separatorBuilder: (context, pos) {
                          return SizedBox(height: 15.h);
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _bloc?.selectAddress(selectedIndex: index + 3);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 1.sp),
                              ),
                              padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 12.h, bottom: 12.h),
                              child: Row(
                                children: [
                                  Icon(CustomIcons.stopPoint, color: getCurrentTheme(context).colorIconCommon, size: 25.sp),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          addStopAddressList.data?[index].name ?? languages.stopPoint,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: bodyText(
                                            context: context,
                                            textColor: addStopAddressList.data?[index].name != null
                                                ? getCurrentTheme(context).colorTextCommon
                                                : getCurrentTheme(context).colorTextLight,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _bloc?.removeStopAddress(index);
                                    },
                                    child: Icon(CustomIcons.remove, color: getCurrentTheme(context).colorIconLight, size: 25.sp),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : Container();
          },
        );
      },
    );
  }

  Widget fromAddress() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, snapMode) {
      final pickupHint = snapMode.data == ServiceModeKind.encomiendas ? 'Dónde comprar' : languages.pickUpLocation;
      return StreamBuilder<SearchedLocation?>(
        stream: _bloc?.fromAddressController,
        builder: (context, snap) {
          return GestureDetector(
        onTap: () {
          _bloc?.selectAddress(selectedIndex: 1);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 1.sp),
          ),

          padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 12.h, bottom: 12.h),
          child: Row(
            children: [
              Icon(CustomIcons.pickupLocation, color: getCurrentTheme(context).colorIconCommon, size: 25.sp),
              Expanded(
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      snap.data?.name ?? pickupHint,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyText(
                        context: context,
                        textColor: snap.hasData ? getCurrentTheme(context).colorTextCommon : getCurrentTheme(context).colorTextLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _bloc?.fromAddressController.sink.add(null);
                },
                child: Icon(CustomIcons.remove, color: getCurrentTheme(context).colorIconLight, size: 25.sp),
              ),
            ],
          ),
        ),
      );
        },
      );
    },
  );

  Widget toAddress() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, snapMode) {
      final dropHint = snapMode.data == ServiceModeKind.encomiendas ? 'Dónde entregar' : languages.dropLocation;
      return StreamBuilder<SearchedLocation?>(
        stream: _bloc?.toAddressController,
        builder: (context, snap) {
          return GestureDetector(
        onTap: () {
          _bloc?.selectAddress(selectedIndex: 2);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 1.sp),
          ),
          padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 12.h, bottom: 12.h),
          child: Row(
            children: [
              Icon(CustomIcons.dropLocation, color: getCurrentTheme(context).colorIconCommon, size: 25.sp),
              Expanded(
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      snap.data?.name ?? dropHint,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyText(
                        context: context,
                        textColor: snap.hasData ? getCurrentTheme(context).colorTextCommon : getCurrentTheme(context).colorTextLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _bloc?.toAddressController.sink.add(null);
                  _bloc?.clearMapData();
                },
                child: Icon(CustomIcons.remove, color: getCurrentTheme(context).colorIconLight, size: 25.sp),
              ),
            ],
          ),
        ),
      );
        },
      );
    },
  );

  Widget confirmBtnAndOtherOption() {
    return StreamBuilder<ServiceTypeItem?>(
      stream: _bloc?.subjectSelectedServiceData,
      builder: (context, snapService) {
        final hideStopsAndOptions = _bloc?.isEncomiendasMode ?? false;
        return Container(
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
          margin: EdgeInsetsDirectional.only(bottom: getBottomMargin(), top: 20.h),
          child: Row(
            children: [
              if (!hideStopsAndOptions) ...[
                StreamBuilder<List<SearchedLocation>>(
                  stream: _bloc?.addStopAddressList,
                  builder: (context, addStopAddressList) {
                    List<SearchedLocation> addressList = addStopAddressList.data ?? [];
                    return Opacity(
                      opacity: (addressList.length >= 3) ? 0.4 : 1,
                      child: GestureDetector(
                        onTap: () {
                          if (addressList.length < 3) {
                            _bloc?.selectAddress(isAddStopAddress: true, selectedIndex: addressList.length + 3);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 1.sp),
                          ),
                          padding: EdgeInsetsDirectional.all(10.sp),
                          child: Icon(CustomIcons.stopPoint, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 15.w),
              ],
              Expanded(
                child: StreamBuilder<ApiResponse<RideCalculationPojo>>(
                  stream: _bloc?.subjectRideCalculation,
                  builder: (context, snapCalculation) {
                    bool isCalculateLoading = snapCalculation.hasData && snapCalculation.data?.status == Status.loading;
                    return StreamBuilder<ApiResponse<RideBookPojo>>(
                      stream: _bloc?.rideBookSubject,
                      builder: (context, snapBook) {
                        bool isBookLoading = snapBook.hasData && snapBook.data?.status == Status.loading;
                        return StreamBuilder<bool>(
                          stream: _bloc?.mapApiSubject,
                          builder: (context, snapMapLoad) {
                            bool isMapLoad = snapMapLoad.data ?? false;
                            return CustomRoundedButton(
                              context,
                              languages.offerMyFare,
                              (isCalculateLoading || isBookLoading || isMapLoad)
                                  ? null
                                  : () {
                                      openRequiredInfoBottomSheet(context, () {
                                        _bloc?.openOfferFareBottomSheet();
                                      });
                                    },
                              setProgress: (isCalculateLoading || isBookLoading || isMapLoad),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              if (!hideStopsAndOptions) ...[
                SizedBox(width: 15.w),
                GestureDetector(
                  onTap: () {
                    _bloc?.openAdditionalOptionBottomSheet();
                  },
                  child: Opacity(
                    opacity: 1,
                    child: StreamBuilder<bool>(
                      stream: _bloc?.additionalOptionController,
                      builder: (context, snapAdditional) {
                        bool additionalAvailable = snapAdditional.data ?? false;
                        return Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15.r),
                                border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 1.sp),
                              ),
                              padding: EdgeInsetsDirectional.all(10.sp),
                              child: Icon(CustomIcons.filter, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                            ),
                            if (additionalAvailable)
                              Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: Container(
                                  alignment: AlignmentDirectional.topEnd,
                                  width: 10.sp,
                                  height: 10.sp,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: getCurrentTheme(context).colorBlack),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget serviceModeSelector() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, snapMode) {
      return StreamBuilder<ApiResponse<ServiceTypeModel>>(
        stream: _bloc?.subjectServiceData,
        builder: (context, snapHome) {
          final groups = snapHome.data?.data?.serviceModes ??
              ServiceModeKind.groupsFromFlatServices(snapHome.data?.data?.services ?? []);
          return ServiceModeSelector(
            selectedMode: snapMode.data ?? ServiceModeKind.transport,
            groups: groups,
            onModeSelected: (mode) => _bloc?.selectServiceMode(mode),
          );
        },
      );
    },
  );

  Widget serviceData() => StreamBuilder<List<ServiceTypeItem>>(
    stream: _bloc?.filteredServicesSubject,
    builder: (context, snapFiltered) {
      return StreamBuilder<ApiResponse<ServiceTypeModel>>(
        stream: _bloc?.subjectServiceData,
        builder: (context, snap) {
      var isLoading = snap.hasData && snap.data?.status == Status.loading;
      List<ServiceTypeItem> serviceTypeList = snapFiltered.data ?? [];
      return isLoading
          ? getServiceDataShimmer()
          : SizedBox(
              height: 134.h,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsetsDirectional.only(bottom: 4.h, start: commonHorizontalPadding, top: 4.h),
                itemCount: serviceTypeList.length,
                itemBuilder: (BuildContext context, position) {
                  return GestureDetector(
                    onTap: () {
                      _bloc?.vehicleSelect(position);
                    },
                    child: StreamBuilder<ServiceTypeItem?>(
                      stream: _bloc?.subjectSelectedServiceData,
                      builder: (context, snapSelectedService) {
                        final selected = snapSelectedService.data;
                        final item = serviceTypeList[position];
                        return ItemVehicleType(
                          serviceTypeItem: item,
                          isSelected: item.matchesSelection(selected),
                        );
                      },
                    ),
                  );
                },
              ),
            );
        },
      );
    },
  );

  Shimmer getServiceDataShimmer() => Shimmer.fromColors(
    baseColor: getCurrentTheme(context).colorShimmerBg,
    highlightColor: Colors.grey[100]!,
    period: const Duration(milliseconds: 800),
    child: SizedBox(
      height: 120.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, bottom: 15.h),
        itemCount: 4,
        itemBuilder: (BuildContext context, position) {
          return Container(
            alignment: AlignmentDirectional.center,
            width: 80.w,
            margin: EdgeInsetsDirectional.only(end: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 10.h, bottom: 5.h),
                        decoration: BoxDecoration(
                          color: getCurrentTheme(context).colorSelectionPrimaryOpc,
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: getCurrentTheme(context).colorPrimary, width: 0.5.sp),
                        ),
                        child: SizedBox(width: double.maxFinite, height: double.maxFinite),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Container(
                        margin: EdgeInsetsDirectional.only(top: 3.h, end: 5.w),
                        child: Icon(CustomIcons.information, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Flexible(
                  child: Container(alignment: AlignmentDirectional.center, color: getCurrentTheme(context).colorTextCommon, width: 70.w, height: 20.h),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );

  Widget accountBtn({double? topOffset}) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: GestureDetector(
        onTap: () {
          openScreen(context, AccountScreen());
        },
        child: Container(
          width: 40.sp,
          height: 40.sp,
          alignment: AlignmentDirectional.center,
          margin: EdgeInsetsDirectional.only(top: topOffset ?? 40.h, end: commonHorizontalPadding),
          decoration: BoxDecoration(
            color: getCurrentTheme(context).colorScaffoldBg.withValues(alpha: topOffset != null ? 0.94 : 1),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(width: 1.w, color: getCurrentTheme(context).colorDarkBorder),
            boxShadow: topOffset != null ? XistiHomeUiTokens.floatingShadow(context, getCurrentTheme(context).colorBorder) : null,
          ),
          child: Icon(CustomIcons.menu, color: getCurrentTheme(context).colorIconCommon),
        ),
      ),
    );
  }

  StreamBuilder<List<Marker>> googleMap() => StreamBuilder<List<Marker>>(
    stream: _bloc?.rotateMarkerListController,
    builder: (context, rotateMarkerSnap) {
      return Center(
        child: StreamBuilder<List<Marker>>(
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
                        myLocationEnabled: false,
                        compassEnabled: false,
                        mapType: MapType.normal,
                        polylines: (polyLinesSnap.data != null && polyLinesSnap.data!.isNotEmpty) ? Set<Polyline>.of(polyLinesSnap.data!.values) : <Polyline>{},
                        markers: (markerSnap.data != null && (markerSnap.data ?? []).isNotEmpty) ? Set<Marker>.of(markerSnap.data!) : <Marker>{},
                        initialCameraPosition: initCameraPosition,
                        onCameraMove: (cameraPosition) {
                          _bloc?.onCameraMoved(cameraPosition);
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onCameraIdle: _bloc?.onCameraIdle,
                        onMapCreated: (value) {
                          _bloc?.onMapCreated(value);
                          controller.complete(value);
                        },
                        style: mapStyle.data,
                        myLocationButtonEnabled: false,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      );
    },
  );
}
