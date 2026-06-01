class PlaceAutoCompletePojo {
  PlaceAutoCompletePojo({
    this.suggestions,
  });

  PlaceAutoCompletePojo.fromJson(dynamic json) {
    if (json['suggestions'] != null) {
      suggestions = [];
      json['suggestions'].forEach((v) {
        suggestions?.add(Suggestions.fromJson(v));
      });
    }
  }

  List<Suggestions>? suggestions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (suggestions != null) {
      map['suggestions'] = suggestions?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// placePrediction : {"place":"places/ChIJCdxbob_LWTkR8bLPvJgnjOM","placeId":"ChIJCdxbob_LWTkR8bLPvJgnjOM","text":{"text":"KKV Hall, Suryoday Society, Nalanda Society, Rajkot, Gujarat, India","matches":[{"endOffset":3}]},"structuredFormat":{"mainText":{"text":"KKV Hall","matches":[{"endOffset":3}]},"secondaryText":{"text":"Suryoday Society, Nalanda Society, Rajkot, Gujarat, India"}},"types":["banquet_hall","point_of_interest","establishment","event_venue"]}

class Suggestions {
  Suggestions({
    this.placePrediction,
  });

  Suggestions.fromJson(dynamic json) {
    placePrediction = json['placePrediction'] != null ? PlacePrediction.fromJson(json['placePrediction']) : null;
  }

  PlacePrediction? placePrediction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (placePrediction != null) {
      map['placePrediction'] = placePrediction?.toJson();
    }
    return map;
  }
}

/// place : "places/ChIJCdxbob_LWTkR8bLPvJgnjOM"
/// placeId : "ChIJCdxbob_LWTkR8bLPvJgnjOM"
/// text : {"text":"KKV Hall, Suryoday Society, Nalanda Society, Rajkot, Gujarat, India","matches":[{"endOffset":3}]}
/// structuredFormat : {"mainText":{"text":"KKV Hall","matches":[{"endOffset":3}]},"secondaryText":{"text":"Suryoday Society, Nalanda Society, Rajkot, Gujarat, India"}}
/// types : ["banquet_hall","point_of_interest","establishment","event_venue"]

class PlacePrediction {
  PlacePrediction({
    this.place,
    this.placeId,
    this.placeText,
    this.structuredFormat,
    this.types,
  });

  PlacePrediction.fromJson(dynamic json) {
    place = json['place'];
    placeId = json['placeId'];
    placeText = json['text'] != null ? PlaceText.fromJson(json['text']) : null;
    structuredFormat = json['structuredFormat'] != null ? StructuredFormat.fromJson(json['structuredFormat']) : null;
    types = json['types'] != null ? json['types'].cast<String>() : [];
  }

  String? place;
  String? placeId;
  PlaceText? placeText;
  StructuredFormat? structuredFormat;
  List<String>? types;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['place'] = place;
    map['placeId'] = placeId;
    if (placeText != null) {
      map['text'] = placeText?.toJson();
    }
    if (structuredFormat != null) {
      map['structuredFormat'] = structuredFormat?.toJson();
    }
    map['types'] = types;
    return map;
  }
}

/// mainText : {"text":"KKV Hall","matches":[{"endOffset":3}]}
/// secondaryText : {"text":"Suryoday Society, Nalanda Society, Rajkot, Gujarat, India"}

class StructuredFormat {
  StructuredFormat({
    this.mainText,
    this.secondaryText,
  });

  StructuredFormat.fromJson(dynamic json) {
    mainText = json['mainText'] != null ? MainText.fromJson(json['mainText']) : null;
    secondaryText = json['secondaryText'] != null ? SecondaryText.fromJson(json['secondaryText']) : null;
  }

  MainText? mainText;
  SecondaryText? secondaryText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (mainText != null) {
      map['mainText'] = mainText?.toJson();
    }
    if (secondaryText != null) {
      map['secondaryText'] = secondaryText?.toJson();
    }
    return map;
  }
}

/// text : "Suryoday Society, Nalanda Society, Rajkot, Gujarat, India"

class SecondaryText {
  SecondaryText({
    this.text,
  });

  SecondaryText.fromJson(dynamic json) {
    text = json['text'];
  }

  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = text;
    return map;
  }
}

/// text : "KKV Hall"
/// matches : [{"endOffset":3}]

class MainText {
  MainText({
    this.text,
    this.matches,
  });

  MainText.fromJson(dynamic json) {
    text = json['text'];
    if (json['matches'] != null) {
      matches = [];
      json['matches'].forEach((v) {
        matches?.add(Matches.fromJson(v));
      });
    }
  }

  String? text;
  List<Matches>? matches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = text;
    if (matches != null) {
      map['matches'] = matches?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// endOffset : 3

class Matches {
  Matches({
    this.endOffset,
  });

  Matches.fromJson(dynamic json) {
    endOffset = json['endOffset'];
  }

  int? endOffset;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['endOffset'] = endOffset;
    return map;
  }
}

/// text : "KKV Hall, Suryoday Society, Nalanda Society, Rajkot, Gujarat, India"
/// matches : [{"endOffset":3}]

class PlaceText {
  PlaceText({
    this.text,
    this.matches,
  });

  PlaceText.fromJson(dynamic json) {
    text = json['text'];
    if (json['matches'] != null) {
      matches = [];
      json['matches'].forEach((v) {
        matches?.add(Matches.fromJson(v));
      });
    }
  }

  String? text;
  List<Matches>? matches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = text;
    if (matches != null) {
      map['matches'] = matches?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
