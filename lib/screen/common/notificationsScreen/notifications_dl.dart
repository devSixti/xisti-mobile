class NotificationsPojo {
  NotificationsPojo({
    int? status,
    String? message,
    int? messageCode,
    int? currentPage,
    int? lastPage,
    int? total,
    List<MassNotificationItem>? massNotificationList,
  }) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _currentPage = currentPage;
    _lastPage = lastPage;
    _total = total;
    _massNotificationList = massNotificationList;
  }

  NotificationsPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _currentPage = json['current_page'];
    _lastPage = json['last_page'];
    _total = json['total'];
    if (json['mass_notification_list'] != null) {
      _massNotificationList = [];
      json['mass_notification_list'].forEach((v) {
        _massNotificationList?.add(MassNotificationItem.fromJson(v));
      });
    }
  }

  int? _status;
  String? _message;
  int? _messageCode;
  int? _currentPage;
  int? _lastPage;
  int? _total;
  List<MassNotificationItem>? _massNotificationList;

  NotificationsPojo copyWith({
    int? status,
    String? message,
    int? messageCode,
    int? currentPage,
    int? lastPage,
    int? total,
    List<MassNotificationItem>? massNotificationList,
  }) =>
      NotificationsPojo(
        status: status ?? _status,
        message: message ?? _message,
        messageCode: messageCode ?? _messageCode,
        currentPage: currentPage ?? _currentPage,
        lastPage: lastPage ?? _lastPage,
        total: total ?? _total,
        massNotificationList: massNotificationList ?? _massNotificationList,
      );

  int get status => _status ?? 1;

  String get message => _message ?? "Success";

  int get messageCode => _messageCode ?? 1;

  int get currentPage => _currentPage ?? 1;

  int get lastPage => _lastPage ?? 1;

  int get total => _total ?? 0;

  List<MassNotificationItem> get massNotificationList => _massNotificationList ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['current_page'] = _currentPage;
    map['last_page'] = _lastPage;
    map['total'] = _total;
    if (_massNotificationList != null) {
      map['mass_notification_list'] = _massNotificationList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 30
/// title : "Greetings, Message!"
/// message : "Hello all, stay safe and good."
/// datetime : "2022-09-08 13:06:59"

class MassNotificationItem {
  MassNotificationItem({
    int? id,
    String? title,
    String? message,
    String? datetime,
  }) {
    _id = id;
    _title = title;
    _message = message;
    _datetime = datetime;
  }

  MassNotificationItem.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _message = json['message'];
    _datetime = json['datetime'];
  }

  int? _id;
  String? _title;
  String? _message;
  String? _datetime;

  MassNotificationItem copyWith({
    int? id,
    String? title,
    String? message,
    String? datetime,
  }) =>
      MassNotificationItem(
        id: id ?? _id,
        title: title ?? _title,
        message: message ?? _message,
        datetime: datetime ?? _datetime,
      );

  int get id => _id ?? 0;

  String get title => _title ?? "";

  String get message => _message ?? "";

  String get datetime => _datetime ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['message'] = _message;
    map['datetime'] = _datetime;
    return map;
  }
}
