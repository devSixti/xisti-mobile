class LoginPojo {
  int? status;
  String? message;
  int? messageCode;
  int? userId;
  int? userVerified;
  int? isRegister;
  int? cashPayment;
  int? onlinePayment;
  int? walletPayment;
  String? userName;
  String? accessToken;
  String? email;
  String? uniqueId;
  String? loginType;
  String? profileImage;
  dynamic gender;
  String? contactNumber;
  String? referralCode;
  String? selectCountryCode;
  String? selectCurrency;
  String? selectLanguage;
  String? emergencyContact;
  String? emergencyContactName;
  String? emergencyCountryCode;
  String? serverTimeZone;
  int? driverDocStatus;
  int? isDriverStatus;
  int? isDriverType;
  int? driverVehicleStatus;
  int? activeMode;
  dynamic fareNegotiationStep;
  dynamic vatRateOnCommission;
  dynamic adminCommissionPercent;
  dynamic driverCancelUntilStatus;
  String? otpDeliveryChannel;

  LoginPojo({
    this.status,
    this.message,
    this.messageCode,
    this.userId,
    this.userVerified,
    this.isRegister,
    this.accessToken,
    this.email,
    this.loginType,
    this.profileImage,
    this.gender,
    this.contactNumber,
    this.referralCode,
    this.selectCountryCode,
    this.selectCurrency,
    this.selectLanguage,
    this.emergencyContact,
    this.serverTimeZone,
    this.cashPayment,
    this.onlinePayment,
    this.walletPayment,
    this.driverDocStatus,
    this.isDriverStatus,
    this.isDriverType,
    this.driverVehicleStatus,
    this.activeMode,
    this.emergencyCountryCode,
    this.emergencyContactName,
    this.uniqueId,
  });

  LoginPojo.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    messageCode = json["message_code"];
    userId = json["user_id"];
    userVerified = json["user_verified"];
    userName = json["user_name"];
    accessToken = json["access_token"]?.toString();
    isRegister = json["is_register"];
    email = json["email"];
    loginType = json["login_type"];
    profileImage = json["profile_image"];
    gender = json["gender"];
    contactNumber = json["contact_number"];
    referralCode = json["referral_code"];
    selectCountryCode = json["select_country_code"];
    selectCurrency = json["select_currency"];
    selectLanguage = json["select_language"];
    emergencyContact = json["emergency_contact"];
    emergencyContactName = json["emergency_contact_name"];
    emergencyCountryCode = json["emergency_country_code"];
    serverTimeZone = json["server_time_zone"];
    cashPayment = json['cash_payment'];
    onlinePayment = json['online_payment'];
    walletPayment = json['wallet_payment'];
    isDriverType = json['is_driver_type'];
    isDriverStatus = json['is_driver_status'];
    driverDocStatus = json['driver_doc_status'];
    driverVehicleStatus = json['driver_vehicle_status'];
    activeMode = json['active_mode'];
    uniqueId = json['unique_id'];
    fareNegotiationStep = json['fare_negotiation_step'];
    vatRateOnCommission = json['vat_rate_on_commission'];
    adminCommissionPercent = json['admin_commission_percent'];
    driverCancelUntilStatus = json['driver_cancel_until_status'];
    otpDeliveryChannel = json['otp_delivery_channel']?.toString();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    map["message_code"] = messageCode;
    map["user_id"] = userId;
    map["user_verified"] = userVerified;
    map["user_name"] = userName;
    map["access_token"] = accessToken;
    map["is_register"] = isRegister;
    map["email"] = email;
    map["login_type"] = loginType;
    map["profile_image"] = profileImage;
    map["gender"] = gender;
    map["contact_number"] = contactNumber;
    map["referral_code"] = referralCode;
    map["select_country_code"] = selectCountryCode;
    map["select_currency"] = selectCurrency;
    map["select_language"] = selectLanguage;
    map["emergency_contact"] = emergencyContact;
    map["emergency_contact_name"] = emergencyContactName;
    map["emergency_country_code"] = emergencyCountryCode;
    map["server_time_zone"] = serverTimeZone;
    map['cash_payment'] = cashPayment;
    map['online_payment'] = onlinePayment;
    map['wallet_payment'] = walletPayment;
    map['is_driver_type'] = isDriverType;
    map['is_driver_status'] = isDriverStatus;
    map['driver_doc_status'] = driverDocStatus;
    map['driver_vehicle_status'] = driverVehicleStatus;
    map['active_mode'] = activeMode;
    map['unique_id'] = uniqueId;
    map['fare_negotiation_step'] = fareNegotiationStep;
    map['vat_rate_on_commission'] = vatRateOnCommission;
    map['admin_commission_percent'] = adminCommissionPercent;
    map['driver_cancel_until_status'] = driverCancelUntilStatus;
    map['otp_delivery_channel'] = otpDeliveryChannel;
    return map;
  }
}
