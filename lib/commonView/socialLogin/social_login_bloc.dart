import 'package:flutter/cupertino.dart';
import 'package:smart_auth/smart_auth.dart';

import '../../blocs/bloc.dart';
import '../../hive/hive_helper.dart';
import '../../utils/biometrics_login_utils.dart';
import '../../utils/utils.dart';
import '../customCountryCodePicker/country_code.dart';

class SocialLoginBloc extends Bloc {
  final BiometricsLoginUtils biometricsLoginUtils = BiometricsLoginUtils();
  final smartAuth = SmartAuth.instance;
  bool isBiometricAvailable = false;
  Function({required bool isBioMetricLogin, String? simContactNumber, String? simCountryCode, String? simCode})
  onBioMetricLoginOrFetchSimNumber;
  final BuildContext context;

  SocialLoginBloc(this.context, this.onBioMetricLoginOrFetchSimNumber) {
    if (getIntFromSettingBox(hiveIsFingerAllow) == 1) {
      biometricsLoginUtils.isAuthenticationAvailable().then((isBiometricAvailable) {
        this.isBiometricAvailable = isBiometricAvailable && isBiometricShow();
        if (this.isBiometricAvailable) {
          biometricLogin();
        } else {
          if (isContactNumberFetch) {
            fetchSimCardDetail();
          }
        }
      });
    } else {
      if (isContactNumberFetch) {
        fetchSimCardDetail();
      }
    }
  }

  bool isBiometricShow() {
    return (getBoolFromSettingBox(hiveIsLoginWithBiometrics) && getStringFromSettingBox(hiveUniqueId).trim().isNotEmpty);
  }

  Future<void> fetchSimCardDetail() async {
    await smartAuth.requestPhoneNumberHint().then((value) {
      final rawMobileNumber = value.data ?? "";
      Map<String, String> foundedCountry = {};
      if (rawMobileNumber.isNotEmpty) {
        for (var country in myCountryList) {
          String dialCode = country["dial_code"] ?? "";
          if (rawMobileNumber.contains(dialCode)) {
            foundedCountry = country;
          }
        }
        if (foundedCountry.isNotEmpty) {
          var dialCode = rawMobileNumber.substring(0, foundedCountry["dial_code"]!.length);
          var formattedNumber = rawMobileNumber.substring(foundedCountry["dial_code"]!.length);
          var code = foundedCountry["code"]!;
          onBioMetricLoginOrFetchSimNumber(
            isBioMetricLogin: false,
            simContactNumber: formattedNumber,
            simCountryCode: dialCode,
            simCode: code,
          );
        }
      }
    });
  }

  void biometricLogin() {
    if (isBiometricAvailable) {
      biometricsLoginUtils.authenticateWithBiometrics(context).then((isAuthenticated) {
        if (isAuthenticated) {
          onBioMetricLoginOrFetchSimNumber(isBioMetricLogin: true);
        }
      });
    } else {
      openSimpleSnackbar(context, languages.bioMetricsDisableMsg);
    }
  }

  @override
  void dispose() {}
}
