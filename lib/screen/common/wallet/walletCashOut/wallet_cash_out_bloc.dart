import 'package:flutter/material.dart';

import '../../../../blocs/bloc.dart';
import '../../../../networking/base_dl.dart';
import '../../../../utils/utils.dart';
import '../walletHome/wallet_home_repo.dart';

class WalletCaseOutBloc extends Bloc {
  final BuildContext context;
  final double walletAmount;

  WalletCaseOutBloc(this.context, this.walletAmount);

  final _repo = WalletHomeRepo();

  final amountTEC = TextEditingController();

  final cashOutSubject = BehaviorSubject<ApiResponse<BaseModel>>();

  void validateAndGo() {
    double amount = 0;

    if (amountTEC.text.isNotEmpty) {
      amount = getDoubleFromDynamic(amountTEC.text);
      if (amount > walletAmount) {
        openSimpleSnackbar(context, languages.invalidRequestCashOutAmountMsg);
        return;
      }
    } else {
      openSimpleSnackbar(context, languages.pleaseEnterRequestCashOutAmount);
      return;
    }

    if (amount > 0) {
      FocusManager.instance.primaryFocus?.unfocus();
      cashOutApiCall(amount);
    } else {
      openSimpleSnackbar(context, languages.enterValidRequestCashOutAmount);
    }
  }

  Future<void> cashOutApiCall(dynamic amount) async {
    cashOutSubject.sink.add(ApiResponse.loading());
    if (await isNetworkConnected(onRetryPressedCallApi: () => cashOutApiCall(amount))) {
      try {
        var response = BaseModel.fromJson(await _repo.cashOutApi(amount));

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true)) {
          Navigator.pop(context, true);
          cashOutSubject.sink.add(ApiResponse.completed(response));
        } else {
          cashOutSubject.sink.add(ApiResponse.error(response.message));
          if (response.status != 3) openSimpleSnackbar(context, response.message);
        }
      } catch (e) {
        cashOutSubject.sink.add(ApiResponse.error(e.toString()));
        if (context.mounted) openSimpleSnackbar(context, e.toString());
      }
    } else {
      cashOutSubject.sink.add(ApiResponse.error(languages.internetConnLostMessage));
    }
  }

  @override
  void dispose() {
    amountTEC.dispose();
  }
}
