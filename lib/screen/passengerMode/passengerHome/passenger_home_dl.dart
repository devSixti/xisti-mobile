import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/app_mobile_settings.dart';
import '../../../utils/service_mode_util.dart';

/// status : 1
/// message : "Success"
/// message_code : 1
/// services : [{"service_id":1,"service_name":"Taxi","cost_for_km":2,"min_offer_fare_amount":10,"service_icon":"https://admin.xistiapp.com/assets/images/vehicle-service/49361120230606.png?v=0.4"},{"service_id":3,"service_name":"Bike","cost_for_km":1,"min_offer_fare_amount":8,"service_icon":"https://admin.xistiapp.com/assets/images/vehicle-service/31371120230606.png?v=0.4"}]

class ServiceTypeModel {
  ServiceTypeModel({
    this.status,
    this.message,
    this.messageCode,
    this.services,
    this.driverDocStatus,
    this.isDriverStatus,
    this.isDriverType,
    this.driverVehicleStatus,
    this.cashPayment,
    this.onlinePayment,
    this.walletPayment,
    this.serviceModes,
    this.deliveryVehicleOptions,
    this.deliveryPassengerDisclaimer,
    this.encomiendaPassengerDisclaimer,
  });

  ServiceTypeModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    isDriverType = json['is_driver_type'];
    isDriverStatus = json['is_driver_status'];
    driverDocStatus = json['driver_doc_status'];
    driverVehicleStatus = json['driver_vehicle_status'];
    cashPayment = json['cash_payment'];
    onlinePayment = json['online_payment'];
    walletPayment = json['wallet_payment'];
    if (json['services'] != null) {
      services = [];
      json['services'].forEach((v) {
        services?.add(ServiceTypeItem.fromJson(v));
      });
    }
    if (json['service_modes'] != null) {
      serviceModes = [];
      for (final raw in json['service_modes'] as List) {
        final modeServices = <ServiceTypeItem>[];
        if (raw['services'] != null) {
          for (final v in raw['services'] as List) {
            modeServices.add(ServiceTypeItem.fromJson(v));
          }
        }
        serviceModes?.add(
          ServiceModeGroup(
            mode: raw['mode']?.toString() ?? 'transport',
            label: raw['label']?.toString() ?? '',
            displayOrder: raw['display_order'] is int
                ? raw['display_order'] as int
                : int.tryParse('${raw['display_order']}') ?? 0,
            services: modeServices,
          ),
        );
      }
      serviceModes?.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    }
    if (json['delivery_vehicle_options'] != null) {
      deliveryVehicleOptions = [];
      for (final raw in json['delivery_vehicle_options'] as List) {
        deliveryVehicleOptions?.add(DeliveryVehicleOption.fromJson(raw));
      }
    }
    deliveryPassengerDisclaimer = json['delivery_passenger_disclaimer']?.toString();
    encomiendaPassengerDisclaimer = json['encomienda_passenger_disclaimer']?.toString();
    applyAppMobileSettingsFromJson(json);
  }

  int? status;
  String? message;
  int? messageCode;
  int? driverDocStatus;
  int? isDriverStatus;
  int? isDriverType;
  int? driverVehicleStatus;
  int? cashPayment;
  int? onlinePayment;
  int? walletPayment;
  List<ServiceTypeItem>? services;
  List<ServiceModeGroup>? serviceModes;
  List<DeliveryVehicleOption>? deliveryVehicleOptions;
  String? deliveryPassengerDisclaimer;
  String? encomiendaPassengerDisclaimer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    map['is_driver_type'] = isDriverType;
    map['is_driver_status'] = isDriverStatus;
    map['driver_doc_status'] = driverDocStatus;
    map['driver_vehicle_status'] = driverVehicleStatus;
    map['cash_payment'] = cashPayment;
    map['online_payment'] = onlinePayment;
    map['wallet_payment'] = walletPayment;
    if (services != null) {
      map['services'] = services?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// status : 1
/// message : "Success"
/// message_code : 1
/// driver_list : [{"first_name":"Ft Driver","vehicle_company":"Tata","plat_no":"Gj 1 AA 1111","model_year":2020,"model_name":"Nexon","vehicle_color":"Black","permit_number":"AEB-110011","sub_permit_number":"ACD-1012222","permit_expiry":"19-09-2023","driver_profile":"https://teksi.taxxee.com/assets/images/profile-images/customer/1080813202307086.jpg?v=0.4","distance":0.02},{"first_name":"courier driver","vehicle_company":"tt","plat_no":"hh","model_year":2016,"model_name":"hhu","vehicle_color":"hhh","permit_number":null,"sub_permit_number":null,"permit_expiry":null,"driver_profile":"","distance":0.02},{"first_name":"Ft Sam","vehicle_company":"asdad","plat_no":"sadsa","model_year":2021,"model_name":"asdsd","vehicle_color":"asd","permit_number":"asdaqweqe","sub_permit_number":"12313sdq1rds","permit_expiry":"14-09-2023","driver_profile":"https://teksi.taxxee.com/assets/images/profile-images/customer/6232515202311089.jpg?v=0.4","distance":0.02}]

class NearestDriverPojo {
  NearestDriverPojo({this.status, this.message, this.messageCode, this.driverList});

  NearestDriverPojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    if (json['driver_list'] != null) {
      driverList = [];
      json['driver_list'].forEach((v) {
        driverList?.add(DriverList.fromJson(v));
      });
    }
  }

  int? status;
  String? message;
  int? messageCode;
  List<DriverList>? driverList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    if (driverList != null) {
      map['driver_list'] = driverList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// first_name : "Ft Driver"
/// vehicle_company : "Tata"
/// plat_no : "Gj 1 AA 1111"
/// model_year : 2020
/// model_name : "Nexon"
/// vehicle_color : "Black"
/// driver_profile : "https://teksi.taxxee.com/assets/images/profile-images/customer/1080813202307086.jpg?v=0.4"

class DriverList {
  DriverList({
    this.firstName,
    this.vehicleCompany,
    this.platNo,
    this.modelYear,
    this.modelName,
    this.vehicleColor,
    this.driverProfile,
    this.currentLat,
    this.currentLong,
    this.serviceId,
  });

  DriverList.fromJson(dynamic json) {
    firstName = json['first_name'];
    vehicleCompany = json['vehicle_company'];
    platNo = json['plat_no'];
    modelYear = json['model_year'];
    modelName = json['model_name'];
    vehicleColor = json['vehicle_color'];
    driverProfile = json['driver_profile'];
    currentLat = json['current_lat'];
    currentLong = json['current_long'];
    serviceId = json['service_id'];
  }

  String? firstName;
  String? vehicleCompany;
  String? platNo;
  int? modelYear;
  String? modelName;
  String? vehicleColor;
  String? driverProfile;
  dynamic currentLat;
  dynamic currentLong;
  int? serviceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['vehicle_company'] = vehicleCompany;
    map['plat_no'] = platNo;
    map['model_year'] = modelYear;
    map['model_name'] = modelName;
    map['vehicle_color'] = vehicleColor;
    map['driver_profile'] = driverProfile;
    map['current_lat'] = currentLat;
    map['current_long'] = currentLong;
    map['service_id'] = serviceId;
    return map;
  }
}

/// service_id : 1
/// service_name : "Taxi"
/// cost_for_km : 2
/// min_offer_fare_amount : 10
/// service_icon : "https://admin.xistiapp.com/assets/images/vehicle-service/49361120230606.png?v=0.4"

class ServiceTypeItem {
  ServiceTypeItem({
    this.serviceId,
    this.serviceName,
    this.costForKm,
    this.minOfferFareAmount,
    this.serviceIcon,
    this.serviceDescription,
    this.serviceMode,
    this.displayOrder,
    this.deliveryVariant,
  });

  ServiceTypeItem.fromJson(dynamic json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    costForKm = json['cost_for_km'];
    minOfferFareAmount = json['min_offer_fare_amount'];
    serviceIcon = json['service_icon'];
    serviceDescription = json['service_description'];
    serviceMode = json['service_mode']?.toString();
    displayOrder = json['display_order'] is int
        ? json['display_order'] as int
        : int.tryParse('${json['display_order']}');
    deliveryVariant = json['delivery_variant']?.toString();
  }

  int? serviceId;
  String? serviceName;
  dynamic costForKm;
  dynamic minOfferFareAmount;
  String? serviceIcon;
  String? serviceDescription;
  String? serviceMode;
  int? displayOrder;
  String? deliveryVariant;

  bool matchesSelection(ServiceTypeItem? other) {
    if (other == null) return false;
    if (serviceId != other.serviceId) return false;
    return (deliveryVariant ?? '') == (other.deliveryVariant ?? '');
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['service_id'] = serviceId;
    map['service_name'] = serviceName;
    map['cost_for_km'] = costForKm;
    map['min_offer_fare_amount'] = minOfferFareAmount;
    map['service_icon'] = serviceIcon;
    map['service_description'] = serviceDescription;
    map['service_mode'] = serviceMode;
    map['display_order'] = displayOrder;
    return map;
  }
}

class RideCalculationPojo {
  RideCalculationPojo({int? status, String? message, int? messageCode, dynamic recommendedFare, dynamic minPrice}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _recommendedFare = recommendedFare;
    _minPrice = minPrice;
  }

  RideCalculationPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _recommendedFare = json['recommended_fare'];
    _minPrice = json['min_price'];
    _maxPrice = json['max_price'];
  }

  int? _status;
  String? _message;
  int? _messageCode;
  dynamic _recommendedFare;
  dynamic _minPrice;
  dynamic _maxPrice;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  dynamic get recommendedFare => _recommendedFare ?? 0;

  dynamic get minPrice => _minPrice ?? 0;

  dynamic get maxPrice => _maxPrice ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['recommended_fare'] = _recommendedFare;
    map['min_price'] = _minPrice;
    map['max_price'] = _maxPrice;
    return map;
  }
}

/// status : 1
/// message : "Success"
/// message_code : 1
/// ride_id : 12
/// booking_no : "3073712202312062"
/// pickup_date_time : "12 Jun, 2023"
/// pickup_address : "150 Feet Ring Road, 403, 150 Feet Ring Road, Dharam Nagar Society, Rajkot, 360007, Gujarat, "
/// destination_address : "150 Feet Ring Road, Shastrinagar 3 Ramdevpir chok, 150 Feet Ring Road, Dharam Nagar, Rajkot, 360005, Gujarat, "
/// ride_status : 0
/// accept_time_out : 40

class RideBookPojo {
  RideBookPojo({
    this.status,
    this.message,
    this.messageCode,
    this.rideId,
    this.bookingNo,
    this.pickupDateTime,
    this.pickupAddress,
    this.destinationAddress,
    this.rideStatus,
    this.acceptTimeOut,
  });

  RideBookPojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    rideId = json['ride_id'];
    bookingNo = json['booking_no'];
    pickupDateTime = json['pickup_date_time'];
    pickupAddress = json['pickup_address'];
    destinationAddress = json['destination_address'];
    rideStatus = json['ride_status'];
    acceptTimeOut = json['accept_time_out'];
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
  int? acceptTimeOut;

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
    map['accept_time_out'] = acceptTimeOut;
    return map;
  }
}

class PaymentTypeModel {
  int? type;
  String? name;

  PaymentTypeModel({this.type, this.name});
}

class SearchedLocation {
  dynamic lat, lng;
  String? name;
  LatLng? latLng;

  SearchedLocation({this.name, this.lat, this.lng, this.latLng});

  static SearchedLocation? fromJson(dynamic json) {
    return json != null ? SearchedLocation(name: json["address"], lat: json["address_lat"], lng: json["address_long"]) : null;
  }

  dynamic toJson() {
    return {"address": name, "address_lat": lat, "address_long": lng};
  }
}

class DeliveryVehicleOption {
  DeliveryVehicleOption({
    this.vehicleServiceId,
    this.label,
    this.serviceIcon,
    this.deliveryVariant,
  });

  DeliveryVehicleOption.fromJson(dynamic json) {
    vehicleServiceId = json['vehicle_service_id'] is int
        ? json['vehicle_service_id'] as int
        : int.tryParse('${json['vehicle_service_id']}');
    label = json['label']?.toString() ?? '';
    serviceIcon = json['service_icon']?.toString() ?? '';
    deliveryVariant = json['delivery_variant']?.toString();
  }

  int? vehicleServiceId;
  String? label;
  String? serviceIcon;
  String? deliveryVariant;
}
