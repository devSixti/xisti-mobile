const int allAmount = 0;
const int creditAmount = 1;
const int debitAmount = 2;

/// status : 1
/// message : "success!"
/// message_code : 1
/// wallet_balance : 0

class WalletBalancePojo {
  int? _status;
  String? _message;
  int? _messageCode;
  int? _isAutoSettle;
  dynamic _walletBalance;
  String? _redirectUrl;
  String? _failedUrl;
  String? _successUrl;
  List<TopupWallet>? walletTopUpOptionList;
  double? minWompiTopupAmount;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  int get isAutoSettle => _isAutoSettle ?? 0;

  String get redirectUrl => _redirectUrl ?? "";
  String get failedUrl => _failedUrl ?? "";
  String get successUrl => _successUrl ?? "";

  dynamic get walletBalance => _walletBalance;

  void setWalletBalance(dynamic walletBalance) {
    _walletBalance = walletBalance;
  }

  WalletBalancePojo({int? status, String? message, int? messageCode, dynamic walletBalance, this.walletTopUpOptionList, int? isAutoSettle}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _walletBalance = walletBalance;
    _isAutoSettle = isAutoSettle;
  }

  WalletBalancePojo.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _messageCode = json["message_code"];
    _walletBalance = json["wallet_balance"];
    _redirectUrl = json["redirect_url"];
    _failedUrl = json["failed_url"];
    _successUrl = json["success_url"];
    _isAutoSettle = json["is_auto_settle"];
    minWompiTopupAmount = double.tryParse('${json["min_wompi_topup_amount"]}');
    if (json['topup_wallet'] != null) {
      walletTopUpOptionList = [];
      json['topup_wallet'].forEach((v) {
        walletTopUpOptionList?.add(TopupWallet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["message_code"] = _messageCode;
    map["wallet_balance"] = _walletBalance;
    map["redirect_url"] = _redirectUrl;
    map["failed_url"] = _failedUrl;
    map["success_url"] = _successUrl;
    map["is_auto_settle"] = _isAutoSettle;
    map["min_wompi_topup_amount"] = minWompiTopupAmount;
    if (walletTopUpOptionList != null) {
      map['topup_wallet'] = walletTopUpOptionList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class TopupWallet {
  TopupWallet({this.id, this.name, this.packagePrice});

  TopupWallet.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    packagePrice = json['package_price'];
  }

  int? id;
  String? name;
  dynamic packagePrice;
  String? assetImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['package_price'] = packagePrice;
    return map;
  }
}

/// status : 1
/// message : "success!"
/// message_code : 1
/// transactions : [{"id":177,"transaction_type":1,"amount":10,"subject":"credit by user","remaining_balance":10,"date_time":"2021-03-25 11:25:06"}]

class WalletTransactionPojo {
  int? _status;
  String? _message;
  int? _messageCode;
  int? lastPage;
  List<TransactionsItem>? _transactions;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  List<TransactionsItem>? get transactions => _transactions ?? [];

  WalletTransactionPojo({int? status, String? message, int? messageCode, List<TransactionsItem>? transactions, this.lastPage}) {
    _status = status;
    _message = message;
    _messageCode = messageCode;
    _transactions = transactions;
  }

  WalletTransactionPojo.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _messageCode = json["message_code"];
    lastPage = json["last_page"];
    if (json["transactions"] != null) {
      _transactions = [];
      json["transactions"].forEach((v) {
        _transactions?.add(TransactionsItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["message_code"] = _messageCode;
    map["last_page"] = lastPage;
    if (_transactions != null) {
      map["transactions"] = _transactions?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 177
/// transaction_type : 1
/// amount : 10
/// subject : "credit by user"
/// remaining_balance : 10
/// date_time : "2021-03-25 11:25:06"

class TransactionsItem {
  int? _id;
  int? _transactionType;
  dynamic _amount;
  String? _subject;
  dynamic _remainingBalance;
  String? _dateTime;
  String? _serviceCategoryName;
  String? _serviceCategoryImage;
  String? _orderNo;

  int get id => _id ?? 0;

  int get transactionType => _transactionType ?? 0;

  dynamic get amount => _amount;

  String get subject => _subject ?? "";

  dynamic get remainingBalance => _remainingBalance;

  String get dateTime => _dateTime ?? "";

  String get serviceCategoryName => _serviceCategoryName ?? "";

  String get serviceCategoryImage => _serviceCategoryImage ?? "";

  String get orderNo => _orderNo ?? "";

  TransactionsItem({
    int? id,
    int? transactionType,
    dynamic amount,
    String? subject,
    dynamic remainingBalance,
    String? dateTime,
    String? serviceCategoryName,
    String? serviceCategoryImage,
    String? orderNo,
  }) {
    _id = id;
    _transactionType = transactionType;
    _amount = amount;
    _subject = subject;
    _remainingBalance = remainingBalance;
    _dateTime = dateTime;
    _serviceCategoryName = serviceCategoryName;
    _serviceCategoryImage = serviceCategoryImage;
    _orderNo = orderNo;
  }

  TransactionsItem.fromJson(dynamic json) {
    _id = json["id"];
    _transactionType = json["transaction_type"];
    _amount = json["amount"];
    _subject = json["subject"];
    _remainingBalance = json["remaining_balance"];
    _dateTime = json["date_time"];
    _serviceCategoryName = json["service_category_name"];
    _serviceCategoryImage = json["service_category_image"];
    _orderNo = json["order_no"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["transaction_type"] = _transactionType;
    map["amount"] = _amount;
    map["subject"] = _subject;
    map["remaining_balance"] = _remainingBalance;
    map["date_time"] = _dateTime;
    map["service_category_name"] = _serviceCategoryName;
    map["service_category_image"] = _serviceCategoryImage;
    map["order_no"] = _orderNo;
    return map;
  }
}

class ServiceCategoryPojo {
  int? _status;
  int? _messageCode;
  String? _message;

  // List<ServiceLists>? _services;

  ServiceCategoryPojo.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _messageCode = json["message_code"];
    // if (json['services'] != null) {
    //   _services = [];
    //   json['services'].forEach((v) {
    //     _services?.add(ServiceLists.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    map["message_code"] = messageCode;
    // if (_services != null) {
    //   map['services'] = _services?.map((v) => v.toJson()).toList();
    // }
    return map;
  }

  // List<ServiceLists> get services => _services ?? [];

  String get message => _message ?? "";

  int get messageCode => _messageCode ?? 0;

  int get status => _status ?? 0;
}
