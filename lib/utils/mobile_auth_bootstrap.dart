import '../hive/hive_helper.dart';
import '../networking/api_base_helper.dart';
import '../networking/api_constant.dart';
import 'app_mobile_settings.dart';
import 'mobile_auth_header.dart';

bool isMobileAppAuthConfigured() {
  return getStringFromSettingBox(hiveAuthKey).trim().isNotEmpty;
}

/// Applies [rawKey] from bootstrap APIs unless a compile-time key is configured.
void applyMobileAppKeyFromApi(String? rawKey) {
  if (buildTimeAppKey.isNotEmpty) {
    applyBuildTimeAppKeyIfConfigured();
    return;
  }
  final key = (rawKey ?? '').trim();
  if (key.isEmpty) {
    return;
  }
  setAuthKey(key);
}

/// Ensures Authorization header can be built (build-time key or bootstrap API).
Future<bool> ensureMobileAppAuthConfigured() async {
  applyBuildTimeAppKeyIfConfigured();
  if (isMobileAppAuthConfigured()) {
    return true;
  }

  try {
    final response = await ApiBaseHelper().post(
      ApiConst.endPointCountryCurrency,
      body: {},
      showServerErrorOnFailure: false,
    );
    if (response is Map) {
      applyMobileAppKeyFromApi(response['app_key']?.toString());
    }
  } catch (_) {}

  return isMobileAppAuthConfigured();
}
