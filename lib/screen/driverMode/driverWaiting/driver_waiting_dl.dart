class DriverWaitingPojo {
  DriverWaitingPojo({int? status, String? message, int? messageCode, int? rideStatus, int? bidStatus, int? rideType}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _rideStatus = rideStatus;
    _bidStatus = bidStatus;
    _rideType = rideType;
  }

  DriverWaitingPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _rideStatus = json['ride_status'];
    _bidStatus = json['bid_status'];
    _rideType = json['ride_type'];
  }

  int? _status;
  String? _message;
  int? _messageCode;
  int? _rideStatus;
  int? _bidStatus;
  int? _rideType;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  int get rideStatus => _rideStatus ?? 0;

  int get bidStatus => _bidStatus ?? 0;

  int get rideType => _rideType ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['ride_status'] = _rideStatus;
    map['bid_status'] = _bidStatus;
    map['ride_type'] = _rideType;
    return map;
  }
}
