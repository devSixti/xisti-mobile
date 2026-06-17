import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/image_selection.dart';
import '../../../constant/chat_constant.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/utils.dart';
import 'chat_repo.dart';
import 'chatting_dl.dart';

class ChattingBloc extends Bloc {
  String tag = "ChattingBloc>>>";
  final BuildContext context;
  final String chatWithId, chatWithName, chatWithImage, chatNo;
  final int chatWithUserType, reportId;
  final bool isReportIssueChat;

  ChattingBloc(
    this.chatWithId,
    this.chatWithName,
    this.chatWithImage,
    this.chatWithUserType,
    this.chatNo,
    this.isReportIssueChat,
    this.reportId,
    this.context,
  ) {
    userName = getStringFromUserInfoBox(hiveUserName);
    userId = ChatConstant.userIdCode + getIntFromUserInfoBox(hiveUserId).toString();
    setAllDatabaseReference();
    setFCMToken();
    getChatWithFCMToken();
    setChatList();
  }

  final _chatRepo = ChatRepo();
  final msgController = TextEditingController();

  final subjectUploadPhoto = BehaviorSubject<ApiResponse<ChattingPojo>>();
  var subjectChatList = BehaviorSubject<List<ModelChatting>>();

  late FirebaseDatabase firebaseDatabase;
  late DatabaseReference _refUserToChatWith, _refChatWithToUser, _referenceServerTimeZone;
  late String userId, userName, chatWithFCMToken;

  void setAllDatabaseReference() {
    firebaseDatabase = FirebaseDatabase.instance;
    if (isReportIssueChat) {
      _refUserToChatWith = firebaseDatabase.ref().child(ChatConstant.chat).child(ChatConstant.reportIssueChat).child(chatNo).child("${userId}_$chatWithId");
      _refChatWithToUser = firebaseDatabase.ref().child(ChatConstant.chat).child(ChatConstant.reportIssueChat).child(chatNo).child("${chatWithId}_$userId");
    } else {
      _refUserToChatWith = firebaseDatabase.ref().child(ChatConstant.chat).child(ChatConstant.orderChat).child(chatNo).child("${userId}_$chatWithId");
      _refChatWithToUser = firebaseDatabase.ref().child(ChatConstant.chat).child(ChatConstant.orderChat).child(chatNo).child("${chatWithId}_$userId");
    }
    _referenceServerTimeZone = firebaseDatabase.ref().child(ChatConstant.chat).child(ChatConstant.serverTimezone).child(ChatConstant.timestamp);
  }

  void setChatList() {
    _refUserToChatWith.onValue.forEach((element) {
      // logD(tag: tag, message: "_refUserToChatWith.onValue");
      DataSnapshot dataSnapshot = element.snapshot;
      Map? data = dataSnapshot.value as Map<dynamic, dynamic>?;
      List<ModelChatting> chatList = [];
      data?.forEach((key, value) {
        ModelChatting modelChatList = ModelChatting.fromJson(value);
        chatList.add(modelChatList);
      });
      if (chatList.isNotEmpty) {
        chatList.sort((a, b) {
          DateTime aDate = DateTime.fromMillisecondsSinceEpoch(int.parse(a.date));
          DateTime bDate = DateTime.fromMillisecondsSinceEpoch(int.parse(b.date));
          return bDate.toString().compareTo(aDate.toString());
        });
      }
      if (subjectChatList.isClosed) return;
      subjectChatList.add(chatList);
    });
  }

  void getChatWithFCMToken() {
    DatabaseReference refUsers = firebaseDatabase.ref().child(ChatConstant.chat).child(ChatConstant.fcmToken).child(chatWithId).child(ChatConstant.fcmToken);
    refUsers.once().then((dataSnapshot) {
      if (dataSnapshot.snapshot.value != null) {
        chatWithFCMToken = dataSnapshot.snapshot.value.toString();
      } else {
        chatWithFCMToken = "";
      }
      return;
    });
  }

  void sendMsg({bool isImage = false, String img = ''}) {
    String msg = msgController.text.trim();
    if (isImage ? img.isNotEmpty : msg.isNotEmpty) {
      getChatWithFCMToken();
      msgController.text = "";
      _referenceServerTimeZone.set(ServerValue.timestamp).then((value) {
        _referenceServerTimeZone.once().then((dataSnapshot) {
          String key = "${dataSnapshot.snapshot.value}";
          FocusManager.instance.primaryFocus?.unfocus();
          var map = <String, String>{};
          map[ChatConstant.fbSenderId] = userId;
          map[ChatConstant.fbMessage] = isImage ? img : msg;
          map[ChatConstant.fbIsImage] = isImage ? "1" : "0";
          map[ChatConstant.fbSenderName] = userName;
          map[ChatConstant.fbMessageTime] = key;
          _refUserToChatWith.child(key).set(map);
          _refChatWithToUser.child(key).set(map);
          if (chatWithFCMToken.trim().isNotEmpty) {
            callNotificationApi(msg, isImage: isImage);
          }
        });
      });
    }
  }

  void uploadImage() {
    selectImgFromCameraOrGallery(context, (file) async {
      await compressImage(file).then((value) {
        callUploadImageApi(value.path);
      });
    });
  }

  Future<void> callNotificationApi(String msg, {bool isImage = false}) async {
    // FCM for chat is sent server-side; client must not ship service account credentials.
    debugPrint('$tag chat push skipped (server-side FCM only)');
  }

  Future<void> callUploadImageApi(String filePath) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => callUploadImageApi(filePath))) {
      try {
        subjectUploadPhoto.add(ApiResponse.loading());
        MultipartFile? multipartFile = MultipartFile.fromFileSync(filePath, filename: filePath.split('/').last);

        final response = ChattingPojo.fromJson(await _chatRepo.sendImageCall(chatNo, multipartFile));

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true, showMess: true)) {
          subjectUploadPhoto.add(ApiResponse.completed(response));
          sendMsg(isImage: true, img: response.chatImagePath);
        } else {
          subjectUploadPhoto.add(ApiResponse.error(response.message));
          if (response.status != 3) openSimpleSnackbar(context, response.message);
        }
      } catch (e) {
        subjectUploadPhoto.add(ApiResponse.error(e.toString()));
        if (!context.mounted) return;
        openSimpleSnackbar(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    msgController.dispose();
    subjectChatList.close();
    subjectUploadPhoto.close();
  }
}
