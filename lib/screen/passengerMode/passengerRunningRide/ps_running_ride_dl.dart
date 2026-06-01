import 'package:flutter/material.dart';

import '../../../networking/base_dl.dart';

class PassengerRunningRidePojo {
  PassengerRunningRidePojo({
    this.status,
    this.message,
    this.messageCode,
    this.rideId,
    this.additionalRemark,
    this.bookingType,
    this.bookingNo,
    this.pickupDateTime,
    this.serviceDateTime,
    this.rideStatus,
    this.cancelBy,
    this.cancelReason,
    this.serviceType,
    this.serviceTypeIcon,
    this.userRatingStatus,
    this.serviceId,
    this.otp,
    this.isOtp,
    this.recipientName,
    this.recipientContactNumber,
    this.itemDescription,
    this.estimatePrice,
    this.cashPayment,
    this.onlinePayment,
    this.walletPayment,
    this.invoiceDownloadLink,
    this.waypointMsgCode,
    this.waypointMessage,
    this.addressList,
    this.rideForOther,
    this.otherUserName,
    this.otherUserContactNumber,
    this.driverId,
    this.driverName,
    this.driverRating,
    this.driverProfile,
    this.contactNumber,
    this.driverFcmToken,
    this.totalRatings,
    this.vehicleTypeName,
    this.vehicleManufactureName,
    this.vehiclePlatNo,
    this.vehicleModelYear,
    this.vehicleModelName,
    this.vehicleColor,
    this.vehicleImage,
    this.totalDistance,
    this.estimatedTime,
    this.orderChatNumber,
    this.userRefundStatus,
    this.refundAmount,
    this.referDiscount,
    this.totalPay,
    this.payment,
    this.paymentStatus,
    this.sosContactList,
    this.rideFare,
    this.tollCharge,
    this.rideType,
  });

  void setPaymentStatus(int paymentStatus) {
    this.paymentStatus = paymentStatus;
  }

  void setRideStatus(int rideStatus) {
    this.rideStatus = rideStatus;
  }

  PassengerRunningRidePojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    rideId = json['ride_id'];
    additionalRemark = json['additional_remark'];
    bookingType = json['booking_type'];
    bookingNo = json['booking_no'];
    pickupDateTime = json['pickup_date_time'];
    serviceDateTime = json['service_date_time'];
    rideStatus = json['ride_status'];
    cancelBy = json['cancel_by'];
    cancelReason = json['cancel_reason'];
    serviceType = json['service_type'];
    serviceTypeIcon = json['service_type_icon'];
    userRatingStatus = json['user_rating_status'];
    serviceId = json['service_id'];
    otp = json['otp'];
    isOtp = json['is_otp'];
    recipientName = json['recipient_name'];
    recipientContactNumber = json['recipient_contact_number'];
    itemDescription = json['item_description'];
    cashPayment = json['cash_payment'];
    onlinePayment = json['online_payment'];
    walletPayment = json['wallet_payment'];
    invoiceDownloadLink = json['invoice_download_link'];
    waypointMsgCode = json['waypoint_msg_code'];
    waypointMessage = json['waypoint_message'];
    rideType = json['ride_type'];
    if (json['address_list'] != null) {
      addressList = [];
      json['address_list'].forEach((v) {
        addressList?.add(AddressListItem.fromJson(v));
      });
    }
    rideForOther = json['ride_for_other'];
    otherUserName = json['other_user_name'];
    otherUserContactNumber = json['other_user_contact_number'];
    driverId = json['driver_id'];
    driverName = json['driver_name'];
    driverRating = json['driver_rating'];
    driverProfile = json['driver_profile'];
    contactNumber = json['contact_number'];
    driverFcmToken = json['driver_fcm_token'];
    totalRatings = json['total_ratings'];
    vehicleTypeName = json['vehicle_type_name'];
    vehicleManufactureName = json['vehicle_manufacture_name'];
    vehiclePlatNo = json['vehicle_plat_no'];
    vehicleModelYear = json['vehicle_model_year'];
    vehicleModelName = json['vehicle_model_name'];
    vehicleColor = json['vehicle_color'];
    vehicleImage = json['vehicle_image'];
    totalDistance = json['total_distance'];
    estimatedTime = json['estimated_time'];
    userRefundStatus = json['user_refund_status'];
    refundAmount = json['refund_amount'];
    referDiscount = json['refer_discount'];
    totalPay = json['total_pay'];
    payment = json['payment'];
    paymentStatus = json['payment_status'];
    estimatePrice = json['estimate_price'];
    rideFare = json['ride_fare'];
    tollCharge = json['toll_charge'];
    orderChatNumber = json['order_chat_number'];
    if (json["sos_contact_list"] != null) {
      sosContactList = [];
      json["sos_contact_list"].forEach((v) {
        sosContactList?.add(SosContactList.fromJson(v));
      });
    }
  }

  int? status;
  String? message;
  int? messageCode;
  int? rideId;
  String? additionalRemark;
  int? bookingType;
  String? bookingNo;
  String? pickupDateTime;
  String? serviceDateTime;
  int? rideStatus;
  String? cancelBy;
  String? cancelReason;
  String? serviceType;
  String? serviceTypeIcon;
  int? userRatingStatus;
  int? serviceId;
  String? otp;
  int? isOtp;
  String? recipientName;
  String? recipientContactNumber;
  dynamic estimatePrice;
  String? itemDescription;
  int? cashPayment;
  int? onlinePayment;
  int? walletPayment;
  String? invoiceDownloadLink;
  int? waypointMsgCode;
  String? waypointMessage;
  List<AddressListItem>? addressList;
  int? rideForOther;
  String? otherUserName;
  String? otherUserContactNumber;
  int? driverId;
  String? driverName;
  dynamic driverRating;
  String? driverProfile;
  String? contactNumber;
  String? driverFcmToken;
  int? totalRatings;
  String? vehicleTypeName;
  String? vehicleManufactureName;
  String? vehiclePlatNo;
  int? vehicleModelYear;
  String? vehicleModelName;
  String? vehicleColor;
  String? vehicleImage;
  String? totalDistance;
  String? estimatedTime;
  String? orderChatNumber;
  int? userRefundStatus;
  dynamic refundAmount;
  dynamic referDiscount;
  dynamic totalPay;
  dynamic rideFare;
  dynamic tollCharge;
  int? payment;
  int? paymentStatus;
  int? rideType;
  List<SosContactList>? sosContactList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    map['ride_id'] = rideId;
    map['additional_remark'] = additionalRemark;
    map['booking_type'] = bookingType;
    map['booking_no'] = bookingNo;
    map['pickup_date_time'] = pickupDateTime;
    map['service_date_time'] = serviceDateTime;
    map['ride_status'] = rideStatus;
    map['cancel_by'] = cancelBy;
    map['cancel_reason'] = cancelReason;
    map['service_type'] = serviceType;
    map['service_type_icon'] = serviceTypeIcon;
    map['user_rating_status'] = userRatingStatus;
    map['service_id'] = serviceId;
    map['otp'] = otp;
    map['is_otp'] = isOtp;
    map['recipient_name'] = recipientName;
    map['recipient_contact_number'] = recipientContactNumber;
    map['item_description'] = itemDescription;
    map['cash_payment'] = cashPayment;
    map['online_payment'] = onlinePayment;
    map['wallet_payment'] = walletPayment;
    map['invoice_download_link'] = invoiceDownloadLink;
    map['waypoint_msg_code'] = waypointMsgCode;
    map['waypoint_message'] = waypointMessage;
    if (addressList != null) {
      map['address_list'] = addressList?.map((v) => v.toJson()).toList();
    }
    if (sosContactList != null) {
      map["sos_contact_list"] = sosContactList?.map((v) => v.toJson()).toList();
    }
    map['ride_for_other'] = rideForOther;
    map['other_user_name'] = otherUserName;
    map['other_user_contact_number'] = otherUserContactNumber;
    map['driver_id'] = driverId;
    map['driver_name'] = driverName;
    map['driver_rating'] = driverRating;
    map['driver_profile'] = driverProfile;
    map['contact_number'] = contactNumber;
    map['driver_fcm_token'] = driverFcmToken;
    map['total_ratings'] = totalRatings;
    map['vehicle_type_name'] = vehicleTypeName;
    map['vehicle_manufacture_name'] = vehicleManufactureName;
    map['vehicle_plat_no'] = vehiclePlatNo;
    map['vehicle_model_year'] = vehicleModelYear;
    map['vehicle_model_name'] = vehicleModelName;
    map['vehicle_color'] = vehicleColor;
    map['vehicle_image'] = vehicleImage;
    map['total_distance'] = totalDistance;
    map['estimated_time'] = estimatedTime;
    map['user_refund_status'] = userRefundStatus;
    map['refund_amount'] = refundAmount;
    map['refer_discount'] = referDiscount;
    map['total_pay'] = totalPay;
    map['payment'] = payment;
    map['payment_status'] = paymentStatus;
    map['estimate_price'] = estimatePrice;
    map['ride_fare'] = rideFare;
    map['toll_charge'] = tollCharge;
    map['order_chat_number'] = orderChatNumber;
    map['ride_type'] = rideType;
    return map;
  }
}

class SelectPaymentMethodItem {
  int type;
  int id;
  String name;
  String secondaryText;
  IconData icon;

  SelectPaymentMethodItem({required this.id, required this.type, required this.name, required this.icon, this.secondaryText = ""});
}

class PaymentBaseModel {
  int? _status;
  String? _message;
  int? _messageCode;
  int? _rideStatus;
  String? _redirectUrl;
  String? _successUrl;
  String? _failedUrl;

  int? get status => _status;

  String? get message => _message;

  int? get messageCode => _messageCode;

  int? get rideStatus => _rideStatus;

  String? get redirectUrl => _redirectUrl;

  String? get successUrl => _successUrl;

  String? get failedUrl => _failedUrl;

  PaymentBaseModel({int? status, String? message, int? messageCode, int? rideStatus, String? redirectUrl, String? successUrl, String? failedUrl}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _rideStatus = rideStatus;
    _redirectUrl = redirectUrl;
    _successUrl = successUrl;
    _failedUrl = failedUrl;
  }

  PaymentBaseModel.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _messageCode = json["message_code"];
    _rideStatus = json["ride_status"];
    _redirectUrl = json["redirect_url"];
    _successUrl = json["success_url"];
    _failedUrl = json["failed_url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["message_code"] = _messageCode;
    map["ride_status"] = _rideStatus;
    map["redirect_url"] = _redirectUrl;
    map["success_url"] = _successUrl;
    map["failed_url"] = _failedUrl;
    return map;
  }
}
