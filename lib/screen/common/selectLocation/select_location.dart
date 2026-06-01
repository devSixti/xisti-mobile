import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/custom_text_field.dart';
import '../../../commonView/item_location_list.dart';
import '../../../commonView/sliding_panel.dart';
import '../../../googleApi/place_auto_complete_dl.dart';
import '../../../utils/map_style_hot_reload.dart';
import '../../../utils/utils.dart';
import 'select_location_bloc.dart';

class SelectLocation extends StatefulWidget {
  final bool isHailRide;
  final bool showFilledLocation;

  const SelectLocation({super.key, required this.showFilledLocation, this.isHailRide = false});

  @override
  SelectLocationState createState() => SelectLocationState();
}

class SelectLocationState extends State<SelectLocation> with WidgetsBindingObserver {
  SelectLocationBloc? _bloc;
  bool showFilledLocation = true;
  MapStyleHotReloadHandle? _mapStyleHotReload;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    showFilledLocation = widget.showFilledLocation;
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    _bloc ??= SelectLocationBloc(context, widget.showFilledLocation, widget.isHailRide);
    _mapStyleHotReload?.dispose();
    _mapStyleHotReload = MapStyleHotReload.bind(
      context: context,
      onStyle: (changedStyle) => _bloc?.mapStyle.sink.add(changedStyle),
    );
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _bloc?.googleMapController?.animateCamera(CameraUpdate.newLatLng(_bloc?.latLng ?? defaultLatLng));
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _mapStyleHotReload?.dispose();
    _bloc?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(
        centerTitle: true,
        titleSpacing: 0,
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          languages.selectLocation,
          textAlign: TextAlign.start,
          style: toolbarStyle(context: context),
        ),
      ),
      body: _buildRideAddLocation(context),
    );
  }

  Widget _buildRideAddLocation(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _bloc?.loading,
      builder: (context, snapshot) {
        bool isLoading = snapshot.data == null ? false : snapshot.data ?? false;
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsetsDirectional.only(bottom: 195.h),
                child: Stack(
                  children: [
                    StreamBuilder<String>(
                      stream: _bloc?.mapStyle,
                      builder: (context, mapStyle) {
                        return GoogleMap(
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: true,
                          mapType: MapType.normal,
                          initialCameraPosition: initCameraPosition,
                          style: mapStyle.data,
                          onCameraMove: (cameraPosition) {
                            _bloc?.onCameraMoved(cameraPosition);
                            FocusManager.instance.primaryFocus?.unfocus();
                            _bloc?.textEditingController.clear();
                          },
                          onCameraIdle: _bloc?.onCameraIdle,
                          onMapCreated: (controller) {
                            _bloc?.onMapCreated(controller);
                          },
                          onCameraMoveStarted: () {
                            showFilledLocation = true;
                          },

                          myLocationButtonEnabled: true,
                        );
                      },
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(bottom: 20.h),
                        child: Image.asset(setImagesBasedOnTheme(context, "map_pointer.png"), height: 40.sp, width: 40.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedPadding(
                duration: Duration(milliseconds: 100),
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                curve: Curves.easeOut,
                child: SlidingUpPanel(
                  parallaxEnabled: true,
                  controller: _bloc?.controller,
                  minHeight: 205.h,
                  maxHeight: 500.h,
                  backdropOpacity: 0,
                  padding: EdgeInsets.zero,
                  boxShadow: const [],
                  color: getCurrentTheme(context).colorWhite,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
                  header: SizedBox(width: 0, height: 0),
                  // renderPanelSheet: ,
                  panelBuilder: (sc) {
                    return _panel(isLoading);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _panel(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 25.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
            child: Text(
              languages.selectYourLocation,
              textAlign: TextAlign.start,
              style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 20.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
            child: StreamBuilder<String>(
              stream: _bloc?.locationSearch,
              builder: (context, snapSearch) {
                if (snapSearch.hasData && showFilledLocation) {
                  _bloc?.textEditingController.text = snapSearch.data ?? "";
                }
                return TextFormFieldCustom(
                  hint: languages.searchLocation,
                  controller: _bloc?.textEditingController,
                  maxLine: 1,
                  borderRadius: BorderRadius.circular(15.r),
                  onChanged: (value) {
                    _bloc?.deBouncer.run(() {
                      _bloc?.getPlaces(value);
                    });
                    if (value.isEmpty) {
                      _bloc?.changePlaceList([]);
                      if (_bloc?.controller.isPanelOpen ?? false) {
                        _bloc?.controller.close();
                      }
                    }
                  },
                  suffix: (_bloc?.textEditingController.text.isEmpty ?? true)
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: commonHorizontalPadding, vertical: 10.h),
                          child: Icon(CustomIcons.search, size: 24.sp, color: getCurrentTheme(context).colorIconCommon),
                        )
                      : GestureDetector(
                          onTap: () {
                            _bloc?.changeLocationSearch("");
                            _bloc?.textEditingController.clear();
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_bloc?.controller.isPanelOpen ?? false) {
                              _bloc?.controller.close();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                            child: Icon(Icons.clear, size: 24.sp, color: getCurrentTheme(context).colorIconCommon),
                          ),
                        ),
                );
              },
            ),
          ),
          searchResultList(),
          StreamBuilder<ApiResponse>(
            stream: _bloc?.subjectHailRide,
            builder: (context, snapHail) {
              var isHailLoading = snapHail.hasData && snapHail.data?.status == Status.loading;
              return CustomRoundedButton(
                context,
                languages.confirmLocation,
                (isLoading || isHailLoading)
                    ? null
                    : () {
                        _bloc?.confirmPlace();
                      },
                setProgress: isHailLoading || isLoading,
                minWidth: double.infinity,
                margin: EdgeInsetsDirectional.only(bottom: getBottomMargin(), top: 25.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget searchResultList() {
    return StreamBuilder<String>(
      stream: _bloc?.locationSearch,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return StreamBuilder<List<Suggestions>>(
            stream: _bloc?.placesList,
            builder: (context, snapPlacesList) {
              List<Suggestions> data = snapPlacesList.data ?? [];
              return data.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        padding: EdgeInsetsDirectional.only(top: 20.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, position) {
                          return ItemLocationList(
                            onTap: () {
                              _bloc?.onPlaceListClick(data[position].placePrediction?.placeText?.text ?? "", data[position].placePrediction?.placeId ?? "");
                            },
                            address: (data[position].placePrediction?.placeText?.text ?? "").isNotEmpty
                                ? data[position].placePrediction?.placeText?.text ?? ""
                                : "",
                            leadingIcon: CustomIcons.dropLocation,
                          );
                        },
                        itemCount: data.length >= 5 ? 5 : data.length,
                      ),
                    )
                  : Container(height: 0);
            },
          );
        } else {
          return Container(height: 0);
        }
      },
    );
  }
}
