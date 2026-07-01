import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/api_response.dart';
import '../../../utils/qa_review_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';
import '../Login/login_dl.dart';
import '../Login/login_screen.dart';
import '../signup/signup_screen.dart';
import 'otp_verify_bloc.dart';
import 'otp_verify_bottom_sheet.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  OtpVerifyBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= OtpVerifyBloc(context);
    if (isQaReviewPhone()) {
      _bloc?.otpController.add(kQaReviewFixedOtp);
      _bloc?.pinInputController.text = kQaReviewFixedOtp;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _bloc?.verify();
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        if (getBoolFromSettingBox(hivePendingSignupAfterOtp)) {
          if (!context.mounted) return;
          openScreenWithClearPrevious(context, const SignupScreen());
        } else {
          await putDataInUserInfoBox(hiveUserId, 0);
          if (!context.mounted) return;
          openScreenWithClearPrevious(context, const LoginScreen());
        }
      },
      child: ScaffoldWithSafeArea(
        appBar: CommonAppBar(
          leading: backButtonForAppBarCustom(
            context: context,
            onBackPress: () async {
              if (getBoolFromSettingBox(hivePendingSignupAfterOtp)) {
                if (!context.mounted) return;
                openScreenWithClearPrevious(context, const SignupScreen());
              } else {
                await putDataInUserInfoBox(hiveUserId, 0);
                if (!context.mounted) return;
                openScreenWithClearPrevious(context, const LoginScreen());
              }
            },
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languages.enterOTPSendNumber,
                    style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize32px),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    languages.enterOTPVerifyAccount,
                    style: bodyText(context: context, fontSize: textSize14px),
                  ),
                  StreamBuilder<String>(
                    stream: _bloc?.otpDeliveryChannelSubject,
                    builder: (context, channelSnap) {
                      if (channelSnap.data == 'whatsapp') {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsetsDirectional.only(top: 10.h),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsetsDirectional.all(12.w),
                          decoration: BoxDecoration(
                            color: XistiBrand.purple.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: XistiBrand.purple.withValues(alpha: 0.35)),
                          ),
                          child: Text(
                            languages.otpSentViaWhatsappHint,
                            style: bodyText(
                              context: context,
                              fontSize: textSize12px,
                              textColor: XistiBrand.purple,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  StreamBuilder<String>(
                    stream: _bloc?.otpController,
                    builder: (context, snap) {
                      return Container(
                        margin: EdgeInsetsDirectional.only(top: 30.h),
                        child: MaterialPinField(
                          length: 6,
                          obscureText: false,
                          autoDismissKeyboard: true,
                          enableAutofill: true,
                          pinController: _bloc?.pinInputController,
                          keyboardType: TextInputType.number,
                          enablePaste: false,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('^[0-9]*\$'))],
                          theme: MaterialPinTheme(
                            animateCursor: true,
                            showCursor: true,
                            cursorColor: getCurrentTheme(context).colorPrimary,
                            animationDuration: const Duration(milliseconds: 300),
                            completeFillColor: getCurrentTheme(context).colorScaffoldBg,
                            fillColor: getCurrentTheme(context).colorScaffoldBg,
                            focusedFillColor: getCurrentTheme(context).colorScaffoldBg,
                            filledFillColor: getCurrentTheme(context).colorScaffoldBg,
                            shape: MaterialPinShape.outlined,
                            borderRadius: BorderRadius.circular(20.r),
                            errorBorderColor: getCurrentTheme(context).colorRed,
                            disabledColor: getCurrentTheme(context).colorTextFieldBorder,
                            borderColor: getCurrentTheme(context).colorTextFieldBorder,
                            borderWidth: 1.sp,
                            focusedBorderWidth: 1.sp,
                            cellSize: Size(50.sp, 50.sp),
                            focusedBorderColor: getCurrentTheme(context).colorPrimary,
                            textStyle: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w500),
                          ),
                          onChanged: (value) {
                            _bloc?.otpController.add(value);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: CustomRoundedButton(
                      context,
                      languages.resend,
                      () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return OtpBottomSheet(bloc: _bloc!);
                          },
                        );
                      },
                      margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, bottom: getBottomMargin()),
                      setBorder: true,
                    ),
                  ),
                  SizedBox(width: commonHorizontalPadding),
                  Expanded(
                    child: StreamBuilder<ApiResponse<LoginPojo>>(
                      stream: _bloc?.subjectVerify,
                      builder: (context, snapLoading) {
                        var isLoading = snapLoading.hasData && snapLoading.data?.status == Status.loading;
                        return StreamBuilder<String>(
                          stream: _bloc?.otpController,
                          builder: (context, snap) {
                            return CustomRoundedButton(
                              context,
                              languages.continueTxt,
                              ((!(snap.hasData && snap.data!.length == 6) || isLoading)
                                  ? null
                                  : () {
                                      _bloc?.verify();
                                    }),
                              setProgress: isLoading,
                              margin: EdgeInsetsDirectional.only(end: commonHorizontalPadding, bottom: getBottomMargin()),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
