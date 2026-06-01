import 'app_mobile_settings.dart';
import '../hive/hive_helper.dart';

/// Spanish API messages aligned with XISTI Admin `resources/lang/es/user_messages.php`.
String? spanishApiMessageForCode(int code) {
  switch (code) {
    case 1:
      return 'Éxito';
    case 2:
      return 'Verificación de correo o número de teléfono pendiente';
    case 3:
      return 'Tu cuenta está bloqueada y no tienes acceso a la aplicación';
    case 4:
      return 'Tu sesión expiró. Por favor inicia sesión de nuevo';
    case 5:
      return 'Usuario no encontrado';
    case 9:
      return 'Por favor inténtalo de nuevo';
    case 11:
      return 'El correo electrónico ya está registrado';
    case 12:
      return 'El número de teléfono ya está registrado';
    case 371:
      return 'La placa debe tener 3 letras y 3 números (ej. ABC123). En moto: ABC12D o ABC123';
    case 385:
      return 'El teléfono debe tener exactamente 10 dígitos numéricos';
    case 387:
      return 'El número de documento debe tener entre 6 y 10 dígitos';
    case 388:
      final step = getFareNegotiationStepFromSettings().toInt();
      return 'La tarifa debe avanzar de a $step en $step (moneda local)';
    case 389:
      return 'Ingresa el peso del paquete en kilogramos.';
    case 390:
      return 'Ingresa las dimensiones del paquete (alto, ancho y largo en cm).';
    case 391:
      return 'Ingresa el nombre del destinatario.';
    case 392:
      return 'Ingresa la descripción del paquete.';
    default:
      return null;
  }
}

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

/// Maps common Laravel validation strings (English) to Spanish for Colombia users.
String? _spanishFromKnownEnglishApiMessage(String? message) {
  if (message == null || message.trim().isEmpty) return null;
  final m = message.toLowerCase();
  if (m.contains('package weight') || m.contains('package_weight_kg') || m.contains('peso del paquete')) {
    return spanishApiMessageForCode(389);
  }
  if (m.contains('package height') ||
      m.contains('package width') ||
      m.contains('package length') ||
      m.contains('package_height') ||
      m.contains('package_width') ||
      m.contains('package_length') ||
      m.contains('dimensiones del paquete')) {
    return spanishApiMessageForCode(390);
  }
  if (m.contains('recipient name') || m.contains('recipient_name') || m.contains('nombre del destinatario')) {
    return spanishApiMessageForCode(391);
  }
  if (m.contains('item description') || m.contains('item_description') || m.contains('descripción del paquete')) {
    return spanishApiMessageForCode(392);
  }
  if (m.contains('phone number must be exactly 10') ||
      m.contains('recipient contact') ||
      m.contains('teléfono debe tener exactamente 10')) {
    return spanishApiMessageForCode(385);
  }
  if (m.contains('document number must be between')) {
    return spanishApiMessageForCode(387);
  }
  if (m.contains('fare must change in steps')) {
    return spanishApiMessageForCode(388);
  }
  return null;
}

/// Prefer Spanish by message_code and known English patterns; fallback to API text or generic error.
String resolveApiMessage({String? message, int? messageCode}) {
  final isSpanish = _prefersSpanishApiMessages();

  if (isSpanish) {
    final fromEnglish = _spanishFromKnownEnglishApiMessage(message);
    if (fromEnglish != null && fromEnglish.isNotEmpty) {
      return fromEnglish;
    }

    if (messageCode != null && messageCode > 0 && messageCode != 9) {
      final byCode = spanishApiMessageForCode(messageCode);
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
        return spanishApiMessageForCode(9) ?? 'Ocurrió un error. Inténtalo de nuevo.';
      }
      return text;
    }

    return spanishApiMessageForCode(messageCode ?? 9) ?? 'Ocurrió un error. Inténtalo de nuevo.';
  }

  if (messageCode != null && messageCode > 0) {
    final byCode = spanishApiMessageForCode(messageCode);
    if (byCode != null && byCode.isNotEmpty) {
      return byCode;
    }
  }

  final text = (message ?? '').trim();
  if (text.isNotEmpty && text.toLowerCase() != 'null') {
    return text;
  }
  return 'Something went wrong. Please try again.';
}
