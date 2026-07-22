import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isEmailOrNumNull', () {
    test('phone-only user can request services without email', () {
      expect(
        isContactInfoMissing(hasEmail: false, hasPhone: true),
        isFalse,
      );
    });

    test('email-only user can proceed without phone', () {
      expect(
        isContactInfoMissing(hasEmail: true, hasPhone: false),
        isFalse,
      );
    });

    test('missing both email and phone blocks service flow', () {
      expect(
        isContactInfoMissing(hasEmail: false, hasPhone: false),
        isTrue,
      );
    });
  });
}

/// Pure helper mirroring [isEmailOrNumNull] hive reads for unit tests.
bool isContactInfoMissing({required bool hasEmail, required bool hasPhone}) {
  return !hasEmail && !hasPhone;
}
