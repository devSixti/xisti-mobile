import 'dart:convert';

import '../hive/hive_helper.dart';

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

  static List<DestinationPaymentOption> optionsForLocale(bool isSpanish) {
    final fromApi = _optionsFromHive(isSpanish);
    if (fromApi.isNotEmpty) {
      return fromApi;
    }
    if (isSpanish) {
      return const [
        DestinationPaymentOption(code: cash, label: 'Efectivo'),
        DestinationPaymentOption(code: bancolombia, label: 'Bancolombia'),
        DestinationPaymentOption(code: daviplata, label: 'Daviplata'),
        DestinationPaymentOption(code: nequi, label: 'Nequi'),
      ];
    }
    return const [
      DestinationPaymentOption(code: cash, label: 'Cash'),
      DestinationPaymentOption(code: bancolombia, label: 'Bancolombia'),
      DestinationPaymentOption(code: daviplata, label: 'Daviplata'),
      DestinationPaymentOption(code: nequi, label: 'Nequi'),
    ];
  }

  static List<DestinationPaymentOption> _optionsFromHive(bool isSpanish) {
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
        final label = (row['label'] ?? row[isSpanish ? 'label_es' : 'label_en'] ?? code).toString();
        out.add(DestinationPaymentOption(code: code, label: label));
      }
      return out;
    } catch (_) {
      return [];
    }
  }

  static String labelForCode(String? code, {bool isSpanish = true}) {
    final match = optionsForLocale(isSpanish).where((o) => o.code == code);
    if (match.isNotEmpty) {
      return match.first.label;
    }
    return code ?? '';
  }
}
