import 'package:flutter/material.dart';

class ActiveModePojo {
  ActiveModePojo({this.status, this.message, this.messageCode, this.activeMode, this.cashPayment, this.onlinePayment, this.walletPayment});

  ActiveModePojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    activeMode = json['active_mode'];
    messageCode = json['message_code'];
    cashPayment = json['cash_payment'];
    onlinePayment = json['online_payment'];
    walletPayment = json['wallet_payment'];
  }

  int? status;
  String? message;
  int? activeMode;
  int? messageCode;
  int? cashPayment;
  int? onlinePayment;
  int? walletPayment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['active_mode'] = activeMode;
    map['message_code'] = messageCode;
    map['cash_payment'] = cashPayment;
    map['online_payment'] = onlinePayment;
    map['wallet_payment'] = walletPayment;
    return map;
  }
}

/// status : 1
/// message : "Success"
/// message_code : 1
/// is_driver_type : 1
/// is_driver_status : 1
/// driver_doc_status : 1
/// driver_vehicle_status : 1

class DriverServiceStatusPojo {
  DriverServiceStatusPojo({
    this.status,
    this.message,
    this.messageCode,
    this.isDriverType,
    this.isDriverStatus,
    this.driverDocStatus,
    this.driverVehicleStatus,
    this.rejectReason,
  });

  DriverServiceStatusPojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    isDriverType = json['is_driver_type'];
    isDriverStatus = json['is_driver_status'];
    driverDocStatus = json['driver_doc_status'];
    driverVehicleStatus = json['driver_vehicle_status'];
    rejectReason = json['reject_reason'];
  }

  int? status;
  String? message;
  int? messageCode;
  int? isDriverType;
  int? isDriverStatus;
  int? driverDocStatus;
  int? driverVehicleStatus;
  String? rejectReason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    map['is_driver_type'] = isDriverType;
    map['is_driver_status'] = isDriverStatus;
    map['driver_doc_status'] = driverDocStatus;
    map['driver_vehicle_status'] = driverVehicleStatus;
    map['reject_reason'] = rejectReason;
    return map;
  }
}

class AccountItem {
  IconData icon;
  String name;
  AccountEnum accountEnum;
  bool isEmailAndNumberCheck;

  AccountItem(this.accountEnum, this.icon, this.name, {this.isEmailAndNumberCheck = false});
}

enum AccountEnum {
  rideHistory,
  notification,
  wallet,
  referHistory,
  myPreference,
  emergencyContact,
  inviteFriend,
  reportIssue,
  help,
  manageAccount,
  manageAddress,
  manageInformation,
  heatMap,
  bankDetails,
  rating,
}

class ManageAccountItem {
  IconData icon;
  String name;
  ManageAccountEnum manageAccountEnum;
  double? size;

  ManageAccountItem(this.manageAccountEnum, this.icon, this.name, {this.size});
}

enum ManageAccountEnum { logout, deleteAccount }

class ManageInformationItem {
  IconData icon;
  String name;
  ManageInformationEnum manageAccountEnum;
  double? size;
  bool status;

  ManageInformationItem(this.manageAccountEnum, this.icon, this.name, this.status, {this.size});
}

enum ManageInformationEnum { vehicleDetail, requireDocument }
