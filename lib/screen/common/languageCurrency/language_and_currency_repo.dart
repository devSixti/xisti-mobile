import '../../../constant/constant.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class LanguageAndCurrencyRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future getLanguageAndCurrency() async {
    final response = await _apiBaseHelper.post(ApiConst.endPointCountryCurrency, body: {});
    return response;
  }

  Future updateCountryAndCurrency(String languageCode, String currencySymbol) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointUpdateCountryCurrency,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramSelectLanguage: languageCode,
        ApiParam.paramSelectCountryCode: getStringFromUserInfoBox(hiveCountryCode).isNotEmpty
            ? getStringFromUserInfoBox(hiveCountryCode)
            : defaultCountryCode.dialCode!,
        ApiParam.paramSelectCurrency: currencySymbol,
      },
    );
    return response;
  }

  Future updateDeviceTokenApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointUpdateDeviceToken,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramProviderServiceId: 0,
        ApiParam.paramIssueProviderType: ChatWithType.user,
        ApiParam.paramDeviceToken: getStringFromSettingBox(hiveDeviceToken),
      },
    );
    return response;
  }
}
