import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../main.dart';
import '../../../networking/api_response.dart';
import '../../../utils/app_mobile_settings.dart';
import '../../../utils/map_style_hot_reload.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_service_mode_presentation.dart';
import 'passenger_home_activity_hub.dart';
import 'passenger_home_barrio_shortcuts.dart';
import 'passenger_home_barrio_shortcuts_ui.dart';
import '../../common/account/account_screen.dart';
import 'item_vehicle_type.dart';
import 'passenger_vehicle_deck.dart';
import 'passenger_home_bloc.dart';
import 'passenger_home_booking_sheet.dart';
import 'passenger_home_dl.dart';
import 'delivery_quick_fields.dart';
import 'delivery_direction_selector.dart';
import 'shared_ride_kind_selector.dart';
import 'shared_ride_fields.dart';
import 'acarreo_quick_fields.dart';
import 'mode_service_hint.dart';
import 'service_mode_context_strip.dart';
import 'xisti_section_label.dart';
import '../../../utils/delivery_direction_kind.dart';
import '../../../utils/shared_ride_kind.dart';
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
              addressSelection(),
              serviceData(),
              confirmBtnAndOtherOption(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _modernBody() {
    if (XistiUiTokens.isTabletOrLandscape(context)) {
      return _modernBodyTablet();
    }
    return _modernBodyPortrait();
  }

  Widget _modernMapStack() {
    return Stack(
      fit: StackFit.expand,
      children: [
        googleMap(),
        _mapCenterPin(legacyOffset: false),
      ],
    );
  }

  /// Wireframe: círculo recalcular (izq) y menú cuadrado (der), flotando sobre el panel fijo.
  Widget _mapFloatingActions() {
    return StreamBuilder<String>(
      stream: _bloc?.selectedServiceModeSubject,
      builder: (context, modeSnap) {
        final theme = getCurrentTheme(context);
        final accent = XistiUiTokens.accentForMode(modeSnap.data);
        return Positioned(
          left: commonHorizontalPadding,
          bottom: 14.h,
          child: GestureDetector(
            onTap: () => _bloc?.focusCurrentPosition(),
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: theme.colorWhite,
                shape: BoxShape.circle,
                border: Border.all(color: accent.withValues(alpha: 0.55), width: 1.5.w),
                boxShadow: XistiUiTokens.floatingShadow(context, theme.colorBorder),
              ),
              child: Icon(CustomIcons.pickupLocation, size: 24.sp, color: accent),
            ),
          ),
        );
      },
    );
  }

  Widget _accountMenuButton() {
    return StreamBuilder<String>(
      stream: _bloc?.selectedServiceModeSubject,
      builder: (context, modeSnap) {
        final accent = XistiUiTokens.accentForMode(modeSnap.data);
        return GestureDetector(
          onTap: () => openScreen(context, AccountScreen()),
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: getCurrentTheme(context).colorScaffoldBg.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: accent.withValues(alpha: 0.45), width: 1.5.w),
              boxShadow: XistiUiTokens.floatingShadow(context, getCurrentTheme(context).colorBorder),
            ),
            child: Icon(CustomIcons.menu, size: 22.sp, color: getCurrentTheme(context).colorIconCommon),
          ),
        );
      },
    );
  }

  Widget _cityZoneShortcuts() {
    return StreamBuilder<String>(
      stream: _bloc?.selectedServiceModeSubject,
      builder: (context, modeSnap) {
        return StreamBuilder<List<XistiBarrioShortcut>>(
          stream: _bloc?.activeCityZonesSubject,
          builder: (context, snap) {
            return PassengerHomeBarrioShortcuts(
              shortcuts: snap.data ?? kXistiBarrioShortcutsDefault,
              onBarrioSelected: (b) => _bloc?.flyToBarrio(b),
              accentColor: XistiUiTokens.accentForMode(modeSnap.data),
            );
          },
        );
      },
    );
  }

  Widget _panelHandle() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 8.h, bottom: 6.h),
      child: Center(
        child: Container(
          width: 48.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: getCurrentTheme(context).colorIndicatorOff,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }

  /// Bottom booking panel — route-first flow with XISTI vehicle spotlight deck.
  List<Widget> _bottomBookingPanelContent() {
    return [
      _panelHandle(),
      serviceModeSelector(),
      serviceModeContextStrip(),
      modeServiceHint(),
      sharedRideKindSelector(),
      sharedRideAddressFields(),
      deliveryDirectionSelector(),
      Padding(
        padding: EdgeInsetsDirectional.only(top: 4.h, bottom: 8.h),
        child: addressSelection(),
      ),
      serviceData(fillAvailable: false),
      cityZoneShortcuts(),
      acarreoQuickFields(),
      confirmBtnAndOtherOption(),
      SizedBox(height: 4.h),
      activityHubCard(),
    ];
  }

  Widget serviceModeContextStrip() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, snap) {
      return ServiceModeContextStrip(mode: snap.data);
    },
  );

  Widget modeServiceHint() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, snap) {
      final mode = snap.data;
      return ModeServiceHint(
        mode: mode,
        apiDisclaimer: _bloc?.disclaimerTextForMode(mode),
      );
    },
  );

  Widget cityZoneShortcuts() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, modeSnap) {
      if (!XistiServiceModePresentation.showsBarrioShortcuts(modeSnap.data)) {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: EdgeInsetsDirectional.only(bottom: 8.h),
        child: _cityZoneShortcuts(),
      );
    },
  );

  bool _isSharedRidesMode(String? mode) => ServiceModeKind.isSharedRideMode(mode);

  bool _isAcarreosMode(String? mode) => ServiceModeKind.isAcarreosMode(mode);

  Widget sharedRideKindSelector() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, snap) {
      if (!_isSharedRidesMode(snap.data)) return const SizedBox.shrink();
      return StreamBuilder<String>(
        stream: _bloc?.selectedSharedRideKindSubject,
        builder: (context, kindSnap) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              start: commonHorizontalPadding,
              end: commonHorizontalPadding,
              bottom: 6.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                XistiSectionLabel(
                  label: 'Tipo de ruta',
                  accent: XistiUiTokens.accentForMode(snap.data),
                ),
                SharedRideKindSelector(
                  selectedKind: kindSnap.data ?? SharedRideKind.defaultKind,
                  onKindChanged: _bloc!.selectSharedRideKind,
                ),
              ],
            ),
          );
        },
      );
    },
  );

  Widget deliveryDirectionSelector() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, snap) {
      if (snap.data != ServiceModeKind.delivery) return const SizedBox.shrink();
      return Padding(
        padding: EdgeInsetsDirectional.only(
          start: commonHorizontalPadding,
          end: commonHorizontalPadding,
          bottom: 8.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            XistiSectionLabel(
              label: '¿Envías o recibes?',
              accent: XistiUiTokens.deliveryAccent,
            ),
            StreamBuilder<String>(
              stream: _bloc?.selectedDeliveryDirectionSubject,
              builder: (context, dirSnap) {
                return DeliveryDirectionSelector(
                  selected: dirSnap.data ?? 'send',
                  onChanged: _bloc!.selectDeliveryDirection,
                );
              },
            ),
          ],
        ),
      );
    },
  );

  Widget sharedRideAddressFields() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, snap) {
      if (!_isSharedRidesMode(snap.data)) return const SizedBox.shrink();
      return StreamBuilder<DateTime?>(
        stream: _bloc?.sharedRideTripDateSubject,
        builder: (context, dateSnap) {
          return StreamBuilder<String>(
            stream: _bloc?.selectedSharedRideKindSubject,
            builder: (context, kindSnap) {
              return SharedRideFields(
                tripKind: kindSnap.data ?? SharedRideKind.defaultKind,
                originController: _bloc!.sharedRideOriginTEC,
                destinationController: _bloc!.sharedRideDestinationTEC,
                tripDate: dateSnap.data,
                onDateChanged: (d) => _bloc!.sharedRideTripDateSubject.add(d),
              );
            },
          );
        },
      );
    },
  );

  Widget acarreoQuickFields() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, snap) {
      if (!_isAcarreosMode(snap.data)) return const SizedBox.shrink();
      return StreamBuilder<DateTime?>(
        stream: _bloc?.acarreoEstimatedDateSubject,
        builder: (context, dateSnap) {
          return AcarreoQuickFields(
            descriptionController: _bloc!.acarreoDescriptionTEC,
            fareController: _bloc!.acarreoFareTEC,
            estimatedDate: dateSnap.data,
            onDateChanged: (d) => _bloc!.acarreoEstimatedDateSubject.add(d),
          );
        },
      );
    },
  );

  Widget _modernBookingPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _bottomBookingPanelContent(),
    );
  }

  Widget activityHubCard() => StreamBuilder(
        stream: _bloc?.activityHubSubject,
        builder: (context, snap) {
          return PassengerHomeActivityHub(
            snapshot: snap.data,
            onTap: () => _bloc?.openActivityHub(),
          );
        },
      );

  Widget _modernBodyPortrait() {
    final maxPanelH = MediaQuery.sizeOf(context).height * 0.58;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              _modernMapStack(),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 8.h,
                right: commonHorizontalPadding,
                child: _accountMenuButton(),
              ),
              _mapFloatingActions(),
            ],
          ),
        ),
        StreamBuilder<String>(
          stream: _bloc?.selectedServiceModeSubject,
          builder: (context, modeSnap) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxPanelH),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                child: PassengerHomeBookingSheet(
                  key: ValueKey(modeSnap.data ?? ServiceModeKind.transport),
                  expandToFill: false,
                  accentColor: XistiUiTokens.accentForMode(modeSnap.data),
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: _modernBookingPanel(),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _modernBodyTablet() {
    return Row(
      children: [
        Expanded(
          flex: 55,
          child: Stack(
            children: [
              _modernMapStack(),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 8.h,
                right: commonHorizontalPadding,
                child: _accountMenuButton(),
              ),
              _mapFloatingActions(),
            ],
          ),
        ),
        Expanded(
          flex: 45,
          child: Container(
            decoration: BoxDecoration(
              color: getCurrentTheme(context).colorScaffoldBg,
              border: Border(
                left: BorderSide(color: getCurrentTheme(context).colorDarkBorder.withValues(alpha: 0.5)),
              ),
            ),
            child: StreamBuilder<String>(
              stream: _bloc?.selectedServiceModeSubject,
              builder: (context, modeSnap) {
                final accent = XistiUiTokens.accentForMode(modeSnap.data);
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child: Container(
                    key: ValueKey(modeSnap.data ?? ServiceModeKind.transport),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: accent.withValues(alpha: 0.85), width: 2.w),
                      ),
                    ),
                    child: ListView(
                      padding: EdgeInsetsDirectional.only(top: 8.h, bottom: getBottomMargin()),
                      children: _bottomBookingPanelContent(),
                    ),
                  ),
                );
              },
            ),
          ),
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

  Widget deliveryFields() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, snap) {
      if (snap.data != ServiceModeKind.delivery) return const SizedBox.shrink();
      return StreamBuilder<String>(
        stream: _bloc?.packageWeightController,
        builder: (context, weightSnap) {
          return StreamBuilder<String>(
            stream: _bloc?.packageHeightController,
            builder: (context, heightSnap) {
              return StreamBuilder<String>(
                stream: _bloc?.packageWidthController,
                builder: (context, widthSnap) {
                  return StreamBuilder<String>(
                    stream: _bloc?.packageLengthController,
                    builder: (context, lengthSnap) {
                      return DeliveryQuickFields(
                        weightKg: weightSnap.data ?? '',
                        heightCm: heightSnap.data ?? '',
                        widthCm: widthSnap.data ?? '',
                        lengthCm: lengthSnap.data ?? '',
                        onWeightChanged: (v) => _bloc?.packageWeightController.sink.add(v),
                        onHeightChanged: (v) => _bloc?.packageHeightController.sink.add(v),
                        onWidthChanged: (v) => _bloc?.packageWidthController.sink.add(v),
                        onLengthChanged: (v) => _bloc?.packageLengthController.sink.add(v),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );

  Widget addressSelection() {
    return StreamBuilder<String>(
      stream: _bloc?.selectedServiceModeSubject,
      builder: (context, snap) {
        if (_isSharedRidesMode(snap.data)) return const SizedBox.shrink();
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
      },
    );
  }

  Widget multiStopAddress() {
    return StreamBuilder<ServiceTypeItem?>(
      stream: _bloc?.subjectSelectedServiceData,
      builder: (context, snapService) {
        ServiceTypeItem? selectedService = snapService.data;
        final deliveryLike = ServiceModeKind.isDeliveryLikeMode(_bloc?.selectedServiceModeSubject.valueOrNull) ||
            (selectedService?.serviceId == ServiceType.courier);
        return StreamBuilder<List<SearchedLocation>>(
          stream: _bloc?.addStopAddressList,
          builder: (context, addStopAddressList) {
            return (((addStopAddressList.data?.length ?? 0) > 0) && !deliveryLike)
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
      final isDelivery = snapMode.data == ServiceModeKind.delivery;
      return StreamBuilder<String>(
        stream: isDelivery ? _bloc?.selectedDeliveryDirectionSubject : null,
        builder: (context, dirSnap) {
          final pickupHint = isDelivery
              ? DeliveryDirectionKind.pickupHint(dirSnap.data ?? DeliveryDirectionKind.send)
              : languages.pickUpLocation;
          return StreamBuilder<SearchedLocation?>(
        stream: _bloc?.fromAddressController,
        builder: (context, snap) {
          final accent = XistiUiTokens.accentForMode(snapMode.data);
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
              Icon(CustomIcons.pickupLocation, color: accent, size: 25.sp),
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
    },
  );

  Widget toAddress() => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, snapMode) {
      final isDelivery = snapMode.data == ServiceModeKind.delivery;
      return StreamBuilder<String>(
        stream: isDelivery ? _bloc?.selectedDeliveryDirectionSubject : null,
        builder: (context, dirSnap) {
          final dropHint = isDelivery
              ? DeliveryDirectionKind.dropHint(dirSnap.data ?? DeliveryDirectionKind.send)
              : languages.dropLocation;
          return StreamBuilder<SearchedLocation?>(
        stream: _bloc?.toAddressController,
        builder: (context, snap) {
          final accent = XistiUiTokens.accentForMode(snapMode.data);
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
              Icon(CustomIcons.dropLocation, color: accent, size: 25.sp),
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
    },
  );

  Widget confirmBtnAndOtherOption() {
    return StreamBuilder<String>(
      stream: _bloc?.selectedServiceModeSubject,
      builder: (context, modeSnap) {
        final accent = XistiUiTokens.accentForMode(modeSnap.data);
        return _confirmBtnAndOtherOptionContent(accent);
      },
    );
  }

  Widget _confirmBtnAndOtherOptionContent(Color accent) {
    return StreamBuilder<String>(
      stream: _bloc?.selectedServiceModeSubject,
      builder: (context, modeSnap) {
        final mode = modeSnap.data;
        final isShared = _isSharedRidesMode(mode);
        final isAcarreo = _isAcarreosMode(mode);
        return StreamBuilder<ServiceTypeItem?>(
      stream: _bloc?.subjectSelectedServiceData,
      builder: (context, snapService) {
        final hideStopsAndOptions = (_bloc?.isEncomiendasMode ?? false) || isShared || isAcarreo;
        return Container(
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
          margin: EdgeInsetsDirectional.only(
            bottom: isXistiNewHomeLayoutEnabled()
                ? MediaQuery.paddingOf(context).bottom + 4.h
                : getBottomMargin(),
            top: 6.h,
          ),
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
                            final btnLabel = isShared
                                ? languages.searchSharedRides
                                : (isAcarreo ? languages.sendHaulingRequest : languages.offerMyFare);
                            final busy = isCalculateLoading || isBookLoading || isMapLoad;
                            return StreamBuilder<ApiResponse<Map<String, dynamic>>>(
                              stream: isShared ? _bloc?.sharedRideSearchSubject : null,
                              builder: (context, snapSearch) {
                                final searchLoading =
                                    isShared && snapSearch.hasData && snapSearch.data?.status == Status.loading;
                                return CustomRoundedButton(
                              context,
                              btnLabel,
                              (busy || searchLoading)
                                  ? null
                                  : () {
                                      openRequiredInfoBottomSheet(context, () {
                                        _bloc?.openOfferFareBottomSheet();
                                      });
                                    },
                              setProgress: busy || searchLoading,
                              bgColor: accent,
                              textColor: XistiBrand.dark,
                            );
                              },
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
            useSlimRail: isXistiNewHomeLayoutEnabled(),
          );
        },
      );
    },
  );

  Widget serviceData({bool fillAvailable = false}) => StreamBuilder<String>(
    stream: _bloc?.selectedServiceModeSubject,
    builder: (context, modeSnap) {
      return StreamBuilder<List<ServiceTypeItem>>(
        stream: _bloc?.filteredServicesSubject,
        builder: (context, snapFiltered) {
          return StreamBuilder<ApiResponse<ServiceTypeModel>>(
            stream: _bloc?.subjectServiceData,
            builder: (context, snap) {
              final isLoading = snap.hasData && snap.data?.status == Status.loading;
              final serviceTypeList = snapFiltered.data ?? [];
              if (isLoading) {
                return getServiceDataShimmer();
              }
              if (serviceTypeList.isEmpty) {
                if (_isSharedRidesMode(modeSnap.data)) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding, vertical: 12.h),
                  child: Text(
                    languages.noRecordFound,
                    style: bodyText(context: context, fontSize: textSize12px, textColor: getCurrentTheme(context).colorTextLight),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final useModern = isXistiNewHomeLayoutEnabled();

              if (useModern) {
                return StreamBuilder<ServiceTypeItem?>(
                  stream: _bloc?.subjectSelectedServiceData,
                  builder: (context, snapSelected) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PassengerVehicleDeck(
                          vehicles: serviceTypeList,
                          selected: snapSelected.data,
                          serviceMode: modeSnap.data,
                          sectionLabel: _isSharedRidesMode(modeSnap.data)
                              ? 'Tipo de vehículo'
                              : _isAcarreosMode(modeSnap.data)
                                  ? 'Tipo de carga'
                                  : null,
                          onSelect: (index) => _bloc?.vehicleSelect(index),
                        ),
                        if (_isSharedRidesMode(modeSnap.data))
                          StreamBuilder<String?>(
                            stream: _bloc?.selectedSharedRideVehicleSubject,
                            builder: (context, variantSnap) {
                              final accent = XistiUiTokens.accentForMode(modeSnap.data);
                              return Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    end: commonHorizontalPadding,
                                    bottom: 4.h,
                                  ),
                                  child: TextButton(
                                    onPressed: variantSnap.data == null ? null : () => _bloc?.selectSharedRideVehicle(null),
                                    child: Text(
                                      'Cualquier tipo',
                                      style: bodyText(context: context, fontSize: textSize12px, textColor: accent),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    );
                  },
                );
              }

              return Padding(
                padding: EdgeInsetsDirectional.only(
                  start: commonHorizontalPadding,
                  end: commonHorizontalPadding,
                  top: 2.h,
                  bottom: 2.h,
                ),
                child: SizedBox(
                  height: useModern ? XistiUiTokens.wireframeVehicleTileHeight : 78.h,
                  child: serviceTypeList.length <= 2
                      ? Row(
                          children: [
                            for (var position = 0; position < serviceTypeList.length; position++) ...[
                              if (position > 0) SizedBox(width: 10.w),
                              Expanded(
                                child: _vehicleTile(
                                  serviceTypeList,
                                  position,
                                  modeSnap.data,
                                  wireframe: useModern,
                                ),
                              ),
                            ],
                          ],
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: serviceTypeList.length,
                          itemBuilder: (context, position) => _vehicleTile(
                            serviceTypeList,
                            position,
                            modeSnap.data,
                            wireframe: useModern,
                          ),
                        ),
                ),
              );
            },
          );
        },
      );
    },
  );

  Widget _vehicleTile(
    List<ServiceTypeItem> serviceTypeList,
    int position,
    String? serviceMode, {
    bool wireframe = false,
    bool photoTile = false,
    double? photoTileHeight,
  }) {
    final textOnly = false;
    return GestureDetector(
      onTap: () => _bloc?.vehicleSelect(position),
      child: StreamBuilder<ServiceTypeItem?>(
        stream: _bloc?.subjectSelectedServiceData,
        builder: (context, snapSelectedService) {
          final selected = snapSelectedService.data;
          final item = serviceTypeList[position];
          return ItemVehicleType(
            serviceTypeItem: item,
            isSelected: item.matchesSelection(selected),
            serviceMode: serviceMode,
            expanded: serviceTypeList.length <= 2 && !photoTile,
            wireframeTile: wireframe && !photoTile && !textOnly,
            photoTile: photoTile,
            textOnlyTile: textOnly,
            photoTileHeight: photoTileHeight,
          );
        },
      ),
    );
  }

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
            boxShadow: topOffset != null ? XistiUiTokens.floatingShadow(context, getCurrentTheme(context).colorBorder) : null,
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
