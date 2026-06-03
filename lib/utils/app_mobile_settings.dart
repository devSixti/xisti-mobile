import 'dart:convert';
import 'dart:io';

import '../constant/constant.dart';
import '../hive/hive_constant.dart';
import '../hive/hive_helper.dart';

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
}

/// Defaults when app-version-check is unreachable (DNS down, offline, etc.).
void applyBootstrapDefaultsWhenApiUnavailable() {
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

bool isEncomiendasMobileEnabled() =>
    getIntFromSettingBox(hiveEnableEncomiendasMobile) == 1;

bool isCourierPackageDimensionsRequired() =>
    getIntFromSettingBox(hiveRequireCourierPackageDimensions) == 1;

bool isColombiaCurrencySelected() {
  final currency = getStringFromSettingBox(hiveSelectedCurrency, defaultValue: defaultCurrency).toUpperCase();
  return currency.contains('COL') || currency.contains('COP');
}

double _normalizeFareNegotiationStep(double step) {
  if (isColombiaCurrencySelected()) {
    if (step < kColombiaFareNegotiationStep) {
      return kColombiaFareNegotiationStep;
    }
    return step;
  }
  return step > 0 ? step : 1;
}

double getFareNegotiationStepFromSettings() {
  final stored = getDoubleFromSettingBox(hiveFareNegotiationStep, defaultValue: 0);
  if (stored > 0) {
    return _normalizeFareNegotiationStep(stored);
  }
  return isColombiaCurrencySelected() ? kColombiaFareNegotiationStep : 1;
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
