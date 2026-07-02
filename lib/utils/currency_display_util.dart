import '../screen/common/languageCurrency/language_and_currency_dl.dart';

/// Consistent currency symbols for preferences and amounts.
class CurrencyDisplayUtil {
  static String normalizeSymbol(String? symbol, {String? currencyCode}) {
    final raw = (symbol ?? '').trim();
    final upper = raw.toUpperCase();
    final code = (currencyCode ?? '').trim().toUpperCase();
    if (upper == 'COL\$' || upper == 'COL' || upper.contains('COL\$') || upper == 'COP' || code == 'COP') {
      return '\$';
    }
    if (raw.isNotEmpty) return raw;
    switch (code) {
      case 'COP':
        return '\$';
      case 'USD':
        return 'US\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'MXN':
        return 'MX\$';
      default:
        return raw;
    }
  }

  static String chipLabel(CurrencyListItem item) {
    final name = item.currencyName.trim();
    final code = (item.currencyCode.trim().isNotEmpty ? item.currencyCode : name).trim().toUpperCase();
    final symbol = normalizeSymbol(item.currencySymbol, currencyCode: code);
    if (code.isNotEmpty && symbol.isNotEmpty) {
      return '$code · $symbol';
    }
    if (name.isNotEmpty && symbol.isNotEmpty) {
      return '$name · $symbol';
    }
    return name.isNotEmpty ? name : code;
  }

  static String amountPrefix(String storedSymbol) {
    final normalized = normalizeSymbol(storedSymbol);
    if (normalized.isNotEmpty) return normalized;
    final upper = storedSymbol.trim().toUpperCase();
    if (upper.contains('COP') || upper.contains('COL')) return '\$';
    return storedSymbol.trim().isEmpty ? '\$' : storedSymbol.trim();
  }
}
