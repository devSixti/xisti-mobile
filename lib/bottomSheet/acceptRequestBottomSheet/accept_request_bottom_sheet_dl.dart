class OfferRatePojo {
  int? _isCustom;
  dynamic _offerAmount;

  int get isCustom => _isCustom ?? 0;

  dynamic get offerAmount => _offerAmount ?? 0;

  OfferRatePojo({int? isCustom, dynamic offerAmount}) {
    _isCustom = isCustom;
    _offerAmount = offerAmount;
  }

  OfferRatePojo.fromJson(dynamic json) {
    _isCustom = json["is_custom"];
    _offerAmount = json["offer_amount"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["is_custom"] = _isCustom;
    map["offer_amount"] = _offerAmount;
    return map;
  }
}