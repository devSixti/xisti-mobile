class DriverVehicleListPojo {
  DriverVehicleListPojo({int? status, String? message, int? messageCode, List<ServiceList>? serviceList}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _serviceList = serviceList;
  }

  DriverVehicleListPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    if (json['service_list'] != null) {
      _serviceList = [];
      json['service_list'].forEach((v) {
        _serviceList?.add(ServiceList.fromJson(v));
      });
    }
  }

  int? _status;
  String? _message;
  int? _messageCode;
  List<ServiceList>? _serviceList;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  List<ServiceList> get serviceList => _serviceList ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    if (_serviceList != null) {
      map['service_list'] = _serviceList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// service_id : 1
/// service_name : "Taxi"
/// service_icon : "https://admin.xistiapp.com/assets/images/vehicle-service/32440820253005.png?v=0.4"
/// vehicle_type_list : [{"vehicle_type_id":1,"vehicle_type_name":"Hatchback","vehicle_icon":"https://admin.xistiapp.com/assets/images/service-category/transport-service-type/209151420200710.png?v=0.4"},{"vehicle_type_id":2,"vehicle_type_name":"SUV","vehicle_icon":"https://admin.xistiapp.com/assets/images/service-category/transport-service-type/231141420200710.png?v=0.4"},{"vehicle_type_id":3,"vehicle_type_name":"Luxury","vehicle_icon":"https://admin.xistiapp.com/assets/images/service-category/transport-service-type/251141420200710.png?v=0.4"},{"vehicle_type_id":4,"vehicle_type_name":"Sedan","vehicle_icon":"https://admin.xistiapp.com/assets/images/service-category/transport-service-type/219141420200710.png?v=0.4"}]

class ServiceList {
  ServiceList({
    int? serviceId,
    String? serviceName,
    String? serviceIcon,
    String? serviceDescription,
    List<VehicleTypeList>? vehicleTypeList,
    bool? supportsPassengerTransportToggle,
    bool? isDeliveryOnlyService,
    bool? requiresTechnicalInspection,
    String? deliveryVariant,
  }) {
    _serviceId = serviceId;
    _serviceName = serviceName;
    _serviceIcon = serviceIcon;
    _serviceDescription = serviceDescription;
    _vehicleTypeList = vehicleTypeList;
    _supportsPassengerTransportToggle = supportsPassengerTransportToggle;
    _isDeliveryOnlyService = isDeliveryOnlyService;
    _requiresTechnicalInspection = requiresTechnicalInspection;
    _deliveryVariant = deliveryVariant;
  }

  ServiceList.fromJson(dynamic json) {
    _serviceId = json['service_id'];
    _serviceName = json['service_name'];
    _serviceIcon = json['service_icon'];
    _serviceDescription = json['service_description'];
    _deliveryVariant = json['delivery_variant']?.toString() ?? '';
    _supportsPassengerTransportToggle = json['supports_passenger_transport_toggle'] == true ||
        json['supports_passenger_transport_toggle'] == 1;
    _isDeliveryOnlyService = json['is_delivery_only_service'] == true || json['is_delivery_only_service'] == 1;
    _requiresTechnicalInspection = json['requires_technical_inspection'] == true || json['requires_technical_inspection'] == 1;
    if (json['vehicle_type_list'] != null) {
      _vehicleTypeList = [];
      json['vehicle_type_list'].forEach((v) {
        _vehicleTypeList?.add(VehicleTypeList.fromJson(v));
      });
    }
  }

  int? _serviceId;
  String? _serviceName;
  String? _serviceIcon;
  String? _serviceDescription;
  List<VehicleTypeList>? _vehicleTypeList;
  bool? _supportsPassengerTransportToggle;
  bool? _isDeliveryOnlyService;
  bool? _requiresTechnicalInspection;
  String? _deliveryVariant;

  int get serviceId => _serviceId ?? 0;

  String get deliveryVariant => _deliveryVariant ?? '';

  String get serviceName => _serviceName ?? "";

  String get serviceIcon => _serviceIcon ?? "";

  String get serviceDescription => _serviceDescription ?? "";

  List<VehicleTypeList> get vehicleTypeList => _vehicleTypeList ?? [];

  bool get supportsPassengerTransportToggle => _supportsPassengerTransportToggle ?? false;

  bool get isDeliveryOnlyService => _isDeliveryOnlyService ?? false;

  bool get requiresTechnicalInspection => _requiresTechnicalInspection ?? false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['service_id'] = _serviceId;
    map['service_name'] = _serviceName;
    map['service_icon'] = _serviceIcon;
    map['service_description'] = _serviceDescription;
    if (_vehicleTypeList != null) {
      map['vehicle_type_list'] = _vehicleTypeList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// vehicle_type_id : 1
/// vehicle_type_name : "Hatchback"
/// vehicle_icon : "https://admin.xistiapp.com/assets/images/service-category/transport-service-type/209151420200710.png?v=0.4"

class VehicleTypeList {
  VehicleTypeList({int? vehicleTypeId, String? vehicleTypeName, String? vehicleIcon}) {
    _vehicleTypeId = vehicleTypeId;
    _vehicleTypeName = vehicleTypeName;
    _vehicleIcon = vehicleIcon;
  }

  VehicleTypeList.fromJson(dynamic json) {
    _vehicleTypeId = json['vehicle_type_id'];
    _vehicleTypeName = json['vehicle_type_name'];
    _vehicleIcon = json['vehicle_icon'];
  }

  int? _vehicleTypeId;
  String? _vehicleTypeName;
  String? _vehicleIcon;

  int? get vehicleTypeId => _vehicleTypeId ?? 0;

  String? get vehicleTypeName => _vehicleTypeName ?? "";

  String? get vehicleIcon => _vehicleIcon ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicle_type_id'] = _vehicleTypeId;
    map['vehicle_type_name'] = _vehicleTypeName;
    map['vehicle_icon'] = _vehicleIcon;
    return map;
  }
}

/// status : 1
/// message : "Success"
/// message_code : 1
/// service_id : 1
/// vehicle_type_id : 3
/// manufacture_name : "asdfasd"
/// model_name : "fasdf"
/// model_year : 2018
/// vehicle_plat_no : "asdfasdf"
/// vehicle_color : "asdfasd"
/// vehicle_image : "https://admin.xistiapp.com/assets/images/provider-vehicle-image/9435301202504061.jpg"

class VehicleDetailsPojo {
  VehicleDetailsPojo({
    int? status,
    String? message,
    int? messageCode,
    int? serviceId,
    int? vehicleTypeId,
    String? manufactureName,
    String? modelName,
    int? modelYear,
    String? vehiclePlatNo,
    String? vehicleColor,
    String? vehicleImage,
    int? childSafetySeat,
    int? handyCapSeat,
    String? technicalInspectionExpiry,
  }) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _serviceId = serviceId;
    _vehicleTypeId = vehicleTypeId;
    _manufactureName = manufactureName;
    _modelName = modelName;
    _modelYear = modelYear;
    _vehiclePlatNo = vehiclePlatNo;
    _vehicleColor = vehicleColor;
    _vehicleImage = vehicleImage;
    _childSafetySeat = childSafetySeat;
    _handyCapSeat = handyCapSeat;
    _technicalInspectionExpiry = technicalInspectionExpiry;
  }

  VehicleDetailsPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _serviceId = json['service_id'];
    _vehicleTypeId = json['vehicle_type_id'];
    _manufactureName = json['manufacture_name'];
    _modelName = json['model_name'];
    _modelYear = json['model_year'];
    _vehiclePlatNo = json['vehicle_plat_no'];
    _vehicleColor = json['vehicle_color'];
    _vehicleImage = json['vehicle_image'] ?? json['vehicle_image_front'];
    _vehicleImageFront = json['vehicle_image_front'];
    _vehicleImageSide = json['vehicle_image_side'];
    _vehicleImageRear = json['vehicle_image_rear'];
    _childSafetySeat = json['child_safety_seat'];
    _handyCapSeat = json['handy_cap_seat'];
    _technicalInspectionExpiry = json['technical_inspection_expiry']?.toString();
  }

  int? _status;
  String? _message;
  int? _messageCode;
  int? _serviceId;
  int? _vehicleTypeId;
  String? _manufactureName;
  String? _modelName;
  int? _modelYear;
  String? _vehiclePlatNo;
  String? _vehicleColor;
  String? _vehicleImage;
  String? _vehicleImageFront;
  String? _vehicleImageSide;
  String? _vehicleImageRear;
  int? _childSafetySeat;
  int? _handyCapSeat;
  String? _technicalInspectionExpiry;

  int get status => _status ?? 0;

  String get message => _message ?? '';

  int get messageCode => _messageCode ?? 0;

  int get serviceId => _serviceId ?? 0;

  int get vehicleTypeId => _vehicleTypeId ?? 0;

  String get manufactureName => _manufactureName ?? '';

  String get modelName => _modelName ?? '';

  int get modelYear => _modelYear ?? 0;

  String get vehiclePlatNo => _vehiclePlatNo ?? '';

  String get vehicleColor => _vehicleColor ?? '';

  String get vehicleImage => _vehicleImage ?? '';

  String get vehicleImageFront => _vehicleImageFront ?? _vehicleImage ?? '';

  String get vehicleImageSide => _vehicleImageSide ?? '';

  String get vehicleImageRear => _vehicleImageRear ?? '';

  int get childSafetySeat => _childSafetySeat ?? 0;

  int get handyCapSeat => _handyCapSeat ?? 0;

  String get technicalInspectionExpiry => _technicalInspectionExpiry ?? '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['service_id'] = _serviceId;
    map['vehicle_type_id'] = _vehicleTypeId;
    map['manufacture_name'] = _manufactureName;
    map['model_name'] = _modelName;
    map['model_year'] = _modelYear;
    map['vehicle_plat_no'] = _vehiclePlatNo;
    map['vehicle_color'] = _vehicleColor;
    map['vehicle_image'] = _vehicleImage;
    return map;
  }
}

/// status : 1
/// message : "Success"
/// message_code : 1
/// vehicle_type_icon : "https://admin.xistiapp.com/assets/images/service-category/transport-service-type/33101220230606.png"
/// vehicle_type_name : "Sports"
/// is_driver_type : 1
/// driver_vehicle_status : 1

class UploadVehiclePojo {
  UploadVehiclePojo({
    this.status,
    this.message,
    this.messageCode,
    this.vehicleTypeIcon,
    this.vehicleTypeName,
    this.isDriverType,
    this.driverVehicleStatus,
    this.driverDocStatus,
  });

  UploadVehiclePojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    vehicleTypeIcon = json['vehicle_type_icon'];
    vehicleTypeName = json['vehicle_type_name'];
    isDriverType = json['is_driver_type'];
    driverDocStatus = json['driver_doc_status'];
    driverVehicleStatus = json['driver_vehicle_status'];
  }

  int? status;
  String? message;
  int? messageCode;
  String? vehicleTypeIcon;
  String? vehicleTypeName;
  int? isDriverType;
  int? driverVehicleStatus;
  int? driverDocStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    map['vehicle_type_icon'] = vehicleTypeIcon;
    map['vehicle_type_name'] = vehicleTypeName;
    map['is_driver_type'] = isDriverType;
    map['driver_doc_status'] = driverDocStatus;
    map['driver_vehicle_status'] = driverVehicleStatus;
    return map;
  }
}
