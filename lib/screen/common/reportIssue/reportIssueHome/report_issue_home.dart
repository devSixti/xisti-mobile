import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonView/common_view.dart';
import '../../../../commonView/custom_rounded_button.dart';
import '../../../../commonView/no_record_found.dart';
import '../../../../networking/api_response.dart';
import '../../../../utils/utils.dart';
import 'report_issue_home_bloc.dart';
import 'report_issue_home_dl.dart';
import 'report_issue_home_shimmer.dart';

class ReportIssueHome extends StatefulWidget {
  const ReportIssueHome({super.key});

  @override
  State<ReportIssueHome> createState() => _ReportIssueHomeState();
}

class _ReportIssueHomeState extends State<ReportIssueHome> {
  ReportIssueHomeBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= ReportIssueHomeBloc(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      appBar: CommonAppBar(
        centerTitle: true,
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        title: Text(languages.reportIssue, textAlign: TextAlign.center, style: toolbarStyle(context: context)),
      ),
      body: _buildReportIssueHome(context),
    );
  }

  Widget _buildReportIssueHome(BuildContext context) {
    return StreamBuilder<ApiResponse<ReportIssueFaqPojo>>(
      stream: _bloc?.reportIssueFaqSubject,
      builder: (context, snap) {
        switch (snap.data?.status ?? Status.loading) {
          case Status.loading:
            return ReportIssueHomeShimmer();
          case Status.error:
            return noRecordFoundView();
          case Status.completed:
            return faqView(context, faqsList: snap.data?.data?.faqs ?? []);
        }
      },
    );
  }

  Widget noRecordFoundView() {
    return Stack(children: [NoRecordFound(message: languages.noRecordFound), Align(alignment: AlignmentDirectional.bottomCenter, child: button())]);
  }

  Widget faqView(BuildContext context, {required List<Faqs> faqsList}) {
    return Stack(
      children: [
        faqsList.isEmpty
            ? NoRecordFound(image: "empty_report_issue.png", message: languages.noRecordFound)
            : Padding(
              padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languages.faq, style: bodyText(context: context, fontSize: textSize22px, fontWeight: FontWeight.w600)),
                  SizedBox(height: 20.h),
                  Expanded(child: _faqList(faqsList)),
                ],
              ),
            ),
        Align(alignment: AlignmentDirectional.bottomCenter, child: button()),
      ],
    );
  }

  Widget _faqList(List<Faqs> faqList) {
    return ListView.separated(
      itemCount: faqList.length,
      shrinkWrap: true,
      padding: EdgeInsetsDirectional.only(bottom: 52.h),
      separatorBuilder: (context, index) {
        return Divider(height: 20.h, color: getCurrentTheme(context).colorLoginLine, thickness: 1.sp);
      },
      itemBuilder: (context, index) {
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsetsDirectional.zero,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.topLeft,
            iconColor: getCurrentTheme(context).colorIconCommon,
            collapsedIconColor: getCurrentTheme(context).colorIconCommon,
            title: Text(
              faqList[index].name,
              textAlign: TextAlign.start,
              style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600),
            ),
            children: [Text(faqList[index].description, style: bodyText(context: context))],
          ),
        );
      },
    );
  }

  Widget button() {
    return CustomRoundedButton(
      context,
      _bloc?.reportIssueCount == 0 ? languages.addIssue : languages.myReportedIssue,
      () {
        _bloc?.addIssueClick();
      },
      minWidth: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding, vertical: getBottomMargin()),
    );
  }
}
