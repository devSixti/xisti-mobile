import 'package:flutter/material.dart';

import '../../../../blocs/bloc.dart';
import '../../../../hive/hive_helper.dart';
import '../../../../utils/utils.dart';
import '../issueRideHistory/issuePassengerRideHistory/issue_passenger_ride_history.dart';
import '../issueRideHistory/issueDriverRideHistory/issue_driver_ride_history.dart';
import '../reportedIssueHistory/reported_issue_history.dart';
import 'report_issue_home_dl.dart';
import 'report_issue_home_repo.dart';

class ReportIssueHomeBloc extends Bloc {
  BuildContext context;

  ReportIssueHomeBloc(this.context) {
    callReportIssueFaqApi();
  }

  final ReportIssueHomeRepo _reportIssueRepo = ReportIssueHomeRepo();

  int reportIssueCount = 0;

  final reportIssueFaqSubject = BehaviorSubject<ApiResponse<ReportIssueFaqPojo>>();

  void addIssueClick() {
    if (reportIssueCount == 0) {
      if (getIntFromSettingBox(hiveAppMode) == AppMode.passenger) {
        openScreen(context, const IssuePassengerRideHistory());
      } else {
        openScreen(context, const IssueDriverRideHistory());
      }
    } else {
      openScreen(context, const ReportedIssueHistory());
    }
  }

  //--------------------------------------Api Calling Start----------------------------
  Future<void> callReportIssueFaqApi() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => callReportIssueFaqApi())) {
      reportIssueFaqSubject.sink.add(ApiResponse.loading());
      try {
        ReportIssueFaqPojo response = ReportIssueFaqPojo.fromJson(await _reportIssueRepo.faqListApi());

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true)) {
          reportIssueFaqSubject.sink.add(ApiResponse.completed(response));
          reportIssueCount = response.reportIssueCount;
        } else {
          reportIssueFaqSubject.sink.add(ApiResponse.error(response.message));
          if (response.status != 3) openSimpleSnackbar(context, response.message);
        }
      } catch (e) {
        reportIssueFaqSubject.sink.add(ApiResponse.error(e.toString()));
        if (context.mounted) openSimpleSnackbar(context, e.toString());
      }
    }
  }
  //--------------------------------------Api Calling End----------------------------

  @override
  void dispose() {
    reportIssueFaqSubject.close();
  }
}
