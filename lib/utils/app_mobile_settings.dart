import 'dart:convert';

import '../constant/constant.dart';
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
