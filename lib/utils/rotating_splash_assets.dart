import 'dart:math';

/// One splash artwork per cold start — each user/session sees a random variant.
abstract final class RotatingSplashAssets {
  static const List<String> variants = [
    'assets/images/splash_variants/splash_1.png',
    'assets/images/splash_variants/splash_2.png',
    'assets/images/splash_variants/splash_3.png',
    'assets/images/splash_variants/splash_4.png',
    'assets/images/splash_variants/splash_5.png',
    'assets/images/splash_variants/splash_6.png',
    'assets/images/splash_variants/splash_7.png',
  ];

  static final String selected = variants[Random().nextInt(variants.length)];
}
