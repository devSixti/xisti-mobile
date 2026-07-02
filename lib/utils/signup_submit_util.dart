/// Whether signup "Continuar" should be enabled. Validators return empty when valid.
bool isSignupSubmitEnabled({
  required bool hideNameField,
  required bool hideEmailField,
  required bool isPhoneEditable,
  required String nameError,
  required String mobileError,
  required String emailError,
  required bool hasProfileImage,
  required bool acceptTerms,
  required bool acceptPlatform,
}) {
  final nameOk = hideNameField || nameError.isEmpty;
  final mobileOk = !isPhoneEditable || mobileError.isEmpty;
  final emailOk = hideEmailField || emailError.isEmpty;
  return nameOk && mobileOk && emailOk && hasProfileImage && acceptTerms && acceptPlatform;
}
