import 'package:app_xisti/utils/currency_display_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bare dollar symbol resolves as USD not COP', () {
    expect(CurrencyDisplayUtil.currencyBadge(r'$'), r'$ USD');
    expect(CurrencyDisplayUtil.currencyBadge('COL\$'), r'$ COP');
    expect(CurrencyDisplayUtil.currencyBadge('USD'), r'$ USD');
  });
}
