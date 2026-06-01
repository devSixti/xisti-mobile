import 'package:firebase_database/firebase_database.dart';

import '../../../constant/chat_constant.dart';

class ModelChatList {
  String? _userId;
  String? _userName;
  String? _userProfile;
  String? _lastMsg;
  String? _lastMsgTime;
  String? _userFCMToken;
  String? _userDateTime;
  int? _userType;

  ModelChatList(this._userId, this._userName, this._userProfile, this._lastMsg, this._lastMsgTime, this._userFCMToken, this._userDateTime);

  int get userType => _userType ?? -1;

  String get userId => _userId ?? "0";

  String get userName => _userName ?? "";

  String get userProfile => _userProfile ?? "";

  String get lastMsg => _lastMsg ?? "";

  String get lastMsgTime => _lastMsgTime ?? "";

  String get userFCMToken => _userFCMToken ?? "";

  String get userDateTime => _userDateTime ?? "";

  ModelChatList.fromSnapshot(DataSnapshot snapshot) {
    Map<String, dynamic> result = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
    _userId = result[ChatConstant.userId];
    _userName = result[ChatConstant.userName];
    _userProfile = result[ChatConstant.userProfile];
    _lastMsg = result[ChatConstant.userLastMessage];
    _lastMsgTime = result[ChatConstant.userDateTime];
    _userDateTime = result[ChatConstant.userDateTime];
    _userType = result[ChatConstant.userType];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map[ChatConstant.userDateTime] = _lastMsgTime;
    map[ChatConstant.userLastMessage] = _lastMsg;
    map[ChatConstant.userProfile] = _userProfile;
    map[ChatConstant.userId] = _userId;
    map[ChatConstant.userName] = _userName;
    map[ChatConstant.userType] = _userType;
    return map;
  }
}

class ModelChatting {
  String? _message, _senderId, _senderName, _date, _isImage;

  ModelChatting(this._message, this._senderId, this._senderName, this._date);

  String get message => _message ?? "";

  String get senderId => _senderId ?? "";

  String get senderName => _senderName ?? "";

  String get date => _date ?? "";

  String get isImage => _isImage ?? "";

  ModelChatting.fromSnapshot(DataSnapshot snapshot) {
    Map<String, dynamic> result = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
    _message = result[ChatConstant.fbMessage];
    _senderId = result[ChatConstant.fbSenderId];
    _senderName = result[ChatConstant.fbSenderName];
    _date = result[ChatConstant.fbMessageTime];
    _isImage = result[ChatConstant.fbIsImage];
  }

  ModelChatting.fromJson(dynamic json) {
    _message = json[ChatConstant.fbMessage];
    _senderId = json[ChatConstant.fbSenderId];
    _senderName = json[ChatConstant.fbSenderName];
    _date = json[ChatConstant.fbMessageTime];
    _isImage = json[ChatConstant.fbIsImage];
  }
}

class ChattingPojo {
  ChattingPojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _chatImagePath = json['chat_image_path'];
    _messageCode = json['message_code'];
  }

  int? _status;
  String? _message;
  String? _chatImagePath;
  int? _messageCode;

  int get status => _status ?? 0;

  String get message => _message ?? "";

  String get chatImagePath => _chatImagePath ?? "";

  int get messageCode => _messageCode ?? 0;
}
