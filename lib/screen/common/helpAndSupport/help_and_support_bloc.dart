import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/utils.dart';
import 'help_and_support_dl.dart';
import 'help_and_support_repo.dart';

class HelpAndSupportBloc extends Bloc {
  BuildContext context;
  final HelpAndSupportRepo _repo = HelpAndSupportRepo();

  HelpAndSupportBloc(this.context) {
    getSupportPage();
  }

  final _subject = BehaviorSubject<ApiResponse<SupportPojo>>();

  BehaviorSubject<ApiResponse<SupportPojo>> get subject => _subject;

  Future<void> getSupportPage() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => getSupportPage())) {
      _subject.sink.add(ApiResponse.loading());
      try {
        var response = SupportPojo.fromJson(await _repo.getHelpAndSupport());

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true, showMess: true)) {
          if ((response.pages).isNotEmpty) {
            _subject.sink.add(ApiResponse.completed(response));
          } else {
            _subject.sink.add(ApiResponse.error(languages.noRecordFound));
          }
        } else {
          _subject.sink.add(ApiResponse.error(response.message));
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
