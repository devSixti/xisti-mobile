import 'package:app_xisti/utils/signup_submit_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isSignupSubmitEnabled', () {
    test('enabled when all required fields and consents are valid', () {
      expect(
        isSignupSubmitEnabled(
          hideNameField: false,
          hideEmailField: false,
          requiresPhone: true,
          requiresEmail: false,
          firstNameError: '',
          lastNameError: '',
          mobileError: '',
          emailError: '',
          acceptTerms: true,
          acceptDataProcessing: true,
          acceptPlatform: true,
        ),
        isTrue,
      );
    });

    test('enabled for Apple Sign In when name is hidden', () {
      expect(
        isSignupSubmitEnabled(
          hideNameField: true,
          hideEmailField: true,
          requiresPhone: false,
          requiresEmail: true,
          firstNameError: 'Name required',
          lastNameError: 'Name required',
          mobileError: '',
          emailError: '',
          acceptTerms: true,
          acceptDataProcessing: true,
          acceptPlatform: true,
        ),
        isTrue,
      );
    });

    test('disabled without terms acceptance', () {
      expect(
        isSignupSubmitEnabled(
          hideNameField: false,
          hideEmailField: false,
          requiresPhone: true,
          requiresEmail: false,
          firstNameError: '',
          lastNameError: '',
          mobileError: '',
          emailError: '',
          acceptTerms: false,
          acceptDataProcessing: true,
          acceptPlatform: true,
        ),
        isFalse,
      );
    });

    test('disabled without data processing acceptance', () {
      expect(
        isSignupSubmitEnabled(
          hideNameField: false,
          hideEmailField: false,
          requiresPhone: true,
          requiresEmail: false,
          firstNameError: '',
          lastNameError: '',
          mobileError: '',
          emailError: '',
          acceptTerms: true,
          acceptDataProcessing: false,
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
          requiresPhone: true,
          requiresEmail: false,
          firstNameError: '',
          lastNameError: '',
          mobileError: '',
          emailError: '',
          acceptTerms: true,
          acceptDataProcessing: true,
          acceptPlatform: false,
        ),
        isFalse,
      );
    });
  });
}
