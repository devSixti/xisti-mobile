import 'package:flutter/material.dart';

import '../../../../blocs/bloc.dart';
import '../../../../hive/hive_helper.dart';
import '../../../../utils/utils.dart';
import '../walletCashOut/wallet_cash_out.dart';
import '../walletTopUp/wallet_top_up.dart';
import '../walletTransfer/wallet_transfer.dart';
import 'walletTransactionsView/wallet_transaction.dart';
import 'wallet_home_dl.dart';
import 'wallet_home_repo.dart';

class WalletHomeBloc extends Bloc {
  final BuildContext context;
  final TabController tabController;

  WalletHomeBloc(this.context, this.tabController) {
    getWalletAmountApiCall();
  }

  final walletAllTransactionsScreenKey = GlobalKey<WalletTransactionState>();
  final walletCreditTransactionsScreenKey = GlobalKey<WalletTransactionState>();
  final walletDebitTransactionsScreenKey = GlobalKey<WalletTransactionState>();

  final _repo = WalletHomeRepo();

  final walletAmountSubject = BehaviorSubject<double>.seeded(0);
  final selectedTransactionTypeSubject = BehaviorSubject<int>.seeded(0);
  final getWalletBalanceSubject = BehaviorSubject<ApiResponse<WalletBalancePojo>>();

  double totalWalletAmount() => walletAmountSubject.valueOrNull ?? 0;

  void updateTransactionHistory() {
    /// Refresh Transaction History
    switch (tabController.index) {
      case 0:
        walletAllTransactionsScreenKey.currentState?.refreshData();
        break;
      case 1:
        walletCreditTransactionsScreenKey.currentState?.refreshData();
        break;
      case 2:
        walletDebitTransactionsScreenKey.currentState?.refreshData();
        break;
      default:
        return;
    }
  }

  void openWalletTransferScreen() {
    openScreenWithResult(context, WalletTransfer(walletAmount: totalWalletAmount())).then((value) {
      if (value != null) {
        getWalletAmountApiCall();
        updateTransactionHistory();
      }
    });
  }

  void openTopUpScreen() {
    FocusManager.instance.primaryFocus?.unfocus();

    List<TopupWallet> walletTopUpOptionList = getWalletBalanceSubject.valueOrNull?.data?.walletTopUpOptionList ?? [];
    final minTopup = getWalletBalanceSubject.valueOrNull?.data?.minWompiTopupAmount ?? 13000;

    openScreenWithResult(
      context,
      WalletTopUp(walletTopUpOptionList: walletTopUpOptionList, minTopupAmount: minTopup),
    ).then((value) {
      if (value != null) {
        getWalletAmountApiCall();
        updateTransactionHistory();
      }
    });
  }

  void openCaseOutScreen() {
    FocusManager.instance.primaryFocus?.unfocus();

    openScreenWithResult(context, WalletCaseOut(walletAmount: totalWalletAmount())).then((value) {
      if (value != null) {
        if (context.mounted) openSimpleSnackbar(context, languages.cashOutSuccess);
        getWalletAmountApiCall();
        updateTransactionHistory();
      }
    });
  }

  Future<void> getWalletAmountApiCall() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => getWalletAmountApiCall())) {
      getWalletBalanceSubject.sink.add(ApiResponse.loading());
      try {
        WalletBalancePojo response = WalletBalancePojo.fromJson(await _repo.getWalletBalanceApi());

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true, showMess: true)) {
          walletAmountSubject.sink.add(getDoubleFromDynamic(response.walletBalance ?? "0"));
          putDataInSettingBox(hiveIsAutoSettle, response.isAutoSettle == 1);
          getWalletBalanceSubject.sink.add(ApiResponse.completed(response));
        } else {
          getWalletBalanceSubject.sink.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        getWalletBalanceSubject.sink.add(ApiResponse.error(e.toString()));
        if (!context.mounted) return;
        openSimpleSnackbar(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    walletAmountSubject.close();
    getWalletBalanceSubject.close();
    selectedTransactionTypeSubject.close();
  }
}
