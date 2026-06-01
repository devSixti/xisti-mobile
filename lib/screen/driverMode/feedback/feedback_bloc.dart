import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/utils.dart';
import 'feedback_dl.dart';
import 'feedback_repo.dart';

class FeedbackBloc extends Bloc {
  late BuildContext context;
  final FeedbackRepo _feedbackRepo = FeedbackRepo();

  FeedbackBloc(this.context) {
    callCustomerFeedback();
  }

  final subject = BehaviorSubject<ApiResponse<FeedbackPojo>>();

  Future<void> callCustomerFeedback() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callCustomerFeedback();
      },
    )) {
      subject.sink.add(ApiResponse.loading());
      try {
        var response = FeedbackPojo.fromJson(await _feedbackRepo.customerFeedback());

        if (!context.mounted) return;
        String message = getApiMsg(response.message);
        if (isApiStatus(context, response.status, message, true)) {
          if (response.feedbackList.isNotEmpty) {
            subject.sink.add(ApiResponse.completed(response));
          } else {
            subject.sink.add(ApiResponse.error(languages.noRecordFound));
          }
        } else {
          subject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        debugPrint(e.toString());
        subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    subject.close();
  }
}
