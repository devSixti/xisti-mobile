import 'package:flutter_test/flutter_test.dart';

import 'package:xisti/utils/phone_util.dart';

void main() {
  test('normalizeColombiaLocalMobile strips +57 prefix', () {
    expect(
      normalizeColombiaLocalMobile('573001234567', dialCode: '+57'),
      '3001234567',
    );
  });

  test('normalizeColombiaLocalMobile does not truncate excess digits', () {
    expect(
      normalizeColombiaLocalMobile('300123456789', dialCode: '+57'),
      '300123456789',
    );
    expect(isValidLocalMobile('300123456789', dialCode: '+57', isoCode: 'CO'), false);
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

  test('Colombia mobile must start with 3', () {
    expect(isValidLocalMobile('2001234567', dialCode: '+57', isoCode: 'CO'), false);
    expect(isValidLocalMobile('3001234567', dialCode: '+57', isoCode: 'CO'), true);
  });
}
