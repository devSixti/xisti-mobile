import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/customCountryCodePicker/custom_country_code_picker.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/custom_text_field.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/api_constant.dart';
import '../../../networking/api_response.dart';
import '../../../utils/utils.dart';
import '../../../utils/validator.dart';
import '../Login/login_dl.dart';
import '../Login/login_screen.dart';
import 'sign_up_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  SignUpBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= SignUpBloc(context);
    super.didChangeDependencies();
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

  Widget _userProfileImage() {
    return GestureDetector(
      onTap: () => _bloc?.addProfileImage(),
      child: StreamBuilder<File?>(
        stream: _bloc?.imgFileController,
        builder: (context, snap) {
          return SizedBox(
            width: 100.sp,
            height: 120.sp,
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: snap.data != null
                        ? Image.file(snap.data!, width: 100.sp, height: 100.sp, fit: BoxFit.cover)
                        : LoadImageWithPlaceHolder(
                            width: 100.sp,
                            height: 100.sp,
                            image: "",
                            defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 40.sp,
                    height: 40.sp,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        padding: EdgeInsetsDirectional.all(10.sp),
                        decoration: BoxDecoration(
                          gradient: XistiAuthTokens.optionSelectedGradient,
                          borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        ),
                        child: Icon(CustomIcons.edit, color: XistiAuthTokens.onGradientText, size: 20.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _authCheckbox({
    required Stream<bool>? stream,
    required ValueChanged<bool?> onChanged,
  }) {
    return StreamBuilder<bool>(
      stream: stream,
      builder: (context, snapshot) {
        return Transform.scale(
          scale: 1.2,
          child: Checkbox(
            visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity, horizontal: VisualDensity.minimumDensity),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
            side: BorderSide(color: XistiBrand.lavenderMuted, width: 1.5.sp),
            checkColor: XistiAuthTokens.onGradientText,
            activeColor: XistiAuthTokens.checkboxActive,
            value: snapshot.data ?? false,
            onChanged: onChanged,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        await putDataInUserInfoBox(hiveUserId, 0);
        if (!context.mounted) return;
        openScreenWithClearPrevious(context, const LoginScreen());
      },
      child: ScaffoldWithSafeArea(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsetsDirectional.only(bottom: 100.h),
                  child: Form(
                    key: _bloc?.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        backButtonCustom(
                          context: context,
                          onBackPress: () async {
                            await putDataInUserInfoBox(hiveUserId, 0);
                            if (!context.mounted) return;
                            openScreenWithClearPrevious(context, const LoginScreen());
                          },
                        ),
                        SizedBox(height: 20.h),
                        _authHero(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                languages.startYour,
                                style: bodyText(
                                  context: context,
                                  fontWeight: FontWeight.w600,
                                  fontSize: textSize32px,
                                  textColor: XistiAuthTokens.onGradientText,
                                ),
                              ),
                              Text(
                                languages.journeyWithUs,
                                style: bodyText(
                                  context: context,
                                  fontWeight: FontWeight.w600,
                                  fontSize: textSize32px,
                                  textColor: XistiAuthTokens.onGradientText,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                languages.registerAndStart,
                                style: bodyText(
                                  context: context,
                                  fontSize: textSize14px,
                                  textColor: XistiAuthTokens.onGradientText.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Center(child: _userProfileImage()),
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 8.h),
                          child: Text(
                            'Opcional: una foto mejora tu experiencia en la app.',
                            style: bodyText(context: context, fontSize: textSize12px, fontWeight: FontWeight.w300),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 30.h),
                          child: TextFormFieldCustom(
                            controller: _bloc?.mobileController,
                            keyboardType: TextInputType.phone,
                            hint: (_bloc?.requiresPhone ?? false)
                                ? languages.contactNumber
                                : '${languages.contactNumber} (opcional)',
                            readOnly: !(_bloc?.isPhoneEditable ?? false),
                            setError: _bloc?.isPhoneEditable ?? false,
                            inputFormatters: phoneInputFormatters(
                              dialCode: _bloc?.countryCodeController.valueOrNull?.dialCode,
                              isoCode: _bloc?.countryCodeController.valueOrNull?.code,
                            ),
                            validator: (value) {
                              if (!(_bloc?.isPhoneEditable ?? false)) {
                                return '';
                              }
                              _bloc?.buttonHide();
                              if (!(_bloc?.requiresPhone ?? false) && (value ?? '').trim().isEmpty) {
                                return '';
                              }
                              return colombiaMobileNumberValidate(
                                value,
                                dialCode: _bloc?.countryCodeController.valueOrNull?.dialCode,
                                isoCode: _bloc?.countryCodeController.valueOrNull?.code,
                              );
                            },
                            prefix: (_bloc?.isPhoneEditable ?? false)
                                ? CustomCountryCodePicker(
                                    showDropDownButton: true,
                                    flagWidth: 35.w,
                                    padding: const EdgeInsets.all(0),
                                    onChanged: (countryCode) {
                                      _bloc?.countryCodeController.sink.add(countryCode);
                                      _bloc?.buttonHide();
                                    },
                                    onInit: (countryCode) {
                                      if (countryCode != null) {
                                        _bloc?.countryCodeController.sink.add(countryCode);
                                      }
                                      _bloc?.buttonHide();
                                    },
                                    initialSelection: defaultCountryCode.dialCode,
                                    builder: (countryCode) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsetsDirectional.only(start: 15.w, end: 10.w, top: 10.h, bottom: 10.h),
                                            child: Icon(CustomIcons.call, color: getCurrentTheme(context).colorIconCommon, size: 24.sp),
                                          ),
                                          Text(countryCode?.dialCode ?? "", style: bodyText(context: context, fontWeight: FontWeight.w500)),
                                          Padding(
                                            padding: EdgeInsetsDirectional.only(start: 5.w),
                                            child: Icon(Icons.arrow_drop_down, color: Colors.grey, size: 25.sp),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : null,
                            commonPrefixIcon: (_bloc?.isPhoneEditable ?? false) ? null : CustomIcons.call,
                          ),
                        ),
                        if (!(_bloc?.hideNameField ?? false)) ...[
                          Padding(
                            padding: EdgeInsetsDirectional.only(top: 20.h),
                            child: TextFormFieldCustom(
                              controller: _bloc?.firstNameController,
                              keyboardType: TextInputType.text,
                              hint: 'Nombre',
                              setError: !(_bloc?.nameFieldReadOnly ?? false),
                              readOnly: _bloc?.nameFieldReadOnly ?? false,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
                              ],
                              validator: (value) {
                                _bloc?.buttonHide();
                                if (_bloc?.hideNameField ?? false) {
                                  return '';
                                }
                                return registerFirstNameValidate(value, languages.enterValidFullName);
                              },
                              commonPrefixIcon: CustomIcons.name,
                              suffix: (_bloc?.nameFieldReadOnly ?? false)
                                  ? null
                                  : Container(margin: EdgeInsetsDirectional.only(end: 10.w), child: Icon(CustomIcons.edit)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(top: 20.h),
                            child: TextFormFieldCustom(
                              controller: _bloc?.lastNameController,
                              keyboardType: TextInputType.text,
                              hint: 'Apellido',
                              setError: !(_bloc?.nameFieldReadOnly ?? false),
                              readOnly: _bloc?.nameFieldReadOnly ?? false,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
                              ],
                              validator: (value) {
                                _bloc?.buttonHide();
                                if (_bloc?.hideNameField ?? false) {
                                  return '';
                                }
                                return registerLastNameValidate(value, languages.enterValidFullName);
                              },
                              commonPrefixIcon: CustomIcons.name,
                              suffix: (_bloc?.nameFieldReadOnly ?? false)
                                  ? null
                                  : Container(margin: EdgeInsetsDirectional.only(end: 10.w), child: Icon(CustomIcons.edit)),
                            ),
                          ),
                        ],
                        if (!(_bloc?.hideEmailField ?? false))
                          Padding(
                            padding: EdgeInsetsDirectional.only(top: 20.h),
                            child: TextFormFieldCustom(
                              controller: _bloc?.emailController,
                              keyboardType: TextInputType.emailAddress,
                              hint: (_bloc?.requiresEmail ?? false)
                                  ? languages.email
                                  : '${languages.email} (opcional)',
                              setError: !(_bloc?.emailFieldReadOnly ?? false),
                              readOnly: _bloc?.emailFieldReadOnly ?? false,
                              validator: (value) {
                                _bloc?.buttonHide();
                                if (_bloc?.hideEmailField ?? false) {
                                  return '';
                                }
                                if (_bloc?.requiresEmail ?? false) {
                                  return emailValidate(value);
                                }
                                return emailValidateOptional(value);
                              },
                              commonPrefixIcon: CustomIcons.email,
                              suffix: (_bloc?.emailFieldReadOnly ?? false)
                                  ? null
                                  : Container(margin: EdgeInsetsDirectional.only(end: 10.w), child: Icon(CustomIcons.edit)),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 20.h),
                          child: TextFormFieldCustom(
                            controller: _bloc?.referralCodeController,
                            keyboardType: TextInputType.text,
                            hint: languages.referralCode,
                            commonPrefixIcon: CustomIcons.referralCode,
                            suffix: Container(margin: EdgeInsetsDirectional.only(end: 10.w), child: Icon(CustomIcons.edit)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 20.h),
                          child: TextFormFieldCustom(
                            controller: _bloc?.emergencyContactNameController,
                            keyboardType: TextInputType.text,
                            hint: 'Contacto de emergencia (opcional)',
                            commonPrefixIcon: CustomIcons.name,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 20.h),
                          child: TextFormFieldCustom(
                            controller: _bloc?.emergencyContactController,
                            keyboardType: TextInputType.phone,
                            hint: 'Teléfono de emergencia (opcional)',
                            inputFormatters: phoneInputFormatters(
                              dialCode: _bloc?.emergencyCountryCodeController.valueOrNull?.dialCode,
                              isoCode: _bloc?.emergencyCountryCodeController.valueOrNull?.code,
                            ),
                            prefix: CustomCountryCodePicker(
                              showDropDownButton: true,
                              flagWidth: 35.w,
                              padding: const EdgeInsets.all(0),
                              onChanged: (countryCode) {
                                _bloc?.emergencyCountryCodeController.sink.add(countryCode);
                                _bloc?.buttonHide();
                              },
                              onInit: (countryCode) {
                                if (countryCode != null) {
                                  _bloc?.emergencyCountryCodeController.sink.add(countryCode);
                                }
                              },
                              initialSelection: defaultCountryCode.dialCode,
                              builder: (countryCode) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(start: 15.w, end: 10.w, top: 10.h, bottom: 10.h),
                                      child: Icon(CustomIcons.call, color: getCurrentTheme(context).colorIconCommon, size: 24.sp),
                                    ),
                                    Text(countryCode?.dialCode ?? '', style: bodyText(context: context, fontWeight: FontWeight.w500)),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 12.h),
                          child: Text(
                            'Opcional: completar foto, correo/celular alternativo, código de referido o contacto de emergencia mejora tu experiencia en la app.',
                            style: bodyText(context: context, fontSize: textSize12px, fontWeight: FontWeight.w300),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 20.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _authCheckbox(
                                stream: _bloc?.acceptTermsController,
                                onChanged: (value) {
                                  _bloc?.acceptTermsController.add(value ?? false);
                                  _bloc?.buttonHide();
                                },
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: languages.byRegisterYouAgree,
                                    style: bodyText(context: context, fontWeight: FontWeight.w300, fontSize: textSize14px),
                                    children: [
                                      TextSpan(
                                        text: ' ${languages.termsCondition}',
                                        style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize14px).copyWith(decoration: TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            openUrl(legalCmsUrl(ApiConst.endPointTermsAndConditions), launchMode: LaunchMode.externalApplication);
                                          },
                                      ),
                                      TextSpan(
                                        text: ' ${languages.privacyPolicy}',
                                        style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize14px).copyWith(decoration: TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            openUrl(legalCmsUrl(ApiConst.endPointPrivacyPolicy), launchMode: LaunchMode.externalApplication);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _authCheckbox(
                                stream: _bloc?.acceptDataProcessingController,
                                onChanged: (value) {
                                  _bloc?.acceptDataProcessingController.add(value ?? false);
                                  _bloc?.buttonHide();
                                },
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: languages.dataProcessingAuthorizationPrefix,
                                    style: bodyText(context: context, fontWeight: FontWeight.w300, fontSize: textSize14px),
                                    children: [
                                      TextSpan(
                                        text: ' ${languages.dataProcessingPolicy}',
                                        style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize14px).copyWith(decoration: TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            openUrl(legalCmsUrl(ApiConst.endPointPrivacyPolicy), launchMode: LaunchMode.externalApplication);
                                          },
                                      ),
                                      const TextSpan(text: '.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _authCheckbox(
                                stream: _bloc?.acceptPlatformController,
                                onChanged: (value) {
                                  _bloc?.acceptPlatformController.add(value ?? false);
                                  _bloc?.buttonHide();
                                },
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  languages.platformConnectionNotice,
                                  style: bodyText(context: context, fontWeight: FontWeight.w300, fontSize: textSize14px),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: StreamBuilder<bool>(
                    stream: _bloc?.submitValid,
                    builder: (context, snapshot) {
                      bool isEnable = snapshot.data ?? false;
                      return StreamBuilder<ApiResponse<LoginPojo>>(
                        stream: _bloc?.subject,
                        builder: (context, snapLoading) {
                          var isLoading = snapLoading.hasData && snapLoading.data?.status == Status.loading;
                          return CustomRoundedButton(
                            context,
                            languages.continueTxt,
                            (isLoading || !isEnable)
                                ? null
                                : () {
                                    debugPrint("submit click");
                                    _bloc?.submit();
                                  },
                            margin: EdgeInsetsDirectional.only(top: 30.h, bottom: getBottomMargin()),
                            setProgress: isLoading,
                            minWidth: double.infinity,
                          );
                        },
                      );
                    },
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
