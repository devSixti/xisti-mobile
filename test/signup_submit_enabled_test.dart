import 'package:app_xisti/utils/signup_submit_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isSignupSubmitEnabled', () {
    test('enabled when all fields valid', () {
      expect(
        isSignupSubmitEnabled(
          hideNameField: false,
          hideEmailField: false,
          isPhoneEditable: true,
          nameError: '',
          mobileError: '',
          emailError: '',
          hasProfileImage: true,
          acceptTerms: true,
          acceptPlatform: true,
        ),
        isTrue,
      );
    });

    test('disabled without profile image', () {
      expect(
        isSignupSubmitEnabled(
          hideNameField: false,
          hideEmailField: false,
          isPhoneEditable: true,
          nameError: '',
          mobileError: '',
          emailError: '',
          hasProfileImage: false,
          acceptTerms: true,
          acceptPlatform: true,
        ),
        isFalse,
      );
    });

    test('disabled without platform acceptance', () {
      expect(
        isSignupSubmitEnabled(
          hideNameField: false,
          hideEmailField: false,
          isPhoneEditable: true,
          nameError: '',
          mobileError: '',
          emailError: '',
          hasProfileImage: true,
          acceptTerms: true,
          acceptPlatform: false,
        ),
        isFalse,
      );
    });
  });
}
