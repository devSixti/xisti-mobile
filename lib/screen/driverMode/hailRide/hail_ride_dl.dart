class HailRideBookingPojo {
  HailRideBookingPojo({
      this.status, 
      this.message, 
      this.messageCode, 
      this.rideId, 
      this.bookingNo, 
      this.pickupDateTime, 
      this.pickupAddress, 
      this.destinationAddress, 
      this.rideStatus,});

  HailRideBookingPojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    rideId = json['ride_id'];
    bookingNo = json['booking_no'];
    pickupDateTime = json['pickup_date_time'];
    pickupAddress = json['pickup_address'];
    destinationAddress = json['destination_address'];
    rideStatus = json['ride_status'];
  }
  int? status;
  String? message;
  int? messageCode;
  int? rideId;
  String? bookingNo;
  String? pickupDateTime;
  String? pickupAddress;
  String? destinationAddress;
  int? rideStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    map['ride_id'] = rideId;
    map['booking_no'] = bookingNo;
    map['pickup_date_time'] = pickupDateTime;
    map['pickup_address'] = pickupAddress;
    map['destination_address'] = destinationAddress;
    map['ride_status'] = rideStatus;
    return map;
  }

}