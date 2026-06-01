import 'dart:convert';

class AddressListPojo {
  int? _status;
  String? _message;
  List<AddressType>? _typeList;
  int? _messageCode;
  int? _maxAddressLimit;

  int get status => _status ?? 0;

  int get messageCode => _messageCode ?? 0;

  int get maxAddressLimit => _maxAddressLimit ?? 0;

  String get message => _message ?? "";

  List<AddressType> get typeList => _typeList ?? [];

  AddressListPojo.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _maxAddressLimit = json["max_address_limit"];
    if (json["type_list"] != null) {
      _typeList = [];
      json["type_list"].forEach((v) {
        _typeList?.add(AddressType.fromJson(v));
      });
    }
    _messageCode = json["message_code"];
  }
}

class AddressType {
  AddressType({int? type, List<ItemManageAddressList>? addressList}) {
    _type = type;
    _addressList = addressList;
  }

  int? _type;
  List<ItemManageAddressList>? _addressList;

  AddressType.fromJson(dynamic json) {
    _type = json["type"];
    if (json["address_list"] != null) {
      _addressList = [];
      json["address_list"].forEach((v) {
        _addressList?.add(ItemManageAddressList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["type"] = _type;
    if (_addressList != null) {
      map['address_list'] = _addressList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  List<ItemManageAddressList> get addressList => _addressList ?? [];

  int get type => _type ?? 0;
}

class ItemManageAddressList {
  ItemManageAddressList({int? addressId, int? addressType, String? address, dynamic lat, dynamic long}) {
    _addressId = addressId;
    _addressType = addressType;
    _address = address;
    _lat = lat;
    _long = long;
  }

  int? _addressId;
  int? _addressType;
  String? _address;
  dynamic _lat;
  dynamic _long;

  int get addressId => _addressId ?? 0;

  String get address => _address ?? "";

  dynamic get lat => _lat;

  dynamic get long => _long;

  int get addressType => _addressType ?? 0;

  ItemManageAddressList.fromJson(dynamic json) {
    _addressId = json["address_id"];
    _addressType = json["address_type"];
    _address = json["address"];
    _lat = json["lat"];
    _long = json["long"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["address_id"] = _addressId;
    map["address_type"] = _addressType;
    map["address"] = _address;
    map["lat"] = _lat;
    map["long"] = _long;
    return map;
  }

  void setAddressType(int value) {
    _addressType = value;
  }

  void setAddress(String value) {
    _address = value;
  }

  void setLat(dynamic value) {
    _lat = value;
  }

  void setLong(dynamic value) {
    _long = value;
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
