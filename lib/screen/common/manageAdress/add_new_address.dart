import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/custom_text_field.dart';
import '../../../commonView/item_location_list.dart';
import '../../../googleApi/place_auto_complete_dl.dart';
import '../../../networking/api_response.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import 'add_new_address_bloc.dart';
import 'manage_address_dl.dart';

class AddNewAddress extends StatefulWidget {
  final ItemManageAddressList? addressListItem;

  const AddNewAddress({super.key, this.addressListItem});

  @override
  State<StatefulWidget> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  AddNewAddressBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= AddNewAddressBloc(context, widget.addressListItem);
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
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(widget.addressListItem == null ? languages.addAddress : languages.editAddress, style: toolbarStyle(context: context)),
        elevation: 0,
      ),
      body: _buildAddNewAddress(context),
    );
  }

  Widget _buildAddNewAddress(BuildContext context) {
    if (widget.addressListItem != null) {
      _bloc?.addressTypeController.sink.add(widget.addressListItem?.addressType ?? 0);
      _bloc?.locationController.text = widget.addressListItem?.address ?? "";
      _bloc?.latLng = LatLng(widget.addressListItem?.lat, widget.addressListItem?.long);
    }
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(bottom: 80.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(top: 10.h),
                child: _changeAddressType(_bloc!),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 25.h),
                child: _location(),
              ),
              setOnMap(),
              placesList(),
            ],
          ),
        ),
        Container(alignment: Alignment.bottomCenter, child: _saveAddressButton()),
      ],
    );
  }

  Widget _changeAddressType(AddNewAddressBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.addressTypeController,
      builder: (context, snap) {
        int selectedTab = snap.data ?? 0;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  bloc.addressTypeController.sink.add(1);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: selectedTab == 1 ? getCurrentTheme(context).colorPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: selectedTab == 1 ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorBorder, width: 1.sp),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CustomIcons.home, size: 30.sp, color: selectedTab == 1 ? getCurrentTheme(context).colorWhite : getCurrentTheme(context).colorIconCommon),
                      SizedBox(height: 5.h),
                      Text(
                        languages.home,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: bodyText(
                          context: context,
                          fontWeight: FontWeight.w600,
                          textColor: selectedTab == 1 ? getCurrentTheme(context).colorWhite : getCurrentTheme(context).colorTextCommon,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  bloc.addressTypeController.sink.add(2);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: selectedTab == 2 ? getCurrentTheme(context).colorPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: selectedTab == 2 ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorBorder, width: 1.sp),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(CustomIcons.work, size: 28.sp, color: selectedTab == 2 ? getCurrentTheme(context).colorWhite : getCurrentTheme(context).colorIconCommon),
                      SizedBox(height: 5.h),
                      Text(
                        languages.work,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: bodyText(
                          context: context,
                          fontWeight: FontWeight.w600,
                          textColor: selectedTab == 2 ? getCurrentTheme(context).colorWhite : getCurrentTheme(context).colorTextCommon,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  bloc.addressTypeController.sink.add(3);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: selectedTab == 3 ? getCurrentTheme(context).colorPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: selectedTab == 3 ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorBorder, width: 1.sp),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        CustomIcons.otherAddress,
                        size: 25.sp,
                        color: selectedTab == 3 ? getCurrentTheme(context).colorWhite : getCurrentTheme(context).colorIconCommon,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        languages.other,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: bodyText(
                          context: context,
                          fontWeight: FontWeight.w600,
                          textColor: selectedTab == 3 ? getCurrentTheme(context).colorWhite : getCurrentTheme(context).colorTextCommon,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _location() {
    return TextFormFieldCustom(
      controller: _bloc?.locationController,
      hint: languages.searchLocation,
      maxLine: 1,
      setError: true,
      onChanged: (value) {
        _bloc?.deBouncer.run(() {
          _bloc?.getPlaces(value);
        });
      },
      suffix: InkWell(
        onTap: () {
          _bloc?.locationController.clear();
          _bloc?.placesListController.sink.add([]);
        },
        child: Padding(
          padding: EdgeInsetsDirectional.only(end: 10.w, start: 10.w),
          child: Icon(CustomIcons.remove, color: getCurrentTheme(context).colorIconCommon, size: 25.sp),
        ),
      ),
      commonPrefixIcon: CustomIcons.pickupLocation,
    );
  }

  Widget _saveAddressButton() {
    return StreamBuilder<ApiResponse<BaseModel>>(
      stream: _bloc?.subject,
      builder: (context, snapLoading) {
        var isLoading = snapLoading.hasData && snapLoading.data?.status == Status.loading;
        return CustomRoundedButton(
          context,
          languages.saveAddress,
          () {
            _bloc?.submit();
          },
          setProgress: isLoading,
          minWidth: double.infinity,
          margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin()),
        );
      },
    );
  }

  Widget setOnMap() {
    return GestureDetector(
      onTap: () {
        _bloc?.gotoSelectLocation();
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsetsDirectional.only(top: 20.h),
        child: Row(
          children: [
            Icon(CustomIcons.setOnMap, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(languages.setLocationOnMap, style: bodyText(context: context)),
            ),
            SizedBox(width: 10.w),
            Transform(
              alignment: AlignmentDirectional.center,
              transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
              child: Icon(CustomIcons.arrowForward, size: 18.sp, color: getCurrentTheme(context).colorIconCommon),
            ),
          ],
        ),
      ),
    );
  }

  Widget placesList() => StreamBuilder<List<Suggestions>>(
    stream: _bloc?.placesListController,
    builder: (context, snapPlacesList) {
      List<Suggestions> data = snapPlacesList.data ?? [];
      if (data.isNotEmpty) {
        return ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
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
