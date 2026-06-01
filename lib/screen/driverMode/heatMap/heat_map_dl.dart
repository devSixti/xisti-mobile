class HeatMapModel {
  int? _status;
  int? _messageCode;
  String? _message;
  String? _heatMapUrl;

  HeatMapModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _heatMapUrl = json['heat_map_url'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['heat_map_url'] = _heatMapUrl;
    return map;
  }

  String get heatMapUrl => _heatMapUrl ?? "";

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  int get status => _status ?? 0;
}
