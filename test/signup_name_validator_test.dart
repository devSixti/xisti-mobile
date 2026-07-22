import 'package:app_xisti/utils/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('register name validators', () {
    test('accepts accented Spanish names', () {
      expect(registerFirstNameValidate('Jerónimo', 'invalid'), isEmpty);
      expect(registerLastNameValidate('Restrepo', 'invalid'), isEmpty);
      expect(registerFirstNameValidate('José', 'invalid'), isEmpty);
      expect(registerLastNameValidate('María', 'invalid'), isEmpty);
    });

    test('rejects digits in names', () {
      expect(registerFirstNameValidate('John3', 'invalid'), isNotEmpty);
    });
  });
}
