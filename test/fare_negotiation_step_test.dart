import 'dart:io';

import 'package:app_xisti/constant/constant.dart';
import 'package:app_xisti/hive/hive_helper.dart';
import 'package:app_xisti/utils/app_mobile_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  setUpAll(() async {
    final dir = Directory.systemTemp.createTempSync('app_zimo_hive_test');
    Hive.init(dir.path);
    await initBox();
    await putDataInSettingBox(hiveSelectedCurrency, defaultCurrency);
  });

  tearDownAll(() async {
    await Hive.close();
  });

  test('default fare negotiation step constant is 500 COP', () {
    expect(kColombiaFareNegotiationStep, 500);
  });

  test('getFareNegotiationStepFromSettings falls back to 500 for Colombia', () {
    expect(getFareNegotiationStepFromSettings(), 500);
  });

  test('applyAppMobileSettingsFromJson persists admin fare step', () async {
    applyAppMobileSettingsFromJson({'fare_negotiation_step': 500});
    expect(getFareNegotiationStepFromSettings(), 500);
  });
}
