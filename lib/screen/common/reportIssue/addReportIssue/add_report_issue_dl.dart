class DraftPojo {
  DraftPojo({int? status, String? message, int? messageCode, int? reportId, int? minReportIssueImageUpload, int? maxReportIssueImageUpload}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _reportId = reportId;
    _minReportIssueImageUpload = minReportIssueImageUpload;
    _maxReportIssueImageUpload = maxReportIssueImageUpload;
  }

  DraftPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _reportId = json['report_id'];
    _minReportIssueImageUpload = json['min_report_issue_image_upload'];
    _maxReportIssueImageUpload = json['max_report_issue_image_upload'];
  }

  int? _status;
  String? _message;
  int? _messageCode;
  int? _reportId;
  int? _minReportIssueImageUpload;
  int? _maxReportIssueImageUpload;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  int get reportId => _reportId ?? 0;

  int get minReportIssueImageUpload => _minReportIssueImageUpload ?? 0;

  int get maxReportIssueImageUpload => _maxReportIssueImageUpload ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['report_id'] = _reportId;
    map['min_report_issue_image_upload'] = _minReportIssueImageUpload;
    map['max_report_issue_image_upload'] = _maxReportIssueImageUpload;
    return map;
  }
}

class UploadImagesPojo {
  UploadImagesPojo({int? status, String? message, int? messageCode, int? isImageValid, List<ImageList>? image}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _image = image;
    _isImageValid = isImageValid;
  }

  UploadImagesPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _isImageValid = json['is_image_valid'];
    if (json['image'] != null) {
      _image = [];
      json['image'].forEach((v) {
        _image?.add(ImageList.fromJson(v));
      });
    }
  }

  int? _status;
  String? _message;
  int? _messageCode;
  int? _isImageValid;
  List<ImageList>? _image;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  int get isImageValid => _isImageValid ?? 0;

  List<ImageList> get image => _image ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['is_image_valid'] = _isImageValid;
    if (_image != null) {
      map['image'] = _image?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ImageList {
  ImageList({int? id, String? image}) {
    _id = id;
    _image = image;
  }

  ImageList.fromJson(dynamic json) {
    _id = json['id'];
    _image = json['image'];
  }

  int? _id;
  String? _image;

  int get id => _id ?? 0;

  String get image => _image ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['image'] = _image;
    return map;
  }
}

class ReportIssueDetailsPojo {
  ReportIssueDetailsPojo({
    int? status,
    String? message,
    int? messageCode,
    String? referenceNo,
    int? rideNo,
    String? description,
    List<Images>? images,
    String? reportChatNo,
    int? minReportIssueImageUpload,
    int? maxReportIssueImageUpload,
  }) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _referenceNo = referenceNo;
    _rideNo = rideNo;
    _description = description;
    _images = images;
    _reportChatNo = reportChatNo;
    _minReportIssueImageUpload = minReportIssueImageUpload;
    _maxReportIssueImageUpload = maxReportIssueImageUpload;
  }

  ReportIssueDetailsPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _referenceNo = json['reference_no'];
    _rideNo = json['ride_no'];
    _description = json['description'];
    _reportChatNo = json['report_chat_number'];
    _minReportIssueImageUpload = json['min_report_issue_image_upload'];
    _maxReportIssueImageUpload = json['max_report_issue_image_upload'];
    if (json['images'] != null) {
      _images = [];
      json['images'].forEach((v) {
        _images?.add(Images.fromJson(v));
      });
    }
  }

  int? _status;
  String? _message;
  int? _messageCode;
  String? _referenceNo;
  int? _rideNo;
  String? _description;
  String? _reportChatNo;
  int? _minReportIssueImageUpload;
  int? _maxReportIssueImageUpload;
  List<Images>? _images;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  String get referenceNo => _referenceNo ?? "";

  int get rideNo => _rideNo ?? 0;

  String get description => _description ?? "";

  String get reportChatNo => _reportChatNo ?? "";

  int get minReportIssueImageUpload => _minReportIssueImageUpload ?? 0;

  int get maxReportIssueImageUpload => _maxReportIssueImageUpload ?? 0;

  List<Images> get images => _images ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['reference_no'] = _referenceNo;
    map['ride_no'] = _rideNo;
    map['description'] = _description;
    map['report_chat_number'] = _reportChatNo;
    map['min_report_issue_image_upload'] = _minReportIssueImageUpload;
    map['max_report_issue_image_upload'] = _maxReportIssueImageUpload;
    if (_images != null) {
      map['images'] = _images?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Images {
  Images({String? image}) {
    _image = image;
  }

  Images.fromJson(dynamic json) {
    _image = json['image'];
  }

  String? _image;

  String get image => _image ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    return map;
  }
}
