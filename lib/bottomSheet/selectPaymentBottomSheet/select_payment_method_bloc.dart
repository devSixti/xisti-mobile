import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/utils.dart';
import '../../hive/hive_helper.dart';
import '../../screen/passengerMode/passengerRunningRide/ps_running_ride_dl.dart';

class SelectPaymentMethodBloc extends Bloc {
  BuildContext context;
  bool showCash, showWallet, showOnline;
  int index = 0;
  double walletAmount = 0, totalPay;
  final Function(int paymentType) onSubmit;

  SelectPaymentMethodBloc(this.context, this.totalPay, this.walletAmount, this.showCash, this.showWallet, this.showOnline, this.onSubmit) {
    showCash = (showCash && getBoolFromSettingBox(hivePaymentTypeCash));
    showWallet = (showWallet && getBoolFromSettingBox(hivePaymentTypeWallet));
    showOnline = (showOnline && getBoolFromSettingBox(hivePaymentTypeOnline));
    getSelectedPayment();
  }

  final selectedPaymentMethodController = BehaviorSubject<SelectPaymentMethodItem>();
  final selectPaymentMethodListController = BehaviorSubject<List<SelectPaymentMethodItem>>();

  void getSelectedPayment() {
    List<SelectPaymentMethodItem> paymentMethodItemList = [];

    if (showCash) {
      index++;
      paymentMethodItemList.add(SelectPaymentMethodItem(id: index, type: PaymentType.cash, name: languages.cash, icon: CustomIcons.cash));
    }
    if (showWallet) {
      index++;
      paymentMethodItemList.add(
        SelectPaymentMethodItem(
          id: index,
          type: PaymentType.wallet,
          name: languages.wallet,
          secondaryText: "(${getAmountWithCurrency(walletAmount)})",
          icon: CustomIcons.wallet,
        ),
      );
    }

    if (showOnline) {
      index++;
      paymentMethodItemList.add(SelectPaymentMethodItem(id: index, type: PaymentType.online, name: languages.onlinePayment, icon: CustomIcons.onlinePayment));
    }
    selectPaymentMethodListController.sink.add(paymentMethodItemList);
    if (paymentMethodItemList.isNotEmpty) {
      selectedPaymentMethodController.sink.add(paymentMethodItemList.first);
    }
  }

  void payNow() {
    SelectPaymentMethodItem selectPaymentMethodItem = selectedPaymentMethodController.value;
    switch (selectPaymentMethodItem.type) {
      case PaymentType.cash:
        onSubmit(selectPaymentMethodItem.type);
        break;
      case PaymentType.online:
        onSubmit(selectPaymentMethodItem.type);
        break;
      case PaymentType.wallet:
        if (!(walletAmount >= totalPay)) {
          openSimpleSnackbar(context, languages.insufficientWalletBalance);
        } else {
          onSubmit(selectPaymentMethodItem.type);
        }
        break;
    }
  }

  @override
  void dispose() {
    selectedPaymentMethodController.close();
    selectPaymentMethodListController.close();
  }
}
