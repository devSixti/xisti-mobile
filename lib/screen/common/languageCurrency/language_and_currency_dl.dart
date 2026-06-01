class LanguageAndCurrencyResponse {
  int? _status;
  String? _message;
  String? appKey;
  int? _messageCode;
  List<CurrencyListItem>? _currencyList;

  int get status => _status ?? 0;

  int get messageCode => _messageCode ?? 0;

  String get message => _message ?? "";

  List<CurrencyListItem> get currencyList => _currencyList ?? [];

  LanguageAndCurrencyResponse({int? status, String? message, int? messageCode, List<CurrencyListItem>? currencyList, this.appKey}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _currencyList = currencyList;
  }

  LanguageAndCurrencyResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _messageCode = json["message_code"];
    appKey = json["app_key"];
    if (json["currency_list"] != null) {
      _currencyList = [];
      json["currency_list"].forEach((v) {
        _currencyList?.add(CurrencyListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["message_code"] = _messageCode;
    map["app_key"] = appKey;
    if (_currencyList != null) {
      map["currency_list"] = _currencyList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// currency_id : 1
/// currency_name : "Dolar"
/// currency_symbol : "$"
/// currency_code : "USD"

class CurrencyListItem {
  int? _currencyId;
  String? _currencyName;
  String? _currencySymbol;
  String? _currencyCode;

  int get currencyId => _currencyId ?? 0;

  String get currencyName => _currencyName ?? "";

  String get currencySymbol => _currencySymbol ?? "";

  String get currencyCode => _currencyCode ?? "";

  CurrencyListItem({int? currencyId, String? currencyName, String? currencySymbol, String? currencyCode}) {
    _currencyId = currencyId;
    _currencyName = currencyName;
    _currencySymbol = currencySymbol;
    _currencyCode = currencyCode;
  }

  CurrencyListItem.fromJson(dynamic json) {
    _currencyId = json["currency_id"];
    _currencyName = json["currency_name"];
    _currencySymbol = json["currency_symbol"];
    _currencyCode = json["currency_code"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["currency_id"] = _currencyId;
    map["currency_name"] = _currencyName;
    map["currency_symbol"] = _currencySymbol;
    map["currency_code"] = _currencyCode;
    return map;
  }

  @override
  String toString() {
    return currencyName;
  }
}

class LanguageListItem {
  final String languageName;
  final String languageCode;

  LanguageListItem(this.languageName, this.languageCode);

  @override
  String toString() {
    return languageName;
  }
}
class ModelPaymentType {
  int paymentType;
  String name;

  ModelPaymentType(this.paymentType, this.name);

  @override
  String toString() {
    return 'name: $name';
  }
}


class AppThemeListItem {
  final String appThemeName;
  final int appThemeCode;

  AppThemeListItem(this.appThemeName, this.appThemeCode);
}
