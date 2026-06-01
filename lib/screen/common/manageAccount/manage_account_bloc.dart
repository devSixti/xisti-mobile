import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/common_bottom_sheet.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import '../account/account_dl.dart';
import 'manage_account_repo.dart';

class ManageAccountBloc extends Bloc {
  final BuildContext context;

  final subjectLogout = BehaviorSubject<ApiResponse<BaseModel>>();
  final accountItemSubject = BehaviorSubject<List<ManageAccountItem>>();
  final deleteAccountSubject = BehaviorSubject<ApiResponse<BaseModel>>();

  final ManageAccountRepo _repo = ManageAccountRepo();

  ManageAccountBloc(this.context) {
    getDrawerData();
  }

  Future<void> logoutApiCall() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => logoutApiCall())) {
      subjectLogout.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(await _repo.callLogoutApi());
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true, showMess: false)) {
          subjectLogout.sink.add(ApiResponse.completed(response));
          logout(context);
        } else {
          subjectLogout.sink.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        subjectLogout.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> deleteAccountApiCall() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => deleteAccountApiCall())) {
      deleteAccountSubject.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(await _repo.deleteAccountApi());
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true, showMess: false)) {
          deleteAccountSubject.sink.add(ApiResponse.completed(response));
          logout(context, isAccountDelete: true);
        } else {
          openSimpleSnackbar(context, response.message);
          deleteAccountSubject.sink.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        deleteAccountSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void getDrawerData() {
    List<ManageAccountItem> accountItemsList = [
      ManageAccountItem(ManageAccountEnum.deleteAccount, CustomIcons.delete, languages.accountDelete),
      ManageAccountItem(ManageAccountEnum.logout, CustomIcons.logout, languages.logout),
    ];
    accountItemSubject.add(accountItemsList);
  }

  void openAccountSelectedScreen(ManageAccountEnum accountEnum) {
    switch (accountEnum) {
      case ManageAccountEnum.logout:
        openLogoutBottomSheet();
        break;
      case ManageAccountEnum.deleteAccount:
        openDeleteAccountBottomSheet();
        break;
    }
  }

  void openLogoutBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StreamBuilder<ApiResponse<BaseModel>>(
          stream: subjectLogout,
          builder: (context, snapLoading) {
            var isLoading = snapLoading.hasData && snapLoading.data?.status == Status.loading;
            return CommonBottomSheet(
              isLoading: isLoading,
              title: languages.logout,
              message: languages.logOutDialogMsg,
              positiveButtonTxt: languages.logout,
              negativeButtonTxt: languages.cancel,
              onPositivePress: () {
                logoutApiCall();
              },
              onNegativePress: () {
                Navigator.pop(context, true);
              },
            );
          },
        );
      },
    );
  }

  void openDeleteAccountBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StreamBuilder<ApiResponse<BaseModel>>(
          stream: deleteAccountSubject,
          builder: (context, snapLoading) {
            var isLoading = snapLoading.hasData && snapLoading.data?.status == Status.loading;
            return CommonBottomSheet(
              isLoading: isLoading,
              title: languages.accountDelete,
              message: languages.accountDeleteDialogMsg,
              positiveButtonTxt: languages.accountDelete,
              negativeButtonTxt: languages.cancel,
              onPositivePress: () {
                deleteAccountApiCall();
              },
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
    subjectLogout.close();
    accountItemSubject.close();
    deleteAccountSubject.close();
  }
}
