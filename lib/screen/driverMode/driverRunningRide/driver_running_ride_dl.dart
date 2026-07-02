import '../../../networking/base_dl.dart';

class DriverRunningRidePojo {
  DriverRunningRidePojo({this.status, this.message, this.messageCode, this.rideDetails});

  DriverRunningRidePojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    rideDetails = json['ride_details'] != null ? RideDetails.fromJson(json['ride_details']) : null;
  }

  int? status;
  String? message;
  int? messageCode;
  RideDetails? rideDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    if (rideDetails != null) {
      map['ride_details'] = rideDetails?.toJson();
    }
    return map;
  }
}

/// ride_id : 15
/// user_id : 304
/// driver_id : 306
/// ride_type : 0
/// additional_remark : ""
/// user_fcm_token : "cjNMbEL4TBucWTxTVhHAYa:APA91bFE7zXzQQaLHUBA5FmReUfkypD5qiu_IkLVRJ9woyRBg7GWSmrkwS9eaeep6T9JOHIXqgJnkzQZGQrMEqgXON1bA0ijG7z69dYbaGMRkJSRFlWMMvjjhfxTa8EiA3IzRNBPhxWN"
/// booking_no : 9125607202314067
/// user_profile_image : "https://admin.xistiapp.com/assets/images/profile-images/customer/4261206202313063.jpg"
/// user_name : "Test"
/// contact_number : "+17532"
/// pickup_datetime : "2023-06-14 07:56:12"
/// service_date_time : "2023-06-14 07:56:12"
/// total_amount : 6
/// payment_type : 1
/// ride_status : 1
/// promocode_discount : 0
/// promocode_name : ""
/// otp : 6701
/// pickup_latlong : "22.3188967,70.7671717"
/// destination_latlong : "22.308475447068,70.767306424677"
/// user_rating : 0
/// vehicle_type_name : "SUV"
/// vehicle_company : "tata"
/// model_name : "punch"

/// ride_id : 3
/// user_id : 11
/// driver_id : 2
/// ride_type : 0
/// additional_remark : ""
/// user_fcm_token : ""
/// booking_no : 8091002202504067
/// user_profile_image : ""
/// user_name : "Ft Sahil 2678"
/// contact_number : "+12678"
/// pickup_datetime : "2025-06-04 14:10:09"
/// service_date_time : "2025-06-04 14:10:09"
/// total_amount : 86.5
/// payment_type : 1
/// ride_status : 1
/// refer_discount : 0
/// otp : 5512
/// is_otp : 1
/// user_rating : 0
/// vehicle_type_name : "Hatchback"
/// vehicle_company : "asdfasd"
/// model_name : "fasdf"
/// total_ratings : 0
/// service_id : 1
/// cancel_reason : null
/// recipient_name : ""
/// recipient_contact_number : ""
/// item_description : ""
/// invoice_download_link : ""
/// address_list : [{"address":"2nd, 150 Feet Ring Road, Dhokaliya, Rajkot, 360006, Gujarat, ","address_lat":"22.329261050265","address_long":"70.769545063376"},{"address":"Parameshwar Society, Raiya Ring Road, Radhika Park, Rajkot, 360005, Gujarat, ","address_lat":"22.304502270487","address_long":"70.767581351101"}]
/// ride_for_other : 0
/// other_user_name : null
/// other_user_contact_number : null

class RideDetails {
  RideDetails({
    int? rideId,
    int? userId,
    int? driverId,
    int? rideType,
    String? additionalRemark,
    String? userFcmToken,
    int? bookingNo,
    String? userProfileImage,
    String? userName,
    String? contactNumber,
    String? pickupDatetime,
    String? serviceDateTime,
    dynamic totalAmount,
    int? paymentType,
    int? rideStatus,
    dynamic referDiscount,
    int? otp,
    int? isOtp,
    int? isTollCharge,
    dynamic userRating,
    String? vehicleTypeName,
    String? vehicleCompany,
    String? modelName,
    dynamic totalRatings,
    int? serviceId,
    String? cancelReason,
    String? cancelBy,
    String? recipientName,
    String? recipientContactNumber,
    String? itemDescription,
    String? invoiceDownloadLink,
    List<AddressListItem>? addressList,
    int? rideForOther,
    String? otherUserName,
    String? otherUserContactNumber,
    List<SosContactList>? sosContactList,
    int? wayPointStatus,
    dynamic tollCharge,
    dynamic rideFare,
    dynamic estimatePrice,
    String? vehicleModelName,
    String? vehicleImage,
    String? orderChatNumber,
  }) {
    _rideId = rideId;
    _userId = userId;
    _driverId = driverId;
    _rideType = rideType;
    _additionalRemark = additionalRemark;
    _userFcmToken = userFcmToken;
    _bookingNo = bookingNo;
    _userProfileImage = userProfileImage;
    _userName = userName;
    _contactNumber = contactNumber;
    _pickupDatetime = pickupDatetime;
    _serviceDateTime = serviceDateTime;
    _totalAmount = totalAmount;
    _paymentType = paymentType;
    _rideStatus = rideStatus;
    _referDiscount = referDiscount;
    _otp = otp;
    _isOtp = isOtp;
    _isTollCharge = isTollCharge;
    _userRating = userRating;
    _vehicleTypeName = vehicleTypeName;
    _vehicleCompany = vehicleCompany;
    _modelName = modelName;
    _totalRatings = totalRatings;
    _serviceId = serviceId;
    _cancelReason = cancelReason;
    _recipientName = recipientName;
    _recipientContactNumber = recipientContactNumber;
    _itemDescription = itemDescription;
    _invoiceDownloadLink = invoiceDownloadLink;
    _addressList = addressList;
    _rideForOther = rideForOther;
    _otherUserName = otherUserName;
    _otherUserContactNumber = otherUserContactNumber;
    _sosContactList = sosContactList;
    _wayPointStatus = wayPointStatus;
    _tollCharge = tollCharge;
    _rideFare = rideFare;
    _estimatePrice = estimatePrice;
    _vehicleModelName = vehicleModelName;
    _vehicleImage = vehicleImage;
    _orderChatNumber = orderChatNumber;
    _cancelBy = cancelBy;
  }

  RideDetails.fromJson(dynamic json) {
    _rideId = json['ride_id'];
    _userId = json['user_id'];
    _driverId = json['driver_id'];
    _rideType = json['ride_type'];
    _additionalRemark = json['additional_remark'];
    _userFcmToken = json['user_fcm_token'];
    _bookingNo = json['booking_no'];
    _userProfileImage = json['user_profile_image'];
    _userName = json['user_name'];
    _contactNumber = json['contact_number'];
    _pickupDatetime = json['pickup_datetime'];
    _serviceDateTime = json['service_date_time'];
    _totalAmount = json['total_amount'];
    _paymentType = json['payment_type'];
    _destinationPaymentMethod = json['destination_payment_method'];
    _destinationPaymentLabel = json['destination_payment_label'];
    _rideStatus = json['ride_status'];
    _referDiscount = json['refer_discount'];
    _otp = json['otp'];
    _isOtp = json['is_otp'];
    _isTollCharge = json['is_toll_charge'];
    _userRating = json['user_rating'];
    _vehicleTypeName = json['vehicle_type_name'];
    _vehicleCompany = json['vehicle_company'];
    _modelName = json['model_name'];
    _totalRatings = json['total_ratings'];
    _serviceId = json['service_id'];
    _cancelReason = json['cancel_reason'];
    _cancelBy = json['cancel_by'];
    _recipientName = json['recipient_name'];
    _recipientContactNumber = json['recipient_contact_number'];
    _itemDescription = json['item_description'];
    _invoiceDownloadLink = json['invoice_download_link'];
    _orderChatNumber = json['order_chat_number'];
    _driverCanCancel = json['driver_can_cancel'] is int
        ? json['driver_can_cancel'] as int
        : int.tryParse('${json['driver_can_cancel']}') ?? 0;
    _commissionAmount = json['commission_amount'];
    _vatOnCommission = json['vat_on_commission'];
    _totalDeduction = json['total_deduction'];
    _netDriverPay = json['net_driver_pay'];
    if (json['address_list'] != null) {
      _addressList = [];
      json['address_list'].forEach((v) {
        _addressList?.add(AddressListItem.fromJson(v));
      });
    }
    _rideForOther = json['ride_for_other'];
    _otherUserName = json['other_user_name'];
    _otherUserContactNumber = json['other_user_contact_number'];
    _wayPointStatus = json['way_point_status'];
    _tollCharge = json['toll_charge'];
    _rideFare = json['ride_fare'];
    _estimatePrice = json['estimate_price'];
    _vehicleModelName = json['vehicle_model_name'];
    _vehicleImage = json['vehicle_image'];
    if (json['sos_contact_list'] != null) {
      _sosContactList = [];
      json['sos_contact_list'].forEach((v) {
        _sosContactList?.add(SosContactList.fromJson(v));
      });
    }
  }

  int? _rideId;
  int? _userId;
  int? _driverId;
  int? _rideType;
  String? _additionalRemark;
  String? _userFcmToken;
  int? _bookingNo;
  String? _userProfileImage;
  String? _userName;
  String? _contactNumber;
  String? _pickupDatetime;
  String? _serviceDateTime;
  dynamic _totalAmount;
  int? _paymentType;
  String? _destinationPaymentMethod;
  String? _destinationPaymentLabel;
  int? _rideStatus;
  dynamic _referDiscount;
  int? _otp;
  int? _isOtp;
  int? _isTollCharge;
  dynamic _userRating;
  String? _vehicleTypeName;
  String? _vehicleCompany;
  String? _modelName;
  dynamic _totalRatings;
  int? _serviceId;
  String? _cancelReason;
  String? _cancelBy;
  String? _recipientName;
  String? _recipientContactNumber;
  String? _itemDescription;
  String? _invoiceDownloadLink;
  List<AddressListItem>? _addressList;
  int? _rideForOther;
  String? _otherUserName;
  String? _otherUserContactNumber;
  List<SosContactList>? _sosContactList;
  int? _wayPointStatus;
  dynamic _tollCharge;
  dynamic _rideFare;
  dynamic _estimatePrice;
  String? _vehicleModelName;
  String? _vehicleImage;
  String? _orderChatNumber;
  int? _driverCanCancel;
  dynamic _commissionAmount;
  dynamic _vatOnCommission;
  dynamic _totalDeduction;
  dynamic _netDriverPay;

  int get rideId => _rideId ?? 0;

  int get userId => _userId ?? 0;

  int get driverId => _driverId ?? 0;

  int get rideType => _rideType ?? 0;

  String get additionalRemark => _additionalRemark ?? "";

  String get userFcmToken => _userFcmToken ?? "";

  int get bookingNo => _bookingNo ?? 0;

  String get userProfileImage => _userProfileImage ?? "";

  String get userName => _userName ?? "";

  String get contactNumber => _contactNumber ?? "";

  String get pickupDatetime => _pickupDatetime ?? "";

  String get serviceDateTime => _serviceDateTime ?? "";

  dynamic get totalAmount => _totalAmount ?? "";

  int get paymentType => _paymentType ?? 0;

  String get destinationPaymentMethod => _destinationPaymentMethod ?? '';

  String get destinationPaymentLabel => _destinationPaymentLabel ?? '';

  int get rideStatus => _rideStatus ?? 0;

  dynamic get referDiscount => _referDiscount ?? "0";

  int get otp => _otp ?? 0;

  int get isOtp => _isOtp ?? 0;

  int get isTollCharge => _isTollCharge ?? 0;

  dynamic get userRating => _userRating ?? 0;

  String get vehicleTypeName => _vehicleTypeName ?? "";

  String get vehicleCompany => _vehicleCompany ?? "";

  String get modelName => _modelName ?? "";

  dynamic get totalRatings => _totalRatings ?? "0";

  int get serviceId => _serviceId ?? 0;

  String get cancelReason => _cancelReason ?? "";

  String get cancelBy => _cancelBy ?? "";

  dynamic get tollCharge => _tollCharge ?? 0;

  dynamic get rideFare => _rideFare ?? 0;

  dynamic get estimatePrice => _estimatePrice ?? 0;

  String get recipientName => _recipientName ?? "";

  String get recipientContactNumber => _recipientContactNumber ?? "";

  String get itemDescription => _itemDescription ?? "";

  String get invoiceDownloadLink => _invoiceDownloadLink ?? "";

  List<AddressListItem> get addressList => _addressList ?? [];

  int get rideForOther => _rideForOther ?? 0;

  String get otherUserName => _otherUserName ?? "";

  String get otherUserContactNumber => _otherUserContactNumber ?? "";

  String get vehicleModelName => _vehicleModelName ?? "";

  String get vehicleImage => _vehicleImage ?? "";

  int get wayPointStatus => _wayPointStatus ?? 0;

  List<SosContactList> get sosContactList => _sosContactList ?? [];

  String get orderChatNumber => _orderChatNumber ?? "";

  int get driverCanCancel => _driverCanCancel ?? 0;

  dynamic get commissionAmount => _commissionAmount;

  dynamic get vatOnCommission => _vatOnCommission;

  dynamic get totalDeduction => _totalDeduction;

  dynamic get netDriverPay => _netDriverPay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ride_id'] = _rideId;
    map['user_id'] = _userId;
    map['driver_id'] = _driverId;
    map['ride_type'] = _rideType;
    map['additional_remark'] = _additionalRemark;
    map['user_fcm_token'] = _userFcmToken;
    map['booking_no'] = _bookingNo;
    map['user_profile_image'] = _userProfileImage;
    map['user_name'] = _userName;
    map['contact_number'] = _contactNumber;
    map['pickup_datetime'] = _pickupDatetime;
    map['service_date_time'] = _serviceDateTime;
    map['total_amount'] = _totalAmount;
    map['payment_type'] = _paymentType;
    map['ride_status'] = _rideStatus;
    map['refer_discount'] = _referDiscount;
    map['otp'] = _otp;
    map['is_otp'] = _isOtp;
    map['is_toll_charge'] = _isTollCharge;
    map['user_rating'] = _userRating;
    map['vehicle_type_name'] = _vehicleTypeName;
    map['vehicle_company'] = _vehicleCompany;
    map['model_name'] = _modelName;
    map['total_ratings'] = _totalRatings;
    map['service_id'] = _serviceId;
    map['cancel_reason'] = _cancelReason;
    map['cancel_by'] = _cancelBy;
    map['recipient_name'] = _recipientName;
    map['recipient_contact_number'] = _recipientContactNumber;
    map['item_description'] = _itemDescription;
    map['invoice_download_link'] = _invoiceDownloadLink;
    map['way_point_status'] = _wayPointStatus;
    map['toll_charge'] = _tollCharge;
    map['ride_fare'] = _rideFare;
    map['estimate_price'] = _estimatePrice;
    map['vehicle_model_name'] = _vehicleModelName;
    map['vehicle_image'] = _vehicleImage;
    map["order_chat_number"] = _orderChatNumber;
    if (_addressList != null) {
      map['address_list'] = _addressList?.map((v) => v.toJson()).toList();
    }
    if (_sosContactList != null) {
      map['sos_contact_list'] = _sosContactList?.map((v) => v.toJson()).toList();
    }
    map['ride_for_other'] = _rideForOther;
    map['other_user_name'] = _otherUserName;
    map['other_user_contact_number'] = _otherUserContactNumber;
    return map;
  }
}

/// status : 1
/// message : "Success"
/// message_code : 1
/// ride_id : 15
/// ride_status : 7
/// ride_completed_status : 0
/// ride_cancelled_status : 0
/// driver_current_status : 1
/// cancel_by : ""

class UpdateRideStatusPojo {
  UpdateRideStatusPojo({
    this.status,
    this.message,
    this.messageCode,
    this.rideId,
    this.rideStatus,
    this.rideCompletedStatus,
    this.rideCancelledStatus,
    this.driverCurrentStatus,
    this.cancelBy,
    this.adminReassign,
  });

  UpdateRideStatusPojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    rideId = json['ride_id'];
    rideStatus = json['ride_status'];
    rideCompletedStatus = json['ride_completed_status'];
    rideCancelledStatus = json['ride_cancelled_status'];
    driverCurrentStatus = json['driver_current_status'];
    cancelBy = json['cancel_by'];
    adminReassign = json['admin_reassign'];
  }

  int? status;
  String? message;
  int? messageCode;
  int? rideId;
  int? rideStatus;
  int? rideCompletedStatus;
  int? rideCancelledStatus;
  int? driverCurrentStatus;
  String? cancelBy;
  int? adminReassign;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    map['ride_id'] = rideId;
    map['ride_status'] = rideStatus;
    map['ride_completed_status'] = rideCompletedStatus;
    map['ride_cancelled_status'] = rideCancelledStatus;
    map['driver_current_status'] = driverCurrentStatus;
    map['cancel_by'] = cancelBy;
    map['admin_reassign'] = adminReassign;
    return map;
  }
}
