import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../constant/chat_constant.dart';
import '../hive/hive_helper.dart';
import 'utils.dart';

/// Returns a non-empty token for login/register APIs (FCM or stable fallback).
Future<String> resolveDeviceToken() async {
  final cached = getStringFromSettingBox(hiveDeviceToken).trim();
  if (cached.isNotEmpty) {
    return cached;
  }

  await getAPNsToken();
  for (var attempt = 0; attempt < 5; attempt++) {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.trim().isNotEmpty) {
        putDataInSettingBox(hiveDeviceToken, token.trim());
        debugPrint('FCMToken: $token');
        return token.trim();
      }
    } catch (e) {
      debugPrint('FCM getToken attempt $attempt: $e');
    }
    await Future.delayed(const Duration(seconds: 1));
  }

  final fallback = await _fallbackDeviceToken();
  putDataInSettingBox(hiveDeviceToken, fallback);
  debugPrint('FCMToken fallback: $fallback');
  return fallback;
}

Future<String> _fallbackDeviceToken() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final android = await deviceInfo.androidInfo;
    final id = android.id.trim();
    if (id.isNotEmpty) {
      return 'no-fcm-android-$id';
    }
  } else if (Platform.isIOS) {
    final ios = await deviceInfo.iosInfo;
    final id = ios.identifierForVendor?.trim() ?? '';
    if (id.isNotEmpty) {
      return 'no-fcm-ios-$id';
    }
  }
  return 'no-fcm-${DateTime.now().millisecondsSinceEpoch}';
}

void getFCMToken() {
  resolveDeviceToken();
}

Future<void> getAPNsToken() async {
  if (Platform.isIOS) {
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken == null) {
      debugPrint("APNS token not available yet. Retrying...");
      await Future.delayed(Duration(seconds: 1));
      apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    }
    debugPrint("APNS Token: $apnsToken");
  }
}

Future<void> firebaseAuth() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  String email = getStringFromUserInfoBox(hiveEmail).trim().isNotEmpty ? getStringFromUserInfoBox(hiveEmail) : "dummy@gmail.com";
  if (currentUser == null) {
    try {
      UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(password: "123456", email: "u_$email");
      final User? user = result.user;
      if (user == null) {
        await firebaseAuthWithEmail(email);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      await firebaseAuthWithEmail(email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

Future<void> firebaseAuthWithEmail(String email) async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(password: "123456", email: "u_$email");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
        await firebaseAuth();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

void setFCMToken() {
  String userId = ChatConstant.userIdCode + getIntFromUserInfoBox(hiveUserId).toString();
  DatabaseReference refFcmToken = FirebaseDatabase.instance.ref().child(ChatConstant.chat).child(ChatConstant.fcmToken).child(userId);
  var map = <String, String>{};
  map[ChatConstant.newUserFcmToken] = getStringFromSettingBox(hiveDeviceToken);
  refFcmToken.set(map);
}

Future<void> clearFCMToken() async {
  String userId = ChatConstant.userIdCode + getIntFromUserInfoBox(hiveUserId).toString();
  DatabaseReference refFcmToken = FirebaseDatabase.instance.ref().child(ChatConstant.chat).child(ChatConstant.fcmToken).child(userId);
  var map = <String, String>{};
  map[ChatConstant.newUserFcmToken] = "";
  await refFcmToken.set(map);
}

void changeSubscribeTopic() {
  if (isLoggedIn()) {
    if (getIntFromSettingBox(hiveAppMode) == AppMode.driver) {
      FirebaseMessaging.instance.unsubscribeFromTopic(firebaseTopicNameForUser);
      FirebaseMessaging.instance.subscribeToTopic(firebaseTopicNameForDriver);
    } else if (getIntFromSettingBox(hiveAppMode) == AppMode.passenger) {
      FirebaseMessaging.instance.unsubscribeFromTopic(firebaseTopicNameForDriver);
      FirebaseMessaging.instance.subscribeToTopic(firebaseTopicNameForUser);
    }
  }
}
