import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../config/google_sign_in_config.dart';
import '../../hive/hive_constant.dart';
import '../../hive/hive_helper.dart';
import '../../utils/utils.dart';
import 'social_login_bloc.dart';

class SocialLogin extends StatefulWidget {
  final Function({required String loginType, required String name, required String email, required String id}) function;

  final Function({required bool isBioMetricLogin, String? simContactNumber, String? simCountryCode, String? simCode}) onBioMetricLoginOrFetchSimNumber;

  final Function({required String error})? errorFunction;
  final bool loading;
  final bool showFingerPrint;
  final bool showGoogle;
  final bool showFacebook;
  final bool showApple;

  const SocialLogin({
    super.key,
    required this.function,
    required this.onBioMetricLoginOrFetchSimNumber,
    this.errorFunction,
    this.loading = false,
    this.showGoogle = true,
    this.showFingerPrint = true,
    this.showFacebook = true,
    this.showApple = true,
  });

  @override
  State<SocialLogin> createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  SocialLoginBloc? _bloc;
  bool _googleSignInInitialized = false;

  @override
  void didChangeDependencies() {
    _bloc ??= SocialLoginBloc(context, widget.onBioMetricLoginOrFetchSimNumber);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.showFingerPrint)
          Flexible(
            flex: 1,
            child: socialLoginButton(
              "assets/images/finger_print_img.png",
              imageColor: getCurrentTheme(context).colorIconCommon,
              onPressed: () {
                _bloc?.biometricLogin();
              },
            ),
          ),
        if (widget.showGoogle)
          Flexible(
            flex: 1,
            child: socialLoginButton(
              "assets/images/google_img.png",
              onPressed: () async {
                if (await isNetworkConnected(onRetryPressedCallApi: _signInWithGoogle)) {
                  await _signInWithGoogle();
                }
              },
            ),
          ),
        if (widget.showFacebook)
          Flexible(
            flex: 1,
            child: socialLoginButton(
              "assets/images/facebook_img.png",
              onPressed: () async {
                if (await isNetworkConnected(onRetryPressedCallApi: _signInWithFacebook)) {
                  await _signInWithFacebook();
                }
              },
            ),
          ),
        if (Platform.isIOS && widget.showApple)
          Flexible(
            flex: 1,
            child: socialLoginButton(
              "assets/images/apple_img.png",
              imageColor: getCurrentTheme(context).colorIconCommon,
              onPressed: () async {
                if (await isNetworkConnected(onRetryPressedCallApi: _signInWithApple)) {
                  await _signInWithApple();
                }
              },
            ),
          ),
      ],
    );
  }

  Widget socialLoginButton(String assetImage, {Function()? onPressed, Color? imageColor}) {
    return GestureDetector(
      onTap: widget.loading
          ? null
          : () {
              if (onPressed != null) {
                onPressed();
              }
            },
      child: Container(
        width: 50.w,
        height: 50.h,
        margin: EdgeInsetsDirectional.only(start: 7.5.w, end: 7.5.w),
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: getCurrentTheme(context).colorTextFieldBorder, width: 1.sp),
        ),
        padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.h, bottom: 10.h),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(assetImage, color: imageColor, colorBlendMode: BlendMode.srcIn, fit: BoxFit.contain, height: 24.h, width: 24.w),
      ),
    );
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) {
      return;
    }
    final GoogleSignIn signIn = GoogleSignIn.instance;
    await signIn.initialize(
      clientId: Platform.isIOS ? kGoogleIosClientId : null,
      serverClientId: kGoogleWebClientId,
    );
    _googleSignInInitialized = true;
  }

  void _reportSocialError(String message) {
    debugPrint('SocialLogin: $message');
    widget.errorFunction?.call(error: message);
    if (!mounted) {
      return;
    }
    showApiMessage(context, true, message, 0, const []);
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      final GoogleSignIn signIn = GoogleSignIn.instance;
      if (!signIn.supportsAuthenticate()) {
        _reportSocialError(languages.googleSignInUnavailable);
        return;
      }
      final GoogleSignInAccount googleSignInAccount = await signIn.authenticate(scopeHint: ['email']);
      final id = googleSignInAccount.id;
      final email = googleSignInAccount.email;
      final name = googleSignInAccount.displayName ?? '-';

      widget.function.call(loginType: LoginType.google, name: name, email: email, id: id);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return;
      }
      _reportSocialError(e.description ?? e.code.name);
    } catch (error) {
      _reportSocialError(error.toString());
    }
  }

  Future<void> _signInWithFacebook() async {
    FacebookAuth facebookAuth = FacebookAuth.instance;
    final result = await facebookAuth.login(permissions: ['email']);

    switch (result.status) {
      case LoginStatus.success:
        final token = result.accessToken?.tokenString ?? '-';
        final graphResponse = await get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
        var body = jsonDecode(graphResponse.body);
        if (body != null) {
          var name = body['name'] ?? '';
          var email = body['email'] ?? '';
          var id = body['id'] ?? '';

          widget.function.call(loginType: LoginType.facebook, name: name, email: email, id: id);
        }
        facebookAuth.logOut();
        break;
      case LoginStatus.cancelled:
        widget.errorFunction?.call(error: 'Facebook login cancelled by the user. ${result.message}');
        debugPrint('Facebook login cancelled by the user.');
        break;
      case LoginStatus.failed:
        widget.errorFunction?.call(error: 'Facebook login Failed ${result.message}');
        debugPrint('Failed');
        break;
      case LoginStatus.operationInProgress:
        widget.errorFunction?.call(error: 'Facebook login in Progress ${result.message}');
        debugPrint('In Progress');
        break;
    }
  }

  Future<void> _signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);
      final id = credential.userIdentifier ?? '';
      var email = credential.email ?? '';

      String givenName = credential.givenName ?? '';
      String familyName = credential.familyName ?? '';
      var fullName = '$givenName $familyName'.trim();

      final cachedAppleId = getStringFromUserInfoBox(hiveAppleUserIdentifier);
      if (id.isNotEmpty && cachedAppleId == id) {
        if (!isValidSocialProvidedName(fullName)) {
          fullName = getStringFromUserInfoBox(hiveAppleCachedFullName);
        }
        if (email.isEmpty) {
          email = getStringFromUserInfoBox(hiveAppleCachedEmail);
        }
      }

      if (id.isNotEmpty) {
        putDataInUserInfoBox(hiveAppleUserIdentifier, id);
      }
      if (isValidSocialProvidedName(fullName)) {
        putDataInUserInfoBox(hiveAppleCachedFullName, fullName.trim());
      }
      if (email.trim().isNotEmpty) {
        putDataInUserInfoBox(hiveAppleCachedEmail, email.trim());
      }

      widget.function.call(loginType: LoginType.apple, name: fullName, email: email, id: id);
    } catch (error) {
      _reportSocialError(error.toString());
    }
  }
}
