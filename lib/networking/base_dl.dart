import 'dart:convert';

/// status : 1
/// message : "success!"
/// message_code : 1

class BaseModel {
  int? _status;
  String? _message;
  int? _messageCode;
  String? _otpDeliveryChannel;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  String get otpDeliveryChannel => _otpDeliveryChannel ?? '';

  BaseModel({int? status, String? message, int? messageCode, String? otpDeliveryChannel}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _otpDeliveryChannel = otpDeliveryChannel;
  }

  BaseModel.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _messageCode = json["message_code"];
    _otpDeliveryChannel = json["otp_delivery_channel"]?.toString();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["message_code"] = _messageCode;
    map["otp_delivery_channel"] = _otpDeliveryChannel;
    return map;
  }
}

class KeyValueModel {
  bool? setDivider, setBold, setValueWithCurrency;
  Function()? setButton;
  String key, value;

  KeyValueModel(this.setDivider, this.setBold, this.setValueWithCurrency, this.key, this.value, {this.setButton});
}

class HistoryFilterModel {
  int filterType;
  String filterName;

  HistoryFilterModel(this.filterType, this.filterName);

  @override
  String toString() {
    return filterName;
  }
}

/// address : "516, Madhapar, Rajkot, 360006, Gujarat, "
/// address_lat : "22.318898410847"
/// address_long : "70.767273232341"

class AddressListItem {
  AddressListItem({String? address, dynamic addressLat, dynamic addressLong}) {
    _address = address;
    _addressLat = addressLat;
    _addressLong = addressLong;
  }

  AddressListItem.fromJson(dynamic json) {
    _address = json['address'];
    _addressLat = json['address_lat'];
    _addressLong = json['address_long'];
  }

  String? _address;
  dynamic _addressLat;
  dynamic _addressLong;

  String get address => _address ?? "";

  dynamic get addressLat => _addressLat ?? "";

  dynamic get addressLong => _addressLong ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['address_lat'] = _addressLat;
    map['address_long'] = _addressLong;
    return map;
  }
}

class NotificationPojo {
  NotificationPojo({
    this.titleCode,
    this.notificationType,
    this.rideId,
    this.messageCode,
    this.sound,
    this.body,
    this.title,
    this.clickAction,
    this.message,
    this.pickupAddress,
    this.destinationAddress,
    this.offeredPrice,
  });

  NotificationPojo.fromJson(dynamic json) {
    titleCode = json['title_code'];
    notificationType = json['notification_type'];
    rideId = json['ride_id'];
    messageCode = json['message_code'];
    sound = json['sound'];
    body = json['body'];
    title = json['title'];
    clickAction = json['click_action'];
    message = json['message'];
    pickupAddress = json['pickup_address'];
    destinationAddress = json['destination_address'];
    offeredPrice = json['offered_price'];
  }

  String? titleCode;
  String? notificationType;
  String? rideId;
  String? messageCode;
  String? sound;
  String? body;
  String? title;
  String? clickAction;
  String? message;
  String? pickupAddress;
  String? destinationAddress;
  String? offeredPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title_code'] = titleCode;
    map['notification_type'] = notificationType;
    map['ride_id'] = rideId;
    map['message_code'] = messageCode;
    map['sound'] = sound;
    map['body'] = body;
    map['title'] = title;
    map['click_action'] = clickAction;
    map['message'] = message;
    map['pickup_address'] = pickupAddress;
    map['destination_address'] = destinationAddress;
    map['offered_price'] = offeredPrice;
    return map;
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

class SosContactList {
  SosContactList({int? id, String? name, String? countryCode, String? contactNumber}) {
    _id = id;
    _name = name;
    _countryCode = countryCode;
    _contactNumber = contactNumber;
  }

  SosContactList.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _countryCode = json['country_code'];
    _contactNumber = json['contact_number'];
  }

  int? _id;
  String? _name;
  String? _countryCode;
  String? _contactNumber;

  int get id => _id ?? 0;

  String get name => _name ?? "";

  String get countryCode => _countryCode ?? "";

  String get contactNumber => _contactNumber ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['country_code'] = _countryCode;
    map['contact_number'] = _contactNumber;
    return map;
  }
}
