import '../../../networking/base_dl.dart';

/// status : 1
/// message : "Success"
/// message_code : 1
/// user_profile : "Success"
/// timeout : 30

class DriverBidPojo {
  DriverBidPojo({int? status, String? message, int? messageCode, String? userProfile, int? timeout}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _userProfile = userProfile;
    _timeout = timeout;
  }

  DriverBidPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _userProfile = json['user_profile'];
    _timeout = json['timeout'];
  }

  int? _status;
  String? _message;
  int? _messageCode;
  String? _userProfile;
  int? _timeout;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  String get userProfile => _userProfile ?? "";

  int get timeout => _timeout ?? 30;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['user_profile'] = _userProfile;
    map['timeout'] = _timeout;
    return map;
  }
}

/// status : 1
/// message : "Success"
/// message_code : 1
/// ride_id : 11
/// ride_no : 5100005202505062
/// rating : 0
/// offered_price : 33.44
/// user_name : "Ft Jeel 177"
/// profile_image : ""
/// order_time : "21min 8sec ago"
/// distance : 0.03
/// time : 0.05
/// total_ratings : 0
/// additional_remarks : ""
/// service_id : 1
/// recipient_name : ""
/// recipient_contact_number : ""
/// item_description : ""
/// payment_type : 1
/// driver_service : {"service_id":1,"service_name":"Taxi","min_offer_fare_amount":10,"cost_for_km":22}
/// service_name : "Taxi"
/// address_list : [{"address":"608, 150 Feet Ring Road, Dharam Nagar Society, Rajkot, 360007, Gujarat, ","address_lat":"22.319049147919","address_long":"70.767201818526"},{"address":"8Q79+M5H, 150 Feet Ring Road, Bajrang Wadi, Rajkot, 360007, Gujarat, ","address_lat":"22.314217726656","address_long":"70.768264308572"}]
/// driver_price_suggestion : 1

class NewRequestPojo {
  NewRequestPojo({
    int? status,
    String? message,
    int? messageCode,
    int? rideId,
    int? rideNo,
    dynamic rating,
    dynamic offeredPrice,
    String? userName,
    String? profileImage,
    String? orderTime,
    dynamic distance,
    dynamic time,
    int? totalRatings,
    String? additionalRemarks,
    int? serviceId,
    String? recipientName,
    String? recipientContactNumber,
    String? itemDescription,
    int? paymentType,
    DriverService? driverService,
    String? serviceName,
    String? scheduleDate,
    List<AddressListItem>? addressList,
    dynamic driverPriceSuggestion,
    int? isAutoAccept,
    int? rideType,
    String? destinationPaymentMethod,
    String? destinationPaymentLabel,
    dynamic estimatePrice,
    dynamic packageWeightKg,
    dynamic packageHeightCm,
    dynamic packageWidthCm,
    dynamic packageLengthCm,
    int? isDelivery,
  }) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _rideId = rideId;
    _rideNo = rideNo;
    _rating = rating;
    _offeredPrice = offeredPrice;
    _userName = userName;
    _profileImage = profileImage;
    _orderTime = orderTime;
    _distance = distance;
    _time = time;
    _totalRatings = totalRatings;
    _additionalRemarks = additionalRemarks;
    _serviceId = serviceId;
    _recipientName = recipientName;
    _recipientContactNumber = recipientContactNumber;
    _itemDescription = itemDescription;
    _paymentType = paymentType;
    _driverService = driverService;
    _serviceName = serviceName;
    _addressList = addressList;
    _driverPriceSuggestion = driverPriceSuggestion;
    _isAutoAccept = isAutoAccept;
    _rideType = rideType;
    _scheduleDate = scheduleDate;
    _destinationPaymentMethod = destinationPaymentMethod;
    _destinationPaymentLabel = destinationPaymentLabel;
    _estimatePrice = estimatePrice;
    _packageWeightKg = packageWeightKg;
    _packageHeightCm = packageHeightCm;
    _packageWidthCm = packageWidthCm;
    _packageLengthCm = packageLengthCm;
    _isDelivery = isDelivery;
  }

  NewRequestPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _rideId = json['ride_id'];
    _rideNo = json['ride_no'];
    _rating = json['rating'];
    _offeredPrice = json['offered_price'];
    _userName = json['user_name'];
    _profileImage = json['profile_image'];
    _orderTime = json['order_time'];
    _distance = json['distance'];
    _time = json['time'];
    _totalRatings = json['total_ratings'];
    _additionalRemarks = json['additional_remarks'];
    _serviceId = json['service_id'];
    _recipientName = json['recipient_name'];
    _recipientContactNumber = json['recipient_contact_number'];
    _itemDescription = json['item_description'];
    _paymentType = json['payment_type'];
    _driverService = json['driver_service'] != null ? DriverService.fromJson(json['driver_service']) : null;
    _serviceName = json['service_name'];
    _scheduleDate = json['schedule_date'];
    if (json['address_list'] != null) {
      _addressList = [];
      json['address_list'].forEach((v) {
        _addressList?.add(AddressListItem.fromJson(v));
      });
    }
    _driverPriceSuggestion = json['driver_price_suggestion'];
    _isAutoAccept = json['is_auto_accept'];
    _rideType = json['ride_type'];
    _destinationPaymentMethod = json['destination_payment_method'];
    _destinationPaymentLabel = json['destination_payment_label'];
    _estimatePrice = json['estimate_price'];
    _packageWeightKg = json['package_weight_kg'];
    _packageHeightCm = json['package_height_cm'];
    _packageWidthCm = json['package_width_cm'];
    _packageLengthCm = json['package_length_cm'];
    _isDelivery = json['is_delivery'] is int ? json['is_delivery'] : int.tryParse('${json['is_delivery'] ?? 0}');
    _vehicleVariant = json['vehicle_variant']?.toString() ?? json['delivery_variant']?.toString();
    _isTaxi = json['is_taxi'] is int ? json['is_taxi'] : int.tryParse('${json['is_taxi'] ?? 0}');
  }

  int? _status;
  String? _message;
  int? _messageCode;
  int? _rideId;
  int? _rideNo;
  dynamic _rating;
  dynamic _offeredPrice;
  String? _userName;
  String? _profileImage;
  String? _orderTime;
  dynamic _distance;
  dynamic _time;
  int? _totalRatings;
  String? _additionalRemarks;
  int? _serviceId;
  String? _recipientName;
  String? _recipientContactNumber;
  String? _itemDescription;
  int? _paymentType;
  DriverService? _driverService;
  String? _serviceName;
  List<AddressListItem>? _addressList;
  dynamic _driverPriceSuggestion;
  int? _isAutoAccept;
  int? _rideType;
  String? _scheduleDate;
  String? _destinationPaymentMethod;
  String? _destinationPaymentLabel;
  dynamic _estimatePrice;
  dynamic _packageWeightKg;
  dynamic _packageHeightCm;
  dynamic _packageWidthCm;
  dynamic _packageLengthCm;
  int? _isDelivery;
  String? _vehicleVariant;
  int? _isTaxi;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  int get rideId => _rideId ?? 0;

  int get rideNo => _rideNo ?? 0;

  dynamic get rating => _rating ?? 0;

  dynamic get offeredPrice => _offeredPrice ?? 0;

  String get userName => _userName ?? "";

  String get profileImage => _profileImage ?? "";

  String get orderTime => _orderTime ?? "";

  dynamic get distance => _distance ?? 0;

  dynamic get time => _time ?? 0;

  int get totalRatings => _totalRatings ?? 0;

  String get additionalRemarks => _additionalRemarks ?? "";

  int get serviceId => _serviceId ?? 0;

  String get recipientName => _recipientName ?? "";

  String get recipientContactNumber => _recipientContactNumber ?? "";

  String get itemDescription => _itemDescription ?? "";

  int get paymentType => _paymentType ?? 0;

  DriverService get driverService => _driverService ?? DriverService();

  String get serviceName => _serviceName ?? "";

  String get scheduleDate => _scheduleDate ?? "";

  List<AddressListItem> get addressList => _addressList ?? [];

  dynamic get driverPriceSuggestion => _driverPriceSuggestion ?? 0;

  int get isAutoAccept => _isAutoAccept ?? 0;

  int get rideType => _rideType ?? 0;

  String get destinationPaymentMethod => _destinationPaymentMethod ?? "";

  String get destinationPaymentLabel => _destinationPaymentLabel ?? "";

  dynamic get estimatePrice => _estimatePrice ?? 0;

  String get packageWeightKg => "${_packageWeightKg ?? ''}";

  String get packageHeightCm => "${_packageHeightCm ?? ''}";

  String get packageWidthCm => "${_packageWidthCm ?? ''}";

  String get packageLengthCm => "${_packageLengthCm ?? ''}";

  int get isDelivery => _isDelivery ?? 0;

  String get vehicleVariant => _vehicleVariant ?? '';

  int get isTaxi => _isTaxi ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['ride_id'] = _rideId;
    map['ride_no'] = _rideNo;
    map['rating'] = _rating;
    map['offered_price'] = _offeredPrice;
    map['user_name'] = _userName;
    map['profile_image'] = _profileImage;
    map['order_time'] = _orderTime;
    map['distance'] = _distance;
    map['time'] = _time;
    map['total_ratings'] = _totalRatings;
    map['additional_remarks'] = _additionalRemarks;
    map['service_id'] = _serviceId;
    map['recipient_name'] = _recipientName;
    map['recipient_contact_number'] = _recipientContactNumber;
    map['item_description'] = _itemDescription;
    map['payment_type'] = _paymentType;
    map['is_auto_accept'] = _isAutoAccept;
    map['ride_type'] = _rideType;
    map['schedule_date'] = _scheduleDate;
    map['destination_payment_method'] = _destinationPaymentMethod;
    map['destination_payment_label'] = _destinationPaymentLabel;
    map['estimate_price'] = _estimatePrice;
    map['package_weight_kg'] = _packageWeightKg;
    map['package_height_cm'] = _packageHeightCm;
    map['package_width_cm'] = _packageWidthCm;
    map['package_length_cm'] = _packageLengthCm;
    if (_driverService != null) {
      map['driver_service'] = _driverService?.toJson();
    }
    map['service_name'] = _serviceName;
    if (_addressList != null) {
      map['address_list'] = _addressList?.map((v) => v.toJson()).toList();
    }
    map['driver_price_suggestion'] = _driverPriceSuggestion;
    return map;
  }
}

/// service_id : 1
/// service_name : "Taxi"
/// min_offer_fare_amount : 10
/// cost_for_km : 22

class DriverService {
  DriverService({int? serviceId, String? serviceName, dynamic minOfferFareAmount, dynamic costForKm}) {
    _serviceId = serviceId;
    _serviceName = serviceName;
    _minOfferFareAmount = minOfferFareAmount;
    _costForKm = costForKm;
  }

  DriverService.fromJson(dynamic json) {
    _serviceId = json['service_id'];
    _serviceName = json['service_name'];
    _minOfferFareAmount = json['min_offer_fare_amount'];
    _costForKm = json['cost_for_km'];
  }

  int? _serviceId;
  String? _serviceName;
  dynamic _minOfferFareAmount;
  dynamic _costForKm;

  int get serviceId => _serviceId ?? 0;

  String get serviceName => _serviceName ?? "";

  dynamic get minOfferFareAmount => _minOfferFareAmount ?? 0;

  dynamic get costForKm => _costForKm ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['service_id'] = _serviceId;
    map['service_name'] = _serviceName;
    map['min_offer_fare_amount'] = _minOfferFareAmount;
    map['cost_for_km'] = _costForKm;
    return map;
  }
}
