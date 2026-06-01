class PlaceDetailPojo {
  PlaceDetailPojo({
    this.formattedAddress,
    this.addressComponents,
    this.location,
    this.displayName,
  });

  PlaceDetailPojo.fromJson(dynamic json) {
    formattedAddress = json['formattedAddress'];
    if (json['addressComponents'] != null) {
      addressComponents = [];
      json['addressComponents'].forEach((v) {
        addressComponents?.add(AddressComponents.fromJson(v));
      });
    }
    location = json['location'] != null ? PlaceLocation.fromJson(json['location']) : null;
    displayName = json['displayName'] != null ? DisplayName.fromJson(json['displayName']) : null;
  }

  String? formattedAddress;
  List<AddressComponents>? addressComponents;
  PlaceLocation? location;
  DisplayName? displayName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['formattedAddress'] = formattedAddress;
    if (addressComponents != null) {
      map['addressComponents'] = addressComponents?.map((v) => v.toJson()).toList();
    }
    if (location != null) {
      map['location'] = location?.toJson();
    }
    if (displayName != null) {
      map['displayName'] = displayName?.toJson();
    }
    return map;
  }
}

/// text : "KKV Hall"
/// languageCode : "en"

class DisplayName {
  DisplayName({
    this.text,
    this.languageCode,
  });

  DisplayName.fromJson(dynamic json) {
    text = json['text'];
    languageCode = json['languageCode'];
  }

  String? text;
  String? languageCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = text;
    map['languageCode'] = languageCode;
    return map;
  }
}

/// latitude : 22.2862485
/// longitude : 70.7725263

class PlaceLocation {
  PlaceLocation({
    this.latitude,
    this.longitude,
  });

  PlaceLocation.fromJson(dynamic json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  double? latitude;
  double? longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}

/// longText : "Shree Mahalaxmi"
/// shortText : "Shree Mahalaxmi"
/// types : ["premise","landmark"]
/// languageCode : "en"

class AddressComponents {
  AddressComponents({
    this.longText,
    this.shortText,
    this.types,
    this.languageCode,
  });

  AddressComponents.fromJson(dynamic json) {
    longText = json['longText'];
    shortText = json['shortText'];
    types = json['types'] != null ? json['types'].cast<String>() : [];
    languageCode = json['languageCode'];
  }

  String? longText;
  String? shortText;
  List<String>? types;
  String? languageCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['longText'] = longText;
    map['shortText'] = shortText;
    map['types'] = types;
    map['languageCode'] = languageCode;
    return map;
  }
}
