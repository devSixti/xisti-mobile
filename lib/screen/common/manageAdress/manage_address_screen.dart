import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/no_record_found.dart';
import '../../../networking/api_response.dart';
import '../../../utils/utils.dart';
import 'item_manage_address.dart';
import 'manage_address_bloc.dart';
import 'manage_address_dl.dart';
import 'manage_address_shimmer.dart';

class ManageAddressScreen extends StatefulWidget {
  const ManageAddressScreen({super.key});

  @override
  State<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  ManageAddressBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= ManageAddressBloc(context);
    super.didChangeDependencies();
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
        title: Text(languages.manageAddress, style: toolbarStyle(context: context)),
      ),
      body: StreamBuilder<ApiResponse<AddressListPojo>>(
        stream: _bloc?.subject,
        builder: (context, snap) {
          var isLoading = snap.hasData && snap.data?.status == Status.loading;
          ManageAddressShimmer shimmerView = ManageAddressShimmer(enabled: isLoading);
          List<AddressType> addressTypeList = snap.data?.data?.typeList ?? [];
          debugPrint("my address: ${addressTypeList.length}");
          return switch (snap.data?.status ?? Status.loading) {
            Status.loading => shimmerView,
            Status.error => noAnyAddress(),
            Status.completed => addressList(addressTypeList),
          };
        },
      ),
    );
  }

  Widget addressList(List<AddressType> addressTypeList) {
    return addressTypeList.isNotEmpty
        ? Stack(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: addressTypeList.length,
              padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 10.h, bottom: 80.h),
              itemBuilder: (context, index) {
                AddressType addressType = addressTypeList[index];
                return Padding(
                  padding: EdgeInsetsDirectional.symmetric(vertical: 15.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getAddressTypeInString(type: addressType.type),
                        style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600),
                      ),
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
                              _bloc?.openAddNewAddress(addressListItem: addressListItem);
                            },
                            child: ItemManageAddress(
                              addressListItem: addressListItem,
                              addressType: addressType,
                              onDeletePress: () {
                                _bloc?.openDeleteAddressSheet(addressListItem);
                              },
                            ),
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
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: CustomRoundedButton(
                context,
                languages.addAddress,
                () {
                  _bloc?.openAddNewAddress(addressListItem: null);
                },
                // setProgress: isLoading,
                minWidth: double.infinity,
                margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin()),
              ),
            ),
          ],
        )
        : noAnyAddress();
  }

  Widget noAnyAddress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: NoRecordFound(image: "empty_manage_address.png", message: languages.noAnyAddressMsg)),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: CustomRoundedButton(
            context,
            languages.addAddress,
            () {
              _bloc?.openAddNewAddress(addressListItem: null);
            },
            minWidth: double.infinity,
            margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin()),
          ),
        ),
      ],
    );
  }
}
