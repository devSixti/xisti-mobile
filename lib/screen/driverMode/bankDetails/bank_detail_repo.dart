import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class BankDetailRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future getBankDetailsApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointGetBankDetails,
      body: {ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId), ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken)},
    );
    return response;
  }

  Future updateBankDetailsApi(String accountNumber, String holderName, String bankName, String bankLocation, String paymentEmail, String bicSwiftCode) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointUpdateBankDetails,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramAccountNumber: accountNumber,
        ApiParam.paramHolderName: holderName,
        ApiParam.paramBankName: bankName,
        ApiParam.paramBankLocation: bankLocation,
        ApiParam.paramPaymentEmail: paymentEmail,
        ApiParam.paramBicSwiftCode: bicSwiftCode
      },
    );
    return response;
  }
}
