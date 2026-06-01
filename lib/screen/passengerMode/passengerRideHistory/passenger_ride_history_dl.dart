class PassengerRideHistoryPojo {
  PassengerRideHistoryPojo({this.status, this.message, this.messageCode, this.currentPage, this.lastPage, this.total, this.rides});

  PassengerRideHistoryPojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    total = json['total'];
    if (json['rides'] != null) {
      rides = [];
      json['rides'].forEach((v) {
        rides?.add(PassengerRideListItem.fromJson(v));
      });
    }
  }

  int? status;
  String? message;
  int? messageCode;
  int? currentPage;
  int? lastPage;
  int? total;
  List<PassengerRideListItem>? rides;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    map['current_page'] = currentPage;
    map['last_page'] = lastPage;
    map['total'] = total;
    if (rides != null) {
      map['rides'] = rides?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// ride_id : 23
/// booking_no : 1560706202315064
/// ride_status : 9
/// total_pay : 3
/// service_date_time : "2023-06-15 06:07:56"
/// schedule_order_date_time : "2023-06-15 06:07:56"
/// pickup_address : "150 Feet Ring Road, 403, 150 Feet Ring Road, Dharam Nagar Society, Rajkot, 360007, Gujarat, "
/// destination_address : "63, 150 Feet Ring Road, Gandhigram, Rajkot, 360007, Gujarat, "
/// driver_name : "Test"
/// driver_profile : ""

class PassengerRideListItem {
  PassengerRideListItem({
    int? rideId,
    int? bookingNo,
    int? rideStatus,
    dynamic totalPay,
    String? serviceDateTime,
    String? scheduleOrderDateTime,
    String? pickupAddress,
    String? destinationAddress,
    String? driverName,
    String? driverProfile,
    String? serviceName,
    int? serviceId,
  }) {
    _rideId = rideId;
    _bookingNo = bookingNo;
    _rideStatus = rideStatus;
    _totalPay = totalPay;
    _serviceDateTime = serviceDateTime;
    _scheduleOrderDateTime = scheduleOrderDateTime;
    _pickupAddress = pickupAddress;
    _destinationAddress = destinationAddress;
    _driverName = driverName;
    _driverProfile = driverProfile;
    _serviceId = serviceId;
    _serviceName = serviceName;
  }

  PassengerRideListItem.fromJson(dynamic json) {
    _rideId = json['ride_id'];
    _bookingNo = json['booking_no'];
    _rideStatus = json['ride_status'];
    _totalPay = json['total_pay'];
    _serviceDateTime = json['service_date_time'];
    _scheduleOrderDateTime = json['schedule_order_date_time'];
    _pickupAddress = json['pickup_address'];
    _destinationAddress = json['destination_address'];
    _driverName = json['driver_name'];
    _driverProfile = json['driver_profile'];
    _serviceId = json['service_id'];
    _serviceName = json['service_name'];
  }

  int? _rideId;
  int? _bookingNo;
  int? _rideStatus;
  dynamic _totalPay;
  String? _serviceDateTime;
  String? _scheduleOrderDateTime;
  String? _pickupAddress;
  String? _destinationAddress;
  String? _driverName;
  String? _driverProfile;
  String? _serviceName;
  int? _serviceId;

  int get rideId => _rideId ?? 0;

  int get bookingNo => _bookingNo ?? 0;

  int get rideStatus => _rideStatus ?? 0;

  dynamic get totalPay => _totalPay ?? 0;

  String get serviceDateTime => _serviceDateTime ?? "";

  String get scheduleOrderDateTime => _scheduleOrderDateTime ?? "";

  String get pickupAddress => _pickupAddress ?? "";

  String get destinationAddress => _destinationAddress ?? "";

  String get driverName => _driverName ?? "";

  String get driverProfile => _driverProfile ?? "";

  String get serviceName => _serviceName ?? "";

  int get serviceId => _serviceId ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ride_id'] = _rideId;
    map['booking_no'] = _bookingNo;
    map['ride_status'] = _rideStatus;
    map['total_pay'] = _totalPay;
    map['service_date_time'] = _serviceDateTime;
    map['schedule_order_date_time'] = _scheduleOrderDateTime;
    map['pickup_address'] = _pickupAddress;
    map['destination_address'] = _destinationAddress;
    map['driver_name'] = _driverName;
    map['driver_profile'] = _driverProfile;
    map['service_id'] = _serviceId;
    map['service_name'] = _serviceName;
    return map;
  }
}
