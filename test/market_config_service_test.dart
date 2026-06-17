import 'dart:io';

import 'package:app_xisti/hive/hive_helper.dart';
import 'package:app_xisti/services/market_config_service.dart';
import 'package:app_xisti/utils/xisti_region_catalog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  setUpAll(() async {
    final dir = Directory.systemTemp.createTempSync('app_xisti_market_test');
    Hive.init(dir.path);
    await initBox();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  test('MarketConfigService overlays server min fare on local country', () {
    MarketConfigService.clearMemoryCache();
    MarketConfigService.applyFromJson({
      'config_version': 'test-1',
      'countries': [
        {
          'id': 'us',
          'min_fare': 10,
          'fare_negotiation_step': 2,
          'currency_symbol': '\$',
        },
      ],
    });

    final local = XistiRegionCatalog.countries.firstWhere((c) => c.id == 'us');
    final merged = MarketConfigService.overlayCountry(local);
    expect(merged.minFare, 10);
    expect(merged.fareNegotiationStep, 2);
  });
}
