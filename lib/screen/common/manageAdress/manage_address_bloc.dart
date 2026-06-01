import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/common_bottom_sheet.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import 'add_new_address.dart';
import 'manage_address_dl.dart';
import 'manage_address_repo.dart';

class ManageAddressBloc extends Bloc {
  final BuildContext context;

  final ManageAddressRepo _manageAddressRepo = ManageAddressRepo();
  static const String tag = "ManageAddressTag>>>";
  int maxAddressLimit = 0;
  int addressListLength = 0;

  ManageAddressBloc(this.context) {
    getAddressList();
  }

  final subject = BehaviorSubject<ApiResponse<AddressListPojo>>();
  final subjectDeleteAddress = BehaviorSubject<ApiResponse<BaseModel>>();

  void getAddressList({bool showLoading = true}) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => getAddressList(showLoading: showLoading))) {
      if (showLoading) subject.sink.add(ApiResponse.loading());
      try {
        var response = AddressListPojo.fromJson(await _manageAddressRepo.callAddressListApi());

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true)) {
          subject.sink.add(ApiResponse.completed(response));
          maxAddressLimit = response.maxAddressLimit;
          addressListLength = 0;
          for (var element in response.typeList) {
            addressListLength = addressListLength + element.addressList.length;
          }
        } else {
          subject.sink.add(ApiResponse.error(response.message));
          debugPrint("$tag ${response.message}");
        }
      } catch (e) {
        debugPrint("$tag ${e.toString()}");
        subject.sink.add(ApiResponse.error(e.toString()));
        if (!context.mounted) return;
        openSimpleSnackbar(context, e.toString());
      }
    }
  }

  Future<void> deleteAddress(int addressId) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => deleteAddress(addressId))) {
      subjectDeleteAddress.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(await _manageAddressRepo.callDeleteAddressApi(addressId));

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true)) {
          subjectDeleteAddress.sink.add(ApiResponse.completed(response));
          openSimpleSnackbar(context, languages.addressDeletedSuccessMsg);
          Navigator.pop(context);
          getAddressList(showLoading: false);
        } else {
          subjectDeleteAddress.sink.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        subjectDeleteAddress.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void openAddNewAddress({ItemManageAddressList? addressListItem}) {
    if (addressListItem == null) {
      if (addressListLength < maxAddressLimit) {
        openScreenWithResult(context, AddNewAddress(addressListItem: addressListItem)).then((value) {
          if (value ?? false) {
            getAddressList();
          }
        });
      } else {
        openSimpleSnackbar(context, languages.maxAddressMsg(maxAddressLimit));
      }
    } else {
      openScreenWithResult(context, AddNewAddress(addressListItem: addressListItem)).then((value) {
        if (value ?? false) {
          getAddressList();
        }
      });
    }
  }

  void openDeleteAddressSheet(ItemManageAddressList accountItem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StreamBuilder<ApiResponse<BaseModel>>(
          stream: subjectDeleteAddress,
          builder: (context, snapLoading) {
            var isLoading = snapLoading.hasData && snapLoading.data?.status == Status.loading;
            return CommonBottomSheet(
              isLoading: isLoading,
              title: languages.deleteAddress,
              message: languages.deleteAddressDialogMsg,
              positiveButtonTxt: languages.delete,
              onPositivePress: () {
                deleteAddress(accountItem.addressId);
              },
              negativeButtonTxt: languages.cancel,
              onNegativePress: () {
                Navigator.pop(context, true);
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    subject.close();
  }
}
