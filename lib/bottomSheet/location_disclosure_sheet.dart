import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../hive/hive_helper.dart';
import '../networking/api_constant.dart';
import '../utils/utils.dart';

class LocationDisclosureSheet extends StatefulWidget {
  final VoidCallback onAgree;

  const LocationDisclosureSheet({super.key, required this.onAgree});

  @override
  State<LocationDisclosureSheet> createState() => _LocationDisclosureSheetState();
}

class _LocationDisclosureSheetState extends State<LocationDisclosureSheet> {
  bool _acceptTerms = false;
  bool _acceptPlatform = false;
  bool _marketingOptIn = false;

  bool get _canContinue => _acceptTerms && _acceptPlatform;

  Widget _checkboxRow({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required Widget label,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.2,
          child: Checkbox(
            visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity, horizontal: VisualDensity.minimumDensity),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
            side: BorderSide(color: getCurrentTheme(context).colorTextFieldBorder, width: 1.5.sp),
            checkColor: getCurrentTheme(context).colorWhite,
            activeColor: getCurrentTheme(context).colorPrimary,
            value: value,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(child: label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ScaffoldWithSafeArea(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.88),
            decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
            padding: bottomSheetPadding,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    languages.locationMessageTitle,
                    style: bodyText(context: context, fontSize: textSize24px, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    languages.locationMessage,
                    style: bodyText(context: context, textColor: getCurrentTheme(context).colorTextCommon),
                  ),
                  SizedBox(height: 20.h),
                  _checkboxRow(
                    value: _acceptTerms,
                    onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                    label: RichText(
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
                  SizedBox(height: 12.h),
                  _checkboxRow(
                    value: _acceptPlatform,
                    onChanged: (value) => setState(() => _acceptPlatform = value ?? false),
                    label: Text(
                      languages.platformConnectionNotice,
                      style: bodyText(context: context, fontWeight: FontWeight.w300, fontSize: textSize14px),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _checkboxRow(
                    value: _marketingOptIn,
                    onChanged: (value) => setState(() => _marketingOptIn = value ?? false),
                    label: Text(
                      languages.marketingOptIn,
                      style: bodyText(context: context, fontWeight: FontWeight.w300, fontSize: textSize14px),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CustomRoundedButton(
                    context,
                    languages.agreeAndContinue,
                    _canContinue
                        ? () async {
                            putDataInSettingBox(hiveDisclosureDialogOpen, true);
                            putDataInSettingBox(hiveAuditConsentVersion, currentAuditConsentVersion);
                            putDataInSettingBox(hiveMarketingOptIn, _marketingOptIn);
                            widget.onAgree();
                          }
                        : null,
                    minWidth: double.maxFinite,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
