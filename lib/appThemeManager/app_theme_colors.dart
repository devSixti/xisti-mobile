import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../hive/hive_helper.dart';

/// 1: light, 2: dark.
ValueNotifier<int> themeModeChangeListener = ValueNotifier(1);

AppThemeColors getCurrentTheme(BuildContext context) {
  /// "Extension" here refers to extending an existing theme by integrating with the
  /// predefined theme system (similar to connecting an extension to a switchboard),
  /// rather than creating and applying custom theme colors independently.
  /// In this case, it means using our defined theme colors instead of the default theme.

  return Theme.of(context).extension<AppThemeColors>() ?? AppThemeColors.light();
}

void checkAndChangeThemeMode() {
  if (getIntFromSettingBox(hiveAppTheme) == 0) {
    // XISTI brand default: dark urban theme on first launch.
    themeModeChangeListener.value = 2;
  } else if (getIntFromSettingBox(hiveAppTheme) == 1 || getIntFromSettingBox(hiveAppTheme) == 2) {
    themeModeChangeListener.value = getIntFromSettingBox(hiveAppTheme);
  }
}

ThemeMode getSelectedThemeMode() {
  switch (getIntFromSettingBox(hiveAppTheme)) {
    case 1:
      return ThemeMode.light;
    case 2:
      return ThemeMode.dark;
    default:
      return ThemeMode.dark;
  }
}

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  Color colorStaticBlack = Color(0xFF1B1B1B);
  Color colorStaticWhite = Color(0xFFFFFFFF);
  Color colorStaticOfferRideText = Color(0xFFFFFFFF);
  Color colorStaticIndicator = Color(0xFFECECEC);
  Color colorStaticIconBlack = Color(0xFF1B1B1B);
  Color colorStaticText = Color(0xFF1B1B1B);
  Color colorStaticProgressBar = Color(0xFF1B1B1B);
  Color colorStaticGreyText = Color(0xFF9E9E9E);

  SystemUiOverlayStyle? _systemUiOverlayStyle;
  String? _mapStyle;
  Color? _colorWhite;
  Color? _colorAppBarDefault;
  Color? _colorPreferencesChoiceChipBg;
  Color? _colorPrimary;
  Color? _colorWalletBgGradient1;
  Color? _colorWalletBgGradient2;
  Color? _colorBlack;
  Color? _colorScaffoldBg;
  Color? _colorTextCommon;
  Color? _colorShimmerBg;
  Color? _colorTextFieldBg;
  Color? _colorTextLight;
  Color? _colorIconCommon;
  Color? _colorDeleteIcon;
  Color? _colorIconLight;
  Color? _colorBtnGradient1;
  Color? _colorBtnGradient2;
  Color? _colorIndicatorOff;
  Color? _colorOtherChatBg;
  Color? _colorTextFieldBorder;
  Color? _colorLoginLine;
  Color? _colorRed;
  Color? _colorSelectionPrimaryOpc;
  Color? _colorBorder;
  Color? _colorDarkBorder;
  Color? _colorDriverStatusContainerBg;
  Color? _colorOfflineContainerRed;
  Color? _colorOnlineContainerGreen;
  Color? _colorActiveOfflineText;
  Color? _colorActiveOnlineText;
  Color? _colorInActiveOnlineText;
  Color? _colorContainerBorder;
  Color? _colorDivider;
  Color? _colorManageAddressDivider;
  Color? _colorTimeAgo;
  Color? _colorRating;
  Color? _colorHailIcon;
  Color? _colorRippleAnimation;
  Color? _colorRippleAnimationBg;
  Color? _colorProgressBtnBg;
  Color? _colorAvailableDriverBg;
  Color? _colorAvailableDriverBorder1;
  Color? _colorAvailableDriverBorder2;
  Color? _colorAvailableDriverCardBg;
  Color? _colorPsRunningIcon;
  Color? _colorPsRunningIconBg;
  Color? _colorPsCompletedIconBg;
  Color? _colorSosBg;
  Color? _colorDisableRating;
  Color? _colorStatusOnGoing;
  Color? _colorReferralPending;
  Color? _colorStatusCancel;
  Color? _colorReferralRejected;
  Color? _colorStatusCompleted;
  Color? _colorReferralClaimed;
  Color? _colorCountryCodePickerSelectionDialogBG;
  Color? _colorKmAndTimeText;
  Color? _colorSuggestionAmountAndIcon;
  Color? _colorOfferEditIcon;
  Color? _colorBackGroundWaiting;
  Color? _colorCreditIcon;
  Color? _colorDebitIcon;
  Color? _colorIssueResolved;
  Color? _colorIssueUnResolved;
  Color? _colorGreen;
  Color? _colorSplashGradient1;
  Color? _colorSplashGradient2;

  /// Theme Mode for monitoring and change theme
  /// 0 : system
  /// 1 : light
  /// 2 : dark
  int themeMode = 1;

  AppThemeColors({
    this.themeMode = 1,
    SystemUiOverlayStyle? systemUiOverlayStyle,
    String? mapStyle,
    Color? colorWhite,
    Color? colorAppBarDefault,
    Color? colorPreferencesChoiceChipBg,
    Color? colorPrimary,
    Color? colorWalletBgGradient1,
    Color? colorWalletBgGradient2,
    Color? colorDarkIconCommon,
    Color? colorBlack,
    Color? colorScaffoldBg,
    Color? colorTextCommon,
    Color? colorShimmerBg,
    Color? colorTextFieldBg,
    Color? colorTextLight,
    Color? colorIconCommon,
    Color? colorDeleteIcon,
    Color? colorIconLight,
    Color? colorBtnGradient1,
    Color? colorBtnGradient2,
    Color? colorIndicatorOff,
    Color? colorOtherChatBg,
    Color? colorTextFieldBorder,
    Color? colorLoginLine,
    Color? colorRed,
    Color? colorSelectionPrimaryOpc,
    Color? colorBorder,
    Color? colorDarkBorder,
    Color? colorDriverStatusContainerBg,
    Color? colorOfflineContainerRed,
    Color? colorOnlineContainerGreen,
    Color? colorActiveOfflineText,
    Color? colorActiveOnlineText,
    Color? colorInActiveOnlineText,
    Color? colorContainerBorder,
    Color? colorDivider,
    Color? colorManageAddressDivider,
    Color? colorTimeAgo,
    Color? colorRating,
    Color? colorHailIcon,
    Color? colorRippleAnimation,
    Color? colorRippleAnimationBg,
    Color? colorProgressBtnBg,
    Color? colorAvailableDriverBg,
    Color? colorAvailableDriverBorder1,
    Color? colorAvailableDriverBorder2,
    Color? colorAvailableDriverCardBg,
    Color? colorPsRunningIcon,
    Color? colorPsRunningIconBg,
    Color? colorPsCompletedIconBg,
    Color? colorSosBg,
    Color? colorDisableRating,
    Color? colorStatusOnGoing,
    Color? colorReferralPending,
    Color? colorStatusCancel,
    Color? colorReferralRejected,
    Color? colorStatusCompleted,
    Color? colorReferralClaimed,
    Color? colorCountryCodePickerSelectionDialogBG,
    Color? colorKmAndTimeText,
    Color? colorSuggestionAmountAndIcon,
    Color? colorOfferEditIcon,
    Color? colorCreditIcon,
    Color? colorDebitIcon,
    Color? colorIssueResolved,
    Color? colorIssueUnResolved,
    Color? colorBackGroundWaiting,
    Color? colorGreen,
    Color? colorSplashGradient1,
    Color? colorSplashGradient2,
  }) {
    _systemUiOverlayStyle = systemUiOverlayStyle;
    _mapStyle = mapStyle;
    _colorWhite = colorWhite;
    _colorAppBarDefault = colorAppBarDefault;
    _colorPreferencesChoiceChipBg = colorPreferencesChoiceChipBg;
    _colorPrimary = colorPrimary;
    _colorWalletBgGradient1 = colorWalletBgGradient1;
    _colorWalletBgGradient2 = colorWalletBgGradient2;
    _colorBlack = colorBlack;
    _colorScaffoldBg = colorScaffoldBg;
    _colorTextCommon = colorTextCommon;
    _colorShimmerBg = colorShimmerBg;
    _colorTextFieldBg = colorTextFieldBg;
    _colorTextLight = colorTextLight;
    _colorIconCommon = colorIconCommon;
    _colorDeleteIcon = colorDeleteIcon;
    _colorIconLight = colorIconLight;
    _colorBtnGradient1 = colorBtnGradient1;
    _colorBtnGradient2 = colorBtnGradient2;
    _colorIndicatorOff = colorIndicatorOff;
    _colorOtherChatBg = colorOtherChatBg;
    _colorTextFieldBorder = colorTextFieldBorder;
    _colorLoginLine = colorLoginLine;
    _colorRed = colorRed;
    _colorSelectionPrimaryOpc = colorSelectionPrimaryOpc;
    _colorBorder = colorBorder;
    _colorDarkBorder = colorDarkBorder;
    _colorRippleAnimation = colorRippleAnimation;
    _colorRippleAnimationBg = colorRippleAnimationBg;
    _colorDriverStatusContainerBg = colorDriverStatusContainerBg;
    _colorOfflineContainerRed = colorOfflineContainerRed;
    _colorOnlineContainerGreen = colorOnlineContainerGreen;
    _colorActiveOfflineText = colorActiveOfflineText;
    _colorActiveOnlineText = colorActiveOnlineText;
    _colorInActiveOnlineText = colorInActiveOnlineText;
    _colorContainerBorder = colorContainerBorder;
    _colorDivider = colorDivider;
    _colorManageAddressDivider = colorManageAddressDivider;
    _colorTimeAgo = colorTimeAgo;
    _colorRating = colorRating;
    _colorHailIcon = colorHailIcon;
    _colorProgressBtnBg = colorProgressBtnBg;
    _colorAvailableDriverBg = colorAvailableDriverBg;
    _colorAvailableDriverBorder1 = colorAvailableDriverBorder1;
    _colorAvailableDriverBorder2 = colorAvailableDriverBorder2;
    _colorAvailableDriverCardBg = colorAvailableDriverCardBg;
    _colorPsRunningIcon = colorPsRunningIcon;
    _colorPsRunningIconBg = colorPsRunningIconBg;
    _colorPsCompletedIconBg = colorPsCompletedIconBg;
    _colorSosBg = colorSosBg;
    _colorDisableRating = colorDisableRating;
    _colorStatusOnGoing = colorStatusOnGoing;
    _colorReferralPending = colorReferralPending;
    _colorStatusCancel = colorStatusCancel;
    _colorReferralRejected = colorReferralRejected;
    _colorStatusCompleted = colorStatusCompleted;
    _colorReferralClaimed = colorReferralClaimed;
    _colorCountryCodePickerSelectionDialogBG = colorCountryCodePickerSelectionDialogBG;
    _colorKmAndTimeText = colorKmAndTimeText;
    _colorSuggestionAmountAndIcon = colorSuggestionAmountAndIcon;
    _colorOfferEditIcon = colorOfferEditIcon;
    _colorCreditIcon = colorCreditIcon;
    _colorDebitIcon = colorDebitIcon;
    _colorIssueResolved = colorIssueResolved;
    _colorIssueUnResolved = colorIssueUnResolved;
    _colorBackGroundWaiting = colorBackGroundWaiting;
    _colorGreen = colorGreen;
    _colorSplashGradient1 = colorSplashGradient1;
    _colorSplashGradient2 = colorSplashGradient2;
  }

  AppThemeColors.light({
    this.themeMode = 1,
    Color? colorCommonShadow = const Color(0x33000000),
    String mapStyle = 'assets/mapStyle/map_style.json',
    Color colorWhite = const Color(0xFFFFFFFF),
    Color colorAppBarDefault = const Color(0xFFFFFFFF),
    Color colorPreferencesChoiceChipBg = const Color(0xFFF3F4F6),
    Color colorPrimary = const Color(0xFF39FF14),
    Color colorWalletBgGradient1 = const Color(0xFF39FF14),
    Color colorWalletBgGradient2 = const Color(0xFF9333EA),
    Color? colorSelectionPrimaryOpc = const Color(0x3339FF14),
    Color? colorDarkIconCommon = const Color(0xFF323332),
    Color? colorBlack = const Color(0xFF000000),
    Color? colorScaffoldBg = const Color(0xFFFFFFFF),
    Color? colorTextCommon = const Color(0xFF1B1B1B),
    Color? colorShimmerBg = const Color(0xFFe5ecf1),
    Color? colorTextFieldBg = const Color(0xFFFFFFFF),
    Color? colorTextLight = const Color(0xFF949494),
    Color? colorIconCommon = const Color(0xFF1B1B1B),
    Color? colorDeleteIcon = const Color(0xFF1D1D1D),
    Color? colorIconLight = const Color(0xFF9E9E9E),
    Color? colorBtnGradient1 = const Color(0xFF39FF14),
    Color? colorBtnGradient2 = const Color(0xFF22C55E),
    Color? colorIndicatorOff = const Color(0xFFECECEC),
    Color? colorOtherChatBg = const Color(0xFFECECEC),
    Color? colorTextFieldBorder = const Color(0xFF9E9E9E),
    Color? colorLoginLine = const Color(0xFFD9D9D9),
    Color? colorRed = const Color(0xFFF04438),
    Color? colorBorder = const Color(0xFF9e9e9e),
    Color? colorDarkBorder = const Color(0xFF1B1B1B),
    Color? colorRippleAnimation = const Color(0xFFFFFFFF),
    Color? colorRippleAnimationBg = const Color(0xB31B1B1B),
    Color? colorDriverStatusContainerBg = const Color(0xffECECEC),
    Color? colorOfflineContainerRed = const Color(0xFFDE1135),
    Color? colorOnlineContainerGreen = const Color(0xFF2AC11C),
    Color? colorActiveOfflineText = const Color(0xFF9E9E9E),
    Color? colorActiveOnlineText = const Color(0xffFFFFFF),
    Color? colorInActiveOnlineText = const Color(0xFF1B1B1B),
    Color? colorContainerBorder = const Color(0xFF1B1B1B),
    Color? colorDivider = const Color(0xFF9E9E9E),
    Color? colorManageAddressDivider = const Color(0xFFECECEC),
    Color? colorTimeAgo = const Color(0xFF9E9E9E),
    Color? colorRating = const Color(0xFFFFB500),
    Color? colorHailIcon = const Color(0xFFFFFFFF),
    Color? colorProgressBtnBg = const Color(0xFFECECEC),
    Color? colorAvailableDriverBg = const Color(0xE61B1B1B),
    Color? colorAvailableDriverBorder1 = const Color(0x80FFFFFF),
    Color? colorAvailableDriverBorder2 = const Color(0x33FFFFFF),
    Color? colorAvailableDriverCardBg = const Color(0x33FFFFFF),
    Color? colorPsRunningIcon = const Color(0xFFFFFFFF),
    Color? colorPsRunningIconBg = const Color(0xFF39FF14),
    Color? colorPsCompletedIconBg = const Color(0xFF2AC11C),
    Color? colorSosBg = const Color(0xFFDE1135),
    Color? colorDisableRating = const Color(0xFFECECEC),
    Color? colorStatusOnGoing = const Color(0xFF9333EA),
    Color? colorReferralPending = const Color(0xFF9333EA),
    Color? colorStatusCancel = const Color(0xFFDE1135),
    Color? colorReferralRejected = const Color(0xFFDE1135),
    Color? colorStatusCompleted = const Color(0xFF2AC11C),
    Color? colorReferralClaimed = const Color(0xFF2AC11C),
    Color? colorCountryCodePickerSelectionDialogBG = const Color(0xFFF8F8F8),
    Color? colorKmAndTimeText = const Color(0xFF9E9E9E),
    Color? colorSuggestionAmountAndIcon = const Color(0xFFFFFFFF),
    Color? colorOfferEditIcon = const Color(0xFF1D1D1D),
    Color? colorBackGroundWaiting = const Color(0xFF1b1b1b),
    Color? colorCreditIcon = const Color(0xFF2AC11C),
    Color? colorDebitIcon = const Color(0xFFDE1135),
    Color? colorIssueResolved = const Color(0xFF2AC11C),
    Color? colorIssueUnResolved = const Color(0xFFDE1135),
    Color? colorGreen = const Color(0xFF4BB543),
    Color? colorSplashGradient1 = const Color(0xFF9DDE00),
    Color? colorSplashGradient2 = const Color(0xFF7CA901),
  }) {
    _systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: colorWhite,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
    _mapStyle = mapStyle;
    _colorWhite = colorWhite;
    _colorAppBarDefault = colorAppBarDefault;
    _colorPreferencesChoiceChipBg = colorPreferencesChoiceChipBg;
    _colorPrimary = colorPrimary;
    _colorWalletBgGradient1 = colorWalletBgGradient1;
    _colorWalletBgGradient2 = colorWalletBgGradient2;
    _colorBlack = colorBlack;
    _colorScaffoldBg = colorScaffoldBg;
    _colorTextCommon = colorTextCommon;
    _colorShimmerBg = colorShimmerBg;
    _colorTextFieldBg = colorTextFieldBg;
    _colorTextLight = colorTextLight;
    _colorIconCommon = colorIconCommon;
    _colorDeleteIcon = colorDeleteIcon;
    _colorIconLight = colorIconLight;
    _colorBtnGradient1 = colorBtnGradient1;
    _colorBtnGradient2 = colorBtnGradient2;
    _colorIndicatorOff = colorIndicatorOff;
    _colorOtherChatBg = colorOtherChatBg;
    _colorTextFieldBorder = colorTextFieldBorder;
    _colorLoginLine = colorLoginLine;
    _colorRed = colorRed;
    _colorSelectionPrimaryOpc = colorSelectionPrimaryOpc;
    _colorBorder = colorBorder;
    _colorDarkBorder = colorDarkBorder;
    _colorRippleAnimation = colorRippleAnimation;
    _colorRippleAnimationBg = colorRippleAnimationBg;
    _colorDriverStatusContainerBg = colorDriverStatusContainerBg;
    _colorOfflineContainerRed = colorOfflineContainerRed;
    _colorOnlineContainerGreen = colorOnlineContainerGreen;
    _colorActiveOfflineText = colorActiveOfflineText;
    _colorActiveOnlineText = colorActiveOnlineText;
    _colorInActiveOnlineText = colorInActiveOnlineText;
    _colorContainerBorder = colorContainerBorder;
    _colorDivider = colorDivider;
    _colorManageAddressDivider = colorManageAddressDivider;
    _colorTimeAgo = colorTimeAgo;
    _colorRating = colorRating;
    _colorHailIcon = colorHailIcon;
    _colorProgressBtnBg = colorProgressBtnBg;
    _colorAvailableDriverBg = colorAvailableDriverBg;
    _colorAvailableDriverBorder1 = colorAvailableDriverBorder1;
    _colorAvailableDriverBorder2 = colorAvailableDriverBorder2;
    _colorAvailableDriverCardBg = colorAvailableDriverCardBg;
    _colorPsRunningIcon = colorPsRunningIcon;
    _colorPsRunningIconBg = colorPsRunningIconBg;
    _colorPsCompletedIconBg = colorPsCompletedIconBg;
    _colorSosBg = colorSosBg;
    _colorDisableRating = colorDisableRating;
    _colorStatusOnGoing = colorStatusOnGoing;
    _colorReferralPending = colorReferralPending;
    _colorStatusCancel = colorStatusCancel;
    _colorReferralRejected = colorReferralRejected;
    _colorStatusCompleted = colorStatusCompleted;
    _colorReferralClaimed = colorReferralClaimed;
    _colorCountryCodePickerSelectionDialogBG = colorCountryCodePickerSelectionDialogBG;
    _colorKmAndTimeText = colorKmAndTimeText;
    _colorSuggestionAmountAndIcon = colorSuggestionAmountAndIcon;
    _colorOfferEditIcon = colorOfferEditIcon;
    _colorCreditIcon = colorCreditIcon;
    _colorDebitIcon = colorDebitIcon;
    _colorIssueResolved = colorIssueResolved;
    _colorIssueUnResolved = colorIssueUnResolved;
    _colorBackGroundWaiting = colorBackGroundWaiting;
    _colorGreen = colorGreen;
    _colorSplashGradient1 = colorSplashGradient1;
    _colorSplashGradient2 = colorSplashGradient2;
  }

  AppThemeColors.dark({
    this.themeMode = 2,
    String? mapStyle = "assets/mapStyle/map_style_dark.json",
    Color? colorWhite = const Color(0xFF0B0B0B),
    Color? colorAppBarDefault = const Color(0xFF0B0B0B),
    Color? colorPreferencesChoiceChipBg = const Color(0xFF141414),
    Color colorPrimary = const Color(0xFF39FF14),
    Color colorWalletBgGradient1 = const Color(0xFF39FF14),
    Color colorWalletBgGradient2 = const Color(0xFF22C55E),
    Color? colorDarkIconCommon = const Color(0xFFE5E7EB),
    Color? colorBlack = const Color(0xFFF9FAFB),
    Color? colorScaffoldBg = const Color(0xFF0B0B0B),
    Color? colorTextCommon = const Color(0xFFF3F4F6),
    Color? colorShimmerBg = const Color(0xFF1F2937),
    Color? colorTextFieldBg = const Color(0xFF141414),
    Color? colorTextLight = const Color(0xFF9CA3AF),
    Color? colorIconCommon = const Color(0xFFF3F4F6),
    Color? colorDeleteIcon = const Color(0xFFF3F4F6),
    Color? colorIconLight = const Color(0xFF9CA3AF),
    Color? colorBtnGradient1 = const Color(0xFF39FF14),
    Color? colorBtnGradient2 = const Color(0xFF22C55E),
    Color? colorIndicatorOff = const Color(0xFF374151),
    Color? colorOtherChatBg = const Color(0xFF374151),
    Color? colorTextFieldBorder = const Color(0xFF4B5563),
    Color? colorLoginLine = const Color(0xFF374151),
    Color? colorRed = const Color(0xFFF04438),
    Color? colorSelectionPrimaryOpc = const Color(0x3339FF14),
    Color? colorBorder = const Color(0xFF4B5563),
    Color? colorDarkBorder = const Color(0xFF6B7280),
    Color? colorRippleAnimation = const Color(0xFF39FF14),
    Color? colorRippleAnimationBg = const Color(0xB30B0B0B),
    Color? colorDriverStatusContainerBg = const Color(0xFF1F2937),
    Color? colorOfflineContainerRed = const Color(0xFFFF0051),
    Color? colorOnlineContainerGreen = const Color(0xFF39FF14),
    Color? colorActiveOfflineText = const Color(0xFF0B0B0B),
    Color? colorActiveOnlineText = const Color(0xFF0B0B0B),
    Color? colorInActiveOnlineText = const Color(0xFF0B0B0B),
    Color? colorContainerBorder = const Color(0xFF9333EA),
    Color? colorDivider = const Color(0xFF374151),
    Color? colorManageAddressDivider = const Color(0xFF374151),
    Color? colorTimeAgo = const Color(0xFF9CA3AF),
    Color? colorRating = const Color(0xFF39FF14),
    Color? colorHailIcon = const Color(0xFF0B0B0B),
    Color? colorProgressBtnBg = const Color(0xFF374151),
    Color? colorAvailableDriverBg = const Color(0xE60B0B0B),
    Color? colorAvailableDriverBorder1 = const Color(0x8039FF14),
    Color? colorAvailableDriverBorder2 = const Color(0x333933EA),
    Color? colorAvailableDriverCardBg = const Color(0x33141414),
    Color? colorPsRunningIcon = const Color(0xFF0B0B0B),
    Color? colorPsRunningIconBg = const Color(0xFF39FF14),
    Color? colorPsCompletedIconBg = const Color(0xFF22C55E),
    Color? colorSosBg = const Color(0xFFFF0051),
    Color? colorDisableRating = const Color(0xFF374151),
    Color? colorStatusOnGoing = const Color(0xFF9333EA),
    Color? colorReferralPending = const Color(0xFF9333EA),
    Color? colorStatusCancel = const Color(0xFFFF0051),
    Color? colorReferralRejected = const Color(0xFFFF0051),
    Color? colorStatusCompleted = const Color(0xFF39FF14),
    Color? colorReferralClaimed = const Color(0xFF39FF14),
    Color? colorCountryCodePickerSelectionDialogBG = const Color(0xFF141414),
    Color? colorKmAndTimeText = const Color(0xFF9CA3AF),
    Color? colorSuggestionAmountAndIcon = const Color(0xFF0B0B0B),
    Color? colorOfferEditIcon = const Color(0xFFF3F4F6),
    Color? colorBackGroundWaiting = const Color(0xFF0B0B0B),
    Color? colorCreditIcon = const Color(0xFF39FF14),
    Color? colorDebitIcon = const Color(0xFFFF0051),
    Color? colorIssueResolved = const Color(0xFF39FF14),
    Color? colorIssueUnResolved = const Color(0xFFFF0051),
    Color? colorGreen = const Color(0xFF39FF14),
    Color? colorSplashGradient1 = const Color(0xFF39FF14),
    Color? colorSplashGradient2 = const Color(0xFF9333EA),
  }) {
    _systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: colorWhite,
      systemNavigationBarIconBrightness: Brightness.light,
    );
    _mapStyle = mapStyle;
    _colorWhite = colorWhite;
    _colorAppBarDefault = colorAppBarDefault;
    _colorPreferencesChoiceChipBg = colorPreferencesChoiceChipBg;
    _colorPrimary = colorPrimary;
    _colorWalletBgGradient1 = colorWalletBgGradient1;
    _colorWalletBgGradient2 = colorWalletBgGradient2;
    _colorBlack = colorBlack;
    _colorScaffoldBg = colorScaffoldBg;
    _colorTextCommon = colorTextCommon;
    _colorShimmerBg = colorShimmerBg;
    _colorTextFieldBg = colorTextFieldBg;
    _colorTextLight = colorTextLight;
    _colorIconCommon = colorIconCommon;
    _colorDeleteIcon = colorDeleteIcon;
    _colorIconLight = colorIconLight;
    _colorBtnGradient1 = colorBtnGradient1;
    _colorBtnGradient2 = colorBtnGradient2;
    _colorIndicatorOff = colorIndicatorOff;
    _colorOtherChatBg = colorOtherChatBg;
    _colorTextFieldBorder = colorTextFieldBorder;
    _colorLoginLine = colorLoginLine;
    _colorRed = colorRed;
    _colorSelectionPrimaryOpc = colorSelectionPrimaryOpc;
    _colorBorder = colorBorder;
    _colorDarkBorder = colorDarkBorder;
    _colorRippleAnimation = colorRippleAnimation;
    _colorRippleAnimationBg = colorRippleAnimationBg;
    _colorDriverStatusContainerBg = colorDriverStatusContainerBg;
    _colorOfflineContainerRed = colorOfflineContainerRed;
    _colorOnlineContainerGreen = colorOnlineContainerGreen;
    _colorActiveOfflineText = colorActiveOfflineText;
    _colorActiveOnlineText = colorActiveOnlineText;
    _colorInActiveOnlineText = colorInActiveOnlineText;
    _colorContainerBorder = colorContainerBorder;
    _colorDivider = colorDivider;
    _colorManageAddressDivider = colorManageAddressDivider;
    _colorTimeAgo = colorTimeAgo;
    _colorRating = colorRating;
    _colorHailIcon = colorHailIcon;
    _colorProgressBtnBg = colorProgressBtnBg;
    _colorAvailableDriverBg = colorAvailableDriverBg;
    _colorAvailableDriverBorder1 = colorAvailableDriverBorder1;
    _colorAvailableDriverBorder2 = colorAvailableDriverBorder2;
    _colorAvailableDriverCardBg = colorAvailableDriverCardBg;
    _colorPsRunningIcon = colorPsRunningIcon;
    _colorPsRunningIconBg = colorPsRunningIconBg;
    _colorPsCompletedIconBg = colorPsCompletedIconBg;
    _colorSosBg = colorSosBg;
    _colorDisableRating = colorDisableRating;
    _colorStatusOnGoing = colorStatusOnGoing;
    _colorReferralPending = colorReferralPending;
    _colorStatusCancel = colorStatusCancel;
    _colorReferralRejected = colorReferralRejected;
    _colorStatusCompleted = colorStatusCompleted;
    _colorReferralClaimed = colorReferralClaimed;
    _colorCountryCodePickerSelectionDialogBG = colorCountryCodePickerSelectionDialogBG;
    _colorKmAndTimeText = colorKmAndTimeText;
    _colorSuggestionAmountAndIcon = colorSuggestionAmountAndIcon;
    _colorOfferEditIcon = colorOfferEditIcon;
    _colorBackGroundWaiting = colorBackGroundWaiting;
    _colorCreditIcon = colorCreditIcon;
    _colorDebitIcon = colorDebitIcon;
    _colorIssueResolved = colorIssueResolved;
    _colorIssueUnResolved = colorIssueUnResolved;
    _colorGreen = colorGreen;
    _colorSplashGradient1 = colorSplashGradient1;
    _colorSplashGradient2 = colorSplashGradient2;
  }

  @override
  AppThemeColors copyWith({
    int? themeMode,
    Color? colorCommonShadow,
    String? mapStyle,
    Color? colorWhite,
    Color? colorAppBarDefault,
    Color? colorPreferencesChoiceChipBg,
    Color? colorPrimary,
    Color? colorWalletBgGradient1,
    Color? colorWalletBgGradient2,
    Color? colorDarkIconCommon,
    Color? colorBlack,
    Color? colorScaffoldBg,
    Color? colorTextCommon,
    Color? colorShimmerBg,
    Color? colorTextFieldBg,
    Color? colorTextLight,
    Color? colorIconCommon,
    Color? colorDeleteIcon,
    Color? colorIconLight,
    Color? colorBtnGradient1,
    Color? colorBtnGradient2,
    Color? colorIndicatorOff,
    Color? colorOtherChatBg,
    Color? colorTextFieldBorder,
    Color? colorLoginLine,
    Color? colorRed,
    Color? colorSelectionPrimaryOpc,
    Color? colorBorder,
    Color? colorDarkBorder,
    Color? colorRippleAnimation,
    Color? colorRippleAnimationBg,
    Color? colorDriverStatusContainerBg,
    Color? colorOfflineContainerRed,
    Color? colorOnlineContainerGreen,
    Color? colorActiveOfflineText,
    Color? colorActiveOnlineText,
    Color? colorInActiveOnlineText,
    Color? colorContainerBorder,
    Color? colorDivider,
    Color? colorManageAddressDivider,
    Color? colorTimeAgo,
    Color? colorRating,
    Color? colorHailIcon,
    Color? colorProgressBtnBg,
    Color? colorAvailableDriverBg,
    Color? colorAvailableDriverBorder1,
    Color? colorAvailableDriverBorder2,
    Color? colorAvailableDriverCardBg,
    Color? colorPsRunningIcon,
    Color? colorPsRunningIconBg,
    Color? colorPsCompletedIconBg,
    Color? colorSosBg,
    Color? colorDisableRating,
    Color? colorStatusOnGoing,
    Color? colorReferralPending,
    Color? colorStatusCancel,
    Color? colorReferralRejected,
    Color? colorStatusCompleted,
    Color? colorReferralClaimed,
    Color? colorCountryCodePickerSelectionDialogBG,
    Color? colorKmAndTimeText,
    Color? colorSuggestionAmountAndIcon,
    Color? colorOfferEditIcon,
    Color? colorCreditIcon,
    Color? colorDebitIcon,
    Color? colorIssueResolved,
    Color? colorIssueUnResolved,
    Color? colorBackGroundWaiting,
    Color? colorGreen,
    Color? colorSplashGradient1,
    Color? colorSplashGradient2,
  }) {
    return AppThemeColors(
      themeMode: themeMode ?? this.themeMode,
      mapStyle: mapStyle ?? _mapStyle,
      colorWhite: colorWhite ?? _colorWhite,
      colorAppBarDefault: colorAppBarDefault ?? _colorAppBarDefault,
      colorPreferencesChoiceChipBg: colorPreferencesChoiceChipBg ?? _colorPreferencesChoiceChipBg,
      colorPrimary: colorPrimary ?? _colorPrimary,
      colorWalletBgGradient1: colorWalletBgGradient1 ?? _colorWalletBgGradient1,
      colorWalletBgGradient2: colorWalletBgGradient2 ?? _colorWalletBgGradient2,
      colorBlack: colorBlack ?? _colorBlack,
      colorScaffoldBg: colorScaffoldBg ?? _colorScaffoldBg,
      colorTextCommon: colorTextCommon ?? _colorTextCommon,
      colorShimmerBg: colorShimmerBg ?? _colorShimmerBg,
      colorTextFieldBg: colorTextFieldBg ?? _colorTextFieldBg,
      colorTextLight: colorTextLight ?? _colorTextLight,
      colorIconCommon: colorIconCommon ?? _colorIconCommon,
      colorDeleteIcon: colorDeleteIcon ?? _colorDeleteIcon,
      colorIconLight: colorIconLight ?? _colorIconLight,
      colorBtnGradient1: colorBtnGradient1 ?? _colorBtnGradient1,
      colorBtnGradient2: colorBtnGradient2 ?? _colorBtnGradient2,
      colorIndicatorOff: colorIndicatorOff ?? _colorIndicatorOff,
      colorOtherChatBg: colorOtherChatBg ?? _colorOtherChatBg,
      colorTextFieldBorder: colorTextFieldBorder ?? _colorTextFieldBorder,
      colorLoginLine: colorLoginLine ?? _colorLoginLine,
      colorRed: colorRed ?? _colorRed,
      colorSelectionPrimaryOpc: colorSelectionPrimaryOpc ?? _colorSelectionPrimaryOpc,
      colorBorder: colorBorder ?? _colorBorder,
      colorDarkBorder: colorDarkBorder ?? _colorDarkBorder,
      colorRippleAnimation: colorRippleAnimation ?? _colorRippleAnimation,
      colorRippleAnimationBg: colorRippleAnimationBg ?? _colorRippleAnimationBg,
      colorDriverStatusContainerBg: colorDriverStatusContainerBg ?? _colorDriverStatusContainerBg,
      colorOfflineContainerRed: colorOfflineContainerRed ?? _colorOfflineContainerRed,
      colorActiveOfflineText: colorActiveOfflineText ?? _colorActiveOfflineText,
      colorActiveOnlineText: colorActiveOnlineText ?? _colorActiveOnlineText,
      colorInActiveOnlineText: colorInActiveOnlineText ?? _colorInActiveOnlineText,
      colorContainerBorder: colorContainerBorder ?? _colorContainerBorder,
      colorDivider: colorDivider ?? _colorDivider,
      colorManageAddressDivider: colorManageAddressDivider ?? _colorManageAddressDivider,
      colorTimeAgo: colorTimeAgo ?? _colorTimeAgo,
      colorRating: colorRating ?? _colorRating,
      colorHailIcon: colorHailIcon ?? _colorHailIcon,
      colorProgressBtnBg: colorProgressBtnBg ?? _colorProgressBtnBg,
      colorAvailableDriverBg: colorAvailableDriverBg ?? _colorAvailableDriverBg,
      colorAvailableDriverBorder1: colorAvailableDriverBorder1 ?? _colorAvailableDriverBorder1,
      colorAvailableDriverBorder2: colorAvailableDriverBorder2 ?? _colorAvailableDriverBorder2,
      colorAvailableDriverCardBg: colorAvailableDriverCardBg ?? _colorAvailableDriverCardBg,
      colorPsRunningIcon: colorPsRunningIcon ?? _colorPsRunningIcon,
      colorPsRunningIconBg: colorPsRunningIconBg ?? _colorPsRunningIconBg,
      colorPsCompletedIconBg: colorPsCompletedIconBg ?? _colorPsCompletedIconBg,
      colorSosBg: colorSosBg ?? _colorSosBg,
      colorDisableRating: colorDisableRating ?? _colorDisableRating,
      colorStatusOnGoing: colorStatusOnGoing ?? _colorStatusOnGoing,
      colorReferralPending: colorReferralPending ?? _colorReferralPending,
      colorStatusCancel: colorStatusCancel ?? _colorStatusCancel,
      colorReferralRejected: colorReferralRejected ?? _colorReferralRejected,
      colorStatusCompleted: colorStatusCompleted ?? _colorStatusCompleted,
      colorReferralClaimed: colorReferralClaimed ?? _colorReferralClaimed,
      colorCountryCodePickerSelectionDialogBG: colorCountryCodePickerSelectionDialogBG ?? _colorCountryCodePickerSelectionDialogBG,
      colorKmAndTimeText: colorKmAndTimeText ?? _colorKmAndTimeText,
      colorSuggestionAmountAndIcon: colorSuggestionAmountAndIcon ?? _colorSuggestionAmountAndIcon,
      colorOfferEditIcon: colorOfferEditIcon ?? _colorOfferEditIcon,
      colorCreditIcon: colorCreditIcon ?? _colorCreditIcon,
      colorDebitIcon: colorDebitIcon ?? _colorDebitIcon,
      colorIssueResolved: colorIssueResolved ?? _colorIssueResolved,
      colorIssueUnResolved: colorIssueUnResolved ?? _colorIssueUnResolved,
      colorBackGroundWaiting: colorBackGroundWaiting ?? _colorBackGroundWaiting,
      colorGreen: colorGreen ?? _colorGreen,
      colorSplashGradient1: colorSplashGradient1 ?? _colorSplashGradient1,
      colorSplashGradient2: colorSplashGradient2 ?? _colorSplashGradient2,
    );
  }

  @override
  AppThemeColors lerp(AppThemeColors? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }
    return AppThemeColors(
      mapStyle: _mapStyle,
      colorWhite: Color.lerp(_colorWhite, other.colorWhite, t),
      colorAppBarDefault: Color.lerp(_colorAppBarDefault, other.colorAppBarDefault, t),
      colorPreferencesChoiceChipBg: Color.lerp(_colorPreferencesChoiceChipBg, other.colorPreferencesChoiceChipBg, t),
      colorPrimary: Color.lerp(_colorPrimary, other.colorPrimary, t),
      colorWalletBgGradient1: Color.lerp(_colorWalletBgGradient1, other.colorWalletBgGradient1, t),
      colorWalletBgGradient2: Color.lerp(_colorWalletBgGradient2, other.colorWalletBgGradient2, t),
      colorBlack: Color.lerp(_colorBlack, other.colorBlack, t),
      colorScaffoldBg: Color.lerp(_colorScaffoldBg, other._colorScaffoldBg, t),
      colorTextCommon: Color.lerp(_colorTextCommon, other._colorTextCommon, t),
      colorShimmerBg: Color.lerp(_colorShimmerBg, other.colorShimmerBg, t),
      colorTextFieldBg: Color.lerp(_colorTextFieldBg, other.colorTextFieldBg, t),
      colorTextLight: Color.lerp(_colorTextLight, other.colorTextLight, t),
      colorIconCommon: Color.lerp(_colorIconCommon, other.colorIconCommon, t),
      colorDeleteIcon: Color.lerp(_colorDeleteIcon, other.colorDeleteIcon, t),
      colorIconLight: Color.lerp(_colorIconLight, other.colorIconLight, t),
      colorBtnGradient1: Color.lerp(_colorBtnGradient1, other.colorBtnGradient1, t),
      colorBtnGradient2: Color.lerp(_colorBtnGradient2, other.colorBtnGradient2, t),
      colorIndicatorOff: Color.lerp(_colorIndicatorOff, other.colorIndicatorOff, t),
      colorOtherChatBg: Color.lerp(_colorOtherChatBg, other.colorOtherChatBg, t),
      colorTextFieldBorder: Color.lerp(_colorTextFieldBorder, other.colorTextFieldBorder, t),
      colorLoginLine: Color.lerp(_colorLoginLine, other.colorLoginLine, t),
      colorRed: Color.lerp(_colorRed, other.colorRed, t),
      colorSelectionPrimaryOpc: Color.lerp(_colorSelectionPrimaryOpc, other.colorSelectionPrimaryOpc, t),
      colorBorder: Color.lerp(_colorBorder, other.colorBorder, t),
      colorDarkBorder: Color.lerp(_colorDarkBorder, other.colorDarkBorder, t),
      colorRippleAnimation: Color.lerp(_colorRippleAnimation, other.colorRippleAnimation, t),
      colorRippleAnimationBg: Color.lerp(_colorRippleAnimationBg, other.colorRippleAnimationBg, t),
      colorDriverStatusContainerBg: Color.lerp(_colorDriverStatusContainerBg, other.colorDriverStatusContainerBg, t),
      colorOfflineContainerRed: Color.lerp(_colorOfflineContainerRed, other.colorOfflineContainerRed, t),
      colorOnlineContainerGreen: Color.lerp(_colorOnlineContainerGreen, other.colorOnlineContainerGreen, t),
      colorActiveOfflineText: Color.lerp(_colorActiveOfflineText, other.colorActiveOfflineText, t),
      colorActiveOnlineText: Color.lerp(_colorActiveOnlineText, other.colorActiveOnlineText, t),
      colorInActiveOnlineText: Color.lerp(_colorInActiveOnlineText, other.colorInActiveOnlineText, t),
      colorContainerBorder: Color.lerp(_colorContainerBorder, other.colorContainerBorder, t),
      colorDivider: Color.lerp(_colorDivider, other.colorDivider, t),
      colorManageAddressDivider: Color.lerp(_colorManageAddressDivider, other.colorManageAddressDivider, t),
      colorTimeAgo: Color.lerp(_colorTimeAgo, other.colorTimeAgo, t),
      colorRating: Color.lerp(_colorRating, other.colorRating, t),
      colorHailIcon: Color.lerp(_colorHailIcon, other.colorHailIcon, t),
      colorProgressBtnBg: Color.lerp(_colorProgressBtnBg, other.colorProgressBtnBg, t),
      colorAvailableDriverBg: Color.lerp(_colorAvailableDriverBg, other.colorAvailableDriverBg, t),
      colorAvailableDriverBorder1: Color.lerp(_colorAvailableDriverBorder1, other.colorAvailableDriverBorder1, t),
      colorAvailableDriverBorder2: Color.lerp(_colorAvailableDriverBorder2, other.colorAvailableDriverBorder2, t),
      colorAvailableDriverCardBg: Color.lerp(_colorAvailableDriverCardBg, other.colorAvailableDriverCardBg, t),
      colorPsRunningIcon: Color.lerp(_colorPsRunningIcon, other.colorPsRunningIcon, t),
      colorPsRunningIconBg: Color.lerp(_colorPsRunningIconBg, other.colorPsRunningIconBg, t),
      colorPsCompletedIconBg: Color.lerp(_colorPsCompletedIconBg, other.colorPsCompletedIconBg, t),
      colorSosBg: Color.lerp(_colorSosBg, other._colorSosBg, t),
      colorDisableRating: Color.lerp(_colorDisableRating, other.colorDisableRating, t),
      colorStatusOnGoing: Color.lerp(_colorStatusOnGoing, other.colorStatusOnGoing, t),
      colorReferralPending: Color.lerp(_colorReferralPending, other.colorReferralPending, t),
      colorStatusCancel: Color.lerp(_colorStatusCancel, other.colorStatusCancel, t),
      colorReferralRejected: Color.lerp(_colorReferralRejected, other.colorReferralRejected, t),
      colorStatusCompleted: Color.lerp(_colorStatusCompleted, other.colorStatusCompleted, t),
      colorReferralClaimed: Color.lerp(_colorReferralClaimed, other.colorReferralClaimed, t),
      colorCountryCodePickerSelectionDialogBG: Color.lerp(_colorCountryCodePickerSelectionDialogBG, other.colorCountryCodePickerSelectionDialogBG, t),
      colorKmAndTimeText: Color.lerp(_colorKmAndTimeText, other.colorKmAndTimeText, t),
      colorSuggestionAmountAndIcon: Color.lerp(_colorSuggestionAmountAndIcon, other.colorSuggestionAmountAndIcon, t),
      colorOfferEditIcon: Color.lerp(_colorOfferEditIcon, other.colorOfferEditIcon, t),
      colorCreditIcon: Color.lerp(_colorCreditIcon, other.colorCreditIcon, t),
      colorDebitIcon: Color.lerp(_colorDebitIcon, other.colorDebitIcon, t),
      colorIssueResolved: Color.lerp(_colorIssueResolved, other.colorIssueResolved, t),
      colorIssueUnResolved: Color.lerp(_colorIssueUnResolved, other.colorIssueUnResolved, t),
      colorBackGroundWaiting: Color.lerp(_colorBackGroundWaiting, other.colorBackGroundWaiting, t),
      colorGreen: Color.lerp(_colorGreen, other.colorGreen, t),
      colorSplashGradient1: Color.lerp(_colorSplashGradient1, other.colorSplashGradient1, t),
      colorSplashGradient2: Color.lerp(_colorSplashGradient2, other.colorSplashGradient2, t),
    );
  }

  SystemUiOverlayStyle get systemUiOverlayStyle =>
      _systemUiOverlayStyle ??
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: themeMode == 1 ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: themeMode == 1 ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: _colorWhite,
        systemNavigationBarIconBrightness: themeMode == 1 ? Brightness.dark : Brightness.light,
      );

  String get mapStyle => _mapStyle ?? "";

  Color get colorWhite => _colorWhite ?? Colors.transparent;

  Color get colorAppBarDefault => _colorAppBarDefault ?? Colors.transparent;

  Color get colorPreferencesChoiceChipBg => _colorPreferencesChoiceChipBg ?? Colors.transparent;

  Color get colorPrimary => _colorPrimary ?? Colors.transparent;

  Color get colorWalletBgGradient1 => _colorWalletBgGradient1 ?? Colors.transparent;

  Color get colorWalletBgGradient2 => _colorWalletBgGradient2 ?? Colors.transparent;

  Color get colorBlack => _colorBlack ?? Colors.transparent;

  Color get colorScaffoldBg => _colorScaffoldBg ?? Colors.transparent;

  Color get colorTextCommon => _colorTextCommon ?? Colors.transparent;

  Color get colorShimmerBg => _colorShimmerBg ?? Colors.transparent;

  Color get colorTextFieldBg => _colorTextFieldBg ?? Colors.transparent;

  Color get colorTextLight => _colorTextLight ?? Colors.transparent;

  Color get colorIconCommon => _colorIconCommon ?? Colors.transparent;

  Color get colorDeleteIcon => _colorDeleteIcon ?? Colors.transparent;

  Color get colorIconLight => _colorIconLight ?? Colors.transparent;

  Color get colorBtnGradient1 => _colorBtnGradient1 ?? Colors.transparent;

  Color get colorBtnGradient2 => _colorBtnGradient2 ?? Colors.transparent;

  Color get colorIndicatorOff => _colorIndicatorOff ?? Colors.transparent;

  Color get colorOtherChatBg => _colorOtherChatBg ?? Colors.transparent;

  Color get colorTextFieldBorder => _colorTextFieldBorder ?? Colors.transparent;

  Color get colorLoginLine => _colorLoginLine ?? Colors.transparent;

  Color get colorRed => _colorRed ?? Colors.transparent;

  Color get colorSelectionPrimaryOpc => _colorSelectionPrimaryOpc ?? Colors.transparent;

  Color get colorBorder => _colorBorder ?? Colors.transparent;

  Color get colorDarkBorder => _colorDarkBorder ?? Colors.transparent;

  Color get colorRippleAnimation => _colorRippleAnimation ?? Colors.transparent;

  Color get colorRippleAnimationBg => _colorRippleAnimationBg ?? Colors.transparent;

  Color get colorDriverStatusContainerBg => _colorDriverStatusContainerBg ?? Colors.transparent;

  Color get colorOfflineContainerRed => _colorOfflineContainerRed ?? Colors.transparent;

  Color get colorOnlineContainerGreen => _colorOnlineContainerGreen ?? Colors.transparent;

  Color get colorActiveOfflineText => _colorActiveOfflineText ?? Colors.transparent;

  Color get colorActiveOnlineText => _colorActiveOnlineText ?? Colors.transparent;

  Color get colorInActiveOnlineText => _colorInActiveOnlineText ?? Colors.transparent;

  Color get colorContainerBorder => _colorContainerBorder ?? Colors.transparent;

  Color get colorDivider => _colorDivider ?? Colors.transparent;

  Color get colorManageAddressDivider => _colorManageAddressDivider ?? Colors.transparent;

  Color get colorTimeAgo => _colorTimeAgo ?? Colors.transparent;

  Color get colorRating => _colorRating ?? Colors.transparent;

  Color get colorHailIcon => _colorHailIcon ?? Colors.transparent;

  Color get colorProgressBtnBg => _colorProgressBtnBg ?? Colors.transparent;

  Color get colorAvailableDriverBg => _colorAvailableDriverBg ?? Colors.transparent;

  Color get colorAvailableDriverBorder1 => _colorAvailableDriverBorder1 ?? Colors.transparent;

  Color get colorAvailableDriverBorder2 => _colorAvailableDriverBorder2 ?? Colors.transparent;

  Color get colorAvailableDriverCardBg => _colorAvailableDriverCardBg ?? Colors.transparent;

  Color get colorPsRunningIcon => _colorPsRunningIcon ?? Colors.transparent;

  Color get colorPsRunningIconBg => _colorPsRunningIconBg ?? Colors.transparent;

  Color get colorPsCompletedIconBg => _colorPsCompletedIconBg ?? Colors.transparent;

  Color get colorSosBg => _colorSosBg ?? Colors.transparent;

  Color get colorDisableRating => _colorDisableRating ?? Colors.transparent;

  Color get colorStatusOnGoing => _colorStatusOnGoing ?? Colors.transparent;

  Color get colorReferralPending => _colorReferralPending ?? Colors.transparent;

  Color get colorStatusCancel => _colorStatusCancel ?? Colors.transparent;

  Color get colorReferralRejected => _colorReferralRejected ?? Colors.transparent;

  Color get colorStatusCompleted => _colorStatusCompleted ?? Colors.transparent;

  Color get colorReferralClaimed => _colorReferralClaimed ?? Colors.transparent;

  Color get colorCountryCodePickerSelectionDialogBG => _colorCountryCodePickerSelectionDialogBG ?? Colors.transparent;

  Color get colorKmAndTimeText => _colorKmAndTimeText ?? Colors.transparent;

  Color get colorSuggestionAmountAndIcon => _colorSuggestionAmountAndIcon ?? Colors.transparent;

  Color get colorOfferEditIcon => _colorOfferEditIcon ?? Colors.transparent;

  Color get colorCreditIcon => _colorCreditIcon ?? Colors.transparent;

  Color get colorDebitIcon => _colorDebitIcon ?? Colors.transparent;

  Color get colorIssueResolved => _colorIssueResolved ?? Colors.transparent;

  Color get colorIssueUnResolved => _colorIssueUnResolved ?? Colors.transparent;

  Color get colorBackGroundWaiting => _colorBackGroundWaiting ?? Colors.transparent;

  Color get colorGreen => _colorGreen ?? Colors.transparent;

  Color get colorSplashGradient1 => _colorSplashGradient1 ?? Colors.transparent;

  Color get colorSplashGradient2 => _colorSplashGradient2 ?? Colors.transparent;
}
