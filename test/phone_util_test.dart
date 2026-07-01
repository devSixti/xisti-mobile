import 'package:flutter_test/flutter_test.dart';

import 'package:app_xisti/utils/phone_util.dart';

void main() {
  test('normalizeColombiaLocalMobile strips +57 prefix', () {
    expect(
      normalizeColombiaLocalMobile('573001234567', dialCode: '+57'),
      '3001234567',
    );
  });

  test('normalizeLocalMobile keeps full US local number', () {
    expect(
      normalizeLocalMobile('5551234567', dialCode: '+1'),
      '5551234567',
    );
  });

  test('normalizeLocalMobile strips pasted country code for US', () {
    expect(
      normalizeLocalMobile('15551234567', dialCode: '+1'),
      '5551234567',
    );
  });
}
