class ReportIssueFaqPojo {
  ReportIssueFaqPojo({int? status, String? message, int? messageCode, List<Faqs>? faqs, int? reportIssueCount}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _faqs = faqs;
    _reportIssueCount = reportIssueCount;
  }

  ReportIssueFaqPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _messageCode = json['message_code'];
    if (json['faqs'] != null) {
      _faqs = [];
      json['faqs'].forEach((v) {
        _faqs?.add(Faqs.fromJson(v));
      });
    }
    _reportIssueCount = json['report_issue_count'];
  }

  int? _status;
  String? _message;
  int? _messageCode;
  List<Faqs>? _faqs;
  int? _reportIssueCount;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  List<Faqs> get faqs => _faqs ?? [];

  int get reportIssueCount => _reportIssueCount ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['message_code'] = _messageCode;
    if (_faqs != null) {
      map['faqs'] = _faqs?.map((v) => v.toJson()).toList();
    }
    map['report_issue_count'] = _reportIssueCount;
    return map;
  }
}

/// id : 1
/// name : "Test"
/// description : "Test"

class Faqs {
  Faqs({int? id, String? name, String? description}) {
    _id = id;
    _name = name;
    _description = description;
  }

  Faqs.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
  }

  int? _id;
  String? _name;
  String? _description;

  int get id => _id ?? 0;

  String get name => _name ?? "";

  String get description => _description ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    return map;
  }
}
