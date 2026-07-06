import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';

import '../bottomSheet/server_error_sheet.dart';
import '../hive/hive_helper.dart';
import '../utils/app_mobile_settings.dart';
import '../utils/utils.dart';
import 'api_constant.dart';
import 'api_exceptions.dart';

export 'api_constant.dart';
export 'api_exceptions.dart';
export 'api_response.dart';

class ApiBaseHelper {
  final Dio _dio = Dio();

  ApiBaseHelper({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) {
    _dio.options.baseUrl = baseUrl ?? BaseUrl.baseUrlCustomer;
    _dio.options.connectTimeout = connectTimeout ?? const Duration(minutes: 3);
    _dio.options.receiveTimeout = receiveTimeout ?? const Duration(minutes: 3);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await applyBuildTimeAppKeyIfConfigured();
          if (deviceIpAddress.trim().isEmpty) {
            setDeviceIpAddressInPref();
          }
          options.headers[ApiParam.paramSelectLanguageHeader] = getLanguageFromUserPrefBox();
          options.headers[ApiParam.paramIPAddress] = deviceIpAddress;
          options.headers[ApiParam.paramSelectTimeZone] = localTimeZone;
          options.headers[ApiParam.paramSessionIdHeader] = getStringFromSettingBox(hiveSessionIdHeader, defaultValue: "");
          if ((getStringFromSettingBox(hiveAuthKey)).isNotEmpty) {
            options.headers[ApiParam.headerAuth] = getStringFromSettingBox(hiveAuthKey);
          }
          if (getIntFromUserInfoBox(hiveIsRegister) != 1 && !isSocialLoginType(getStringFromUserInfoBox(hiveLoginType))) {
            options.headers[ApiParam.headerSignupPhoneOtp] = ApiParam.headerSignupPhoneOtpValue;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
    if (!kReleaseMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          canShowLog: kDebugMode,
          queryParameters: true,
          showProcessingTime: false,
          showCUrl: kDebugMode,
          logPrint: kDebugMode ? log : debugPrint,
        ),
      );
    }
  }

  Future<dynamic> get(String url) async {
    dynamic responseJson;
    try {
      final response = await _dio.get(url);
      responseJson = _returnResponse(response);
    } catch (e) {
      // throw FetchDataException('No Internet connection');
      throw _handleError(e);
    }
    return responseJson;
  }

  Future<dynamic> post(String url, {dynamic body, bool showServerErrorOnFailure = true}) async {
    dynamic responseJson;
    try {
      Response response = await _dio.post(url, data: jsonEncode(body));
      responseJson = _returnResponse(response);
    } catch (e) {
      // throw FetchDataException('No Internet connection');
      throw _handleError(e, showServerErrorOnFailure: showServerErrorOnFailure);
    }
    return responseJson;
  }

  Future<dynamic> postFormData(String url, {dynamic body, onProgress}) async {
    dynamic responseJson;
    try {
      Response response = await _dio.post(
        url,
        data: FormData.fromMap(body),
        onSendProgress: (sent, total) => onProgress != null ? onProgress(sent / total) : null,
      );
      responseJson = _returnResponse(response);
    } catch (e) {
      // throw FetchDataException('No Internet connection');
      throw _handleError(e);
    }
    return responseJson;
  }

  Future<dynamic> put(String url, dynamic body) async {
    dynamic responseJson;
    try {
      final response = await _dio.put(url, data: body);
      responseJson = _returnResponse(response);
    } catch (e) {
      // throw FetchDataException('No Internet connection');
      throw _handleError(e);
    }
    debugPrint(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    dynamic apiResponse;
    try {
      final response = await _dio.delete(url);
      apiResponse = _returnResponse(response);
    } catch (e) {
      // throw FetchDataException('No Internet connection');
      throw _handleError(e);
    }
    return apiResponse;
  }
}

class ApiMapHelper {
  final Dio _dio = Dio();

  ApiMapHelper() {
    _dio.options.baseUrl = BaseUrl.mapBaseUrl;
    _dio.options.connectTimeout = const Duration(minutes: 3);
    _dio.options.receiveTimeout = const Duration(minutes: 3);
    if (!kReleaseMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          canShowLog: kDebugMode,
          queryParameters: true,
          showProcessingTime: true,
          showCUrl: kDebugMode,
          logPrint: kDebugMode ? log : debugPrint,
        ),
      );
    }
  }

  Future<dynamic> get(String url) async {
    dynamic responseJson;
    try {
      final response = await _dio.get(url);
      responseJson = _returnResponse(response);
    } catch (e) {
      // throw FetchDataException('No Internet connection');
      throw _handleError(e);
    }
    return responseJson;
  }
}

class ApiFirebaseHelper {
  final Dio _dio = Dio();

  ApiFirebaseHelper(String auth2Token) {
    _dio.options.baseUrl = BaseUrl.firebaseBaseUrl;
    _dio.options.connectTimeout = const Duration(minutes: 3);
    _dio.options.receiveTimeout = const Duration(minutes: 3);
    Map<String, String> requestHeaders = {'Content-type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $auth2Token'};
    _dio.options.headers.addAll(requestHeaders);
    if (!kReleaseMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          canShowLog: kDebugMode,
          queryParameters: true,
          showProcessingTime: true,
          showCUrl: kDebugMode,
          logPrint: kDebugMode ? log : debugPrint,
        ),
      );
    }
  }

  Future<dynamic> postFormData(String url, {dynamic body}) async {
    dynamic responseJson;
    try {
      Response response = await _dio.post(url, data: jsonEncode(body));
      responseJson = _returnResponse(response);
    } catch (e) {
      // throw FetchDataException('No Internet connection');
      throw _handleError(e);
    }
    return responseJson;
  }
}

dynamic _returnResponse(Response response) {
  switch (response.statusCode) {
    case 200:
      return response.data;
    case 400:
      throw BadRequestException(response.data.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.data.toString());
    case 500:
    default:
      throw FetchDataException('Error occurred while Communication with Server (StatusCode : ${response.statusCode})');
  }
}

String _handleError(dynamic error, {bool showServerErrorOnFailure = true}) {
  String errorDescription = "";
  if (error is DioException) {
    DioException dioError = error;
    switch (dioError.type) {
      case DioExceptionType.cancel:
        errorDescription = languages.apiErrorCancelMsg;
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription = languages.apiErrorConnectTimeoutMsg;
        break;
      case DioExceptionType.unknown:
        errorDescription = languages.apiErrorOtherMsg;
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription = languages.apiErrorReceiveTimeoutMsg;
        break;
      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        final context = navigatorKey.currentContext;
        // 401/403 are session/auth failures, not generic server outages.
        if (showServerErrorOnFailure && context != null && statusCode != 401 && statusCode != 403) {
          if (statusCode == 429 && isGoogleMapsDailyLimitResponse(dioError.response?.data)) {
            showServerErrorDialog(context, isShowMapSessionMsg: true);
          } else if (statusCode == 429) {
            openSimpleSnackbar(context, extractApiErrorMessage(dioError.response?.data) ?? languages.apiErrorResponseMsg);
          } else {
            showServerErrorDialog(context);
          }
        }
        // errorDescription = "${languages.apiErrorResponseMsg}: ${dioError.response?.statusCode}";
        break;
      case DioExceptionType.sendTimeout:
        errorDescription = languages.apiErrorSendTimeoutMsg;
        break;
      case DioExceptionType.badCertificate:
        errorDescription = languages.apiErrorOtherMsg;
        break;
      case DioExceptionType.connectionError:
        errorDescription = languages.apiErrorOtherMsg;
        break;
    }
  } else {
    errorDescription = languages.apiErrorUnexpectedErrorMsg;
  }
  return errorDescription;
}

bool isGoogleMapsDailyLimitResponse(dynamic data) {
  if (data is Map) {
    final messageCode = data['message_code'];
    if (messageCode == 429) {
      return true;
    }
    final message = (data['message'] ?? '').toString().toLowerCase();
    return message.contains('google maps');
  }
  if (data is String) {
    return data.toLowerCase().contains('google maps');
  }
  return false;
}

String? extractApiErrorMessage(dynamic data) {
  if (data is Map) {
    final message = data['message'];
    if (message != null && message.toString().trim().isNotEmpty) {
      return message.toString();
    }
  }
  if (data is String && data.trim().isNotEmpty) {
    final trimmed = data.trim();
    if (trimmed.startsWith('<!DOCTYPE') || trimmed.startsWith('<html')) {
      return null;
    }
    return trimmed;
  }
  return null;
}
