import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/custom_progress_button.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/scaffold_with_safe_area.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/api_response.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import '../Login/login_screen.dart';
import 'otp_verify_bloc.dart';

class OtpBottomSheet extends StatefulWidget {
  final OtpVerifyBloc bloc;

  const OtpBottomSheet({super.key, required this.bloc});

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  static const int _cooldownSeconds = 60;

  @override
  void initState() {
    super.initState();
    final elapsed = DateTime.now().difference(widget.bloc.timer).inSeconds;
    if (elapsed >= _cooldownSeconds && (widget.bloc.resendOTPController.valueOrNull ?? false)) {
      widget.bloc.resendOTPController.add(false);
    }
  }

  int _secondsRemaining() {
    final elapsed = DateTime.now().difference(widget.bloc.timer).inSeconds;
    final left = _cooldownSeconds - elapsed;
    return left.clamp(0, _cooldownSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: getCurrentTheme(context).colorWhite,
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(30.r),
              topStart: Radius.circular(30.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: commonHorizontalPadding,
              end: commonHorizontalPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 25.h, bottom: 20.h),
                        child: Text(
                          languages.haveNotCode,
                          textAlign: TextAlign.start,
                          style: bodyText(
                            context: context,
                            fontSize: textSize24px,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        CustomIcons.cancel,
                        size: 25.sp,
                        color: getCurrentTheme(context).colorIconCommon,
                      ),
                    ),
                  ],
                ),
                Text(
                  languages.ifNotGetCode,
                  textAlign: TextAlign.start,
                  style: bodyText(context: context, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(top: 30.h, bottom: 20.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomRoundedButton(
                          context,
                          languages.changeNumber,
                          () {
                            putDataInSettingBox(hiveUserId, 0);
                            openScreenWithClearPrevious(context, LoginScreen());
                          },
                          setBorder: true,
                          maxLine: 2,
                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 5.h),
                        ),
                      ),
                      SizedBox(width: commonHorizontalPadding),
                      Expanded(
                        child: StreamBuilder<bool>(
                          stream: widget.bloc.resendOTPController,
                          builder: (context, snapResendOTP) {
                            final cooldownActive = snapResendOTP.data ?? false;
                            final secondsLeft = _secondsRemaining();

                            return StreamBuilder<ApiResponse<BaseModel>>(
                              stream: widget.bloc.subjectResend,
                              builder: (context, snapLoading) {
                                final isLoading =
                                    snapLoading.hasData && snapLoading.data?.status == Status.loading;

                                if (cooldownActive && secondsLeft > 0) {
                                  return CustomProgressButton(
                                    margin: EdgeInsetsDirectional.zero,
                                    onTap: null,
                                    setProgress: isLoading,
                                    totalSeconds: _cooldownSeconds,
                                    leftSeconds: secondsLeft,
                                    onTimeExpired: () {
                                      widget.bloc.resendOTPController.add(false);
                                    },
                                    text: languages.retry,
                                  );
                                }

                                return CustomRoundedButton(
                                  context,
                                  languages.retry,
                                  isLoading
                                      ? null
                                      : () {
                                          widget.bloc.resendOtp(context);
                                        },
                                  setBorder: true,
                                  setProgress: isLoading,
                                  margin: EdgeInsetsDirectional.zero,
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
        ),
      ),
    );
  }
}
