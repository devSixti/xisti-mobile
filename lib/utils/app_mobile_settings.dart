import 'dart:convert';
import 'dart:io';

import '../constant/constant.dart';
import '../hive/hive_helper.dart';
import 'mobile_auth_header.dart';

/// Syncs mobile config fields exposed by XISTI Admin API.
void applyAppMobileSettingsFromJson(dynamic json) {
  if (json is! Map) {
    return;
  }
  final map = Map<String, dynamic>.from(json);
  if (map.containsKey('fare_negotiation_step')) {
    putDataInSettingBox(
      hiveFareNegotiationStep,
      _normalizeFareNegotiationStep(_toDouble(map['fare_negotiation_step'], kColombiaFareNegotiationStep)),
    );
  } else if (isColombiaCurrencySelected()) {
    putDataInSettingBox(hiveFareNegotiationStep, kColombiaFareNegotiationStep);
  }
  if (map.containsKey('vat_rate_on_commission')) {
    putDataInSettingBox(
      hiveVatRateOnCommission,
      _toDouble(map['vat_rate_on_commission'], 19),
    );
  }
  if (map.containsKey('admin_commission_percent')) {
    putDataInSettingBox(
      hiveAdminCommissionPercent,
      _toDouble(map['admin_commission_percent'], kDefaultAdminCommissionPercent),
    );
  }
  if (map.containsKey('driver_cancel_until_status')) {
    putDataInSettingBox(
      hiveDriverCancelUntilStatus,
      _toInt(map['driver_cancel_until_status'], 3),
    );
  }
  if (map.containsKey('destination_payment_methods')) {
    final methods = map['destination_payment_methods'];
    if (methods is List) {
      putDataInSettingBox(
        hiveDestinationPaymentMethods,
        methods.isNotEmpty ? jsonEncode(methods) : '',
      );
    }
  }
  if (map.containsKey('enable_expreso_mobile')) {
    putDataInSettingBox(hiveEnableExpresoMobile, _toInt(map['enable_expreso_mobile'], 0));
  }
  if (map.containsKey('enable_encomiendas_mobile')) {
    putDataInSettingBox(hiveEnableEncomiendasMobile, _toInt(map['enable_encomiendas_mobile'], 0));
  }
  if (map.containsKey('require_courier_package_dimensions')) {
    putDataInSettingBox(
      hiveRequireCourierPackageDimensions,
      _toInt(map['require_courier_package_dimensions'], 0),
    );
  }
  if (map.containsKey('enable_xisti_new_home_layout')) {
    putDataInSettingBox(hiveXistiNewHomeLayout, _toInt(map['enable_xisti_new_home_layout'], 1));
  }
  if (map.containsKey('enable_acarreos_mobile')) {
    putDataInSettingBox(hiveEnableAcarreosMobile, _toInt(map['enable_acarreos_mobile'], 1));
  }
}

/// Injected at build time: `--dart-define=XISTI_APP_KEY=...` (or legacy `QA_APP_KEY`).
const String kXistiAppKey = String.fromEnvironment('XISTI_APP_KEY', defaultValue: '');

/// @deprecated Use [kXistiAppKey]
const String kQaAppKey = String.fromEnvironment('QA_APP_KEY', defaultValue: '');

String get buildTimeAppKey {
  if (kXistiAppKey.isNotEmpty) {
    return kXistiAppKey;
  }
  return kQaAppKey;
}

Future<void> applyBuildTimeAppKeyIfConfigured() async {
  final key = buildTimeAppKey;
  if (key.isEmpty) {
    return;
  }
  await setAuthKey(key);
}

Future<void> _applyQaAppKeyIfConfigured() async {
  await applyBuildTimeAppKeyIfConfigured();
}

/// Defaults when app-version-check is unreachable (DNS down, offline, etc.).
Future<void> applyBootstrapDefaultsWhenApiUnavailable() async {
  await _applyQaAppKeyIfConfigured();
  applySocialLoginSettingsFromApi({
    'is_google_login': 1,
    'is_facebook_login': 1,
    'is_apple_login': 1,
    'is_finger_login': 1,
  });
  putDataInSettingBox(hiveFareNegotiationStep, kColombiaFareNegotiationStep);
  putDataInSettingBox(hiveVatRateOnCommission, 19);
  putDataInSettingBox(hiveAdminCommissionPercent, kDefaultAdminCommissionPercent);
  putDataInSettingBox(hiveDriverCancelUntilStatus, 3);
  putDataInSettingBox(hiveEnableExpresoMobile, 0);
  putDataInSettingBox(hiveEnableEncomiendasMobile, 1);
  putDataInSettingBox(hiveRequireCourierPackageDimensions, 0);
  putDataInSettingBox(hiveXistiNewHomeLayout, 1);
}

/// Persists social-login toggles from app-version-check (with safe defaults when admin has them off).
void applySocialLoginSettingsFromApi(dynamic json) {
  if (json is! Map) {
    return;
  }
  final map = Map<String, dynamic>.from(json);
  var google = _toInt(map['is_google_login'], 0);
  var facebook = _toInt(map['is_facebook_login'], 0);
  var apple = _toInt(map['is_apple_login'], 0);
  var finger = _toInt(map['is_finger_login'], 0);

  if (google == 0 && facebook == 0 && apple == 0 && finger == 0) {
    google = 1;
    facebook = 1;
    finger = 1;
    if (Platform.isIOS) {
      apple = 1;
    }
  }

  putDataInSettingBox(hiveIsGoogleAllow, google);
  putDataInSettingBox(hiveIsFaceBookAllow, facebook);
  putDataInSettingBox(hiveIsAppleAllow, apple);
  putDataInSettingBox(hiveIsFingerAllow, finger);
}

bool isExpresoMobileEnabled() =>
    getIntFromSettingBox(hiveEnableExpresoMobile) == 1;

bool isEncomiendasMobileEnabled() => false;

bool isAcarreosMobileEnabled() =>
    getIntFromSettingBox(hiveEnableAcarreosMobile, defaultValue: 1) == 1;

bool isCourierPackageDimensionsRequired() =>
    getIntFromSettingBox(hiveRequireCourierPackageDimensions) == 1;

/// New multiservice home layout (map + floating search + draggable sheet). Default on.
bool isXistiNewHomeLayoutEnabled() =>
    getIntFromSettingBox(hiveXistiNewHomeLayout, defaultValue: 1) == 1;

bool isColombiaCurrencySelected() {
  final currency = getStringFromSettingBox(hiveSelectedCurrency, defaultValue: defaultCurrency).toUpperCase();
  return currency.contains('COL') || currency.contains('COP');
}

/// Currencies that use large integer amounts (similar magnitude to COP).
bool isLargeUnitCurrencySelected() {
  if (isColombiaCurrencySelected()) {
    return true;
  }
  final currency = getStringFromSettingBox(hiveSelectedCurrency, defaultValue: defaultCurrency).toUpperCase();
  const markers = ['ARS', 'CLP', 'PYG', 'CRC', 'UY', 'JPY', 'VND', 'IDR'];
  for (final m in markers) {
    if (currency.contains(m)) {
      return true;
    }
  }
  return false;
}

double _normalizeFareNegotiationStep(double step) {
  if (isColombiaCurrencySelected() || isLargeUnitCurrencySelected()) {
    if (isColombiaCurrencySelected() && step < kColombiaFareNegotiationStep) {
      return kColombiaFareNegotiationStep;
    }
    return step > 0 ? step : (isColombiaCurrencySelected() ? kColombiaFareNegotiationStep : 1);
  }
  // USD / EUR / etc.: reject COP-scale admin steps (500) that zero-out converted fares.
  if (step <= 0 || step > 10) {
    return 1;
  }
  return step;
}

double getFareNegotiationStepFromSettings() {
  final stored = getDoubleFromSettingBox(hiveFareNegotiationStep, defaultValue: 0);
  if (stored > 0) {
    return _normalizeFareNegotiationStep(stored);
  }
  return isColombiaCurrencySelected() ? kColombiaFareNegotiationStep : 1;
}

/// Country floor from [XistiRegionService.applyRegion] (CO / US / BR / AR).
double getRegionMinFareFromSettings() =>
    getDoubleFromSettingBox(hiveRegionMinFare, defaultValue: 0);

/// Ensures API min fare never falls below the active regional floor.
double applyRegionalMinFareFloor(dynamic apiMinFare) {
  final api = double.tryParse(apiMinFare?.toString() ?? '') ?? 0;
  final regional = getRegionMinFareFromSettings();
  if (regional <= 0) {
    return api;
  }
  return api < regional ? regional : api;
}

/// Rounds a fare to the nearest configured negotiation step (e.g. 500 COP).
/// Never collapses a positive fare to 0 (e.g. USD 28 snapped with a stale COP step of 500).
double snapFareToNegotiationStep(double amount, {double? step}) {
  final negotiationStep = step ?? getFareNegotiationStepFromSettings();
  if (negotiationStep <= 1) {
    return amount.roundToDouble() == amount ? amount : (amount * 100).roundToDouble() / 100;
  }
  final snapped = ((amount / negotiationStep).round() * negotiationStep).toDouble();
  if (amount > 0 && snapped <= 0) {
    return amount;
  }
  return snapped;
}

/// Applies regional floor and negotiation-step snapping for passenger fares.
({double recommended, double minPrice, double maxPrice}) normalizePassengerFareRange({
  required dynamic recommendedFare,
  required dynamic minPrice,
  required dynamic maxPrice,
}) {
  final step = getFareNegotiationStepFromSettings();
  var min = snapFareToNegotiationStep(applyRegionalMinFareFloor(minPrice), step: step);
  var max = snapFareToNegotiationStep(double.tryParse(maxPrice?.toString() ?? '') ?? 0, step: step);
  var recommended = snapFareToNegotiationStep(double.tryParse(recommendedFare?.toString() ?? '') ?? 0, step: step);
  final rawRecommended = double.tryParse(recommendedFare?.toString() ?? '') ?? 0;
  if (recommended <= 0 && rawRecommended > 0) {
    recommended = rawRecommended;
  }
  if (recommended < min) {
    recommended = min;
  }
  if (max < min) {
    max = min + step;
  }
  return (recommended: recommended, minPrice: min, maxPrice: max);
}

double getVatRateOnCommissionPercent() {
  final stored = getDoubleFromSettingBox(hiveVatRateOnCommission, defaultValue: 0);
  return stored > 0 ? stored : 19;
}

double getAdminCommissionPercent() {
  final stored = getDoubleFromSettingBox(hiveAdminCommissionPercent, defaultValue: 0);
  return stored > 0 ? stored : 8;
}

int getDriverCancelUntilStatus() {
  final stored = getIntFromSettingBox(hiveDriverCancelUntilStatus);
  return stored > 0 ? stored : 3;
}

double _toDouble(dynamic value, double fallback) {
  if (value == null) {
    return fallback;
  }
  return double.tryParse(value.toString()) ?? fallback;
}

int _toInt(dynamic value, int fallback) {
  if (value == null) {
    return fallback;
  }
  return int.tryParse(value.toString()) ?? fallback;
}
