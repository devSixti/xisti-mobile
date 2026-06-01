class ProfilePojo {
  ProfilePojo({this.status, this.message, this.messageCode, this.userDetails});

  ProfilePojo.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    userDetails = json['user_details'] != null ? UserDetails.fromJson(json['user_details']) : null;
  }

  int? status;
  String? message;
  int? messageCode;
  UserDetails? userDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    if (userDetails != null) {
      map['user_details'] = userDetails?.toJson();
    }
    return map;
  }
}

/// first_name : "User Ft Prashant"
/// email : "ft@prashant.com"
/// country_code : "+1"
/// contact_number : "47"
/// emergency_contact : "5555"
/// profile_image : "https://fox-drive.startuptrinity.com/assets/images/profile-images/customer/3472612202304073.jpg?v=0.4"

class UserDetails {
  UserDetails({
    this.firstName,
    this.email,
    this.countryCode,
    this.contactNumber,
    this.emergencyContact,
    this.emergencyContactName,
    this.profileImage,
    this.emergencyCountryCode,
  });

  UserDetails.fromJson(dynamic json) {
    firstName = json['first_name'];
    email = json['email'];
    countryCode = json['country_code'];
    contactNumber = json['contact_number'];
    emergencyContact = json['emergency_contact'];
    emergencyContactName = json['emergency_contact_name'];
    profileImage = json['profile_image'];
    emergencyCountryCode = json['emergency_country_code'];
  }

  String? firstName;
  String? email;
  String? countryCode;
  String? contactNumber;
  String? emergencyContact;
  String? emergencyContactName;
  String? emergencyCountryCode;
  String? profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['email'] = email;
    map['country_code'] = countryCode;
    map['contact_number'] = contactNumber;
    map['emergency_contact'] = emergencyContact;
    map['emergency_contact_name'] = emergencyContactName;
    map['profile_image'] = profileImage;
    map['emergency_country_code'] = emergencyCountryCode;
    return map;
  }
}
