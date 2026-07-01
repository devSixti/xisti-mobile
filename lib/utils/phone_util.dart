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

/// Strips country prefix if the user pasted it; returns up to 10 local digits.
String normalizeColombiaLocalMobile(String raw, {String? dialCode}) {
  var digits = digitsOnlyPhone(raw);
  if (digits.isEmpty) {
    return '';
  }

  final countryDigits = digitsOnlyPhone(normalizeDialCode(dialCode));
  if (countryDigits.isNotEmpty && digits.startsWith(countryDigits) && digits.length > 10) {
    digits = digits.substring(countryDigits.length);
  }
  if (digits.startsWith('57') && digits.length > 10) {
    digits = digits.substring(2);
  }
  while (digits.startsWith('0') && digits.length > 10) {
    digits = digits.substring(1);
  }
  if (digits.length > 10) {
    digits = digits.substring(digits.length - 10);
  }
  return digits;
}

/// Normalizes a local mobile number for the selected country dial code.
String normalizeLocalMobile(String raw, {String? dialCode}) {
  if (isColombiaDialCode(dialCode)) {
    return normalizeColombiaLocalMobile(raw, dialCode: dialCode);
  }

  var digits = digitsOnlyPhone(raw);
  if (digits.isEmpty) {
    return '';
  }

  final countryDigits = digitsOnlyPhone(normalizeDialCode(dialCode));
  if (countryDigits.isNotEmpty && digits.startsWith(countryDigits) && digits.length > countryDigits.length) {
    digits = digits.substring(countryDigits.length);
  }
  while (digits.startsWith('0') && digits.length > 6) {
    digits = digits.substring(1);
  }

  return digits;
}
