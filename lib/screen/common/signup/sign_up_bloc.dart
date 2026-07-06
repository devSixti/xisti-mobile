import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/customCountryCodePicker/country_code.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/phone_util.dart';
import '../../../services/session_restore_service.dart';
import '../../../utils/signup_submit_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/validator.dart';
import '../../passengerMode/passengerHome/passenger_home.dart';
import '../Login/login_dl.dart';
import '../faceVerification/face_verification_view.dart';
import '../otpVerify/otp_verify_screen.dart';
import 'sign_up_repo.dart';

class SignUpBloc extends Bloc {
  final BuildContext context;

  final SignUpRepo _signUpRepo = SignUpRepo();
  late final VoidCallback _onFieldChanged;

  SignUpBloc(this.context) {
    _onFieldChanged = () => buttonHide();
    firstNameController.addListener(_onFieldChanged);
    lastNameController.addListener(_onFieldChanged);
    emailController.addListener(_onFieldChanged);
    mobileController.addListener(_onFieldChanged);
    referralCodeController.addListener(_onFieldChanged);
    emergencyContactNameController.addListener(_onFieldChanged);
    emergencyContactController.addListener(_onFieldChanged);
    countryCodeController.listen((_) => buttonHide());
    emergencyCountryCodeController.listen((_) => buttonHide());
    imgFileController.listen((_) => buttonHide());
    acceptTermsController.listen((_) => buttonHide());
    acceptDataProcessingController.listen((_) => buttonHide());
    acceptPlatformController.listen((_) => buttonHide());
    final dialCode = normalizeDialCode(getStringFromUserInfoBox(hiveCountryCode));
    final localMobile = normalizeLocalMobile(
      getStringFromUserInfoBox(hiveContactNumber),
      dialCode: dialCode,
    );
    if (localMobile.isNotEmpty) {
      mobileController.text = localMobile;
    }
    final pendingName = fullNameFromSignupHive();
    if (pendingName.isNotEmpty) {
      splitFullNameIntoFields(pendingName, firstNameController, lastNameController);
    }
    final pendingEmail = emailFromSignupHive();
    if (pendingEmail.isNotEmpty) {
      emailController.text = pendingEmail;
    }
    final pendingReferral = getStringFromUserInfoBox(hivePendingSignupReferral);
    if (pendingReferral.isNotEmpty) {
      referralCodeController.text = pendingReferral;
    }
    final pendingProfilePath = getStringFromSettingBox(hivePendingSignupProfilePath);
    if (pendingProfilePath.isNotEmpty) {
      final file = File(pendingProfilePath);
      if (file.existsSync()) {
        imgFileController.sink.add(file);
      }
    }
    countryCodeController.sink.add(
      CountryCode(
        dialCode: dialCode,
        code: defaultCountryCode.code,
        flagUri: 'assets/flags/${(defaultCountryCode.code ?? 'CO').toLowerCase()}.png',
      ),
    );
    emergencyCountryCodeController.sink.add(
      CountryCode(
        dialCode: dialCode,
        code: defaultCountryCode.code,
        flagUri: 'assets/flags/${(defaultCountryCode.code ?? 'CO').toLowerCase()}.png',
      ),
    );
    buttonHide();
    WidgetsBinding.instance.addPostFrameCallback((_) => buttonHide());
  }

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final referralCodeController = TextEditingController();
  final mobileController = TextEditingController();
  final emergencyContactNameController = TextEditingController();
  final emergencyContactController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final acceptTermsController = BehaviorSubject<bool>();
  final acceptDataProcessingController = BehaviorSubject<bool>();
  final acceptPlatformController = BehaviorSubject<bool>();
  final countryCodeController = BehaviorSubject<CountryCode>();
  final emergencyCountryCodeController = BehaviorSubject<CountryCode>();
  final submitValid = BehaviorSubject<bool>();
  final subject = BehaviorSubject<ApiResponse<LoginPojo>>();
  final imgFileController = BehaviorSubject<File?>();

  bool get isPhoneEditable => !signupPhoneFieldLocked();

  bool get hideNameField => signupHidesNameField();

  bool get hideEmailField => signupHidesEmailField();

  bool get nameFieldReadOnly => signupNameFieldReadOnly();

  bool get emailFieldReadOnly => signupEmailFieldReadOnly();

  bool get requiresPhone => signupRequiresPhone();

  bool get requiresEmail => signupRequiresEmail();

  void addProfileImage() {
    openScreenWithResult(
      context,
      FaceVerificationView(
        onVerified: (image, rotation) async {
          File compressFile = await prepareProfileImageFile(image);
          imgFileController.sink.add(compressFile);
          buttonHide();
        },
        onCancel: () {
          debugPrint("FaceVerificationView onCancel called");
        },
      ),
    );
  }

  Future<void> signUpApiCall() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => signUpApiCall())) {
      MultipartFile? multipartFile;
      if (imgFileController.valueOrNull != null) {
        multipartFile = MultipartFile.fromFileSync(imgFileController.valueOrNull!.path, filename: imgFileController.valueOrNull!.path.split('/').last);
      }

      subject.sink.add(ApiResponse.loading());
      try {
        final dialCode = normalizeDialCode(countryCodeController.valueOrNull?.dialCode);
        final localMobile = isPhoneEditable && mobileController.text.trim().isNotEmpty
            ? normalizeLocalMobile(mobileController.text.trim(), dialCode: dialCode, isoCode: countryCodeController.valueOrNull?.code)
            : getStringFromUserInfoBox(hiveContactNumber);
        var response = LoginPojo.fromJson(
          await _signUpRepo.signUp(
            firstName: hideNameField ? fullNameFromSignupHive().split(' ').first : firstNameController.text.trim(),
            lastName: hideNameField
                ? fullNameFromSignupHive().split(' ').skip(1).join(' ')
                : lastNameController.text.trim(),
            email: hideEmailField ? emailFromSignupHive() : emailController.text.trim(),
            referralCode: referralCodeController.text.trim(),
            profileImage: multipartFile,
            contactNumber: localMobile,
            countryCode: dialCode,
            emergencyContactName: emergencyContactNameController.text.trim(),
            emergencyContact: emergencyContactController.text.trim().isNotEmpty
                ? normalizeLocalMobile(
                    emergencyContactController.text.trim(),
                    dialCode: emergencyCountryCodeController.valueOrNull?.dialCode,
                    isoCode: emergencyCountryCodeController.valueOrNull?.code,
                  )
                : '',
            emergencyCountryCode: normalizeDialCode(emergencyCountryCodeController.valueOrNull?.dialCode),
          ),
        );
        final message = getApiMsg(response.message, response.messageCode);
        subject.sink.add(ApiResponse.completed(response));
        if (!context.mounted) return;
        if (isApiStatus(context, response.status ?? 0, message, false, messageCode: response.messageCode ?? 0)) {
          clearPendingSignupData();
          await setDataInHive(response);
          await markSessionAuthenticated();
          unawaited(SessionRestoreService.enableBiometricLoginIfAvailable());
          getGoogleMapKeyForApiCall();
          openScreenWithClearPrevious(context, const PassengerHome());
        }
      } catch (e) {
        subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void _storePendingSignupData() {
    putDataInSettingBox(hivePendingSignupAfterOtp, true);
    putDataInUserInfoBox(
      hivePendingSignupFullName,
      hideNameField
          ? fullNameFromSignupHive()
          : '${firstNameController.text.trim()} ${lastNameController.text.trim()}'.trim(),
    );
    putDataInUserInfoBox(
      hivePendingSignupEmail,
      hideEmailField ? emailFromSignupHive() : emailController.text.trim(),
    );
    putDataInUserInfoBox(hivePendingSignupReferral, referralCodeController.text.trim());
    final profile = imgFileController.valueOrNull;
    if (profile != null) {
      putDataInSettingBox(hivePendingSignupProfilePath, profile.path);
    }
  }

  Future<void> sendPhoneOtpAndOpenVerify() async {
    final dialCode = normalizeDialCode(countryCodeController.valueOrNull?.dialCode);
    final localMobile = normalizeLocalMobile(mobileController.text.trim(), dialCode: dialCode);

    if (await isNetworkConnected(onRetryPressedCallApi: () => sendPhoneOtpAndOpenVerify())) {
      subject.sink.add(ApiResponse.loading());
      try {
        final response = BaseModel.fromJson(
          await _signUpRepo.changeContactNumber(localMobile, dialCode),
        );
        final message = getApiMsg(response.message, response.messageCode);
        subject.sink.add(ApiResponse.completed(LoginPojo()));
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, false, messageCode: response.messageCode)) {
          putDataInUserInfoBox(hiveCountryCode, dialCode);
          putDataInUserInfoBox(hiveContactNumber, localMobile);
          putDataInSettingBox(hiveUserVerified, false);
          _storePendingSignupData();
          openScreen(context, const OtpVerifyScreen());
        }
      } catch (e) {
        subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  bool _needsPhoneOtpBeforeRegister() {
    if (!requiresPhone) {
      return false;
    }
    if (!isUserVerified()) {
      return true;
    }
    final dialCode = normalizeDialCode(countryCodeController.valueOrNull?.dialCode);
    final localMobile = normalizeLocalMobile(mobileController.text.trim(), dialCode: dialCode);
    final storedMobile = normalizeLocalMobile(
      getStringFromUserInfoBox(hiveContactNumber),
      dialCode: dialCode,
    );
    final storedDial = normalizeDialCode(getStringFromUserInfoBox(hiveCountryCode));
    return localMobile != storedMobile || dialCode != storedDial;
  }

  void submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()) {
      if (_needsPhoneOtpBeforeRegister()) {
        sendPhoneOtpAndOpenVerify();
      } else {
        signUpApiCall();
      }
    }
  }

  void buttonHide() {
    final dialCode = normalizeDialCode(countryCodeController.valueOrNull?.dialCode);
    final enabled = isSignupSubmitEnabled(
      hideNameField: hideNameField,
      hideEmailField: hideEmailField,
      requiresPhone: requiresPhone,
      requiresEmail: requiresEmail,
      firstNameError: hideNameField ? '' : registerFirstNameValidate(firstNameController.text, languages.enterValidFullName),
      lastNameError: hideNameField ? '' : registerLastNameValidate(lastNameController.text, languages.enterValidFullName),
      mobileError: requiresPhone
          ? mobileNumberValidateForDialCode(
              mobileController.text,
              dialCode: dialCode,
              isoCode: countryCodeController.valueOrNull?.code,
            )
          : (mobileController.text.trim().isEmpty
              ? ''
              : mobileNumberValidateForDialCode(
                  mobileController.text,
                  dialCode: dialCode,
                  isoCode: countryCodeController.valueOrNull?.code,
                )),
      emailError: requiresEmail && !hideEmailField
          ? emailValidate(emailController.text)
          : emailValidateOptional(emailController.text),
      acceptTerms: acceptTermsController.hasValue && acceptTermsController.value,
      acceptDataProcessing: acceptDataProcessingController.hasValue && acceptDataProcessingController.value,
      acceptPlatform: acceptPlatformController.hasValue && acceptPlatformController.value,
    );
    submitValid.add(enabled);
  }

  @override
  void dispose() {
    firstNameController.removeListener(_onFieldChanged);
    lastNameController.removeListener(_onFieldChanged);
    emailController.removeListener(_onFieldChanged);
    mobileController.removeListener(_onFieldChanged);
    referralCodeController.removeListener(_onFieldChanged);
    emergencyContactNameController.removeListener(_onFieldChanged);
    emergencyContactController.removeListener(_onFieldChanged);
    countryCodeController.close();
    emergencyCountryCodeController.close();
    submitValid.close();
    acceptTermsController.close();
    acceptDataProcessingController.close();
    acceptPlatformController.close();
    imgFileController.close();
    firstNameController.dispose();
    lastNameController.dispose();
    referralCodeController.dispose();
    emailController.dispose();
    mobileController.dispose();
    emergencyContactNameController.dispose();
    emergencyContactController.dispose();
  }
}
