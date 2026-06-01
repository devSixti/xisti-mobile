import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../constant/dimensions.dart';

TextStyle bodyText({required BuildContext context, FontWeight? fontWeight, double? fontSize, Color? textColor}) {
  return commonTextStyle(context: context, fontWeight: fontWeight, fontSize: fontSize, textColor: textColor);
}

TextStyle headerText({required BuildContext context, FontWeight? fontWeight, double? fontSize, Color? textColor}) {
  return commonTextStyle(context: context, fontWeight: fontWeight ?? FontWeight.w600, fontSize: fontSize ?? textSize20px, textColor: textColor);
}

TextStyle toolbarStyle({required BuildContext context, FontWeight? fontWeight, double? fontSize, Color? textColor}) {
  return commonTextStyle(context: context, fontWeight: fontWeight ?? FontWeight.w600, fontSize: fontSize ?? textSize18px, textColor: textColor);
}

TextStyle commonTextStyle({required BuildContext context, FontWeight? fontWeight, double? fontSize, Color? textColor}) {
  return GoogleFonts.figtree(
    textStyle: TextStyle(color: textColor ?? getCurrentTheme(context).colorTextCommon, fontSize: fontSize ?? textSize16px, decoration: TextDecoration.none),
    fontWeight: fontWeight ?? FontWeight.normal,
  ).copyWith(
    fontFamilyFallback: [
      GoogleFonts.roboto().fontFamily ?? "",
      GoogleFonts.notoSans().fontFamily ?? "",
      GoogleFonts.openSans().fontFamily ?? "",
      GoogleFonts.montserrat().fontFamily ?? "",
      GoogleFonts.poppins().fontFamily ?? "",
    ],
  );
}

Color lighten(Color color, [int percent = 15]) {
  assert(percent >= 1 && percent <= 100);
  final hsl = HSLColor.fromColor(color);
  final lightness = (hsl.lightness + percent / 100).clamp(0.0, 1.0);

  return hsl.withLightness(lightness).toColor();
}
