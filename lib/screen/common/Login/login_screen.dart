import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/customCountryCodePicker/custom_country_code_picker.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/custom_text_field.dart';
import '../../../commonView/scaffold_with_safe_area.dart';
import '../../../commonView/socialLogin/social_login.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/api_response.dart';
import '../../../utils/app_mobile_settings.dart';
import '../../../utils/utils.dart';
import '../../../utils/validator.dart';
import 'login_bloc.dart';
import 'login_dl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= LoginBloc(context);
    if (_ensureSocialLoginFlags()) {
      setState(() {});
    }
    super.didChangeDependencies();
  }

  bool _ensureSocialLoginFlags() {
    final noneEnabled =
        getIntFromSettingBox(hiveIsGoogleAllow) == 0 &&
        getIntFromSettingBox(hiveIsFaceBookAllow) == 0 &&
        getIntFromSettingBox(hiveIsAppleAllow) == 0 &&
        getIntFromSettingBox(hiveIsFingerAllow) == 0;
    if (noneEnabled) {
      applySocialLoginSettingsFromApi(const {});
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  Widget _authHero({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.w),
      decoration: XistiAuthTokens.heroBanner(),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              _authHero(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languages.welcomeTo,
                      style: bodyText(
                        context: context,
                        fontWeight: FontWeight.w600,
                        fontSize: textSize32px,
                        textColor: XistiAuthTokens.onGradientText,
                      ),
                    ),
                    Text(
                      languages.appName,
                      style: bodyText(
                        context: context,
                        fontWeight: FontWeight.w600,
                        fontSize: textSize32px,
                        textColor: XistiAuthTokens.onGradientText,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      languages.loginYourAccount,
                      style: bodyText(
                        context: context,
                        fontSize: textSize14px,
                        textColor: XistiAuthTokens.onGradientText.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              StreamBuilder(
                stream: _bloc?.countryCodeController.stream,
                initialData: _bloc?.countryCodeController.valueOrNull,
                builder: (context, countrySnapshot) {
                  final country = countrySnapshot.data;
                  return Form(
                    key: _bloc?.formKey,
                    child: TextFormFieldCustom(
                      setError: true,
                      keyboardType: TextInputType.phone,
                      controller: _bloc?.mobileController,
                      inputFormatters: phoneInputFormatters(
                        dialCode: country?.dialCode,
                        isoCode: country?.code,
                      ),
                      hint: languages.contactNumber,
                      prefix: CustomCountryCodePicker(
                        showDropDownButton: true,
                        flagWidth: 35.w,
                        padding: const EdgeInsets.all(0),
                        onChanged: (countryCode) {
                          _bloc?.countryCodeController.sink.add(countryCode);
                        },
                        onInit: (countryCode) {
                          _bloc?.countryCodeController.sink.add(countryCode!);
                        },
                        initialSelection: defaultCountryCode.dialCode,
                        builder: (countryCode) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 15.w, end: 10.w, top: 10.h, bottom: 10.h),
                                child: Icon(CustomIcons.call, color: XistiBrand.purple, size: 24.sp),
                              ),
                              Text(countryCode?.dialCode ?? "", style: bodyText(context: context, fontWeight: FontWeight.w500)),
                              Padding(padding: EdgeInsetsDirectional.only(start: 5.w), child: Icon(Icons.arrow_drop_down, color: XistiBrand.lavenderMuted, size: 25.sp)),
                            ],
                          );
                        },
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      validator: (value) {
                        _bloc?.buttonHide();
                        return colombiaMobileNumberValidate(
                          value,
                          dialCode: country?.dialCode,
                          isoCode: country?.code,
                        );
                      },
                    ),
                  );
                },
              ),
              StreamBuilder<bool>(
                stream: _bloc?.submitValid,
                builder: (context, snapshot) {
                  bool isEnable = snapshot.data ?? false;
                  return StreamBuilder<ApiResponse<LoginPojo>>(
                    stream: _bloc?.subject,
                    builder: (context, snapLoading) {
                      var isLoading = snapLoading.hasData && snapLoading.data?.status == Status.loading;
                      return CustomRoundedButton(
                        context,
                        languages.sendOTP,
                        (isLoading || !isEnable)
                            ? null
                            : () {
                                _bloc?.manageEmailLogin();
                              },
                        setProgress: isLoading,
                        minWidth: double.maxFinite,
                        margin: EdgeInsetsDirectional.only(top: 30.h),
                      );
                    },
                  );
                },
              ),
              StreamBuilder<ApiResponse<LoginPojo>>(
                stream: _bloc?.subject,
                builder: (context, snapshot) {
                  var isLoading = snapshot.hasData && snapshot.data?.status == Status.loading;
                  bool showSocialLogin =
                      (getIntFromSettingBox(hiveIsFingerAllow) == 1 ||
                          getIntFromSettingBox(hiveIsGoogleAllow) == 1 ||
                          getIntFromSettingBox(hiveIsFaceBookAllow) == 1 ||
                          (getIntFromSettingBox(hiveIsAppleAllow) == 1 && Platform.isIOS));
                  return showSocialLogin
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.only(top: 30.h),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(child: Divider(color: XistiBrand.lavenderMuted, thickness: 1.h, indent: 40.w)),
                                  Flexible(
                                    flex: 0,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w),
                                      child: Text(
                                        languages.orLoginWith,
                                        style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w400),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: XistiBrand.lavenderMuted, thickness: 1.h, endIndent: 40.w)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(top: 35.h),
                              child: SocialLogin(
                                function: ({required email, required id, required loginType, required name}) {
                                  _bloc?.login(loginType, email, name, id);
                                },
                                onBioMetricLoginOrFetchSimNumber: ({required isBioMetricLogin, simContactNumber, simCountryCode, simCode}) {
                                  _bloc?.bioMetricLoginOrFetchSimNumber(
                                    isBioMetricLogin: isBioMetricLogin,
                                    simContactNumber: simContactNumber,
                                    simCountryCode: simCountryCode,
                                    code: simCode,
                                  );
                                },
                                loading: isLoading,
                                showGoogle: getIntFromSettingBox(hiveIsGoogleAllow) == 1,
                                showFacebook: getIntFromSettingBox(hiveIsFaceBookAllow) == 1,
                                showApple: getIntFromSettingBox(hiveIsAppleAllow) == 1,
                                showFingerPrint: getIntFromSettingBox(hiveIsFingerAllow) == 1,
                              ),
                            ),
                          ],
                        )
                      : Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
