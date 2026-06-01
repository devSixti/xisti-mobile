import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../../../blocs/bloc.dart';
import '../../../constant/constant.dart';
import '../../../hive/hive_helper.dart';
import '../../../main.dart';
import 'invite_friends.dart';

class InviteFriendsBloc extends Bloc {
  final BuildContext context;
  final State<InviteFriend> state;

  InviteFriendsBloc(this.context, this.state);

  final _referralCodeController = BehaviorSubject<String>.seeded(getStringFromUserInfoBox(hiveReferralCode));

  Stream<String> get referralCode => _referralCodeController.stream;

  Function(String) get changeReferralCode => _referralCodeController.sink.add;

  void shareReferralCode() {
    PackageInfo.fromPlatform().then((value) {
      String link = "";
      if (Platform.isAndroid) {
        link = "http://play.google.com/store/apps/details?id=${value.packageName}";
      } else if (Platform.isIOS || Platform.isMacOS) {
        link = "https://apps.apple.com/app/id$appleId";
      } else {
        link = "";
      }
      String text = "${languages.use} (${_referralCodeController.value}) ${languages.referCodeGetDiscount}\n${languages.download} ${value.appName} :- $link";
      if (!context.mounted) return;
      final box = context.findRenderObject() as RenderBox?;
      final params = ShareParams(text: text, sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
      SharePlus.instance.share(params);
    });
  }

  @override
  void dispose() {}
}
