/// Whether signup "Continuar" should be enabled. Validators return empty when valid.
bool isSignupSubmitEnabled({
  required bool hideNameField,
  required bool hideEmailField,
  required bool requiresPhone,
  required bool requiresEmail,
  required String firstNameError,
  required String lastNameError,
  required String mobileError,
  required String emailError,
  required bool acceptTerms,
  required bool acceptDataProcessing,
  required bool acceptPlatform,
}) {
  final firstNameOk = hideNameField || firstNameError.isEmpty;
  final lastNameOk = hideNameField || lastNameError.isEmpty;
  final mobileOk = !requiresPhone || mobileError.isEmpty;
  final emailOk = !requiresEmail || hideEmailField || emailError.isEmpty;
  return firstNameOk &&
      lastNameOk &&
      mobileOk &&
      emailOk &&
      acceptTerms &&
      acceptDataProcessing &&
      acceptPlatform;
}
