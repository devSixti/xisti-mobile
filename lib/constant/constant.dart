import 'package:flutter/material.dart';
import 'package:app_xisti/screen/common/notificationsScreen/notification_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/bloc.dart';
import '../bottomSheet/acceptRequestBottomSheet/accept_request_bottom_sheet.dart';
import '../commonView/customCountryCodePicker/country_code.dart';
import '../screen/common/chatting/chatting_screen.dart';

const firebaseTopicNameForUser = "XistiUser";
const firebaseTopicNameForDriver = "XistiDriver";
// const firebaseTopicNameForUser = "XistiUser";
// const firebaseTopicNameForDriver = "XistiDriver";
const appleId = "6764321893";
final CountryCode defaultCountryCode = CountryCode(name: "Colombia", code: "CO", dialCode: "+57");

const double kDefaultAdminCommissionPercent = 8;
const String kXistiTagline = 'Fácil y Seguro';

String firebaseProjectId = "";
const String defaultCurrency = "COL\$";
const String defaultLanguage = "es";

String deviceIpAddress = "";

const double defaultMapZoom = 15.00;
/// Medellín — ciudad de lanzamiento XISTI.
const defaultLatLng = LatLng(6.2442, -75.5812);
const initCameraPosition = CameraPosition(target: defaultLatLng, zoom: defaultMapZoom);

const int perPageRecord = 10;

//Dynamic Modules
const bool isDemoApp = false;
const bool isContactNumberFetch = false;

bool isWaitingOpen = false;

State<ChattingScreen>? chatState;
State<NotificationScreen>? notificationState;
State<AcceptRequestBottomSheet>? acceptRequestBottomSheetState;
int androidVersion15 = 15;

const int minAmountMessageCode = 339;
bool isNewRequestScreenOpen = false;
final isAppKilledOrTerminatedSubject = BehaviorSubject<bool>.seeded(true);

/// Default +/- step when offering fare in Colombia (COP).
const double kColombiaFareNegotiationStep = 500;

///Service Type
class ServiceType {
  static const int taxi = 1;
  static const int bike = 3;
  static const int courier = 4;
  static const int rickshaw = 5;
}

/// Login Types
class LoginType {
  static const String facebook = "facebook";
  static const String google = "google";
  static const String email = "email";
  static const String apple = "apple";
  static const String biometric = "fingerprint";
}

/// Login Device Types
class LoginDeviceType {
  static const int android = 1;
  static const int ios = 2;
}

///App Mode
class AppMode {
  static const int passenger = 1;
  static const int driver = 2;
}

class FilterType {
  static const int filterTypeAll = 0;
  static const int filterTypeToday = 1;
  static const int filterTypeLast7Days = 2;
  static const int filterTypeThisMonth = 3;
  static const int filterTypeYear = 4;
  static const int filterTypeUpcoming = 5;

  static const int filterTypeDefault = filterTypeToday;
}

/// PAYMENT TYPE
class PaymentType {
  static const int cash = 1;
  static const int online = 2;
  static const int wallet = 3;
}

class WalletTransactionType {
  static const int all = 0;
  static const int credit = 1;
  static const int debit = 2;
}

/// PAYMENT TYPE
class ChatWithType {
  static const int user = 0;
  static const int driver = 2;
}
