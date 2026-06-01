// status : 1
// message : "success!"
// account_number : "45454554455454"
// holder_name : "Test"
// bank_name : "Hwhwh"
// bank_location : "Hehwh"
// payment_email : "Hwhw@hshs.jsjs"
// bic_swift_code : "Hshs"
// message_code : 1

class BankDetailPojo {
  int? _status;
  String? _message;
  String? _accountNumber;
  String? _holderName;
  String? _bankName;
  String? _bankLocation;
  String? _paymentEmail;
  String? _bicSwiftCode;
  int? _messageCode;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  String? get accountNumber => _accountNumber;

  String? get holderName => _holderName;

  String? get bankName => _bankName;

  String? get bankLocation => _bankLocation;

  String? get paymentEmail => _paymentEmail;

  String? get bicSwiftCode => _bicSwiftCode;

  int get messageCode => _messageCode ?? 0;

  BankDetailPojo(
      {int? status,
      String? message,
      String? accountNumber,
      String? holderName,
      String? bankName,
      String? bankLocation,
      String? paymentEmail,
      String? bicSwiftCode,
      int? messageCode}) {
    _status = status;
    _message = message;
    _accountNumber = accountNumber;
    _holderName = holderName;
    _bankName = bankName;
    _bankLocation = bankLocation;
    _paymentEmail = paymentEmail;
    _bicSwiftCode = bicSwiftCode;
    _messageCode = messageCode;
  }

  BankDetailPojo.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _accountNumber = json["account_number"];
    _holderName = json["holder_name"];
    _bankName = json["bank_name"];
    _bankLocation = json["bank_location"];
    _paymentEmail = json["payment_email"];
    _bicSwiftCode = json["bic_swift_code"];
    _messageCode = json["message_code"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["account_number"] = _accountNumber;
    map["holder_name"] = _holderName;
    map["bank_name"] = _bankName;
    map["bank_location"] = _bankLocation;
    map["payment_email"] = _paymentEmail;
    map["bic_swift_code"] = _bicSwiftCode;
    map["message_code"] = _messageCode;
    return map;
  }
}
