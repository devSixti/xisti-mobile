class ReportedIssueHistoryPojo {
  ReportedIssueHistoryPojo({
    int? status,
    String? message,
    int? messageCode,
    int? currentPage,
    int? lastPage,
    int? total,
    List<ReportIssueHistory>? reportIssueHistory,
  }) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _currentPage = currentPage;
    _lastPage = lastPage;
    _total = total;
    _reportIssueHistory = reportIssueHistory;
  }

  ReportedIssueHistoryPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    _currentPage = json['current_page'];
    _lastPage = json['last_page'];
    _total = json['total'];
    if (json['report_issue_history'] != null) {
      _reportIssueHistory = [];
      json['report_issue_history'].forEach((v) {
        _reportIssueHistory?.add(ReportIssueHistory.fromJson(v));
      });
    }
  }

  int? _status;
  String? _message;
  int? _messageCode;
  int? _currentPage;
  int? _lastPage;
  int? _total;
  List<ReportIssueHistory>? _reportIssueHistory;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  int get currentPage => _currentPage ?? 0;

  int get lastPage => _lastPage ?? 0;

  int get total => _total ?? 0;

  List<ReportIssueHistory> get reportIssueHistory => _reportIssueHistory ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    map['current_page'] = _currentPage;
    map['last_page'] = _lastPage;
    map['total'] = _total;
    if (_reportIssueHistory != null) {
      map['report_issue_history'] = _reportIssueHistory?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ReportIssueHistory {
  ReportIssueHistory({
    int? reportId,
    String? referenceNo,
    int? rideNo,
    String? categoryIcon,
    String? categoryName,
    int? serviceCategoryId,
    int? status,
    String? reportIssueDateTime,
  }) {
    _reportId = reportId;
    _referenceNo = referenceNo;
    _rideNo = rideNo;
    _categoryIcon = categoryIcon;
    _categoryName = categoryName;
    _serviceCategoryId = serviceCategoryId;
    _status = status;
    _reportIssueDateTime = reportIssueDateTime;
  }

  ReportIssueHistory.fromJson(dynamic json) {
    _reportId = json['report_id'];
    _referenceNo = json['reference_no'];
    _rideNo = json['ride_no'];
    _categoryIcon = json['category_icon'];
    _categoryName = json['category_name'];
    _serviceCategoryId = json['service_category_id'];
    _status = json['status'];
    _reportIssueDateTime = json['report_issue_date_time'];
  }

  int? _reportId;
  String? _referenceNo;
  int? _rideNo;
  String? _categoryIcon;
  String? _categoryName;
  int? _serviceCategoryId;
  int? _status;
  String? _reportIssueDateTime;

  int get reportId => _reportId ?? 0;

  String get referenceNo => _referenceNo ?? "";

  int get rideNo => _rideNo ?? 0;

  String get categoryIcon => _categoryIcon ?? "";

  String get categoryName => _categoryName ?? "";

  int get serviceCategoryId => _serviceCategoryId ?? 0;

  int get status => _status ?? 0;

  String get reportIssueDateTime => _reportIssueDateTime ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['report_id'] = _reportId;
    map['reference_no'] = _referenceNo;
    map['ride_no'] = _rideNo;
    map['category_icon'] = _categoryIcon;
    map['category_name'] = _categoryName;
    map['service_category_id'] = _serviceCategoryId;
    map['status'] = _status;
    map['report_issue_date_time'] = _reportIssueDateTime;
    return map;
  }
}
