import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../utils/utils.dart';
import 'invite_friends_bloc.dart';

class InviteFriend extends StatefulWidget {
  const InviteFriend({super.key});

  @override
  State<InviteFriend> createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend> {
  bool isFirstClick = true;
  Timer? _timer;

  InviteFriendsBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= InviteFriendsBloc(context, this);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      appBar: CommonAppBar(
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(languages.inviteFriends, style: toolbarStyle(context: context)),
      ),
      body: _buildInviteFriend(),
    );
  }

  Widget _buildInviteFriend() {
    return Stack(
      children: [
        Container(
          alignment: AlignmentDirectional.topCenter,
          width: double.maxFinite,
          padding: EdgeInsetsDirectional.only(start: 25.w, end: 25.w),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(setImagesBasedOnTheme(context, "invite_friend.png"), width: double.infinity, fit: BoxFit.fitWidth),
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 20.h, top: 40.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
                child: Text(
                  languages.referFriendAndGetBenefits,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize18px),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 20.h),
                child: Text(languages.inviteFriendsMsg, style: bodyText(context: context), textAlign: TextAlign.center, maxLines: 3),
              ),
              StreamBuilder<String>(
                stream: _bloc?.referralCode,
                builder: (context, referralCode) {
                  return Container(
                    width: 200.w,
                    height: 45.h,
                    margin: EdgeInsetsDirectional.only(bottom: 25.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 1.sp),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () async {
                              await Clipboard.setData(ClipboardData(text: referralCode.data ?? ""));
                            },
                            child: Container(
                              margin: EdgeInsetsDirectional.only(end: 5.w),
                              child: Icon(CustomIcons.copy, color: getCurrentTheme(context).colorIconCommon, size: 24.sp),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "#${referralCode.data}",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: bodyText(context: context, fontWeight: FontWeight.w600, textColor: getCurrentTheme(context).colorPrimary),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: CustomRoundedButton(
            context,
            languages.shareInvite,
            () {
              if (isFirstClick) {
                setState(() {
                  isFirstClick = false;
                });

                _bloc?.shareReferralCode();

                _timer = Timer(const Duration(milliseconds: 1500), () {
                  setState(() {
                    isFirstClick = true;
                  });
                });
              }
            },
            padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w),
            margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin()),
          ),
        ),
      ],
    );
  }
}
