class FeedbackPojo {
  int? _status;
  String? _message;
  int? _messageCode;
  List<FeedbackListItem>? _feedbackList;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  List<FeedbackListItem> get feedbackList => _feedbackList ?? [];

  FeedbackPojo({int? status, String? message, int? messageCode, List<FeedbackListItem>? feedbackList}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _feedbackList = feedbackList;
  }

  FeedbackPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    if (json['feedback_list'] != null) {
      _feedbackList = [];
      json['feedback_list'].forEach((v) {
        _feedbackList?.add(FeedbackListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    if (_feedbackList != null) {
      map['feedback_list'] = _feedbackList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// rating_id : 395
/// service_cat_id : 2
/// ride_id : 919
/// user_name : "Hardik Talaviya"
/// user_profile_image : "https://fox-jek.startuptrinity.com/assets/images/profile-images/customer/9065615202001128.jpg"
/// rating : 4
/// comment : ""
/// service_category_name : "TAXI RIDE"
/// datetime : "Mon 26 Jul, 2021"

class FeedbackListItem {
  int? _ratingId;
  int? _totalRatings;
  int? _serviceCatId;
  int? _rideId;
  String? _userName;
  String? _userProfileImage;
  dynamic _rating;
  String? _comment;
  String? _serviceCategoryName;
  String? _datetime;

  int get ratingId => _ratingId ?? 0;

  int get totalRatings => _totalRatings ?? 0;

  int get serviceCatId => _serviceCatId ?? 0;

  int get rideId => _rideId ?? 0;

  String get userName => _userName ?? "";

  String get userProfileImage => _userProfileImage ?? "";

  dynamic get rating => _rating ?? 0;

  String get comment => _comment ?? "";

  String get serviceCategoryName => _serviceCategoryName ?? "";

  String get datetime => _datetime ?? "";

  FeedbackListItem({
    int? ratingId,
    int? totalRatings,
    int? serviceCatId,
    int? rideId,
    String? userName,
    String? userProfileImage,
    dynamic rating,
    String? comment,
    String? serviceCategoryName,
    String? datetime,
  }) {
    _ratingId = ratingId;
    _totalRatings = totalRatings;
    _serviceCatId = serviceCatId;
    _rideId = rideId;
    _userName = userName;
    _userProfileImage = userProfileImage;
    _rating = rating;
    _comment = comment;
    _serviceCategoryName = serviceCategoryName;
    _datetime = datetime;
  }

  FeedbackListItem.fromJson(dynamic json) {
    _ratingId = json['rating_id'];
    _totalRatings = json['total_ratings'];
    _serviceCatId = json['service_cat_id'];
    _rideId = json['ride_id'];
    _userName = json['user_name'];
    _userProfileImage = json['user_profile_image'];
    _rating = json['rating'];
    _comment = json['comment'];
    _serviceCategoryName = json['service_category_name'];
    _datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['rating_id'] = _ratingId;
    map['total_ratings'] = _totalRatings;
    map['service_cat_id'] = _serviceCatId;
    map['ride_id'] = _rideId;
    map['user_name'] = _userName;
    map['user_profile_image'] = _userProfileImage;
    map['rating'] = _rating;
    map['comment'] = _comment;
    map['service_category_name'] = _serviceCategoryName;
    map['datetime'] = _datetime;
    return map;
  }
}
