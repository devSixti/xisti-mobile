/// Normalizes Colombian mobile numbers: local 10 digits only (no +57 in the input field).
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
