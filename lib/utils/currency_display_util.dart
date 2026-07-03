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

  /// ISO-style display label for amounts: "$ 13.000", "€ 25", "R$ 100".
  static String formatAmount(String storedSymbol, String formattedNumber) {
    final code = _resolveCurrencyCode(storedSymbol);
    switch (code) {
      case 'COP':
        return '\$ $formattedNumber';
      case 'USD':
        return '\$ $formattedNumber USD';
      case 'EUR':
        return '€ $formattedNumber EUR';
      case 'BRL':
        return 'R\$ $formattedNumber BRL';
      case 'ARS':
        return '\$ $formattedNumber ARS';
      default:
        final prefix = amountPrefix(storedSymbol);
        return prefix.isEmpty ? formattedNumber : '$prefix $formattedNumber';
    }
  }

  static String _resolveCurrencyCode(String storedSymbol) {
    final upper = storedSymbol.trim().toUpperCase();
    if (upper.contains('COP') || upper.contains('COL')) return 'COP';
    if (upper.contains('USD') || upper.contains('US\$')) return 'USD';
    if (upper.contains('EUR') || upper.contains('€')) return 'EUR';
    if (upper.contains('BRL') || upper.contains('R\$')) return 'BRL';
    if (upper.contains('ARS')) return 'ARS';
    return upper.length == 3 ? upper : 'COP';
  }
}
