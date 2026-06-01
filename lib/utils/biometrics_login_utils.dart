import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

import 'utils.dart';

class BiometricsLoginUtils {
  final LocalAuthentication localAuth = LocalAuthentication();

  Future<bool> isAuthenticationAvailable() async {
    bool isSupported = await localAuth.isDeviceSupported();
    List<BiometricType> availableBiometricsList = await getAvailableBiometrics();
    return (availableBiometricsList.isNotEmpty && isSupported);
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = [];
      debugPrint(e.toString());
    }
    return availableBiometrics;
  }

  Future<bool> authenticateWithBiometrics(BuildContext context) async {
    bool authenticated = false;
    try {
      authenticated = await localAuth.authenticate(
        localizedReason: languages.bioMetricsPopupMsg,
        authMessages: <AuthMessages>[
          AndroidAuthMessages(signInTitle: languages.authenticationRequired, cancelButton: languages.noThanks),
          IOSAuthMessages(cancelButton: languages.noThanks),
        ],
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException catch (e) {
      if (e.code == "LockedOut") {
        if (!context.mounted) return false;
        openSimpleSnackbar(context, e.message ?? "");
      }
      debugPrint("authenticated Error : ${e.message} $authenticated");
      return false;
    }
    debugPrint("authenticated : $authenticated");
    return authenticated;
  }
}
