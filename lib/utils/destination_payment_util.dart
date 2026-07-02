import 'dart:convert';

import '../hive/hive_helper.dart';
import '../constant/constant.dart';
import '../main.dart';

class DestinationPaymentOption {
  final String code;
  final String label;

  const DestinationPaymentOption({required this.code, required this.label});
}

/// ISO ID-1 card ratio for document camera/crop preview.
const double kDriverDocumentAspectRatio = 85.6 / 54.0;

class DestinationPaymentUtil {
  static const String cash = 'cash';
  static const String bancolombia = 'bancolombia';
  static const String daviplata = 'daviplata';
  static const String nequi = 'nequi';

  static List<DestinationPaymentOption> optionsForLocale([bool _ = true]) {
    final fromApi = _optionsFromHive();
    if (fromApi.isNotEmpty) {
      return fromApi;
    }
    return [
      DestinationPaymentOption(code: cash, label: languages.cash),
      DestinationPaymentOption(code: bancolombia, label: languages.paymentBancolombia),
      DestinationPaymentOption(code: daviplata, label: languages.paymentDaviplata),
      DestinationPaymentOption(code: nequi, label: languages.paymentNequi),
    ];
  }

  static String _apiLabelKey() {
    final lang = getLanguageFromUserPrefBox().toLowerCase();
    if (lang.startsWith('es')) return 'label_es';
    if (lang.startsWith('fr')) return 'label_fr';
    if (lang.startsWith('it')) return 'label_it';
    if (lang.startsWith('pt')) return 'label_pt';
    return 'label_en';
  }

  static String _localizedKnownCode(String code) {
    switch (code) {
      case cash:
        return languages.cash;
      case bancolombia:
        return languages.paymentBancolombia;
      case daviplata:
        return languages.paymentDaviplata;
      case nequi:
        return languages.paymentNequi;
      default:
        return code;
    }
  }

  static String _labelFromRow(Map row, String code) {
    for (final key in [_apiLabelKey(), 'label', 'label_en', 'label_es']) {
      final value = row[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    }
    return _localizedKnownCode(code);
  }

  static List<DestinationPaymentOption> _optionsFromHive() {
    final raw = getStringFromSettingBox(hiveDestinationPaymentMethods, defaultValue: '');
    if (raw.trim().isEmpty) {
      return [];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return [];
      }
      final out = <DestinationPaymentOption>[];
      for (final row in decoded) {
        if (row is! Map) {
          continue;
        }
        final code = (row['code'] ?? '').toString().trim().toLowerCase();
        if (code.isEmpty) {
          continue;
        }
        out.add(DestinationPaymentOption(code: code, label: _labelFromRow(row, code)));
      }
      return out;
    } catch (_) {
      return [];
    }
  }

  static String labelForCode(String? code, {bool isSpanish = true}) {
    final match = optionsForLocale().where((o) => o.code == code);
    if (match.isNotEmpty) {
      return match.first.label;
    }
    return _localizedKnownCode(code ?? '');
  }

  static String ridePaymentMethodLabel({
    required int paymentType,
    String? destinationPaymentMethod,
    String? destinationPaymentLabel,
  }) {
    final serverLabel = destinationPaymentLabel?.trim() ?? '';
    if (serverLabel.isNotEmpty) {
      return serverLabel;
    }
    final code = (destinationPaymentMethod ?? '').trim().toLowerCase();
    if (code.isNotEmpty && code != cash) {
      return labelForCode(code);
    }
    switch (paymentType) {
      case PaymentType.online:
        return languages.onlinePayment;
      case PaymentType.wallet:
        return languages.wallet;
      default:
        return languages.cash;
    }
  }
}
