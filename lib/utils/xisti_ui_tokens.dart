import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'service_mode_util.dart';

/// XISTI brand palette — shared across home, sheets, wallet, and tracking.
abstract final class XistiBrand {
  static const Color green = Color(0xFF39FF14);
  static const Color purple = Color(0xFF9333EA);
  static const Color dark = Color(0xFF0B0B0B);
  static const Color darkSurface = Color(0xFF141414);
  static const Color legalOrange = Color(0xFFE65100);
  static const Color legalOrangeBg = Color(0xFFFFF3E0);
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
        return XistiBrand.green;
      case ServiceModeKind.transport:
      default:
        return XistiBrand.green;
    }
  }

  static Color polylineColorForMode(String? mode) {
    switch (mode) {
      case ServiceModeKind.delivery:
      case ServiceModeKind.encomiendas:
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
    final accentColor = accent ?? XistiBrand.green;
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
