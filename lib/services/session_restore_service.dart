import 'package:flutter/material.dart';

import '../hive/hive_helper.dart';
import '../screen/common/Login/login_dl.dart';
import '../screen/common/Login/login_repo.dart';
import '../utils/biometrics_login_utils.dart';
import '../utils/utils.dart';

/// Restores a persisted mobile session from Hive and optional biometric re-auth.
class SessionRestoreService {
  static void syncLoggedInFlagFromStoredCredentials() {
    if (getBoolFromSettingBox(hiveIsLoggedIn)) {
      return;
    }
    final userId = getIntFromUserInfoBox(hiveUserId);
    final token = getStringFromSettingBox(hiveAccessToken);
    if (userId > 0 && token.trim().isNotEmpty) {
      putDataInSettingBox(hiveIsLoggedIn, true);
    }
  }

  static bool canRestoreBiometricSession() {
    return getIntFromSettingBox(hiveIsFingerAllow) == 1 &&
        getBoolFromSettingBox(hiveIsLoginWithBiometrics) &&
        getStringFromSettingBox(hiveUniqueId).trim().isNotEmpty &&
        getIntFromUserInfoBox(hiveUserId) > 0;
  }

  static Future<void> enableBiometricLoginIfAvailable() async {
    if (getIntFromSettingBox(hiveIsFingerAllow) != 1) {
      return;
    }
    if (getStringFromSettingBox(hiveUniqueId).trim().isEmpty) {
      return;
    }
    if (getBoolFromSettingBox(hiveIsLoginWithBiometrics)) {
      return;
    }
    final biometrics = BiometricsLoginUtils();
    if (await biometrics.isAuthenticationAvailable()) {
      putDataInSettingBox(hiveIsLoginWithBiometrics, true);
    }
  }

  static Future<bool> tryRestoreSessionWithBiometrics(BuildContext context) async {
    if (!canRestoreBiometricSession()) {
      return false;
    }
    final biometrics = BiometricsLoginUtils();
    if (!await biometrics.isAuthenticationAvailable()) {
      return false;
    }
    if (!context.mounted) {
      return false;
    }
    final authenticated = await biometrics.authenticateWithBiometrics(context);
    if (!authenticated || !context.mounted) {
      return false;
    }
    try {
      final response = LoginPojo.fromJson(await LoginRepo().biometricLogin());
      final message = getApiMsg(response.message, response.messageCode);
      if (!context.mounted) {
        return false;
      }
      if (isApiStatus(context, response.status ?? 0, message, false, messageCode: response.messageCode ?? 0)) {
        await setDataInHive(response);
        if (response.isRegister == 1) {
          if (!isUserVerified()) {
            putDataInSettingBox(hiveUserVerified, 1);
          }
          putDataInSettingBox(hiveIsLoggedIn, true);
          await enableBiometricLoginIfAvailable();
          return true;
        }
      }
    } catch (e) {
      debugPrint('SessionRestoreService.tryRestoreSessionWithBiometrics: $e');
    }
    return false;
  }
}
