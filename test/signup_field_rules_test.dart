import 'package:app_xisti/constant/constant.dart';
import 'package:app_xisti/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('signup field requirements', () {
    test('phone OTP login requires phone and optional email', () {
      expect(isPhoneOtpSignup(LoginType.email), isTrue);
      expect(signupRequiresPhone(LoginType.email), isTrue);
      expect(signupRequiresEmail(LoginType.email), isFalse);
      expect(
        signupPhoneFieldLocked(loginType: LoginType.email, contactNumber: '3001234567'),
        isTrue,
      );
    });

    test('social login requires email and optional phone', () {
      expect(isPhoneOtpSignup(LoginType.google), isFalse);
      expect(signupRequiresPhone(LoginType.google), isFalse);
      expect(signupRequiresEmail(LoginType.google), isTrue);
      expect(signupPhoneFieldLocked(loginType: LoginType.google), isFalse);
    });

    test('google signup shows oauth name and email fields', () {
      expect(signupHidesNameField(LoginType.google), isFalse);
      expect(signupHidesEmailField(LoginType.google), isFalse);
    });

    test('apple signup hides name field', () {
      expect(signupHidesNameField(LoginType.apple), isTrue);
    });

    test('empty login type is treated as phone signup', () {
      expect(isPhoneOtpSignup(''), isTrue);
      expect(signupRequiresEmail(''), isFalse);
    });
  });
}
