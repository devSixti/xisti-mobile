import 'package:flutter_test/flutter_test.dart';
import 'package:app_xisti/utils/rotating_splash_assets.dart';

void main() {
  test('rotating splash catalog has seven variants', () {
    expect(RotatingSplashAssets.variants, hasLength(7));
    for (final path in RotatingSplashAssets.variants) {
      expect(path, startsWith('assets/images/splash_variants/splash_'));
      expect(path, endsWith('.png'));
    }
  });
}
