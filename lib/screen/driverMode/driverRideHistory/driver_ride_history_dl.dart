class DriverRideHistoryPojo {
  DriverRideHistoryPojo({
    int? status,
    String? message,
    int? messageCode,
    int? currentPage,
    int? lastPage,
    int? total,
    dynamic totalRevenues,
    int? completedRide,
    int? totalRide,
    int? cancelledRide,
    List<DriverRideListItem>? rideHistoryList,
  }) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _currentPage = currentPage;
    _lastPage = lastPage;
    _total = total;
    _totalRevenues = totalRevenues;
    _completedRide = completedRide;
    _totalRide = totalRide;
    _cancelledRide = cancelledRide;
    _rideHistoryList = rideHistoryList;
  }

  DriverRideHistoryPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _currentPage = json['current_page'];
    _lastPage = json['last_page'];
    _total = json['total'];
    _totalRevenues = json['total_revenues'];
    _completedRide = json['completed_ride'];
    _totalRide = json['total_ride'];
    _cancelledRide = json['cancelled_ride'];
    if (json['ride_history'] != null) {
      _rideHistoryList = [];
      json['ride_history'].forEach((v) {
        _rideHistoryList?.add(DriverRideListItem.fromJson(v));
      });
    }
  }

  int? _status;
  String? _message;
  int? _messageCode;
  int? _currentPage;
  int? _lastPage;
  int? _total;
  dynamic _totalRevenues;
  int? _completedRide;
  int? _totalRide;
  int? _cancelledRide;
  List<DriverRideListItem>? _rideHistoryList;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  int get currentPage => _currentPage ?? 0;

  int get lastPage => _lastPage ?? 0;

  int get total => _total ?? 0;

  dynamic get totalRevenues => _totalRevenues ?? 0;

  int get completedRide => _completedRide ?? 0;

  int get totalRide => _totalRide ?? 0;

  int get cancelledRide => _cancelledRide ?? 0;

  List<DriverRideListItem> get rideHistoryList => _rideHistoryList ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['current_page'] = _currentPage;
    map['last_page'] = _lastPage;
    map['total'] = _total;
    map['total_revenues'] = _totalRevenues;
    map['completed_ride'] = _completedRide;
    map['total_ride'] = _totalRide;
    map['cancelled_ride'] = _cancelledRide;
    if (_rideHistoryList != null) {
      map['ride_history'] = _rideHistoryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// ride_id : 23
/// user_name : "Test"
/// user_profile : "https://fox-drive.startuptrinity.com/assets/images/profile-images/customer/4261206202313063.jpg?v=0.4"
/// driver_pay_settle_status : 0
/// vehicle_type_icon : "https://fox-drive.startuptrinity.com/assets/images/service-category/transport-service-type/231141420200710.png"
/// ride_status : 9
/// ride_date_time : "2023-06-15 06:07:56"
/// ride_amount : 2.82
/// ride_type : 0
/// ride_date : "Thu 15 Jun,2023"
/// ride_time : "06:07"
/// service_date_time : "2023-06-15 06:07:56"
/// schedule_service_date_time : "2023-06-15 06:07:56"

class DriverRideListItem {
  DriverRideListItem({
    int? rideId,
    String? userName,
    String? userProfile,
    int? driverPaySettleStatus,
    String? vehicleTypeIcon,
    int? rideStatus,
    String? rideDateTime,
    dynamic rideAmount,
    int? rideType,
    String? rideDate,
    String? rideTime,
    String? serviceDateTime,
    String? scheduleServiceDateTime,
    String? pickupAddress,
    String? destinationAddress,
    String? serviceName,
    int? serviceId,
    String? otherUserName,
    int? rideNo,
  }) {
    _rideId = rideId;
    _userName = userName;
    _userProfile = userProfile;
    _driverPaySettleStatus = driverPaySettleStatus;
    _vehicleTypeIcon = vehicleTypeIcon;
    _rideStatus = rideStatus;
    _rideDateTime = rideDateTime;
    _rideAmount = rideAmount;
    _rideType = rideType;
    _rideDate = rideDate;
    _rideTime = rideTime;
    _serviceDateTime = serviceDateTime;
    _scheduleServiceDateTime = scheduleServiceDateTime;
    _pickupAddress = pickupAddress;
    _destinationAddress = destinationAddress;
    _serviceId = serviceId;
    _serviceName = serviceName;
    _otherUserName = otherUserName;
    _rideNo = rideNo;
  }

  DriverRideListItem.fromJson(dynamic json) {
    _rideId = json['ride_id'];
    _userName = json['user_name'];
    _userProfile = json['user_profile'];
    _driverPaySettleStatus = json['driver_pay_settle_status'];
    _vehicleTypeIcon = json['vehicle_type_icon'];
    _rideStatus = json['ride_status'];
    _rideDateTime = json['ride_date_time'];
    _rideAmount = json['ride_amount'];
    _rideType = json['ride_type'];
    _rideDate = json['ride_date'];
    _rideTime = json['ride_time'];
    _serviceDateTime = json['service_date_time'];
    _scheduleServiceDateTime = json['schedule_service_date_time'];
    _pickupAddress = json['pickup_address'];
    _destinationAddress = json['destination_address'];
    _serviceId = json['service_id'];
    _serviceName = json['service_name'];
    _otherUserName = json['other_user_name'];
    _rideNo = json['ride_no'];
  }

  int? _rideId;
  int? _rideNo;
  String? _userName;
  String? _userProfile;
  int? _driverPaySettleStatus;
  String? _vehicleTypeIcon;
  int? _rideStatus;
  String? _rideDateTime;
  dynamic _rideAmount;
  int? _rideType;
  String? _rideDate;
  String? _rideTime;
  String? _serviceDateTime;
  String? _scheduleServiceDateTime;
  String? _pickupAddress;
  String? _destinationAddress;
  String? _serviceName;
  int? _serviceId;
  String? _otherUserName;

  int get rideId => _rideId ?? 0;

  String get userName => _userName ?? "";

  String get userProfile => _userProfile ?? "";

  int get driverPaySettleStatus => _driverPaySettleStatus ?? 0;

  String get vehicleTypeIcon => _vehicleTypeIcon ?? "";

  int get rideStatus => _rideStatus ?? 0;

  String get rideDateTime => _rideDateTime ?? "";

  dynamic get rideAmount => _rideAmount ?? "";

  int? get rideType => _rideType ?? 0;

  String get rideDate => _rideDate ?? "";

  String get rideTime => _rideTime ?? "";

  String get serviceDateTime => _serviceDateTime ?? "";

  String get scheduleServiceDateTime => _scheduleServiceDateTime ?? "";

  String get pickupAddress => _pickupAddress ?? "";

  String get destinationAddress => _destinationAddress ?? "";

  String get serviceName => _serviceName ?? "";

  String get otherUserName => _otherUserName ?? "";

  int get rideNo => _rideNo ?? 0;

  int get serviceId => _serviceId ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ride_id'] = _rideId;
    map['user_name'] = _userName;
    map['user_profile'] = _userProfile;
    map['driver_pay_settle_status'] = _driverPaySettleStatus;
    map['vehicle_type_icon'] = _vehicleTypeIcon;
    map['ride_status'] = _rideStatus;
    map['ride_date_time'] = _rideDateTime;
    map['ride_amount'] = _rideAmount;
    map['ride_type'] = _rideType;
    map['ride_date'] = _rideDate;
    map['ride_time'] = _rideTime;
    map['service_date_time'] = _serviceDateTime;
    map['schedule_service_date_time'] = _scheduleServiceDateTime;
    map['pickup_address'] = _pickupAddress;
    map['destination_address'] = _destinationAddress;
    map['service_id'] = _serviceId;
    map['service_name'] = _serviceName;
    map['other_user_name'] = _otherUserName;
    map['ride_no'] = _rideNo;
    return map;
  }
}
