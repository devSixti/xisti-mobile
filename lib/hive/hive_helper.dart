import 'package:hive_flutter/hive_flutter.dart';

import '../constant/constant.dart';
import '../main.dart';
import '../services/secure_token_storage.dart';
import 'hive_constant.dart';

export 'hive_constant.dart';

Future<void> initBox() async {
  /// opening all box here...
  /// we can pass path we want to save our box in inside [openBox] method and it will be stored there...
  /// [settingsBox] is used for all settings of app like device token, bearer token etc...
  settingsBox = await Hive.openBox(hiveSettings);

  /// [userInfoBox] is used for all user details like name , id etc...
  userInfoBox = await Hive.openBox(hiveUserInfo);

  /// [userPrefBox] is used for only for and language...
  userPrefBox = await Hive.openBox(hiveUserPrefBox);

  ///to put default values in [userPrefBox]
  if (userPrefBox.get(hiveSelectedLanguageCode) == null) {
    putDataInUserPrefBox(hiveSelectedLanguageCode, defaultLanguage);
  }

  await SecureTokenStorage.init();
}

///put data in [settingsBox]
Future<void> putDataInSettingBox(String key, dynamic value) async {
  if (key == hiveAccessToken) {
    await SecureTokenStorage.writeAccessToken(value?.toString() ?? '');
    return;
  }
  await settingsBox.put(key, value);
}

///put data in [userInfoBox]
Future<void> putDataInUserInfoBox(String key, dynamic value) async {
  await userInfoBox.put(key, value);
}

///put data in [userPrefBox]
Future<void> putDataInUserPrefBox(String key, dynamic value) async {
  await userPrefBox.put(key, value);
}

///different data types get from [settingsBox]
String getStringFromSettingBox(String key, {String defaultValue = ""}) {
  if (key == hiveAccessToken) {
    final token = SecureTokenStorage.readAccessToken();
    return token.isNotEmpty ? token : defaultValue;
  }
  return settingsBox.get(key, defaultValue: defaultValue) ?? defaultValue;
}

bool getBoolFromSettingBox(String key, {bool defaultValue = false}) {
  return settingsBox.get(key, defaultValue: defaultValue) ?? defaultValue;
}

int getIntFromSettingBox(String key, {int defaultValue = 0}) {
  return settingsBox.get(key, defaultValue: defaultValue) ?? defaultValue;
}

double getDoubleFromSettingBox(String key, {double defaultValue = 0}) {
  final value = settingsBox.get(key, defaultValue: defaultValue);
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse('$value') ?? defaultValue;
}

///different data types get from [userInfoBox]

int getIntFromUserInfoBox(String key, {int defaultValue = 0}) {
  return userInfoBox.get(key, defaultValue: defaultValue) ?? defaultValue;
}

String getStringFromUserInfoBox(String key, {String defaultValue = ""}) {
  return userInfoBox.get(key, defaultValue: defaultValue) ?? defaultValue;
}

/// different data types get from [userPrefBox]
String getLanguageFromUserPrefBox() {
  return userPrefBox.get(hiveSelectedLanguageCode, defaultValue: defaultLanguage) ?? defaultLanguage;
}

///Clearing all boxes with remaining some
Future<void> hiveClearWithRemainSomeData({required bool isAccountDelete}) async {
  String selectedCurrency = getStringFromSettingBox(hiveSelectedCurrency);
  bool isShownOnBoarding = getBoolFromSettingBox(hiveIsShownOnBoarding);
  String authKeyGoogleMap = getStringFromSettingBox(hiveUniqueIdGoogleApiCall);
  int sessionLastKey = getIntFromSettingBox(hiveSessionLastKey);

  String uniqueId = '';
  bool isLoginWithBiometrics = false;

  if (!isAccountDelete) {
    uniqueId = getStringFromSettingBox(hiveUniqueId);
    isLoginWithBiometrics = getBoolFromSettingBox(hiveIsLoginWithBiometrics);
  }

  await settingsBox.clear();
  await userInfoBox.clear();
  await SecureTokenStorage.clearAccessToken();

  putDataInSettingBox(hiveSelectedCurrency, selectedCurrency);
  putDataInSettingBox(hiveIsShownOnBoarding, isShownOnBoarding);
  putDataInSettingBox(hiveUniqueIdGoogleApiCall, authKeyGoogleMap);
  putDataInSettingBox(hiveSessionLastKey, sessionLastKey);
  putDataInSettingBox(hiveIsLoggedIn, false);
  putDataInSettingBox(hivePendingPhoneOtp, false);
  putDataInSettingBox(hiveUserVerified, 0);

  if (!isAccountDelete) {
    putDataInSettingBox(hiveUniqueId, uniqueId);
    putDataInSettingBox(hiveIsLoginWithBiometrics, isLoginWithBiometrics);
  }
}
