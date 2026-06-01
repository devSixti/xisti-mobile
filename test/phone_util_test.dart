import 'package:flutter_test/flutter_test.dart';

import 'package:app_xisti/utils/phone_util.dart';

void main() {
  test('strips +57 when pasted with country prefix', () {
    expect(
      normalizeColombiaLocalMobile('573001234567', dialCode: '+57'),
      '3001234567',
    );
  });

  test('keeps 10 digit local number', () {
    expect(
      normalizeColombiaLocalMobile('3001234567', dialCode: '+57'),
      '3001234567',
    );
  });
}
