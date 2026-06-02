import 'dart:io';

/// status : 1
/// message : "success!"
/// message_code : 1
/// doc_status : 1
/// document_list : [{"document_id":2,"service_category_id":2,"document_name":"Driver’s License","document_file":"https://admin.xistiapp.com/assets/images/provider-documents/4235901202003127.jpg","document_status":0},{"document_id":13,"service_category_id":2,"document_name":"Insurance","document_file":"","document_status":3}]

class RequireDocument {
  RequireDocument({this.status, this.message, this.messageCode, this.driverDocStatus, this.isDriverType, this.documentList});

  RequireDocument.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['message_code'];
    driverDocStatus = json['driver_doc_status'];
    isDriverType = json['is_driver_type'];
    if (json['document_list'] != null) {
      documentList = [];
      json['document_list'].forEach((v) {
        documentList?.add(DocumentList.fromJson(v));
      });
    }
  }

  int? status;
  String? message;
  int? messageCode;
  int? driverDocStatus;
  int? isDriverType;
  List<DocumentList>? documentList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['message_code'] = messageCode;
    map['driver_doc_status'] = driverDocStatus;
    map['is_driver_type'] = isDriverType;
    if (documentList != null) {
      map['document_list'] = documentList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// document_id : 1
/// document_name : "Driver’s License"
/// document_file : "https://admin.xistiapp.com/assets/images/provider-documents/8165301202504064.jpg"
/// contains_expiry : 1
/// document_expire_date : "2025-06-04"
/// document_status : 0

class DocumentList {
  DocumentList({
    this.documentId,
    this.documentName,
    this.documentFile,
    this.containsExpiry,
    this.documentExpireDate,
    this.documentStatus,
    double progress = 0,
    File? selectedImgFile,
  }) {
    _progress = progress;
    _progress = progress;
    _selectedImgFile = selectedImgFile;
  }

  DocumentList.fromJson(dynamic json) {
    documentId = json['document_id'];
    documentName = json['document_name'];
    documentFile = json['document_file'];
    containsExpiry = json['contains_expiry'];
    documentExpireDate = json['document_expire_date'];
    documentStatus = json['document_status'];
  }

  int? documentId;
  String? documentName;
  String? documentFile;
  int? containsExpiry;
  String? documentExpireDate;
  int? documentStatus;
  File? _selectedImgFile;
  bool _isLoading = false;
  double _progress = 0;

  File? get selectedImgFile => _selectedImgFile;

  bool get isLoading => _isLoading;

  double get progress => _progress;

  void setSelectedImgFile(File selectedImgFile) {
    _selectedImgFile = selectedImgFile;
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  void setProgress(double progress) {
    _progress = progress;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['document_id'] = documentId;
    map['document_name'] = documentName;
    map['document_file'] = documentFile;
    map['contains_expiry'] = containsExpiry;
    map['document_expire_date'] = documentExpireDate;
    map['document_status'] = documentStatus;
    return map;
  }
}

class UploadSingleDocPojo {
  int? _status;
  String? _message;
  List<DocumentList>? _requiredDocumentList;
  int? _messageCode;
  int? _driverDocStatus;
  int? _isDriverType;

  int get status => _status ?? 0;

  int get messageCode => _messageCode ?? 0;

  int get driverDocStatus => _driverDocStatus ?? 0;

  String get message => _message ?? "";

  int get isDriverType => _isDriverType ?? 0;

  List<DocumentList> get requiredDocumentList => _requiredDocumentList ?? [];

  UploadSingleDocPojo({int? status, String? message, List<DocumentList>? requiredDocumentList, int? messageCode, int? driverDocStatus, int? isDriverType}) {
    _status = status;
    _message = message;
    _requiredDocumentList = requiredDocumentList;
    _messageCode = messageCode;
    _driverDocStatus = driverDocStatus;
    _isDriverType = isDriverType;
  }

  UploadSingleDocPojo.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _driverDocStatus = json["driver_doc_status"];
    _isDriverType = json["is_driver_type"];
    if (json["document_list"] != null) {
      _requiredDocumentList = [];
      json["document_list"].forEach((v) {
        _requiredDocumentList!.add(DocumentList.fromJson(v));
      });
    }
    _messageCode = json["message_code"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["document_list"] = _requiredDocumentList!.map((v) => v.toJson()).toList();
    map["message_code"] = _messageCode;
    map["driver_doc_status"] = _driverDocStatus;
    map["is_driver_type"] = _isDriverType;
    return map;
  }
}
