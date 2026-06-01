import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/utils.dart';
import 'referral_dl.dart';
import 'referral_repo.dart';

class ReferralBloc extends Bloc {
  BuildContext context;
  final ReferralRepo _referralRepo = ReferralRepo();

  ReferralBloc(this.context) {
    getReferralList();
  }

  final _subject = BehaviorSubject<ApiResponse<ReferralModel>>();

  BehaviorSubject<ApiResponse<ReferralModel>> get subject => _subject;

  Future<void> getReferralList() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () {
      getReferralList();
    })) {
      _subject.sink.add(ApiResponse.loading());
      try {
        var response = ReferralModel.fromJson(await _referralRepo.getReferralList());

        String message = getApiMsg(response.message);

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          _subject.sink.add(ApiResponse.completed(response));
        } else {
          _subject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        _subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    _subject.close();
  }
}
