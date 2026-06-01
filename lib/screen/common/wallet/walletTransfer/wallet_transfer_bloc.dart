import 'package:flutter/material.dart';

import '../../../../blocs/bloc.dart';
import '../../../../bottomSheet/wallet_transfer_bottom_sheet.dart';
import '../../../../networking/base_dl.dart';
import '../../../../utils/utils.dart';
import 'wallet_transfer_dl.dart';
import 'wallet_transfer_repo.dart';

class WalletTransferBloc extends Bloc {
  final BuildContext context;
  double walletAmount = 0;

  WalletTransferBloc(this.context, this.walletAmount);

  final walletTransferRepo = WalletTransferRepo();

  final searchUserSubject = BehaviorSubject<ApiResponse<UserSearchModel>?>();
  final transferToWalletSubject = BehaviorSubject<ApiResponse<BaseModel>>();

  final searchUserTEC = TextEditingController();
  final textBeneficialNameTEC = TextEditingController();
  final textNumberTEC = TextEditingController();
  final textEmailTEC = TextEditingController();
  final textAmountTEC = TextEditingController();

  TransferUserList? transferUserList;

  final formKey = GlobalKey<FormState>();
  final showError = BehaviorSubject<bool>.seeded(true);

  void resetUser() {
    searchUserTEC.text = "";
    transferUserList = null;
    textBeneficialNameTEC.text = "";
    textNumberTEC.text = "";
    textEmailTEC.text = "";
    textAmountTEC.text = "";
    searchUserSubject.add(null);
  }

  void showTransferBottomSheet(double amount) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return WalletTransferBottomSheet(amount: amount);
      },
    );
  }

  Future<void> searchUsersApiCall(String search) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => searchUsersApiCall(search))) {
      searchUserSubject.add(ApiResponse.loading());
      try {
        var response = UserSearchModel.fromJson(await walletTransferRepo.findUser(search));

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true, showMess: false)) {
          searchUserSubject.add(ApiResponse.completed(response));
        } else {
          searchUserSubject.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        if (context.mounted) openSimpleSnackbar(context, e.toString());
        searchUserSubject.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> transferToUserApiCall() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => transferToUserApiCall())) {
      transferToWalletSubject.add(ApiResponse.loading());
      try {
        double amount = getDoubleFromDynamic(textAmountTEC.text);
        var response = BaseModel.fromJson(
          await walletTransferRepo.transferWalletBalance(amount, transferUserList?.transferId ?? 0, transferUserList?.walletProviderType ?? 0),
        );

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true, showMess: true)) {
          walletAmount = walletAmount - amount;
          showTransferBottomSheet(amount);
          showError.sink.add(false);
          resetUser();
          transferToWalletSubject.add(ApiResponse.completed(response));
        } else {
          transferToWalletSubject.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        transferToWalletSubject.add(ApiResponse.error(e.toString()));
        if (context.mounted) openSimpleSnackbar(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    searchUserSubject.close();
    transferToWalletSubject.close();
    showError.close();
  }
}
