import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../appThemeManager/app_theme_colors.dart';

/// Shared sizing and card styling for vehicle service icons (all modes).
class AcarreoIconUtil {
  static const String iconVersion = '1.4';

  static const String iconBase = 'https://admin.xistiapp.com/assets/images/vehicle-service';

  /// Inner padding so icons sit inside bordered tiles without touching edges.
  static const double cardIconPadding = 10;

  /// Show full artwork inside the tile; PNG trim on server removes white margins.
  static const BoxFit vehicleCardImageFit = BoxFit.contain;

  static const double _passengerCardScale = 0.76;
  static const double _driverCardScale = 0.76;

  static const double _sheetSizeFactor = 1.2;

  static bool isAcarreoIcon(String? iconUrl) {
    if (iconUrl == null || iconUrl.isEmpty) return false;
    final icon = iconUrl.toLowerCase();
    return icon.contains('motocarguero') ||
        icon.contains('camion_acarreo') ||
        icon.contains('jaula_acarreo') ||
        icon.contains('motocarro');
  }

  static double passengerCardScale(String? iconUrl) => _passengerCardScale;

  static double driverCardScale(String? iconUrl) => _driverCardScale;

  static double sheetSizeFactor(String? iconUrl) => _sheetSizeFactor;

  /// Border-only tile: transparent fill so icons keep original colors in dark mode.
  static BoxDecoration vehicleCardDecoration(
    BuildContext context, {
    required bool isSelected,
    double borderRadius = 15,
  }) {
    final theme = getCurrentTheme(context);
    final borderColor = isSelected
        ? theme.colorPrimary
        : (theme.themeMode == 1 ? theme.colorDarkBorder : const Color(0xFF5A5A5A));
    return BoxDecoration(
      color: isSelected ? theme.colorPrimary.withValues(alpha: 0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor,
        width: isSelected ? 3 : 2,
      ),
    );
  }

  static const double passengerTileWidth = 88;

  static const double passengerTileSpacing = 17;

  static const double passengerTileLabelGap = 4;

  static const double passengerTileLabelHeight = 34;

  /// Tile + label + ListView vertical padding (top/bottom 4.h each).
  static double passengerVehicleRowHeight() {
    return passengerTileWidth.w +
        passengerTileLabelGap.h +
        passengerTileLabelHeight.h +
        8.h;
  }
}
