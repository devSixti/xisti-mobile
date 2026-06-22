import 'dart:io';

import '../hive/hive_helper.dart';
import '../networking/api_base_helper.dart';
import '../networking/api_constant.dart';
import 'app_mobile_settings.dart';
import 'mobile_auth_header.dart';

bool isMobileAppAuthConfigured() {
  return getStringFromSettingBox(hiveAuthKey).trim().isNotEmpty;
}

/// Applies [rawKey] from bootstrap APIs unless a compile-time key is configured.
Future<void> applyMobileAppKeyFromApi(String? rawKey) async {
  if (buildTimeAppKey.isNotEmpty) {
    await applyBuildTimeAppKeyIfConfigured();
    return;
  }
  final key = (rawKey ?? '').trim();
  if (key.isEmpty) {
    return;
  }
  await setAuthKey(key);
}

/// Ensures Authorization header can be built (build-time key or bootstrap API).
Future<bool> ensureMobileAppAuthConfigured() async {
  await applyBuildTimeAppKeyIfConfigured();
  if (isMobileAppAuthConfigured()) {
    return true;
  }

  for (final endpoint in [ApiConst.endPointCountryCurrency, ApiConst.endPointAppVersionCheck]) {
    try {
      final response = await ApiBaseHelper().post(
        endpoint,
        body: endpoint == ApiConst.endPointAppVersionCheck
            ? {
                ApiParam.paramLoginDevice: Platform.isAndroid ? 1 : 2,
                ApiParam.paramAppType: 0,
              }
            : {},
        showServerErrorOnFailure: false,
      );
      if (response is Map) {
        await applyMobileAppKeyFromApi(response['app_key']?.toString());
      }
      if (isMobileAppAuthConfigured()) {
        return true;
      }
    } catch (_) {}
  }

  return isMobileAppAuthConfigured();
}
