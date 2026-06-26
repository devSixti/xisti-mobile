import 'app_mobile_settings.dart';
import '../hive/hive_helper.dart';
import '../main.dart';

/// Maps API message codes to localized strings from ARB.
String? localizedApiMessageForCode(int code) {
  switch (code) {
    case 1:
      return languages.success;
    case 2:
      return languages.verificationPending;
    case 3:
      return languages.driverBlock;
    case 401:
      return languages.newUpdateMsg;
    case 385:
      return languages.invalidMobileNumberCo;
    case 387:
      return languages.invalidNationalId;
    case 371:
      return languages.invalidVehiclePlate;
    case 388:
      final step = getFareNegotiationStepFromSettings().toInt();
      return languages.offerFareMin('$step');
    case 389:
      return languages.enterParcelNote;
    case 390:
      return languages.enterParcelNote;
    case 391:
      return languages.enterRecipientName;
    case 392:
      return languages.enterParcelNote;
    case 9:
      return languages.genericErrorTryAgain;
    default:
      return null;
  }
}

@Deprecated('Use localizedApiMessageForCode')
String? spanishApiMessageForCode(int code) => localizedApiMessageForCode(code);

bool _prefersSpanishApiMessages() {
  try {
    return getLanguageFromUserPrefBox().toLowerCase().startsWith('es');
  } catch (_) {
    return true;
  }
}

bool _looksLikeSpanish(String text) {
  return RegExp(r'[áéíóúñ¿¡]', caseSensitive: false).hasMatch(text) ||
      text.toLowerCase().contains('por favor') ||
      text.toLowerCase().contains('debe') ||
      text.toLowerCase().contains('ingresa');
}

bool _looksLikeUntranslatedEnglish(String text) {
  final lower = text.toLowerCase();
  if (_looksLikeSpanish(text)) return false;
  return RegExp(r'\b(the|field|required|must|when|package|please)\b').hasMatch(lower);
}

/// Maps common Laravel validation strings (English) to localized messages.
String? _localizedFromKnownEnglishApiMessage(String? message) {
  if (message == null || message.trim().isEmpty) return null;
  final m = message.toLowerCase();
  if (m.contains('package weight') || m.contains('package_weight_kg') || m.contains('peso del paquete')) {
    return localizedApiMessageForCode(389);
  }
  if (m.contains('package height') ||
      m.contains('package width') ||
      m.contains('package length') ||
      m.contains('package_height') ||
      m.contains('package_width') ||
      m.contains('package_length') ||
      m.contains('dimensiones del paquete')) {
    return localizedApiMessageForCode(390);
  }
  if (m.contains('recipient name') || m.contains('recipient_name') || m.contains('nombre del destinatario')) {
    return localizedApiMessageForCode(391);
  }
  if (m.contains('item description') || m.contains('item_description') || m.contains('descripción del paquete')) {
    return localizedApiMessageForCode(392);
  }
  if (m.contains('phone number must be exactly 10') ||
      m.contains('recipient contact') ||
      m.contains('teléfono debe tener exactamente 10')) {
    return localizedApiMessageForCode(385);
  }
  if (m.contains('document number must be between')) {
    return localizedApiMessageForCode(387);
  }
  if (m.contains('fare must change in steps')) {
    return localizedApiMessageForCode(388);
  }
  return null;
}

/// Prefer localized messages by message_code and known English patterns; fallback to API text or generic error.
String resolveApiMessage({String? message, int? messageCode}) {
  final isSpanish = _prefersSpanishApiMessages();

  if (isSpanish) {
    final fromEnglish = _localizedFromKnownEnglishApiMessage(message);
    if (fromEnglish != null && fromEnglish.isNotEmpty) {
      return fromEnglish;
    }

    if (messageCode != null && messageCode > 0 && messageCode != 9) {
      final byCode = localizedApiMessageForCode(messageCode);
      if (byCode != null && byCode.isNotEmpty) {
        return byCode;
      }
    }

    final text = (message ?? '').trim();
    if (text.isNotEmpty && text.toLowerCase() != 'null') {
      if (_looksLikeSpanish(text)) {
        return text;
      }
      if (_looksLikeUntranslatedEnglish(text)) {
        return localizedApiMessageForCode(9) ?? languages.genericErrorTryAgain;
      }
      return text;
    }

    return localizedApiMessageForCode(messageCode ?? 9) ?? languages.genericErrorTryAgain;
  }

  if (messageCode != null && messageCode > 0) {
    final byCode = localizedApiMessageForCode(messageCode);
    if (byCode != null && byCode.isNotEmpty) {
      return byCode;
    }
  }

  final text = (message ?? '').trim();
  if (text.isNotEmpty && text.toLowerCase() != 'null') {
    return text;
  }
  return languages.genericErrorTryAgain;
}
