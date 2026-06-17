import '../networking/api_base_helper.dart';
import 'market_config_service.dart';

class MarketConfigRepo {
  final ApiBaseHelper _api = ApiBaseHelper(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  );

  Future<Map<String, dynamic>> fetchMarketConfig({
    double? lat,
    double? lng,
    String? countryId,
    String? cityId,
  }) async {
    final body = <String, dynamic>{};
    if (lat != null && lng != null) {
      body[ApiParam.paramCurrentLat] = lat.toString();
      body[ApiParam.paramCurrentLng] = lng.toString();
    }
    if (countryId != null && countryId.isNotEmpty) {
      body['country_id'] = countryId;
    }
    if (cityId != null && cityId.isNotEmpty) {
      body['city_id'] = cityId;
    }

    final response = await _api.post(ApiConst.endPointMarketConfig, body: body);
    if (response is Map<String, dynamic>) {
      return response;
    }
    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }
    return {};
  }
}

Future<bool> syncMarketConfig({
  double? lat,
  double? lng,
  String? countryId,
  String? cityId,
}) async {
  try {
    final repo = MarketConfigRepo();
    final json = await repo.fetchMarketConfig(
      lat: lat,
      lng: lng,
      countryId: countryId,
      cityId: cityId,
    );
    if ((json['status'] ?? 0).toString() == '1') {
      MarketConfigService.applyFromJson(json);
      return true;
    }
  } catch (_) {}
  return false;
}
