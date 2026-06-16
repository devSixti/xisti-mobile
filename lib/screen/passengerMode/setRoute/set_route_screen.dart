import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/custom_text_field.dart';
import '../../../commonView/item_location_list.dart';
import '../../../googleApi/place_auto_complete_dl.dart';
import '../../../networking/api_response.dart';
import '../../../utils/utils.dart';
import '../../common/manageAdress/item_manage_address.dart';
import '../../common/manageAdress/manage_address_dl.dart';
import '../../common/manageAdress/manage_address_shimmer.dart';
import '../passengerHome/passenger_home_dl.dart';
import 'item_multi_stop_address.dart';
import 'set_route_bloc.dart';

class SetRouteScreen extends StatefulWidget {
  final SearchedLocation? fromAddress, toAddress;
  final List<SearchedLocation>? stopAddressList;
  final bool isAddStopAddress;
  final int selectedIndex;
  final int serviceId;
  final Function(SearchedLocation? fromAddress, SearchedLocation? toAddress, List<SearchedLocation>? stopAddressList) onConfirmLocation;

  const SetRouteScreen({
    super.key,
    this.fromAddress,
    this.toAddress,
    this.stopAddressList,
    required this.selectedIndex,
    required this.serviceId,
    required this.isAddStopAddress,
    required this.onConfirmLocation,
  });

  @override
  State<SetRouteScreen> createState() => _SetRouteScreenState();
}

class _SetRouteScreenState extends State<SetRouteScreen> {
  SetRouteBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= SetRouteBloc(
      context,
      widget.fromAddress,
      widget.toAddress,
      widget.stopAddressList,
      widget.isAddStopAddress,
      widget.selectedIndex,
      widget.serviceId,
      widget.onConfirmLocation,
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      appBar: CommonAppBar(
        centerTitle: true,
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        title: Text(languages.setRoute, style: toolbarStyle(context: context)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _bloc?.scrollController,
            padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 50.h, top: 10.h),
            child: Column(children: [fromAddress(), SizedBox(height: 20.h), multiStopAddress(), toAddress(), setOnMap(), placesList(), recentLocationHistory(), savedAddresses()]),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: CustomRoundedButton(
              context,
              languages.confirmLocation,
              () {
                _bloc?.onPressConfirm();
              },
              margin: EdgeInsetsDirectional.only(top: 30.h, bottom: getBottomMargin(), start: commonHorizontalPadding, end: commonHorizontalPadding),
              minWidth: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  Widget savedAddresses() {
    return StreamBuilder<ApiResponse<AddressListPojo>>(
      stream: _bloc?.subjectManageAddress,
      builder: (context, snap) {
        var isLoading = snap.hasData && snap.data?.status == Status.loading;
        ManageAddressShimmer shimmerView = ManageAddressShimmer(enabled: isLoading);
        List<AddressType> addressTypeList = snap.data?.data?.typeList ?? [];
        return switch (snap.data?.status ?? Status.loading) {
          Status.loading => shimmerView,
          Status.completed => addressList(addressTypeList),
          Status.error => Container(),
        };
      },
    );
  }

  Widget addressList(List<AddressType> addressTypeList) {
    return addressTypeList.isNotEmpty
        ? ListView.builder(
          shrinkWrap: true,
          itemCount: addressTypeList.length,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsetsDirectional.only(top: 10.h, bottom: 80.h),
          itemBuilder: (context, index) {
            AddressType addressType = addressTypeList[index];
            return Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: 15.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getAddressTypeInString(type: addressType.type), style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600)),
                  SizedBox(height: 15.h),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: addressType.addressList.length,
                    padding: EdgeInsetsDirectional.zero,
                    itemBuilder: (context, position) {
                      ItemManageAddressList addressListItem = addressType.addressList[position];
                      return GestureDetector(
                        onTap: () {
                          _bloc?.setAddressDetail(addressListItem.address, addressListItem.lat, addressListItem.long);
                        },
                        child: ItemManageAddress(addressListItem: addressListItem, addressType: addressType, onDeletePress: null),
                      );
                    },
                    separatorBuilder: (context, position) {
                      return Divider(height: 40.h, thickness: 1.sp, color: getCurrentTheme(context).colorManageAddressDivider);
                    },
                  ),
                ],
              ),
            );
          },
        )
        : Container();
  }

  Widget recentLocationHistory() {
    return StreamBuilder<int>(
      stream: _bloc?.selectedIndexController,
      builder: (context, indexSnap) {
        final index = indexSnap.data ?? 0;
        if (index != 2) return const SizedBox.shrink();

        return StreamBuilder<List<Suggestions>>(
          stream: _bloc?.placesListController,
          builder: (context, placesSnap) {
            final searching = (placesSnap.data ?? []).isNotEmpty;
            if (searching) return const SizedBox.shrink();

            return StreamBuilder<List<Map<String, dynamic>>>(
              stream: _bloc?.locationHistorySubject,
              builder: (context, snap) {
                final trips = snap.data ?? [];
                if (trips.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 16.h, bottom: 10.h),
                      child: Text(
                        'Recientes',
                        style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: trips.length,
                      separatorBuilder: (_, _) => SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final entry = trips[index];
                        final label = '${entry['pickup_name']} → ${entry['destination_name']}';
                        return GestureDetector(
                          onTap: () => _bloc?.applyLocationHistoryEntry(entry),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: getCurrentTheme(context).colorTextFieldBorder),
                            ),
                            child: Text(
                              label,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: bodyText(context: context, fontSize: textSize13px),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget setOnMap() {
    return StreamBuilder<int>(
      stream: _bloc?.selectedIndexController,
      builder: (context, snapIndex) {
        int index = snapIndex.data ?? 0;
        return index > 0
            ? GestureDetector(
              onTap: () {
                _bloc?.selectFromMap();
              },
              child: Container(
                color: Colors.transparent,
                margin: EdgeInsetsDirectional.only(top: 20.h),
                child: Row(
                  children: [
                    Icon(CustomIcons.setOnMap, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
                    SizedBox(width: 10.w),
                    Expanded(child: Text(languages.setLocationOnMap, style: bodyText(context: context))),
                    SizedBox(width: 10.w),
                    Transform(
                        alignment: AlignmentDirectional.center,
                        transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
                        child: Icon(CustomIcons.arrowForward, size: 18.sp, color: getCurrentTheme(context).colorIconCommon)),
                  ],
                ),
              ),
            )
            : Container();
      },
    );
  }

  Widget multiStopAddress() {
    return StreamBuilder<List<SearchedLocation>>(
      stream: _bloc?.addStopAddressListController,
      builder: (context, addStopAddressList) {
        return ((addStopAddressList.data?.length ?? 0) > 0)
            ? ListView.builder(
              padding: EdgeInsetsDirectional.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: addStopAddressList.data?.length ?? 0,
              itemBuilder: (context, index) {
                return ItemMultiStopAddress(
                  bloc: _bloc!,
                  position: index,
                  multiStopModel: addStopAddressList.data![index],
                  onClickRemove: () {
                    _bloc?.removeMultiStopAddress(index);
                  },
                );
              },
            )
            : Container();
      },
    );
  }

  Widget fromAddress() => StreamBuilder<SearchedLocation?>(
    stream: _bloc?.fromAddressController,
    builder: (context, snapAddress) {
      String address = snapAddress.data?.name ?? "";
      return TextFormFieldCustom(
        controller: _bloc?.pickUpLocationTEC,
        hint: languages.pickUpLocation,
        maxLine: 1,
        onTap: () {
          _bloc?.selectedIndexController.sink.add(1);
        },
        onChanged: (value) {
          _bloc?.deBouncer.run(() {
            _bloc?.getPlaces(value);
            _bloc?.selectedIndexController.sink.add(1);
          });
        },
        suffix:
            address.isNotEmpty
                ? InkWell(
                  onTap: () {
                    _bloc?.fromAddressController.sink.add(null);
                    _bloc?.pickUpLocationTEC.text = "";
                    _bloc?.changeLocationSearch();
                    _bloc?.pickUpLocationTEC.clear();
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(end: 10.w, start: 10.w),
                    child: Icon(CustomIcons.remove, color: getCurrentTheme(context).colorIconLight, size: 25.sp),
                  ),
                )
                : Container(width: 20.w),
        commonPrefixIcon: CustomIcons.pickupLocation,
      );
    },
  );

  Widget toAddress() => StreamBuilder<SearchedLocation?>(
    stream: _bloc?.toAddressController,
    builder: (context, snapAddress) {
      String address = snapAddress.data?.name ?? "";
      return TextFormFieldCustom(
        controller: _bloc?.dropLocationTEC,
        hint: languages.dropLocation,
        maxLine: 1,
        onTap: () {
          _bloc?.selectedIndexController.sink.add(2);
        },
        onChanged: (value) {
          _bloc?.deBouncer.run(() {
            _bloc?.getPlaces(value);
            _bloc?.selectedIndexController.sink.add(2);
          });
        },
        suffix:
            address.isNotEmpty
                ? InkWell(
                  onTap: () {
                    _bloc?.toAddressController.sink.add(null);
                    _bloc?.dropLocationTEC.text = "";
                    _bloc?.changeLocationSearch();
                    _bloc?.dropLocationTEC.clear();
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(end: 10.w, start: 10.w),
                    child: Icon(CustomIcons.remove, color: getCurrentTheme(context).colorIconLight, size: 25.sp),
                  ),
                )
                : Container(width: 20.w),
        commonPrefixIcon: CustomIcons.dropLocation,
      );
    },
  );

  Widget placesList() => StreamBuilder<List<Suggestions>>(
    stream: _bloc?.placesListController,
    builder: (context, snapPlacesList) {
      List<Suggestions> data = snapPlacesList.data ?? [];
      if (data.isNotEmpty) {
        return ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsetsDirectional.only(top: 10.h),
          itemBuilder: (BuildContext context, position) {
            return ItemLocationList(
              onTap: () {
                _bloc?.onPlaceListClick(data[position].placePrediction?.placeText?.text ?? "", data[position].placePrediction?.placeId ?? "");
              },
              address: (data[position].placePrediction?.placeText?.text ?? "").isNotEmpty ? data[position].placePrediction?.placeText?.text ?? "" : "",
              leadingIcon: CustomIcons.dropLocation,
            );
          },
        );
      } else {
        return Container(height: 0);
      }
    },
  );
}
