class ReferralModel {
  ReferralModel({
    this.status,
    this.message,
    this.messageCode,
    this.referInfoList,
    this.usedInfo,
  });

  ReferralModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    if (json['refer_info'] != null) {
      referInfoList = [];
      json['refer_info'].forEach((v) {
        referInfoList?.add(ReferralListItem.fromJson(v));
      });
    }
    usedInfo = json['used_info'] != null ? UsedInfo.fromJson(json['used_info']) : null;
  }

  int? status;
  String? message;
  int? messageCode;
  List<ReferralListItem>? referInfoList;
  UsedInfo? usedInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    if (referInfoList != null) {
      map['refer_info'] = referInfoList?.map((v) => v.toJson()).toList();
    }
    if (usedInfo != null) {
      map['used_info'] = usedInfo?.toJson();
    }
    return map;
  }
}

/// name : "Ft Bond"
/// refer_discount_type : 1
/// refer_discount : 30
/// refer_status : 1

class ReferralListItem {
  ReferralListItem({
    this.name,
    this.referDiscountType,
    this.referDiscount,
    this.referStatus,
    this.profileImage,
  });

  ReferralListItem.fromJson(dynamic json) {
    name = json['name'];
    referDiscountType = json['refer_discount_type'];
    referDiscount = json['refer_discount'];
    referStatus = json['refer_status'];
    profileImage = json['profile_image'];
  }

  String? name;
  int? referDiscountType;
  dynamic referDiscount;
  int? referStatus;
  String? profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['refer_discount_type'] = referDiscountType;
    map['refer_discount'] = referDiscount;
    map['refer_status'] = referStatus;
    map['profile_image'] = profileImage;
    return map;
  }
}

/// name : "User Prashant"
/// user_discount_type : 1
/// user_discount : 20
/// user_status : 0

class UsedInfo {
  UsedInfo({
    this.name,
    this.userDiscountType,
    this.userDiscount,
    this.userStatus,
  });

  UsedInfo.fromJson(dynamic json) {
    name = json['name'];
    userDiscountType = json['user_discount_type'];
    userDiscount = json['user_discount'];
    userStatus = json['user_status'];
  }

  String? name;
  int? userDiscountType;
  dynamic userDiscount;
  int? userStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['user_discount_type'] = userDiscountType;
    map['user_discount'] = userDiscount;
    map['user_status'] = userStatus;
    return map;
  }
}
