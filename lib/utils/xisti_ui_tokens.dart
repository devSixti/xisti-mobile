import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'service_mode_util.dart';

/// XISTI official brand palette (Principal + Segundarios).
abstract final class XistiBrand {
  // Principal
  static const Color green = Color(0xFF80FF00);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Secundarios — verdes y grises
  static const Color greenOlive = Color(0xFF478402);
  static const Color greenPale = Color(0xFFD2FF97);
  static const Color greenCream = Color(0xFFEBFFC5);
  static const Color greyDark = Color(0xFF4D4D4D);
  static const Color greenMid = Color(0xFF74D603);
  static const Color dark = Color(0xFF1A1A1A);
  static const Color greenLight = Color(0xFFB5FF5F);
  static const Color offWhite = Color(0xFFF4F4F4);

  // Secundarios — morados, azules y grises
  static const Color greyLight = Color(0xFFE6E6E6);
  static const Color lavenderGrey = Color(0xFFD7D3E2);
  static const Color blueViolet = Color(0xFF4A00FF);
  static const Color purple = Color(0xFF681FFF);
  static const Color purpleMedium = Color(0xFF8251FC);
  static const Color purpleDeep = Color(0xFF3800C1);
  static const Color greyMedium = Color(0xFFCCCCCC);
  static const Color purpleLight = Color(0xFF9C75FC);
  static const Color lavender = Color(0xFFBCA7FC);
  static const Color lavenderMuted = Color(0xFFAEA5C4);

  /// Dark scaffold / cards (alias for [dark]).
  static const Color darkSurface = dark;

  static const Color legalOrange = Color(0xFF681FFF);
  static const Color legalOrangeBg = Color(0xFFEDE7F6);
}

/// Global visual tokens for the XISTI multiservice experience.
abstract final class XistiUiTokens {
  static double get searchCardRadius => 20.r;
  static double get chipRadius => 24.r;
  static double get sheetRadius => 24.r;
  static double get cardRadius => 16.r;
  static double get floatingElevation => 8;
  static double get searchCardTopInset => 12.h;
  static double get overlayHorizontalPadding => 16.w;
  static double get cardPadding => 16.w;

  /// Wireframe: panel inferior compacto (~24% pantalla).
  static double wireframePanelHeight(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return screenH * 0.24 + bottomInset;
  }

  static double get wireframeVehicleTileHeight => 52.h;
  /// Cuadrado solo imagen (referencia wireframe).
  static double get wireframeVehicleBoxSize => 86.w;
  static double get wireframeVehicleLabelGap => 4.h;
  /// Caja + separador + etiqueta (derivado del box para evitar overflow).
  static double get wireframeVehicleRowHeight =>
      wireframeVehicleBoxSize + wireframeVehicleLabelGap + 16.h;
  static double get wireframeVehiclePhotoTileMinHeight => 46.h;
  static double get wireframeVehiclePhotoTileMaxHeight => 52.h;

  static int get wireframeMapFlex => 76;
  static int get wireframePanelFlex => 24;

  static bool isTabletOrLandscape(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.shortestSide >= 600 || size.width > size.height;
  }

  static double sheetInitialSize(BuildContext context) {
    if (isTabletOrLandscape(context)) return 0.38;
    final h = MediaQuery.sizeOf(context).height;
    return h < 700 ? 0.30 : 0.26;
  }

  static double sheetMinSize(BuildContext context) => isTabletOrLandscape(context) ? 0.28 : 0.24;

  static double sheetMaxSize(BuildContext context) {
    if (isTabletOrLandscape(context)) return 0.85;
    final h = MediaQuery.sizeOf(context).height;
    return h < 700 ? 0.78 : 0.72;
  }

  static Color accentForMode(String? mode) {
    switch (mode) {
      case ServiceModeKind.delivery:
        return XistiBrand.purple;
      case ServiceModeKind.encomiendas:
        return XistiBrand.purple;
      case ServiceModeKind.expreso:
        return XistiBrand.greenMid;
      case ServiceModeKind.acarreos:
      case ServiceModeKind.carga:
        return XistiBrand.purple;
      case ServiceModeKind.transport:
      default:
        return XistiBrand.greenMid;
    }
  }

  static Color get deliveryAccent => XistiBrand.purple;

  static Color polylineColorForMode(String? mode) {
    switch (mode) {
      case ServiceModeKind.delivery:
      case ServiceModeKind.encomiendas:
      case ServiceModeKind.acarreos:
      case ServiceModeKind.carga:
        return XistiBrand.purple;
      default:
        return XistiBrand.green;
    }
  }

  static List<Color> chipGradientForMode(String? mode) {
    if (mode == ServiceModeKind.encomiendas) {
      return [XistiBrand.green, XistiBrand.purple];
    }
    return [accentForMode(mode), accentForMode(mode)];
  }

  static List<BoxShadow> floatingShadow(BuildContext context, Color borderColor) => [
        BoxShadow(
          color: borderColor.withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> neonGlow(Color accent, {double alpha = 0.35}) => [
        BoxShadow(
          color: accent.withValues(alpha: alpha),
          blurRadius: 14,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];

  static BoxDecoration glassCard({
    required Color background,
    required Color borderColor,
    Color? accent,
    bool selected = false,
    double radius = 0,
  }) {
    final r = radius > 0 ? radius : cardRadius;
    final accentColor = accent ?? XistiBrand.greenMid;
    return BoxDecoration(
      color: background.withValues(alpha: selected ? 0.22 : 0.12),
      borderRadius: BorderRadius.circular(r),
      border: Border.all(
        color: selected ? accentColor : borderColor.withValues(alpha: 0.6),
        width: selected ? 1.5 : 1,
      ),
      boxShadow: selected ? neonGlow(accentColor, alpha: 0.25) : null,
    );
  }

  static BoxDecoration modeBannerDecoration(Color accent, Color bg) => BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
      );
}

/// Backward-compatible alias used by home layout files.
typedef XistiHomeUiTokens = XistiUiTokens;

/// Auth and wallet screens — purple/green gradient (distinct from ZIMO yellow).
abstract final class XistiAuthTokens {
  static double get heroRadius => 24.r;
  static double get walletRadius => 25.r;
  static double get optionRadius => 15.r;

  static const List<Color> heroGradientColors = [
    XistiBrand.purpleDeep,
    XistiBrand.purple,
    XistiBrand.greenMid,
  ];

  static const List<Color> walletGradientColors = [
    XistiBrand.purpleDeep,
    XistiBrand.purple,
    XistiBrand.purpleMedium,
    XistiBrand.greenMid,
    XistiBrand.green,
  ];

  static LinearGradient get heroGradient => const LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: heroGradientColors,
      );

  static LinearGradient get walletGradient => const LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: walletGradientColors,
      );

  static LinearGradient get optionSelectedGradient => const LinearGradient(
        begin: AlignmentDirectional.centerStart,
        end: AlignmentDirectional.centerEnd,
        colors: [XistiBrand.purple, XistiBrand.greenMid],
      );

  static BoxDecoration heroBanner({double radius = 0}) => BoxDecoration(
        borderRadius: BorderRadius.circular(radius > 0 ? radius : heroRadius),
        gradient: heroGradient,
        boxShadow: XistiUiTokens.neonGlow(XistiBrand.purple, alpha: 0.22),
      );

  static BoxDecoration walletBalanceCard() => BoxDecoration(
        borderRadius: BorderRadius.circular(walletRadius),
        gradient: walletGradient,
        boxShadow: XistiUiTokens.neonGlow(XistiBrand.purple, alpha: 0.28),
      );

  static Color get checkboxActive => XistiBrand.purple;
  static Color get accent => XistiBrand.greenMid;
  static Color get onGradientText => XistiBrand.white;
  static Color get walletIconBg => XistiBrand.white;
}
