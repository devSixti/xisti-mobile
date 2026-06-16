import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:android_nav_setting/android_nav_setting.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../bottomSheet/common_bottom_sheet.dart';
import '../bottomSheet/internet_connection_loss_sheet.dart';
import '../constant/chat_constant.dart';
import '../constant/constant.dart';
import 'api_message_localizer.dart';
import 'app_mobile_settings.dart';
import 'phone_util.dart';
import '../constant/dimensions.dart';
import '../hive/hive_helper.dart';
import '../l10n/appLocalization/app_localizations.dart';
import '../main.dart';
import '../networking/api_constant.dart';
import '../networking/base_dl.dart';
import '../screen/common/Login/login_dl.dart';
import '../screen/common/otpVerify/otp_verify_screen.dart';
import '../screen/common/profile/profile.dart';
import '../screen/common/signup/signup_screen.dart';
import '../screen/common/splash/splash_screen.dart';
import '../screen/driverMode/driverHome/driver_home.dart';
import '../screen/driverMode/driverNewRequest/driver_new_request_screen.dart';
import '../screen/passengerMode/passengerHome/passenger_home.dart';
import 'custom_icons.dart';
import 'firebase_util.dart';
import 'shared_pref_util.dart';
import 'style_util.dart';

export '../appThemeManager/app_theme_colors.dart';
export '../constant/constant.dart';
export '../constant/dimensions.dart';
export '../main.dart';
export 'custom_icons.dart';
export 'firebase_util.dart';
export 'map_utils.dart';
export 'style_util.dart';
export 'time_util.dart';
export 'xisti_ui_tokens.dart';

void openScreen(BuildContext context, Widget screen) {
  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => screen));
}

void openScreenWithReplacePrevious(BuildContext context, Widget screen) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => screen));
}

void openScreenWithClearPrevious(BuildContext context, Widget screen) {
  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => screen), (route) => false);
}

Future openScreenWithResult(BuildContext context, Widget screen) async {
  return await Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

void openScreenWithTransparentBg(BuildContext context, Widget screen) {
  //pushReplacement
  Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => screen, opaque: false, fullscreenDialog: true));
}

Future<void> openUrl(String url, {LaunchMode launchMode = LaunchMode.platformDefault}) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: launchMode);
  } else {
    debugPrint("Url Error : $url");
  }
}

/// Public CMS legal pages (terms, privacy) with user language for admin.xistiapp.com.
String legalCmsUrl(String path) {
  final lang = getLanguageFromUserPrefBox();
  final code = lang.length >= 2 ? lang.substring(0, 2).toLowerCase() : 'es';
  final uri = Uri.parse('${BaseUrl.domain}$path');
  return uri.replace(queryParameters: {...uri.queryParameters, 'lang': code}).toString();
}

String getApiMsg(String? defaultMsg, [int? messageCode]) {
  return resolveApiMessage(message: defaultMsg, messageCode: messageCode);
}

bool isLoggedIn() {
  if (getBoolFromSettingBox(hiveIsLoggedIn)) {
    return true;
  }
  return false;
}

bool isSocialLoginType([String? loginType]) {
  final type = loginType ?? getStringFromUserInfoBox(hiveLoginType);
  return type == LoginType.google || type == LoginType.facebook || type == LoginType.apple;
}

bool requiresPhoneOtpOnSignup() {
  final loginType = getStringFromUserInfoBox(hiveLoginType);
  return loginType != LoginType.email && loginType != LoginType.biometric;
}

void clearPendingSignupData() {
  putDataInSettingBox(hivePendingSignupAfterOtp, false);
  putDataInSettingBox(hivePendingSignupProfilePath, '');
  putDataInUserInfoBox(hivePendingSignupFullName, '');
  putDataInUserInfoBox(hivePendingSignupEmail, '');
  putDataInUserInfoBox(hivePendingSignupReferral, '');
}

void manageLoginResponse(BuildContext context, LoginPojo response) {
  final message = getApiMsg(response.message, response.messageCode);
  if (isApiStatus(context, response.status ?? 0, message, false, messageCode: response.messageCode ?? 0)) {
    setDataInHive(response);
    final loginType = response.loginType ?? getStringFromUserInfoBox(hiveLoginType);
    final hasPhone = (response.contactNumber ?? '').trim().isNotEmpty;

    if (!isUserVerified()) {
      if (isSocialLoginType(loginType) && !hasPhone) {
        openScreenWithClearPrevious(context, const SignupScreen());
      } else {
        openScreen(context, const OtpVerifyScreen());
      }
      return;
    }

    if (response.isRegister == 1) {
      putDataInSettingBox(hiveIsLoggedIn, true);
      putDataInSettingBox(hiveAppMode, response.activeMode ?? AppMode.passenger);
      changeSubscribeTopic();
      getGoogleMapKeyForApiCall();
      if (response.activeMode == AppMode.driver) {
        openScreenWithClearPrevious(context, const DriverHome(isFromLogin: true));
      } else {
        openScreenWithClearPrevious(context, const PassengerHome(isFromLogin: true));
      }
    } else {
      openScreenWithClearPrevious(context, const SignupScreen());
    }
  }
}

bool isApiStatus(
  BuildContext context,
  int? status,
  String message,
  bool isLogout, {
  bool showMess = true,
  int messageCode = 0,
  List<int> hideMessOnCodeList = const [],
}) {
  //API STATUS
  //0 = false
  //1 = true
  //2 = registration pending
  //3 = app user blocked
  //4 = app user access token not match
  //5 = app user not found
  switch (status) {
    case 0:
      showApiMessage(context, showMess, message, messageCode, hideMessOnCodeList);
      return false;
    case 1:
      return true;
    case 2:
      showApiMessage(context, showMess, message, messageCode, hideMessOnCodeList);
      return false;
    case 3:
      showSimpleDialogWithMessAndLogout(context: context, message: message);
      return false;
    case 4:
    case 5:
      showApiMessage(context, showMess, message, messageCode, hideMessOnCodeList);
      if (isLogout) {
        logout(context);
      }
      return false;
  }
  return false;
}

void showApiMessage(BuildContext context, bool showMess, String message, int messageCode, List<int> hideMessOnCodeList) {
  final display = resolveApiMessage(message: message, messageCode: messageCode > 0 ? messageCode : null);
  if (showMess) {
    if (!(hideMessOnCodeList.isNotEmpty && hideMessOnCodeList.contains(messageCode))) {
      openSimpleSnackbar(context, display);
    }
  }
}

void showSimpleDialogWithMessAndLogout({required BuildContext context, required String message}) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CommonBottomSheet(
        title: message,
        positiveButtonTxt: languages.ok,
        onPositivePress: () {
          logout(context);
        },
      );
    },
  );
}

IconData getPaymentTypeIcon(int paymentType) {
  switch (paymentType) {
    case PaymentType.cash:
      return CustomIcons.cash;
    case PaymentType.online:
      return CustomIcons.card;
    case PaymentType.wallet:
      return CustomIcons.wallet;
    default:
      return CustomIcons.cash;
  }
}

void setDataInHive(LoginPojo body) {
  putDataInUserInfoBox(hiveUserId, body.userId ?? 0);
  putDataInSettingBox(hiveAccessToken, body.accessToken.toString());
  putDataInUserInfoBox(hiveUserName, body.userName ?? "");
  putDataInUserInfoBox(hiveEmail, body.email ?? "");
  putDataInSettingBox(hiveUniqueId, body.uniqueId ?? "");
  putDataInUserInfoBox(hiveLoginType, body.loginType ?? "");
  putDataInUserInfoBox(hiveProfileImage, body.profileImage ?? "");
  final dialCode = normalizeDialCode(
    (body.selectCountryCode ?? "").isNotEmpty ? body.selectCountryCode : defaultCountryCode.dialCode,
  );
  putDataInUserInfoBox(hiveCountryCode, dialCode);
  putDataInUserInfoBox(
    hiveContactNumber,
    normalizeColombiaLocalMobile(body.contactNumber ?? '', dialCode: dialCode),
  );
  if ((body.selectCurrency ?? "").isNotEmpty) {
    putDataInUserInfoBox(hiveSelectedCurrency, body.selectCurrency ?? defaultCurrency);
  }
  if ((body.selectLanguage ?? "").isNotEmpty) {
    putDataInUserPrefBox(hiveSelectedLanguageCode, body.selectLanguage ?? defaultLanguage);
  }
  putDataInSettingBox(hiveServerTimeZone, body.serverTimeZone ?? "");
  putDataInSettingBox(hiveUserVerified, body.userVerified ?? 0);
  putDataInUserInfoBox(hiveReferralCode, body.referralCode ?? "");
  putDataInUserInfoBox(hiveEmergencyContact, body.emergencyContact ?? "");
  putDataInUserInfoBox(hiveEmergencyContactName, body.emergencyContactName ?? "");
  putDataInUserInfoBox(hiveEmergencyCountryCode, body.emergencyCountryCode ?? "");
  putDataInUserInfoBox(hiveIsRegister, body.isRegister ?? 0);
  putDataInSettingBox(hiveDriverStatus, body.isDriverStatus ?? 0);
  putDataInSettingBox(hiveDocumentStatus, body.driverDocStatus ?? 0);
  putDataInSettingBox(hiveVehicleStatus, body.driverVehicleStatus ?? 0);
  putDataInSettingBox(hiveDriverType, body.isDriverType ?? 0);
  putDataInSettingBox(hiveAppMode, body.activeMode ?? AppMode.passenger);
  putDataInSettingBox(hivePaymentTypeCash, body.cashPayment == 1);
  putDataInSettingBox(hivePaymentTypeOnline, body.onlinePayment == 1);
  putDataInSettingBox(hivePaymentTypeWallet, body.walletPayment == 1);
  applyAppMobileSettingsFromJson(body.toJson());
  changeSubscribeTopic();
}

bool isUserVerified() {
  if (getIntFromSettingBox(hiveUserVerified) == 1) {
    return true;
  }
  return false;
}

Future<void> logout(BuildContext context, {bool isAccountDelete = false}) async {
  clearFCMToken().then((value) {
    FirebaseAuth.instance.signOut();
  });
  if (await WakelockPlus.enabled) {
    WakelockPlus.toggle(enable: false);
  }
  hiveClearWithRemainSomeData(isAccountDelete: isAccountDelete);
  if (!context.mounted) return;
  openScreenWithClearPrevious(context, SplashScreen());
}

Future<void> setDeviceIpAddressInPref() async {
  try {
    final ipv4 = await Ipify.ipv4();
    deviceIpAddress = ipv4;
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> initAppConfig() async {
  await pushNotificationService.pushNotificationInitialise();
  if (await isNetworkConnected()) setDeviceIpAddressInPref();
}

void setAuthKey(String text) {
  String authKey = base64.encode(utf8.encode(text));
  // logD(tag, "authKey: $authKey");
  String md5String = md5.convert(utf8.encode(authKey)).toString();
  // logD(tag, "utf8.encode(authKey): ${utf8.encode(authKey)}");
  // logD(tag, "md5String: $md5String");
  String preText = getRandomString(57);
  String postText = getRandomString(43);
  text = "$preText$md5String$postText"; //Removing of prefix/post fix characters will fail apis!
  putDataInSettingBox(hiveAuthKey, text);
}

String getRandomString(int length) {
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

Future<bool> isNetworkConnected({Function()? onRetryPressedCallApi}) async {
  final connectivityResult = await Connectivity().checkConnectivity();
  final isConnected = !connectivityResult.contains(ConnectivityResult.none);
  if (isConnected) {
    return true;
  } else {
    showInternetConnectivityLossSheet(
      navigatorKey.currentContext!,
      onRetryPressed: () {
        return onRetryPressedCallApi?.call();
      },
    );
    return false;
  }
}

void setChangedLanguage(BuildContext context, String languageCode, {Function()? nextAction}) {
  putDataInUserPrefBox(hiveSelectedLanguageCode, languageCode);
  AppLocalizations.delegate.load(Locale(languageCode)).then((value) {
    languages = value;
    if (nextAction != null) nextAction();
  });
}

void openSimpleSnackbar(BuildContext context, String title) {
  if (rootScaffoldMessengerKey.currentState != null) {
    rootScaffoldMessengerKey.currentState?.clearSnackBars();
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: getCurrentTheme(context).colorBlack,
        content: Text(
          title,
          textAlign: TextAlign.start,
          style: bodyText(context: context, fontSize: textSize16px, fontWeight: FontWeight.normal, textColor: getCurrentTheme(context).colorWhite),
        ),
      ),
    );
  }
}

void showProfileImageRequiredSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    enableDrag: false,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CommonBottomSheet(
        title: languages.profilePictureUpload,
        message: languages.profilePictureUploadMsg,
        positiveButtonTxt: languages.ok,
        negativeButtonTxt: languages.cancel,
        onNegativePress: () {
          if (Navigator.canPop(context)) Navigator.pop(context, false);
        },
        onPositivePress: () {
          openScreenWithResult(context, const ProfileScreen()).then((_) {
            if (!context.mounted) return;
            if (Navigator.canPop(context)) Navigator.pop(context, true);
          });
        },
      );
    },
  ).then((value) {
    if (value is bool && value) {
      if (getStringFromUserInfoBox(hiveProfileImage).trim().isEmpty) {
        if (context.mounted) showProfileImageRequiredSheet(context);
      }
    }
  });
}

double getDoubleFromDynamic(dynamic value) {
  return double.parse(value.toString());
}

String getAmountWithCurrency(dynamic amount, {int numberAfterPoint = 2}) {
  String selectedCurrency = getStringFromSettingBox(hiveSelectedCurrency);
  if (selectedCurrency.isEmpty) {
    selectedCurrency = defaultCurrency;
  } else if (selectedCurrency == "COL\$") {
    selectedCurrency = "COP";
  }
  final decimalPattern = numberAfterPoint > 0 ? ".${"#" * numberAfterPoint}" : "";
  final formatter = NumberFormat("#,##0$decimalPattern", "en_US");
  return "$selectedCurrency ${formatter.format(getDoubleFromDynamic(amount)).trim()}";
}

String getEditableAmount(dynamic amount, {int numberAfterPoint = 2}) {
  final decimalPattern = numberAfterPoint > 0 ? ".${"#" * numberAfterPoint}" : "";
  final formatter = NumberFormat("0$decimalPattern", "en_US");
  return formatter.format(getDoubleFromDynamic(amount)).trim();
}

/// Fare increment/decrement while searching for a driver (from API / Hive, COP default 500).
double getFareNegotiationStep() {
  return getFareNegotiationStepFromSettings();
}

int getCurrencyFractionDigits() {
  if (isColombiaCurrencySelected()) {
    return 0;
  }
  return 2;
}

extension MapWithIndex<T> on List<T> {
  List<R> mapWithIndex<R>(R Function(T, int i) callback) {
    List<R> result = [];
    for (int i = 0; i < length; i++) {
      R item = callback(this[i], i);
      result.add(item);
    }
    return result;
  }
}

class DeBouncer {
  final int milliseconds;
  Timer? _timer;

  DeBouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

String setImagesBasedOnTheme(BuildContext context, String imgName) {
  return "assets/images/${getCurrentTheme(context).themeMode == 1 ? "light" : "dark"}/$imgName";
}

String setLottieAnimationBasedOnTheme(BuildContext context, String imgName) {
  return "assets/lottieJson/${getCurrentTheme(context).themeMode == 1 ? "light" : "dark"}/$imgName";
}

Future<File> cropImageToSquare(File file) async {
  final bytes = await file.readAsBytes();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  final image = frame.image;
  final side = image.width < image.height ? image.width : image.height;
  final offsetX = (image.width - side) ~/ 2;
  final offsetY = (image.height - side) ~/ 2;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawImageRect(
    image,
    Rect.fromLTWH(offsetX.toDouble(), offsetY.toDouble(), side.toDouble(), side.toDouble()),
    Rect.fromLTWH(0, 0, side.toDouble(), side.toDouble()),
    Paint(),
  );
  final picture = recorder.endRecording();
  final squaredImage = await picture.toImage(side, side);
  final byteData = await squaredImage.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  squaredImage.dispose();

  final dir = await getTemporaryDirectory();
  final out = File('${dir.path}/profile_square_${DateTime.now().millisecondsSinceEpoch}.png');
  await out.writeAsBytes(byteData!.buffer.asUint8List());
  return out;
}

Future<File> prepareProfileImageFile(File file) async {
  final squared = await cropImageToSquare(file);
  return compressImage(squared);
}

Future<File> compressImage(File file) async {
  final filePath = file.absolute.path;
  int lastIndex = -1;
  CompressFormat format = CompressFormat.jpeg;
  if (filePath.contains(".jp")) {
    lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  } else if (filePath.contains(".png")) {
    format = CompressFormat.png;
    lastIndex = filePath.lastIndexOf(RegExp(r'.png'));
  } else if (filePath.contains(".PNG")) {
    format = CompressFormat.png;
    lastIndex = filePath.lastIndexOf(RegExp(r'.PNG'));
  } else if (filePath.contains(".heic")) {
    format = CompressFormat.heic;
    lastIndex = filePath.lastIndexOf(RegExp(r'.heic'));
  } else if (filePath.contains(".webp")) {
    format = CompressFormat.webp;
    lastIndex = filePath.lastIndexOf(RegExp(r'.webp'));
  }
  final split = filePath.substring(0, (lastIndex));
  final outPath = "${split}_out${filePath.substring(lastIndex)}";
  final compressedImage = await FlutterImageCompress.compressAndGetFile(filePath, outPath, quality: 85, format: format);
  return (compressedImage?.path ?? "").isNotEmpty ? File(compressedImage?.path ?? "") : file;
}

String getPaymentType({required int paymentType}) {
  switch (paymentType) {
    case PaymentType.cash:
      return languages.cash;
    case PaymentType.online:
      return languages.onlinePayment;
    case PaymentType.wallet:
      return languages.wallet;
    default:
      return languages.cash;
  }
}

void setKeyValuePair({
  required List<KeyValueModel> keyValuesList,
  required bool setDivider,
  required bool setBold,
  required bool setValueWithCurrency,
  required String key,
  required String value,
  Function()? setButton,
}) {
  if (setValueWithCurrency) {
    if (value.isNotEmpty && double.parse(value) > 0) {
      keyValuesList.add(KeyValueModel(setDivider, setBold, setValueWithCurrency, key, getAmountWithCurrency(double.parse(value)), setButton: setButton));
    }
  } else {
    keyValuesList.add(KeyValueModel(setDivider, setBold, setValueWithCurrency, key, value, setButton: setButton));
  }
}

bool isEmailOrNumNull() {
  if (getStringFromUserInfoBox(hiveEmail).trim().isEmpty || getStringFromUserInfoBox(hiveContactNumber).trim().isEmpty) {
    return true;
  }
  return false;
}

Future<void> isBackgroundNotification() async {
  NotificationPojo? newRequestPojo = getPrefNotificationData();
  if (newRequestPojo != null) {
    setPrefNotificationData(null);
    openScreenWithClearPrevious(navigatorKey.currentContext!, DriverNewRequestScreen(rideId: int.parse(newRequestPojo.rideId ?? "0")));
  }
}

ImageProvider getImageProvider(String link, String defaultAssetLink) {
  if (link.isNotEmpty) {
    return NetworkImage(link);
  } else {
    return AssetImage(defaultAssetLink);
  }
}

String getAddressTypeInString({required int type}) {
  switch (type) {
    case 1:
      return languages.home;
    case 2:
      return languages.work;
    case 3:
      return languages.other;
    default:
      return languages.home;
  }
}

IconData getAddressTypeIcon({required int type}) {
  switch (type) {
    case 1:
      return CustomIcons.homeAddress;
    case 2:
      return CustomIcons.workAddress;
    case 3:
      return CustomIcons.otherAddress;
    default:
      return CustomIcons.homeAddress;
  }
}

TextInputFormatter getDecimalInputFormatter({int decimalRange = 2}) {
  return _StrictDecimalInputFormatter(decimalRange: decimalRange);
}

class _StrictDecimalInputFormatter extends TextInputFormatter {
  final int decimalRange;

  _StrictDecimalInputFormatter({required this.decimalRange});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(',', '.'); // Normalize comma to dot

    if (text.isEmpty) return newValue.copyWith(text: text);

    // Allow only digits and a single `.`
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(text)) return oldValue;

    // Only allow up to `decimalRange` digits after the decimal
    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 2) return oldValue;
      if (parts[1].length > decimalRange) return oldValue;
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

double parseSafeDouble(String input) {
  String sanitized = input.trim();

  if (sanitized == '.') return 0.0;
  if (sanitized.startsWith('.')) sanitized = '0$sanitized';
  if (sanitized.endsWith('.')) sanitized = '${sanitized}0';

  try {
    return double.parse(sanitized);
  } catch (_) {
    return 0;
  }
}

Future<void> checkAndSetGestureNavigation() async {
  if (Platform.isIOS) {
    gestureNavigation = true;
  } else {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int apiLevel = androidInfo.version.sdkInt;
      debugPrint("gesture apiLevel: $apiLevel");
      if (apiLevel <= 34) {
        gestureNavigation = false;
      } else {
        final navSetting = AndroidNavSetting();
        gestureNavigation = await navSetting.isGestureNavigationEnabled();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  debugPrint("gesture enable: $gestureNavigation");
}

Future<String> getAndroidVersion() async {
  // Get device info
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  String androidVersion = androidInfo.version.release; // e.g. "13"
  return androidVersion;
}

double getBottomMargin() {
  return gestureNavigation ? 20.h : 5.h;
}

bool isRtl() {
  Locale selectedLocale = Locale(getLanguageFromUserPrefBox());
  if (selectedLocale.languageCode == 'ar' ||
      selectedLocale.languageCode == 'fa' ||
      selectedLocale.languageCode == 'he' ||
      selectedLocale.languageCode == 'ps' ||
      selectedLocale.languageCode == 'ur') {
    return true;
  }
  return false;
}

void logd(String message) {
  debugPrint(message);
}

//new
Future<void> getGoogleMapKeyForApiCall() async {
  try {
    String? sess;
    if (getStringFromSettingBox(hiveUniqueIdGoogleApiCall).trim().isEmpty) {
      generateSecureKey();
    }
    sess = await getKeyFromFirebase();
    String finalKey = "uid=${getStringFromSettingBox(hiveUniqueIdGoogleApiCall)}|sess:$sess";

    logd("getGoogleMapKeyForApiCall---key---->$finalKey");
    putDataInSettingBox(hiveSessionIdHeader, finalKey);
  } catch (e) {
    debugPrint("map key error: ${e.toString()}");
  }
}

void generateSecureKey({int length = 32, int? lastPos}) {
  String key = "";
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random.secure();

  key = List.generate(length, (index) {
    return chars[random.nextInt(chars.length)];
  }).join();

  putDataInSettingBox(hiveUniqueIdGoogleApiCall, key);
}

Future<String> getKeyFromFirebase() async {
  int pos = getIntFromSettingBox(hiveSessionLastKey);

  // Normalize pos
  if (pos <= 0 || pos > 5) {
    pos = 1;
    putDataInSettingBox(hiveSessionLastKey, pos);
  }

  final DatabaseReference ref = FirebaseDatabase.instance.ref().child('key-${ChatConstant.googleMapKey}').child(pos.toString());

  final DatabaseEvent event = await ref.once();
  final value = event.snapshot.value;

  if (value != null) {
    putDataInSettingBox(hiveSessionLastKey, pos + 1);
    return value.toString();
  }

  return "";
}
