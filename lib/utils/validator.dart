import '../hive/hive_helper.dart';
import 'phone_util.dart';
import 'utils.dart';

String validateEmptyField(String value, String message) {
  if ((value.trim()).isEmpty) {
    return message;
  } else {
    return "";
  }
}

String validateWithFixLength(String value, int length, String emptyMsg, String invalidMsg) {
  if (value.trim().isEmpty) {
    return emptyMsg;
  } else if (value.trim().length != length) {
    return invalidMsg;
  } else {
    return "";
  }
}

String fullNameValidate(String value) {
  if (value.isEmpty) {
    return languages.enterYourName;
  }
  return "";
}

String registerFullNameValidate(String value,String invalidMsg) {
  if (value.trim().isEmpty) {
    return languages.enterYourName;
  } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
    return invalidMsg;
  }
  return "";
}

String mobileNumberValidate(String value) {
  if (value.isEmpty) {
    return languages.enterContactNumber;
  }
  return "";
}

String mobileNumberValidateForDialCode(String value, {String? dialCode}) {
  if (value.trim().isEmpty) {
    return languages.enterContactNumber;
  }
  final digits = normalizeLocalMobile(value, dialCode: dialCode);
  if (isColombiaDialCode(dialCode)) {
    if (digits.length != 10) {
      return languages.invalidMobileNumberCo;
    }
    return "";
  }
  if (digits.length < 6 || digits.length > 15) {
    return languages.invalidMobileNumberCo;
  }
  return "";
}

String colombiaMobileNumberValidate(String value, {String? dialCode}) {
  return mobileNumberValidateForDialCode(value, dialCode: dialCode ?? '+57');
}

String _normalizePlate(String value) {
  return value.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
}

bool _isColombiaSelected() {
  final code = getStringFromUserInfoBox(hiveCountryCode, defaultValue: defaultCountryCode.dialCode ?? '');
  final upper = code.toUpperCase();
  return upper == 'CO' || upper.contains('+57') || upper.contains('57') || upper.contains('COL');
}

String vehiclePlateValidate(String value, {int? vehicleTypeId, int? serviceId}) {
  final plate = value.trim();
  if (plate.isEmpty) {
    return languages.enterVehiclePlateNumber;
  }
  if (_isColombiaSelected()) {
    return colombiaVehiclePlateValidate(plate, vehicleTypeId: vehicleTypeId, serviceId: serviceId);
  }
  if (!RegExp(r'^[A-Za-z0-9]{5,8}$').hasMatch(plate)) {
    return languages.invalidVehiclePlate;
  }
  return "";
}

/// Car: ABC123. Moto (service_id 3): ABC12D or ABC123.
String colombiaVehiclePlateValidate(String value, {int? vehicleTypeId, int? serviceId}) {
  final normalized = _normalizePlate(value);
  if (normalized.isEmpty) {
    return languages.enterVehiclePlateNumber;
  }
  final resolvedServiceId = serviceId ?? 0;
  if (resolvedServiceId == ServiceType.rickshaw) {
    if (normalized.length >= 2 && normalized.length <= 12) {
      return "";
    }
    return languages.invalidVehiclePlate;
  }
  final isMoto = vehicleTypeId == 3 || resolvedServiceId == ServiceType.bike;
  if (isMoto) {
    if (RegExp(r'^[A-Z]{3}[0-9]{2}[A-Z]$').hasMatch(normalized) ||
        RegExp(r'^[A-Z]{3}[0-9]{3}$').hasMatch(normalized)) {
      return "";
    }
  } else if (RegExp(r'^[A-Z]{3}[0-9]{3}$').hasMatch(normalized)) {
    return "";
  }
  return languages.invalidVehiclePlate;
}

String colombianNationalIdValidate(String value) {
  if (value.trim().isEmpty) {
    return languages.document;
  }
  final digits = value.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 6 || digits.length > 10) {
    return languages.invalidNationalId;
  }
  return "";
}

String emailValidate(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  if (value.isEmpty) {
    return languages.enterEmailAddress;
  } else if (!RegExp(pattern).hasMatch(value)) {
    return languages.invalidEmailAddress;
  }
  return "";
}

String emailValidateOptional(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  if (value.isNotEmpty && !RegExp(pattern).hasMatch(value)) {
    return languages.invalidEmailAddress;
  }
  return "";
}

String validateToll({String? value, required int tollType, required String message}) {
  if ((value ?? "").isEmpty) {
    return tollType == 2 ? languages.enterNumberOfToll : languages.enterTollAmount;
  } else if (getDoubleFromDynamic(value) <= 0) {
    return tollType == 2 ? languages.enterValidateNoTolls : languages.enterValidateTollCharge;
  } else {
    return "";
  }
}
