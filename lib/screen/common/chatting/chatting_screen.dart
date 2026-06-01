import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_text_field.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../constant/chat_constant.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/utils.dart';
import '../splash/splash_screen.dart';
import 'chatting_bloc.dart';
import 'chatting_dl.dart';
import 'item_chatting.dart';

class ChattingScreen extends StatefulWidget {
  final String chatWithImage, chatWithName, chatWithId, chatNo;
  final int chatWithUserType, reportId;
  final bool showImagePick, isReportIssueChat;

  const ChattingScreen({
    super.key,
    required this.chatWithId,
    required this.chatWithName,
    this.chatWithImage = "",
    required this.chatNo,
    this.chatWithUserType = -1,
    this.showImagePick = false,
    this.isReportIssueChat = false,
    this.reportId = 0,
  });

  @override
  ChattingScreenState createState() => ChattingScreenState();
}

class ChattingScreenState extends State<ChattingScreen> {
  ChattingBloc? _bloc;
  final _controller = ScrollController();

  @override
  void initState() {
    chatState = null;
    chatState = this;
    pushNotificationService.flutterLocalNotificationsPlugin.cancel(
      id: int.parse(
        widget.chatWithId
            .toString()
            .replaceAll(ChatConstant.driverIdCode, "")
            .replaceAll(ChatConstant.userIdCode, "")
            .replaceAll(ChatConstant.adminIdCode, "")
            .trim(),
      ),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    debugPrint("ChatOrderNo: ${widget.chatNo}");
    chatState = this;
    _bloc ??= ChattingBloc(
      widget.chatWithId,
      widget.chatWithName,
      widget.chatWithImage,
      widget.chatWithUserType,
      widget.chatNo,
      widget.isReportIssueChat,
      widget.reportId,
      context,
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    chatState = null;
    _bloc?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onForegroundGained: () {
        chatState = this;
      },
      onVisibilityGained: () {
        chatState = this;
      },
      onFocusGained: () {
        chatState = this;
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            return;
          }
          if (!Navigator.canPop(context)) {
            openScreenWithClearPrevious(context, SplashScreen());
          } else {
            Navigator.pop(context);
          }
        },
        child: ScaffoldWithSafeArea(
          appBar: CommonAppBar(
            centerTitle: true,
            leading: backButtonForAppBarCustom(
              context: context,
              onBackPress: () {
                if (!Navigator.canPop(context)) {
                  openScreenWithClearPrevious(context, const SplashScreen());
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            title: Text(languages.liveChat, style: toolbarStyle(context: context)),
          ),
          body: _buildChatting(),
        ),
      ),
    );
  }

  void scrollToBottom() {
    Timer(
      const Duration(milliseconds: 500),
      () => _controller.animateTo(_controller.position.maxScrollExtent + 1, duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn),
    );
  }

  Widget _buildChatting() {
    return Column(
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 10.h),
          padding: EdgeInsetsDirectional.only(top: 5.h, bottom: 5.h, start: 5.w, end: 10.w),
          decoration: BoxDecoration(
            border: Border.all(color: getCurrentTheme(context).colorBorder),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 0,
                child: LoadImageWithPlaceHolder(
                  image: widget.chatWithId.contains(ChatConstant.adminIdCode) ? "" : widget.chatWithImage,
                  width: 50.sp,
                  height: 50.sp,
                  defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: 10.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.chatWithId.contains(ChatConstant.adminIdCode) ? "Admin" : widget.chatWithName,
                        textAlign: TextAlign.start,
                        style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize18px),
                      ),
                      Text(
                        widget.chatWithId.contains(ChatConstant.adminIdCode)
                            ? ""
                            : getIntFromSettingBox(hiveAppMode) == AppMode.driver
                            ? languages.customer
                            : languages.driver,
                        textAlign: TextAlign.start,
                        style: bodyText(context: context, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<ModelChatting>>(
            stream: _bloc?.subjectChatList,
            builder: (context, snap) {
              List<ModelChatting> chatList = snap.data ?? [];

              if (chatList.isNotEmpty) {
                _controller.jumpTo(0);
              }

              return ListView.builder(
                controller: _controller,
                itemCount: chatList.length,
                padding: EdgeInsetsDirectional.only(bottom: 30.h, top: 20.h),
                reverse: true,
                itemBuilder: (context, index) {
                  ModelChatting modelChatList = chatList[index];
                  return ItemChatting(userId: _bloc?.userId ?? "", modelChatting: modelChatList);
                },
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin(), top: 10.h),
          decoration: BoxDecoration(
            border: Border.all(color: getCurrentTheme(context).colorDarkBorder),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Expanded(child: msgField()),
              GestureDetector(
                onTap: () {
                  _bloc?.sendMsg();
                },
                child: Container(
                  margin: EdgeInsetsDirectional.only(end: 20.w),
                  child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(isRtl() ? pi : 0),
                      child: Icon(CustomIcons.send, size: 15.sp, color: getCurrentTheme(context).colorIconCommon)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextFormFieldCustom msgField() {
    return TextFormFieldCustom(
      backgroundColor: Colors.transparent,
      controller: _bloc?.msgController,
      hint: languages.writeAMessageHere,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      maxLine: 2,
      minLine: 1,
      prefix: (widget.showImagePick)
          ? GestureDetector(
              onTap: () {
                _bloc?.uploadImage();
              },
              child: SizedBox(
                width: 40.w,
                child: Icon(Icons.attach_file_rounded, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
              ),
            )
          : SizedBox(
              width: 40.w,
              child: Icon(CustomIcons.chat, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
            ),
      contentPadding: EdgeInsetsDirectional.only(top: 10.h, bottom: 10.h),
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        errorBorder: InputBorder.none,
      ),
    );
  }
}
