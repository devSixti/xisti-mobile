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
    fullNameController.addListener(_onFieldChanged);
    emailController.addListener(_onFieldChanged);
    mobileController.addListener(_onFieldChanged);
    referralCodeController.addListener(_onFieldChanged);
    final dialCode = normalizeDialCode(getStringFromUserInfoBox(hiveCountryCode));
    final localMobile = normalizeLocalMobile(
      getStringFromUserInfoBox(hiveContactNumber),
      dialCode: dialCode,
    );
    if (localMobile.isNotEmpty) {
      mobileController.text = localMobile;
    }
    final pendingName = getStringFromUserInfoBox(hivePendingSignupFullName);
    if (pendingName.isNotEmpty) {
      fullNameController.text = pendingName;
    } else {
      final storedName = getStringFromUserInfoBox(hiveUserName);
      if (storedName.isNotEmpty) {
        fullNameController.text = storedName;
      }
    }
    final pendingEmail = getStringFromUserInfoBox(hivePendingSignupEmail);
    if (pendingEmail.isNotEmpty) {
      emailController.text = pendingEmail;
    } else {
      final storedEmail = getStringFromUserInfoBox(hiveEmail);
      if (storedEmail.isNotEmpty) {
        emailController.text = storedEmail;
      }
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
    buttonHide();
  }

  bool get hideNameField => false;

  bool get hideEmailField => false;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final referralCodeController = TextEditingController();
  final mobileController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final acceptTermsController = BehaviorSubject<bool>();
  final acceptPlatformController = BehaviorSubject<bool>();
  final countryCodeController = BehaviorSubject<CountryCode>();
  final submitValid = BehaviorSubject<bool>();
  final subject = BehaviorSubject<ApiResponse<LoginPojo>>();
  final imgFileController = BehaviorSubject<File?>();

  bool get isPhoneEditable => requiresPhoneOtpOnSignup();

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
        var response = LoginPojo.fromJson(
          await _signUpRepo.signUp(fullNameController.text.trim(), emailController.text.trim(), referralCodeController.text.trim(), multipartFile),
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
    putDataInUserInfoBox(hivePendingSignupFullName, fullNameController.text.trim());
    putDataInUserInfoBox(hivePendingSignupEmail, emailController.text.trim());
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
    if (!requiresPhoneOtpOnSignup()) {
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
    if (imgFileController.valueOrNull == null) {
      openSimpleSnackbar(context, languages.pleaseAddProfileImage);
      return;
    }
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
      isPhoneEditable: isPhoneEditable,
      nameError: registerFullNameValidate(fullNameController.text, languages.enterValidFullName),
      mobileError: isPhoneEditable ? mobileNumberValidateForDialCode(mobileController.text, dialCode: dialCode) : '',
      emailError: emailValidate(emailController.text),
      hasProfileImage: imgFileController.valueOrNull != null,
      acceptTerms: acceptTermsController.hasValue && acceptTermsController.value,
      acceptPlatform: acceptPlatformController.hasValue && acceptPlatformController.value,
    );
    submitValid.add(enabled);
  }

  @override
  void dispose() {
    fullNameController.removeListener(_onFieldChanged);
    emailController.removeListener(_onFieldChanged);
    mobileController.removeListener(_onFieldChanged);
    referralCodeController.removeListener(_onFieldChanged);
    countryCodeController.close();
    submitValid.close();
    acceptTermsController.close();
    acceptPlatformController.close();
    imgFileController.close();
    fullNameController.clear();
    referralCodeController.clear();
    emailController.clear();
    mobileController.clear();
  }
}
