import 'phone_length_rules.dart';

/// Phone normalization helpers for Colombia and international dial codes.
String digitsOnlyPhone(String input) {
  return input.replaceAll(RegExp(r'\D'), '');
}

String normalizeDialCode(String? dialCode) {
  if (dialCode == null) {
    return '+57';
  }
  final trimmed = dialCode.trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') {
    return '+57';
  }
  return trimmed.startsWith('+') ? trimmed : '+$trimmed';
}

bool isColombiaDialCode(String? dialCode) {
  return digitsOnlyPhone(normalizeDialCode(dialCode)) == '57';
}

/// Strips country prefix if pasted; does not truncate excess digits (validation rejects them).
String normalizeColombiaLocalMobile(String raw, {String? dialCode}) {
  var digits = digitsOnlyPhone(raw);
  if (digits.isEmpty) {
    return '';
  }

  final countryDigits = digitsOnlyPhone(normalizeDialCode(dialCode));
  if (countryDigits.isNotEmpty && digits.startsWith(countryDigits) && digits.length > countryDigits.length) {
    digits = digits.substring(countryDigits.length);
  }
  if (digits.startsWith('57') && digits.length > 10) {
    digits = digits.substring(2);
  }
  while (digits.startsWith('0') && digits.length > 10) {
    digits = digits.substring(1);
  }
  return digits;
}

/// Normalizes a local mobile number for the selected country dial code.
String normalizeLocalMobile(String raw, {String? dialCode, String? isoCode}) {
  if (isColombiaDialCode(dialCode)) {
    return normalizeColombiaLocalMobile(raw, dialCode: dialCode);
  }

  var digits = digitsOnlyPhone(raw);
  if (digits.isEmpty) {
    return '';
  }

  final countryDigits = digitsOnlyPhone(normalizeDialCode(dialCode));
  final rule = phoneLengthRuleForDialCode(dialCode, isoCode: isoCode);
  if (countryDigits.isNotEmpty && digits.startsWith(countryDigits) && digits.length > countryDigits.length) {
    digits = digits.substring(countryDigits.length);
  }
  while (digits.startsWith('0') && digits.length > rule.min) {
    digits = digits.substring(1);
  }

  return digits;
}

bool isValidLocalMobile(String raw, {String? dialCode, String? isoCode}) {
  final digits = normalizeLocalMobile(raw, dialCode: dialCode, isoCode: isoCode);
  if (digits.isEmpty) {
    return false;
  }
  final rule = phoneLengthRuleForDialCode(dialCode, isoCode: isoCode);
  return rule.isValidLength(digits.length) && rule.matchesPattern(digits);
}
