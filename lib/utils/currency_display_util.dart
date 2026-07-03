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

  static String formatAmount(String storedSymbol, String formattedNumber) {
    return '${currencyBadge(storedSymbol)} $formattedNumber';
  }

  /// Display badge: `$ COP`, `$ USD`, `€ EUR`, `R$ BRL`, `$ ARS`.
  static String currencyBadge(String storedSymbol) {
    final code = _resolveCurrencyCode(storedSymbol);
    switch (code) {
      case 'COP':
        return r'$ COP';
      case 'USD':
        return r'$ USD';
      case 'EUR':
        return '€ EUR';
      case 'BRL':
        return r'R$ BRL';
      case 'ARS':
        return r'$ ARS';
      default:
        final prefix = amountPrefix(storedSymbol);
        return prefix.isEmpty ? code : '$prefix $code';
    }
  }

  static String chipLabel(CurrencyListItem item) {
    final code = (item.currencyCode.trim().isNotEmpty ? item.currencyCode : item.currencyName).trim().toUpperCase();
    if (code.isNotEmpty) {
      return currencyBadge(code);
    }
    return item.currencyName.trim();
  }

  static String amountPrefix(String storedSymbol) {
    final normalized = normalizeSymbol(storedSymbol);
    if (normalized.isNotEmpty) return normalized;
    final upper = storedSymbol.trim().toUpperCase();
    if (upper.contains('COP') || upper.contains('COL')) return '\$';
    return storedSymbol.trim().isEmpty ? '\$' : storedSymbol.trim();
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
