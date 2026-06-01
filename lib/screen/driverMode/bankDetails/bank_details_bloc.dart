import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import 'bank_detail_dl.dart';
import 'bank_detail_repo.dart';

class BankDetailsBloc extends Bloc {
  final BuildContext context;

  BankDetailsBloc(this.context) {
    callGetBankDetailsApi();
  }

  TextEditingController accountNumberTEC = TextEditingController();
  TextEditingController accountHolderNameTEC = TextEditingController();
  TextEditingController bankNameTEC = TextEditingController();
  TextEditingController bankLocationTEC = TextEditingController();
  TextEditingController paymentEmailTEC = TextEditingController();
  TextEditingController swiftCodeTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final subject = BehaviorSubject<ApiResponse<BankDetailPojo>>();
  final updateSubject = BehaviorSubject<ApiResponse<BaseModel>>();

  final BankDetailRepo _bankDetailRepo = BankDetailRepo();

  void callGetBankDetailsApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callGetBankDetailsApi();
      },
    )) {
      subject.sink.add(ApiResponse.loading());
      try {
        var response = BankDetailPojo.fromJson(await _bankDetailRepo.getBankDetailsApi());

        if (!context.mounted) return;
        String message = getApiMsg(response.message);
        if (isApiStatus(context, response.status, message, true, hideMessOnCodeList: [79], messageCode: response.messageCode)) {
          subject.sink.add(ApiResponse.completed(response));
          setData(response);
        } else {
          subject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void setData(BankDetailPojo response) {
    accountNumberTEC.text = response.accountNumber ?? "";
    accountHolderNameTEC.text = response.holderName ?? "";
    bankNameTEC.text = response.bankName ?? "";
    bankLocationTEC.text = response.bankLocation ?? "";
    paymentEmailTEC.text = response.paymentEmail ?? "";
    swiftCodeTEC.text = response.bicSwiftCode ?? "";
  }

  void callUpdateBankDetailApi() async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callUpdateBankDetailApi();
      },
    )) {
      updateSubject.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(
          await _bankDetailRepo.updateBankDetailsApi(
            accountNumberTEC.text.trim(),
            accountHolderNameTEC.text.trim(),
            bankNameTEC.text.trim(),
            bankLocationTEC.text.trim(),
            paymentEmailTEC.text.trim(),
            swiftCodeTEC.text.trim(),
          ),
        );

        if (!context.mounted) return;
        String message = getApiMsg(response.message);
        if (isApiStatus(context, response.status, message, true)) {
          updateSubject.sink.add(ApiResponse.completed(response));
          openSimpleSnackbar(context, languages.updateBankDetailSuccessMsg);
        } else {
          updateSubject.sink.add(ApiResponse.error(message));
          if (response.status != 3) openSimpleSnackbar(context, message);
        }
      } catch (e) {
        debugPrint(e.toString());
        updateSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    accountNumberTEC.dispose();
    accountHolderNameTEC.dispose();
    bankNameTEC.dispose();
    bankLocationTEC.dispose();
    paymentEmailTEC.dispose();
    swiftCodeTEC.dispose();
    subject.close();
    updateSubject.close();
  }
}
