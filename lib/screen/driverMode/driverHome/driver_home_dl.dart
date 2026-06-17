import '../../../networking/base_dl.dart';

/// status : 1
/// message : "Success"
/// message_code : 1
/// search_radius : [{"id":1,"radius":2},{"id":2,"radius":5},{"id":3,"radius":10}]
/// search_distance_filter : 0

class DriverHomePojo {
  DriverHomePojo({
    int? status,
    String? message,
    int? messageCode,
    List<SearchRadius>? searchRadius,
    dynamic searchDistanceFilter,
    int? driverCurrentStatus,
    int? isHailRide,
    int? cashPayment,
    int? onlinePayment,
    int? walletPayment,
    int? serviceId,
    int? acceptTransport,
    int? acceptDelivery,
  }) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _searchRadius = searchRadius;
    _searchDistanceFilter = searchDistanceFilter;
    _driverCurrentStatus = driverCurrentStatus;
    _isHailRide = isHailRide;
    _cashPayment = cashPayment;
    _onlinePayment = onlinePayment;
    _walletPayment = walletPayment;
    _serviceId = serviceId;
    _acceptTransport = acceptTransport;
    _acceptDelivery = acceptDelivery;
  }

  DriverHomePojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    if (json['search_radius'] != null) {
      _searchRadius = [];
      json['search_radius'].forEach((v) {
        _searchRadius?.add(SearchRadius.fromJson(v));
      });
    }
    _searchDistanceFilter = json['search_distance_filter'];
    _driverCurrentStatus = json['driver_current_status'];
    _isHailRide = json['is_hail_ride'];
    _cashPayment = json['cash_payment'];
    _onlinePayment = json['online_payment'];
    _walletPayment = json['wallet_payment'];
    _serviceId = json['service_id'];
    _acceptTransport = json['accept_transport'];
    _acceptDelivery = json['accept_delivery'];
  }

  int? _status;
  String? _message;
  int? _messageCode;
  List<SearchRadius>? _searchRadius;
  dynamic _searchDistanceFilter;
  int? _serviceId;
  int? _driverCurrentStatus;
  int? _isHailRide;
  int? _cashPayment;
  int? _onlinePayment;
  int? _walletPayment;
  int? _acceptTransport;
  int? _acceptDelivery;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  List<SearchRadius> get searchRadius => _searchRadius ?? [];

  dynamic get searchDistanceFilter => _searchDistanceFilter ?? 0;

  int get driverCurrentStatus => _driverCurrentStatus ?? 0;

  int get isHailRide => _isHailRide ?? 0;

  int get cashPayment => _cashPayment ?? 0;

  int get onlinePayment => _onlinePayment ?? 0;

  int get walletPayment => _walletPayment ?? 0;

  int get serviceId => _serviceId ?? 0;

  int get acceptTransport => _acceptTransport ?? 1;

  int get acceptDelivery => _acceptDelivery ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    if (_searchRadius != null) {
      map['search_radius'] = _searchRadius?.map((v) => v.toJson()).toList();
    }
    map['search_distance_filter'] = _searchDistanceFilter;
    map['driver_current_status'] = _driverCurrentStatus;
    map['is_hail_ride'] = _isHailRide;
    map['cash_payment'] = _cashPayment;
    map['online_payment'] = _onlinePayment;
    map['wallet_payment'] = _walletPayment;
    map['service_id'] = _serviceId;
    return map;
  }
}

/// id : 1
/// radius : 2

class SearchRadius {
  SearchRadius({int? id, dynamic radius}) {
    _id = id;
    _radius = radius;
  }

  SearchRadius.fromJson(dynamic json) {
    _id = json['id'];
    _radius = json['radius'];
  }

  int? _id;
  dynamic _radius;

  int get id => _id ?? 0;

  dynamic get radius => _radius ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['radius'] = _radius;
    return map;
  }
}

/// status : 1
/// message : "Success"
/// message_code : 1
/// ride_list : [{"ride_id":22,"ride_no":8555710202505064,"pickup_address":"150 Feet Ring Road, The Spire, 150 Feet Ring Road, Dharam Nagar Society, Rajkot, 360006, Gujarat, ","destination_address":"Indira Circle, Rajkot, Gujarat, India","rating":0,"user_name":"Ft Jeel 177","pickup_lat":"22.318748293931","pickup_long":"70.767113305628","user_id":17,"service_id":1,"offered_price":97.46,"total_ratings":0,"additional_remarks":"","recipient_name":null,"recipient_contact_number":null,"item_description":null,"destination_lat":"22.2883798","destination_long":"70.7709278","profile_image":"","order_time":"54sec ago","distance":0.03,"time":0.05,"address_list":[{"address":"150 Feet Ring Road, The Spire, 150 Feet Ring Road, Dharam Nagar Society, Rajkot, 360006, Gujarat, ","address_lat":"22.318748293931","address_long":"70.767113305628"},{"address":"Indira Circle, Rajkot, Gujarat, India","address_lat":"22.2883798","address_long":"70.7709278"}]}]
/// service : {"service_id":1,"service_name":"Taxi","cost_for_km":22,"min_offer_fare_amount":10}
/// nearest_ride_popup : 5
/// driver_price_suggestion : 1

class AvailableRidePojo {
  AvailableRidePojo({
    int? status,
    String? message,
    int? messageCode,
    List<RideList>? rideList,
    Service? service,
    dynamic nearestRidePopup,
    dynamic driverPriceSuggestion,
  }) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _rideList = rideList;
    _service = service;
    _nearestRidePopup = nearestRidePopup;
    _driverPriceSuggestion = driverPriceSuggestion;
  }

  AvailableRidePojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    if (json['ride_list'] != null) {
      _rideList = [];
      json['ride_list'].forEach((v) {
        _rideList?.add(RideList.fromJson(v));
      });
    }
    _service = json['service'] != null ? Service.fromJson(json['service']) : null;
    _nearestRidePopup = json['nearest_ride_popup'];
    _driverPriceSuggestion = json['driver_price_suggestion'];
  }

  int? _status;
  String? _message;
  int? _messageCode;
  List<RideList>? _rideList;
  Service? _service;
  dynamic _nearestRidePopup;
  dynamic _driverPriceSuggestion;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  List<RideList> get rideList => _rideList ?? [];

  Service get service => _service ?? Service();

  dynamic get nearestRidePopup => _nearestRidePopup ?? 0;

  dynamic get driverPriceSuggestion => _driverPriceSuggestion ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    if (_rideList != null) {
      map['ride_list'] = _rideList?.map((v) => v.toJson()).toList();
    }
    if (_service != null) {
      map['service'] = _service?.toJson();
    }
    map['nearest_ride_popup'] = _nearestRidePopup;
    map['driver_price_suggestion'] = _driverPriceSuggestion;
    return map;
  }
}

/// service_id : 1
/// service_name : "Taxi"
/// cost_for_km : 22
/// min_offer_fare_amount : 10

class Service {
  Service({int? serviceId, String? serviceName, dynamic costForKm, dynamic minOfferFareAmount}) {
    _serviceId = serviceId;
    _serviceName = serviceName;
    _costForKm = costForKm;
    _minOfferFareAmount = minOfferFareAmount;
  }

  Service.fromJson(dynamic json) {
    _serviceId = json['service_id'];
    _serviceName = json['service_name'];
    _costForKm = json['cost_for_km'];
    _minOfferFareAmount = json['min_offer_fare_amount'];
  }

  int? _serviceId;
  String? _serviceName;
  dynamic _costForKm;
  dynamic _minOfferFareAmount;

  int get serviceId => _serviceId ?? 0;

  String get serviceName => _serviceName ?? "";

  dynamic get costForKm => _costForKm ?? 0;

  dynamic get minOfferFareAmount => _minOfferFareAmount ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['service_id'] = _serviceId;
    map['service_name'] = _serviceName;
    map['cost_for_km'] = _costForKm;
    map['min_offer_fare_amount'] = _minOfferFareAmount;
    return map;
  }
}

/// ride_id : 22
/// ride_no : 8555710202505064
/// pickup_address : "150 Feet Ring Road, The Spire, 150 Feet Ring Road, Dharam Nagar Society, Rajkot, 360006, Gujarat, "
/// destination_address : "Indira Circle, Rajkot, Gujarat, India"
/// rating : 0
/// user_name : "Ft Jeel 177"
/// pickup_lat : "22.318748293931"
/// pickup_long : "70.767113305628"
/// user_id : 17
/// service_id : 1
/// offered_price : 97.46
/// total_ratings : 0
/// additional_remarks : ""
/// recipient_name : null
/// recipient_contact_number : null
/// item_description : null
/// destination_lat : "22.2883798"
/// destination_long : "70.7709278"
/// profile_image : ""
/// order_time : "54sec ago"
/// distance : 0.03
/// time : 0.05
/// address_list : [{"address":"150 Feet Ring Road, The Spire, 150 Feet Ring Road, Dharam Nagar Society, Rajkot, 360006, Gujarat, ","address_lat":"22.318748293931","address_long":"70.767113305628"},{"address":"Indira Circle, Rajkot, Gujarat, India","address_lat":"22.2883798","address_long":"70.7709278"}]

class RideList {
  RideList({
    int? rideId,
    int? rideNo,
    String? pickupAddress,
    String? destinationAddress,
    dynamic rating,
    String? userName,
    String? pickupLat,
    String? pickupLong,
    int? userId,
    int? serviceId,
    dynamic offeredPrice,
    int? totalRatings,
    String? additionalRemarks,
    String? recipientName,
    String? recipientContactNumber,
    String? itemDescription,
    String? destinationLat,
    String? destinationLong,
    String? profileImage,
    String? orderTime,
    String? scheduleDate,
    dynamic distance,
    dynamic time,
    dynamic estimatePrice,
    int? isAutoAccept,
    int? rideType,
    List<AddressListItem>? addressList,
    String? otherUserName,
    String? otherUserContactNumber,
    String? destinationPaymentMethod,
    String? destinationPaymentLabel,
    dynamic packageWeightKg,
    dynamic packageHeightCm,
    dynamic packageWidthCm,
    dynamic packageLengthCm,
    int? isDelivery,
    int? isEncomienda,
    String? serviceMode,
    int? childSeat,
    int? handicap,
  }) {
    _rideId = rideId;
    _rideNo = rideNo;
    _pickupAddress = pickupAddress;
    _destinationAddress = destinationAddress;
    _rating = rating;
    _userName = userName;
    _pickupLat = pickupLat;
    _pickupLong = pickupLong;
    _userId = userId;
    _serviceId = serviceId;
    _offeredPrice = offeredPrice;
    _totalRatings = totalRatings;
    _additionalRemarks = additionalRemarks;
    _recipientName = recipientName;
    _recipientContactNumber = recipientContactNumber;
    _itemDescription = itemDescription;
    _destinationLat = destinationLat;
    _destinationLong = destinationLong;
    _profileImage = profileImage;
    _orderTime = orderTime;
    _distance = distance;
    _time = time;
    _addressList = addressList;
    _isAutoAccept = isAutoAccept;
    _rideType = rideType;
    _estimatePrice = estimatePrice;
    _otherUserName = otherUserName;
    _otherUserContactNumber = otherUserContactNumber;
    _scheduleDate = scheduleDate;
    _destinationPaymentMethod = destinationPaymentMethod;
    _destinationPaymentLabel = destinationPaymentLabel;
    _packageWeightKg = packageWeightKg;
    _packageHeightCm = packageHeightCm;
    _packageWidthCm = packageWidthCm;
    _packageLengthCm = packageLengthCm;
    _isDelivery = isDelivery;
    _isEncomienda = isEncomienda;
    _serviceMode = serviceMode;
    _childSeat = childSeat;
    _handicap = handicap;
  }

  RideList.fromJson(dynamic json) {
    _rideId = json['ride_id'];
    _rideNo = json['ride_no'];
    _pickupAddress = json['pickup_address'];
    _destinationAddress = json['destination_address'];
    _rating = json['rating'];
    _userName = json['user_name'];
    _pickupLat = json['pickup_lat'];
    _pickupLong = json['pickup_long'];
    _userId = json['user_id'];
    _serviceId = json['service_id'];
    _offeredPrice = json['offered_price'];
    _totalRatings = json['total_ratings'];
    _additionalRemarks = json['additional_remarks'];
    _recipientName = json['recipient_name'];
    _recipientContactNumber = json['recipient_contact_number'];
    _itemDescription = json['item_description'];
    _destinationLat = json['destination_lat'];
    _destinationLong = json['destination_long'];
    _profileImage = json['profile_image'];
    _orderTime = json['order_time'];
    _distance = json['distance'];
    _time = json['time'];
    _isAutoAccept = json['is_auto_accept'];
    _rideType = json['ride_type'];
    _estimatePrice = json['estimate_price'];
    _otherUserName = json['other_user_name'];
    _otherUserContactNumber = json['other_user_contact_number'];
    _scheduleDate = json['schedule_date'];
    _destinationPaymentMethod = json['destination_payment_method'];
    _destinationPaymentLabel = json['destination_payment_label'];
    _packageWeightKg = json['package_weight_kg'];
    _packageHeightCm = json['package_height_cm'];
    _packageWidthCm = json['package_width_cm'];
    _packageLengthCm = json['package_length_cm'];
    _isDelivery = json['is_delivery'] is int ? json['is_delivery'] : int.tryParse('${json['is_delivery'] ?? 0}');
    _serviceMode = json['service_mode']?.toString();
    _isEncomienda = json['is_encomienda'] is int ? json['is_encomienda'] : int.tryParse('${json['is_encomienda'] ?? 0}');
    _childSeat = json['child_seat'] is int ? json['child_seat'] : int.tryParse('${json['child_seat'] ?? 0}');
    _handicap = json['handicap'] is int ? json['handicap'] : int.tryParse('${json['handicap'] ?? 0}');
    if (json['address_list'] != null) {
      _addressList = [];
      json['address_list'].forEach((v) {
        _addressList?.add(AddressListItem.fromJson(v));
      });
    }
  }

  int? _rideId;
  int? _rideNo;
  String? _pickupAddress;
  String? _destinationAddress;
  dynamic _rating;
  String? _userName;
  String? _pickupLat;
  String? _pickupLong;
  int? _userId;
  int? _serviceId;
  dynamic _offeredPrice;
  int? _totalRatings;
  String? _additionalRemarks;
  String? _recipientName;
  String? _recipientContactNumber;
  String? _itemDescription;
  String? _destinationLat;
  String? _destinationLong;
  String? _profileImage;
  String? _orderTime;
  String? _scheduleDate;
  dynamic _distance;
  dynamic _time;
  int? _isAutoAccept;
  int? _rideType;
  List<AddressListItem>? _addressList;
  dynamic _estimatePrice;
  String? _otherUserName;
  String? _otherUserContactNumber;
  String? _destinationPaymentMethod;
  String? _destinationPaymentLabel;
  dynamic _packageWeightKg;
  dynamic _packageHeightCm;
  dynamic _packageWidthCm;
  dynamic _packageLengthCm;
  int? _isDelivery;
  int? _isEncomienda;
  String? _serviceMode;
  int? _childSeat;
  int? _handicap;

  int get rideId => _rideId ?? 0;

  int get rideNo => _rideNo ?? 0;

  String get pickupAddress => _pickupAddress ?? "";

  String get destinationAddress => _destinationAddress ?? "";

  dynamic get rating => _rating ?? 0;

  String get userName => _userName ?? "";

  String get pickupLat => _pickupLat ?? "";

  String get pickupLong => _pickupLong ?? "";

  int get userId => _userId ?? 0;

  int get serviceId => _serviceId ?? 0;

  dynamic get offeredPrice => _offeredPrice ?? 0;

  int get totalRatings => _totalRatings ?? 0;

  String get additionalRemarks => _additionalRemarks ?? "";

  String get recipientName => _recipientName ?? "";

  String get recipientContactNumber => _recipientContactNumber ?? "";

  String get itemDescription => _itemDescription ?? "";

  String get destinationLat => _destinationLat ?? "";

  String get destinationLong => _destinationLong ?? "";

  String get profileImage => _profileImage ?? "";

  String get orderTime => _orderTime ?? "";

  String get scheduleDate => _scheduleDate ?? "";

  String get otherUserName => _otherUserName ?? "";

  String get otherUserContactNumber => _otherUserContactNumber ?? "";

  dynamic get distance => _distance ?? 0;

  dynamic get time => _time ?? 0;

  dynamic get estimatePrice => _estimatePrice ?? 0;

  int get isAutoAccept => _isAutoAccept ?? 0;

  int get rideType => _rideType ?? 0;

  List<AddressListItem> get addressList => _addressList ?? [];

  String get destinationPaymentMethod => _destinationPaymentMethod ?? "";

  String get destinationPaymentLabel => _destinationPaymentLabel ?? "";

  String get packageWeightKg => "${_packageWeightKg ?? ''}";

  String get packageHeightCm => "${_packageHeightCm ?? ''}";

  String get packageWidthCm => "${_packageWidthCm ?? ''}";

  String get packageLengthCm => "${_packageLengthCm ?? ''}";

  int get isDelivery => _isDelivery ?? 0;

  int get isEncomienda => _isEncomienda ?? 0;

  String? get serviceMode => _serviceMode;

  int get childSeat => _childSeat ?? 0;

  int get handicap => _handicap ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ride_id'] = _rideId;
    map['ride_no'] = _rideNo;
    map['pickup_address'] = _pickupAddress;
    map['destination_address'] = _destinationAddress;
    map['rating'] = _rating;
    map['user_name'] = _userName;
    map['pickup_lat'] = _pickupLat;
    map['pickup_long'] = _pickupLong;
    map['user_id'] = _userId;
    map['service_id'] = _serviceId;
    map['offered_price'] = _offeredPrice;
    map['total_ratings'] = _totalRatings;
    map['additional_remarks'] = _additionalRemarks;
    map['recipient_name'] = _recipientName;
    map['recipient_contact_number'] = _recipientContactNumber;
    map['item_description'] = _itemDescription;
    map['destination_lat'] = _destinationLat;
    map['destination_long'] = _destinationLong;
    map['profile_image'] = _profileImage;
    map['order_time'] = _orderTime;
    map['distance'] = _distance;
    map['time'] = _time;
    map['is_auto_accept'] = _isAutoAccept;
    map['ride_type'] = _rideType;
    map['estimate_price'] = _estimatePrice;
    map['other_user_name'] = _otherUserName;
    map['other_user_contact_number'] = _otherUserContactNumber;
    map['schedule_date'] = _scheduleDate;
    map['destination_payment_method'] = _destinationPaymentMethod;
    map['destination_payment_label'] = _destinationPaymentLabel;
    map['package_weight_kg'] = _packageWeightKg;
    map['package_height_cm'] = _packageHeightCm;
    map['package_width_cm'] = _packageWidthCm;
    map['package_length_cm'] = _packageLengthCm;
    map['child_seat'] = _childSeat;
    map['handicap'] = _handicap;
    if (_addressList != null) {
      map['address_list'] = _addressList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class UpdateCurrentStatusPojo {
  int? _status;
  String? _message;
  int? _driverCurrentStatus;
  int? _messageCode;
  int? _isDocumentPending;
  int? _isDocumentExpired;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get driverCurrentStatus => _driverCurrentStatus ?? 0;

  int get messageCode => _messageCode ?? 0;

  int get isDocumentPending => _isDocumentPending ?? 0;

  int get isDocumentExpired => _isDocumentExpired ?? 0;

  UpdateCurrentStatusPojo({int? status, String? message, int? driverCurrentStatus, int? messageCode,int? isDocumentPending, int? isDocumentExpired}) {
    _status = status;
    _message = message;
    _driverCurrentStatus = driverCurrentStatus;
    _messageCode = messageCode;
    _isDocumentPending = isDocumentPending;
    _isDocumentExpired = isDocumentExpired;
  }

  UpdateCurrentStatusPojo.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _driverCurrentStatus = json["driver_current_status"];
    _messageCode = json["message_code"];
    _isDocumentPending = json["is_document_pending"];
    _isDocumentExpired = json["is_document_expired"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["driver_current_status"] = _driverCurrentStatus;
    map["message_code"] = _messageCode;
    map["is_document_pending"] = _isDocumentPending;
    map["is_document_expired"] = _isDocumentExpired;
    return map;
  }
}
