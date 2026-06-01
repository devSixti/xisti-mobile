import '../../../networking/base_dl.dart';

class PassengerRunningPojo {
  PassengerRunningPojo({
    this.status,
    this.message,
    this.messageCode,
    this.rideId,
    this.rideStatus,
    this.rideCompletedStatus,
    this.rideCancelledStatus,
    this.cashPayment,
    this.cardPayment,
    this.walletPayment,
    this.rideDetails,
  });

  PassengerRunningPojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    rideId = json['ride_id'];
    rideStatus = json['ride_status'];
    rideCompletedStatus = json['ride_completed_status'];
    rideCancelledStatus = json['ride_cancelled_status'];
    cashPayment = json['cash_payment'];
    cardPayment = json['card_payment'];
    walletPayment = json['wallet_payment'];
    if (json['ride_details'] != null) {
      rideDetails = [];
      json['ride_details'].forEach((v) {
        rideDetails?.add(RideDetails.fromJson(v));
      });
    }
  }

  int? status;
  String? message;
  int? messageCode;
  int? rideId;
  int? rideStatus;
  int? rideCompletedStatus;
  int? rideCancelledStatus;
  int? cashPayment;
  int? cardPayment;
  int? walletPayment;
  List<RideDetails>? rideDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    map['ride_id'] = rideId;
    map['ride_status'] = rideStatus;
    map['ride_completed_status'] = rideCompletedStatus;
    map['ride_cancelled_status'] = rideCancelledStatus;
    map['cash_payment'] = cashPayment;
    map['card_payment'] = cardPayment;
    map['wallet_payment'] = walletPayment;
    if (rideDetails != null) {
      map['ride_details'] = rideDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// ride_id : 1
/// ride_status : 0
/// offered_price : 85
/// service_id : 1
/// recipient_name : ""
/// recipient_contact_number : ""
/// item_description : ""
/// min_bargain_amt : 76.03
/// max_bargain_amt : 92.93
/// address_list : [{"address":"516, Madhapar, Rajkot, 360006, Gujarat, ","address_lat":"22.318898410847","address_long":"70.767273232341"},{"address":"Saurashtra Kala Kendra Main Road, Shop No. 2, Saurashtra Kala Kendra Main Road, Someshwar Chowk, Rajkot, 360007, Gujarat, ","address_lat":"22.295727939853","address_long":"70.772121325135"}]

class RideDetails {
  RideDetails({
    this.rideId,
    this.rideStatus,
    this.offeredPrice,
    this.serviceId,
    this.recipientName,
    this.recipientContactNumber,
    this.itemDescription,
    this.minBargainAmt,
    this.maxBargainAmt,
    this.estimatePrice,
    this.addressList,
  });

  RideDetails.fromJson(dynamic json) {
    rideId = json['ride_id'];
    rideStatus = json['ride_status'];
    offeredPrice = json['offered_price'];
    serviceId = json['service_id'];
    recipientName = json['recipient_name'];
    recipientContactNumber = json['recipient_contact_number'];
    itemDescription = json['item_description'];
    minBargainAmt = json['min_bargain_amt'];
    maxBargainAmt = json['max_bargain_amt'];
    estimatePrice = json['estimate_price'];
    if (json['address_list'] != null) {
      addressList = [];
      json['address_list'].forEach((v) {
        addressList?.add(AddressListItem.fromJson(v));
      });
    }
  }

  int? rideId;
  int? rideStatus;
  dynamic offeredPrice;
  int? serviceId;
  String? recipientName;
  String? recipientContactNumber;
  String? itemDescription;
  dynamic minBargainAmt;
  dynamic maxBargainAmt;
  dynamic estimatePrice;
  List<AddressListItem>? addressList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ride_id'] = rideId;
    map['ride_status'] = rideStatus;
    map['offered_price'] = offeredPrice;
    map['service_id'] = serviceId;
    map['recipient_name'] = recipientName;
    map['recipient_contact_number'] = recipientContactNumber;
    map['item_description'] = itemDescription;
    map['min_bargain_amt'] = minBargainAmt;
    map['max_bargain_amt'] = maxBargainAmt;
    map['estimate_price'] = estimatePrice;
    if (addressList != null) {
      map['address_list'] = addressList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// status : 1
/// message : "success!"
/// message_code : 1
/// running_rides : [{"ride_id":3,"ride_service_cat_id":4,"ride_status":1,"way_point_status":0}]

class GetRunningServicePojo {
  GetRunningServicePojo({int? status, String? message, int? messageCode, int? isAutoSettle, List<RunningRides>? runningRides}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _isAutoSettle = isAutoSettle;
    _runningRides = runningRides;
  }

  GetRunningServicePojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _isAutoSettle = json['is_auto_settle'];
    if (json['running_rides'] != null) {
      _runningRides = [];
      json['running_rides'].forEach((v) {
        _runningRides?.add(RunningRides.fromJson(v));
      });
    }
  }

  int? _status;
  String? _message;
  int? _messageCode;
  int? _isAutoSettle;
  List<RunningRides>? _runningRides;

  int? get status => _status;

  String? get message => _message;

  int? get messageCode => _messageCode;

  int get isAutoSettle => _isAutoSettle ?? 0;

  List<RunningRides>? get runningRides => _runningRides;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['is_auto_settle'] = _isAutoSettle;
    if (_runningRides != null) {
      map['running_rides'] = _runningRides?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// ride_id : 3
/// ride_service_cat_id : 4
/// ride_status : 1
/// way_point_status : 0

class RunningRides {
  RunningRides({int? rideId, int? rideServiceCatId, int? rideStatus, int? wayPointStatus}) {
    _rideId = rideId;
    _rideServiceCatId = rideServiceCatId;
    _rideStatus = rideStatus;
    _wayPointStatus = wayPointStatus;
  }

  RunningRides.fromJson(dynamic json) {
    _rideId = json['ride_id'];
    _rideServiceCatId = json['ride_service_cat_id'];
    _rideStatus = json['ride_status'];
    _wayPointStatus = json['way_point_status'];
  }

  int? _rideId;
  int? _rideServiceCatId;
  int? _rideStatus;
  int? _wayPointStatus;

  int? get rideId => _rideId;

  int? get rideServiceCatId => _rideServiceCatId;

  int? get rideStatus => _rideStatus;

  int? get wayPointStatus => _wayPointStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ride_id'] = _rideId;
    map['ride_service_cat_id'] = _rideServiceCatId;
    map['ride_status'] = _rideStatus;
    map['way_point_status'] = _wayPointStatus;
    return map;
  }
}

/// status : 1
/// message : "success!"
/// message_code : 1
/// app_version : "1.0"
/// is_forcefully_update : 0

class AppVersionCheckPojo {
  AppVersionCheckPojo({
    int? status,
    String? message,
    int? messageCode,
    String? appKey,
    String? appVersion,
    int? isForcefullyUpdate,
    this.isGoogleLogin,
    this.isFacebookLogin,
    this.isAppleLogin,
    this.isFingerLogin,
  }) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _appVersion = appVersion;
    _appKey = appKey;
    _isForcefullyUpdate = isForcefullyUpdate;
  }

  AppVersionCheckPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _appKey = json['app_key'];
    _messageCode = json['message_code'];
    _appVersion = json['app_version'];
    _isForcefullyUpdate = json['is_forcefully_update'];
    isGoogleLogin = json['is_google_login'];
    isFacebookLogin = json['is_facebook_login'];
    isAppleLogin = json['is_apple_login'];
    isFingerLogin = json['is_finger_login'];
    fareNegotiationStep = json['fare_negotiation_step'];
    vatRateOnCommission = json['vat_rate_on_commission'];
    adminCommissionPercent = json['admin_commission_percent'];
    driverCancelUntilStatus = json['driver_cancel_until_status'];
  }

  int? _status;
  String? _message;
  int? _messageCode;
  String? _appVersion;
  int? _isForcefullyUpdate;
  String? _appKey;
  int? isGoogleLogin;
  int? isFacebookLogin;
  int? isAppleLogin;
  int? isFingerLogin;
  dynamic fareNegotiationStep;
  dynamic vatRateOnCommission;
  dynamic adminCommissionPercent;
  dynamic driverCancelUntilStatus;

  int? get status => _status;

  String? get message => _message;

  int? get messageCode => _messageCode;

  String? get appVersion => _appVersion;

  int? get isForcefullyUpdate => _isForcefullyUpdate;

  String? get appKey => _appKey;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['app_key'] = _appKey;
    map['message_code'] = _messageCode;
    map['app_version'] = _appVersion;
    map['is_forcefully_update'] = _isForcefullyUpdate;
    map['is_google_login'] = isGoogleLogin;
    map['is_facebook_login'] = isFacebookLogin;
    map['is_apple_login'] = isAppleLogin;
    map['is_finger_login'] = isFingerLogin;
    map['fare_negotiation_step'] = fareNegotiationStep;
    map['vat_rate_on_commission'] = vatRateOnCommission;
    map['admin_commission_percent'] = adminCommissionPercent;
    map['driver_cancel_until_status'] = driverCancelUntilStatus;
    return map;
  }
}
