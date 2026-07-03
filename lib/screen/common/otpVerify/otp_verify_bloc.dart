import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../blocs/bloc.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/base_dl.dart';
import '../../../services/session_restore_service.dart';
import '../../../utils/utils.dart';
import '../../passengerMode/passengerHome/passenger_home.dart';
import '../Login/login_dl.dart';
import '../signup/sign_up_repo.dart';
import 'otp_verify_repo.dart';

class OtpVerifyBloc extends Bloc {
  BuildContext context;

  final OtpVerifyRepo _otpVerifyRepo = OtpVerifyRepo();
  final SignUpRepo _signUpRepo = SignUpRepo();

  OtpVerifyBloc(this.context) {
    final stored = getStringFromSettingBox(hiveOtpDeliveryChannel);
    otpDeliveryChannelSubject.add(stored.isEmpty ? 'sms' : stored);
  }

  final otpController = BehaviorSubject<String>();
  final otpDeliveryChannelSubject = BehaviorSubject<String>.seeded('sms');
  final resendOTPController = BehaviorSubject<bool>.seeded(false);
  final subjectResend = BehaviorSubject<ApiResponse<BaseModel>>();
  final subjectVerify = BehaviorSubject<ApiResponse<LoginPojo>>();
  DateTime timer = DateTime.now();
  PinInputController pinInputController = PinInputController();

  Future<void> verify() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        verify();
      },
    )) {
      subjectVerify.sink.add(ApiResponse.loading());
      try {
        var response = LoginPojo.fromJson(await _otpVerifyRepo.callVerifyOtpApi(otpController.value));

        final message = getApiMsg(response.message, response.messageCode);
        subjectVerify.sink.add(ApiResponse.completed(response));
        if (!context.mounted) return;
        if (isApiStatus(context, response.status ?? 0, message, false, messageCode: response.messageCode ?? 0)) {
          await markSessionAuthenticated();
          final pendingSocialSignup = getBoolFromSettingBox(hivePendingSignupAfterOtp);
          final registrationComplete = (response.isRegister ?? 0) == 1;
          if (pendingSocialSignup && !registrationComplete) {
            await _completePendingSignup();
          } else {
            if (pendingSocialSignup) {
              clearPendingSignupData();
            }
            await manageLoginResponse(context, response);
          }
        } else if (response.status == 4 || response.status == 5) {
          await clearSessionCredentials();
          if (context.mounted) {
            await navigateToWelcome(context);
          }
        } else {
          openSimpleSnackbar(context, message);
        }
      } catch (e) {
        subjectVerify.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> _completePendingSignup() async {
    final profilePath = getStringFromSettingBox(hivePendingSignupProfilePath);
    MultipartFile? multipartFile;
    if (profilePath.isNotEmpty) {
      final file = File(profilePath);
      if (await file.exists()) {
        multipartFile = MultipartFile.fromFileSync(file.path, filename: file.path.split('/').last);
      }
    }

    try {
      final response = LoginPojo.fromJson(
        await _signUpRepo.signUp(
          getStringFromUserInfoBox(hivePendingSignupFullName),
          getStringFromUserInfoBox(hivePendingSignupEmail),
          getStringFromUserInfoBox(hivePendingSignupReferral),
          multipartFile,
        ),
      );
      final message = getApiMsg(response.message, response.messageCode);
      if (!context.mounted) return;
      if (isApiStatus(context, response.status ?? 0, message, false, messageCode: response.messageCode ?? 0)) {
        clearPendingSignupData();
        await setDataInHive(response);
        await markSessionAuthenticated();
        unawaited(SessionRestoreService.enableBiometricLoginIfAvailable());
        unawaited(getGoogleMapKeyForApiCall());
        if (!context.mounted) return;
        openScreenWithClearPrevious(context, const PassengerHome());
      }
    } catch (e) {
      if (!context.mounted) return;
      openSimpleSnackbar(context, e.toString());
    }
  }

  Future<void> resendOtp(BuildContext bottomSheetContext, {String channel = 'sms'}) async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        resendOtp(bottomSheetContext, channel: channel);
      },
    )) {
      subjectResend.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(await _otpVerifyRepo.callResendOtpApi(channel: channel, forceResend: true));

        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, false)) {
          subjectResend.sink.add(ApiResponse.completed(response));
          final deliveredViaWhatsapp =
              channel == 'whatsapp' || response.otpDeliveryChannel == 'whatsapp';
          if (deliveredViaWhatsapp) {
            putDataInSettingBox(hiveOtpDeliveryChannel, 'whatsapp');
            otpDeliveryChannelSubject.add('whatsapp');
            openSimpleSnackbar(context, languages.resendOtpWhatsappSuccessMsg);
          } else {
            putDataInSettingBox(hiveOtpDeliveryChannel, 'sms');
            otpDeliveryChannelSubject.add('sms');
            openSimpleSnackbar(context, languages.resendOtpSuccessMsg);
          }
          timer = DateTime.now();
          resendOTPController.sink.add(true);
        } else {
          subjectResend.sink.add(ApiResponse.error(message));
          openSimpleSnackbar(context, message);
        }
      } catch (e) {
        subjectResend.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    otpDeliveryChannelSubject.close();
    resendOTPController.close();
    otpController.close();
    subjectResend.close();
    subjectVerify.close();
  }
}
