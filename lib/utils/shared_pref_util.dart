import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../networking/base_dl.dart';

const String prefNewRequestPojo = "newRequestPojo";

late SharedPreferences _prefs;

Future<SharedPreferences> initSharedPreferences() async {
  _prefs = await SharedPreferences.getInstance();
  return _prefs;
}

Future<SharedPreferences> reloadSharedPreference() async {
  _prefs = await SharedPreferences.getInstance();
  await _prefs.reload();
  return _prefs;
}

String prefGetString(String key) {
  return _prefs.getString(key) ?? "";
}

bool prefGetBool(String key) {
  return _prefs.getBool(key) ?? false;
}

String prefGetStringWithDefaultValue(String key, String defaultValue) {
  return _prefs.getString(key) ?? defaultValue;
}

Future<void> prefSetBool(String key, bool value) async {
  _prefs.setBool(key, value);
}

Future<void> prefSetString(String key, String value) async {
  _prefs.setString(key, value);
}

int prefGetInt(String key) {
  return _prefs.getInt(key) ?? 0;
}

Future<void> prefSetInt(String key, int value) async {
  _prefs.setInt(key, value);
}

//deletes..
Future<bool> prefRemove(String key) async => await _prefs.remove(key);

Future<bool> prefClear() async => await _prefs.clear();

Future<void> prefClearWithRemainSomeData() async {
  await _prefs.clear();
}

Future<void> setPrefNotificationData(NotificationPojo? newRequestPojo, {String? tag}) async {
  if (newRequestPojo != null) {
    _prefs.setString(prefNewRequestPojo, newRequestPojo.toJsonString());
  } else {
    _prefs.setString(prefNewRequestPojo, "");
  }
}

NotificationPojo? getPrefNotificationData() {
  var value = _prefs.getString(prefNewRequestPojo);

  if (value == null || value.isEmpty) {
    return null;
  }
  NotificationPojo? newRequestPojo = NotificationPojo.fromJson(jsonDecode(value));

  return newRequestPojo;
}
