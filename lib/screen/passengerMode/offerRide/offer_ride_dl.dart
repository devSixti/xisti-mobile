class OfferRidePojo {
  OfferRidePojo({this.status, this.message, this.messageCode, this.itemDriverBid, this.timeOut});

  OfferRidePojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    timeOut = json['time_out'];
    if (json['driver_bid_list'] != null) {
      itemDriverBid = [];
      json['driver_bid_list'].forEach((v) {
        itemDriverBid?.add(ItemDriverBid.fromJson(v));
      });
    }
  }

  int? status;
  String? message;
  int? messageCode;
  int? timeOut;
  List<ItemDriverBid>? itemDriverBid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    map['time_out'] = timeOut;
    if (itemDriverBid != null) {
      map['driver_bid_list'] = itemDriverBid?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// ride_id : 25
/// driver_id : 305
/// user_id : 304
/// offered_price : 17
/// user_name : "Test Driver"
/// rating : 0
/// vehicle_company : "sthh"
/// model_name : "gigh"
/// vehicle_type_name : "SUV"
/// profile_image : ""
/// distance : 1.04
/// time : 1.56

class ItemDriverBid {
  ItemDriverBid({
    this.rideId,
    this.driverId,
    this.userId,
    this.offeredPrice,
    this.userName,
    this.rating,
    this.vehicleCompany,
    this.modelName,
    this.vehicleTypeName,
    this.profileImage,
    this.distance,
    this.time,
    this.biddingTime,
    this.totalRatings,
    this.timeDiffSeconds,
    this.rideType,
    this.vehicleServiceIcon,
    this.serviceId,
    this.isTaxi,
  });

  ItemDriverBid.fromJson(dynamic json) {
    rideId = json['ride_id'];
    driverId = json['driver_id'];
    userId = json['user_id'];
    offeredPrice = json['offered_price'];
    userName = json['user_name'];
    rating = json['rating'];
    vehicleCompany = json['vehicle_company'];
    modelName = json['model_name'];
    vehicleTypeName = json['vehicle_type_name'];
    profileImage = json['profile_image'];
    distance = json['distance'];
    time = json['time'];
    biddingTime = json['bidding_time'];
    totalRatings = json['total_ratings'];
    timeDiffSeconds = json['time_diff_seconds'];
    rideType = json['ride_type'];
    vehicleServiceIcon = json['vehicle_service_icon'];
    serviceId = json['service_id'];
    isTaxi = json['is_taxi'];
  }

  int? rideId;
  int? driverId;
  int? userId;
  dynamic offeredPrice;
  String? userName;
  dynamic rating;
  String? vehicleCompany;
  String? modelName;
  String? vehicleTypeName;
  String? profileImage;
  String? biddingTime;
  String? vehicleServiceIcon;
  dynamic distance;
  dynamic time;
  int? totalRatings;
  int? timeDiffSeconds;
  int? rideType;
  int? serviceId;
  int? isTaxi;
  bool acceptLoading = false;
  bool rejectLoading = false;

  void setAcceptLoading(bool load) {
    acceptLoading = load;
  }

  void setRejectLoading(bool load) {
    rejectLoading = load;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ride_id'] = rideId;
    map['driver_id'] = driverId;
    map['user_id'] = userId;
    map['offered_price'] = offeredPrice;
    map['user_name'] = userName;
    map['rating'] = rating;
    map['vehicle_company'] = vehicleCompany;
    map['model_name'] = modelName;
    map['vehicle_type_name'] = vehicleTypeName;
    map['profile_image'] = profileImage;
    map['distance'] = distance;
    map['time'] = time;
    map['bidding_time'] = biddingTime;
    map['total_ratings'] = totalRatings;
    map['time_diff_seconds'] = timeDiffSeconds;
    map['ride_type'] = rideType;
    map['vehicle_service_icon'] = vehicleServiceIcon;
    return map;
  }
}
