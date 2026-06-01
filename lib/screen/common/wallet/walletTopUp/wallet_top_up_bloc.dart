import 'package:flutter/material.dart';

import '../../../../blocs/bloc.dart';
import '../../../../utils/utils.dart';
import '../../webViewRedirection/web_view_redirection.dart';
import '../walletHome/wallet_home_dl.dart';
import '../walletHome/wallet_home_repo.dart';

class WalletTopUpBloc extends Bloc {
  final BuildContext context;
  final List<TopupWallet> topUpList;
  final double minTopupAmount;

  WalletTopUpBloc(this.context, this.topUpList, {this.minTopupAmount = 13000});

  final subjectTopUpList = BehaviorSubject<List<TopupWallet>>();
  final selectedTopUpOptionSubject = BehaviorSubject<int>();
  final addAmountToWalletSubject = BehaviorSubject<ApiResponse<WalletBalancePojo>>();

  final amountTEC = TextEditingController();

  final _repo = WalletHomeRepo();

  void validateAndGo() {
    double amount = 0;
    if (amountTEC.text.isNotEmpty) {
      amount = getDoubleFromDynamic(amountTEC.text);
      if (amount <= 0) {
        openSimpleSnackbar(context, languages.invalidAmountMsg);
        return;
      }
    } else if ((selectedTopUpOptionSubject.valueOrNull ?? 0) > 0) {
      amount = getDoubleFromDynamic(topUpList[topUpList.indexWhere((element) => element.id == selectedTopUpOptionSubject.value)].packagePrice);
    }

    if (amount > 0) {
      if (minTopupAmount > 0 && amount < minTopupAmount) {
        openSimpleSnackbar(context, languages.walletMinTopupNotice);
        return;
      }
      FocusManager.instance.primaryFocus?.unfocus();
      addAmountToWalletApiCall(amount);
    } else {
      openSimpleSnackbar(context, languages.pleaseEnterAmount);
    }
  }

  Future<void> addAmountToWalletApiCall(double amount) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => addAmountToWalletApiCall(amount))) {
      addAmountToWalletSubject.sink.add(ApiResponse.loading());
      try {
        var response = WalletBalancePojo.fromJson(await _repo.addWalletBalanceApi(amount, 0));

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true, showMess: true)) {
          if (!context.mounted) return;
          if (response.redirectUrl.isEmpty) {
            addAmountToWalletSubject.sink.add(ApiResponse.error(response.message));
            openSimpleSnackbar(context, response.message);
            return;
          }

          await paymentMethodCheckUsingOpenScreenWithResult(
            context,
            PaymentType.online,
            [PaymentType.online],
            successUrl: response.successUrl,
            failedUrl: response.failedUrl,
            redirectUrl: response.redirectUrl,
            onSuccess: () {
              addAmountToWalletSubject.sink.add(ApiResponse.completed(response));
              openSimpleSnackbar(context, languages.walletAddSuccessful);
            },
            onFailed: () {
              addAmountToWalletSubject.sink.add(ApiResponse.error(languages.failed));
              openSimpleSnackbar(context,languages.failed);
            },
          );
          if (!context.mounted) return;
          Navigator.pop(context, true);
          addAmountToWalletSubject.sink.add(ApiResponse.completed(response));
        } else {
          addAmountToWalletSubject.sink.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        addAmountToWalletSubject.sink.add(ApiResponse.error(e.toString()));
        if (context.mounted) openSimpleSnackbar(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    subjectTopUpList.close();
    selectedTopUpOptionSubject.close();
    amountTEC.dispose();
  }
}
