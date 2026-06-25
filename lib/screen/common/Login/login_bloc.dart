import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/customCountryCodePicker/country_code.dart';
import '../../../utils/api_message_localizer.dart';
import '../../../utils/mobile_auth_bootstrap.dart';
import '../../../utils/phone_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/validator.dart';
import 'login_dl.dart';
import 'login_repo.dart';

class LoginBloc extends Bloc {
  BuildContext context;
  final LoginRepo _loginRepo = LoginRepo();

  LoginBloc(this.context) {
    getFCMToken();
  }

  final mobileController = TextEditingController();
  final countryCodeController = BehaviorSubject<CountryCode>();
  final formKey = GlobalKey<FormState>();
  final subject = BehaviorSubject<ApiResponse<LoginPojo>>();
  final submitValid = BehaviorSubject<bool>();

  Future<void> loginApiCall({
    required String loginType,
    String? name,
    String? loginId,
    String? profileImg,
    String? countryCode,
    required String phoneNum,
  }) async {
    if (loginType == LoginType.email) {
      clearPendingSignupData();
    }
    if (!await ensureMobileAppAuthConfigured()) {
      if (context.mounted) {
        openSimpleSnackbar(
          context,
          resolveApiMessage(messageCode: 401),
        );
      }
      subject.sink.add(ApiResponse.error(resolveApiMessage(messageCode: 401)));
      return;
    }
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        loginApiCall(loginType: loginType, phoneNum: phoneNum, name: name, countryCode: countryCode, loginId: loginId, profileImg: profileImg);
      },
    )) {
      subject.sink.add(ApiResponse.loading());
      try {
        var response = LoginPojo.fromJson(
          await _loginRepo.login(loginType: loginType, phoneNum: phoneNum, name: name, loginId: loginId, profileImage: profileImg, countryCode: countryCode),
        );
        subject.sink.add(ApiResponse.completed(response));
        if (!context.mounted) return;
        await manageLoginResponse(context, response, authAttemptLoginType: loginType);
      } catch (e) {
        subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void buttonHide() {
    String mobile = colombiaMobileNumberValidate(mobileController.text);

    if (mobile.isEmpty) {
      submitValid.add(true);
    } else {
      submitValid.add(false);
    }
  }

  void manageEmailLogin() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()) {
      final dialCode = normalizeDialCode(countryCodeController.valueOrNull?.dialCode);
      final localMobile = normalizeColombiaLocalMobile(mobileController.text.trim(), dialCode: dialCode);
      loginApiCall(loginType: LoginType.email, phoneNum: localMobile, countryCode: dialCode);
    }
  }

  Future<void> login(String loginType, String email, String name, String id) async {
    FocusManager.instance.primaryFocus?.unfocus();
    loginApiCall(phoneNum: email, loginType: loginType, name: name, loginId: id);
  }

  void bioMetricLoginOrFetchSimNumber({required bool isBioMetricLogin, String? simContactNumber, String? simCountryCode, String? code}) {
    if (isBioMetricLogin) {
      biometricLoginApiCall();
    } else {
      mobileController.text = simContactNumber ?? "";
      if (simCountryCode != null && code != null) {
        countryCodeController.sink.add(
          CountryCode(dialCode: simCountryCode.replaceAll(" ", ""), code: code, flagUri: 'assets/flags/${code.toLowerCase()}.png'),
        );
      }
      buttonHide();
    }
  }

  Future<void> biometricLoginApiCall() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => biometricLoginApiCall())) {
      subject.sink.add(ApiResponse.loading());
      try {
        var response = LoginPojo.fromJson(await _loginRepo.biometricLogin());
        subject.sink.add(ApiResponse.completed(response));

        if (!context.mounted) return;
        await manageLoginResponse(context, response, authAttemptLoginType: LoginType.biometric);
      } catch (e) {
        subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    countryCodeController.close();
    mobileController.dispose();
    submitValid.close();
  }
}
