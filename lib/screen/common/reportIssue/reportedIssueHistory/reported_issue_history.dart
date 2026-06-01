import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../commonView/common_circular_progress_indicator.dart';
import '../../../../commonView/common_view.dart';
import '../../../../commonView/custom_rounded_button.dart';
import '../../../../commonView/no_record_found.dart';
import '../../../../hive/hive_helper.dart';
import '../../../../networking/api_response.dart';
import '../../../../networking/base_dl.dart';
import '../../../../utils/utils.dart';
import '../../../driverMode/driverHome/driver_home.dart';
import '../../../passengerMode/passengerHome/passenger_home.dart';
import '../addReportIssue/add_report_issue_screen.dart';
import '../issueRideHistory/issueDriverRideHistory/issue_driver_ride_history.dart';
import '../issueRideHistory/issuePassengerRideHistory/issue_passenger_ride_history.dart';
import 'item_reported_issue_history.dart';
import 'reported_issue_history_bloc.dart';
import 'reported_issue_history_dl.dart';
import 'reported_issue_history_shimmer.dart';

class ReportedIssueHistory extends StatefulWidget {
  const ReportedIssueHistory({super.key});

  @override
  State<ReportedIssueHistory> createState() => _ReportedIssueHistoryState();
}

class _ReportedIssueHistoryState extends State<ReportedIssueHistory> {
  ReportedIssueHistoryBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= ReportedIssueHistoryBloc(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          openScreenWithClearPrevious(context, getIntFromSettingBox(hiveAppMode) == AppMode.driver ? const DriverHome() : const PassengerHome());
        }
      },
      child: ScaffoldWithSafeArea(
        appBar: CommonAppBar(
          centerTitle: true,
          leading: backButtonForAppBarCustom(
            context: context,
            onBackPress: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                openScreenWithClearPrevious(context, getIntFromSettingBox(hiveAppMode) == AppMode.driver ? const DriverHome() : const PassengerHome());
              }
            },
          ),
          titleSpacing: 0,
          title: Text(languages.reportIssue, style: toolbarStyle(context: context)),
        ),
        body: _buildReportedIssueHistory(),
      ),
    );
  }

  Widget _buildReportedIssueHistory() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _historyFiltersView(),
            SizedBox(height: 5.h),
            Expanded(
              child: StreamBuilder<ApiResponse<ReportedIssueHistoryPojo>>(
                stream: _bloc?.subject,
                builder: (context, snapHistory) {
                  switch (snapHistory.data?.status ?? Status.loading) {
                    case Status.loading:
                      return ReportedIssueHistoryShimmer();

                    case Status.error:
                      return NoRecordFound(message: snapHistory.data?.message ?? "");

                    case Status.completed:
                      List<ReportIssueHistory> reportIssueHistoryList = snapHistory.data?.data?.reportIssueHistory ?? [];

                      return reportIssueHistoryList.isEmpty
                          ? NoRecordFound(image: "empty_report_issue.png", message: languages.issueNotFound)
                          : PagingListener(
                            controller:
                                _bloc?.pagingController ?? PagingController<int, ReportIssueHistory>(getNextPageKey: (state) => 1, fetchPage: (pageKey) => []),
                            builder: (context, state, fetchNextPage) {
                              return PagedListView<int, ReportIssueHistory>.separated(
                                shrinkWrap: true,
                                state: state,
                                fetchNextPage: fetchNextPage,
                                padding: EdgeInsetsDirectional.only(
                                  start: commonHorizontalPadding,
                                  end: commonHorizontalPadding,
                                  top: 5.h,
                                  bottom: 70.h + getBottomMargin(),
                                ),
                                builderDelegate: PagedChildBuilderDelegate(
                                  itemBuilder: (context, item, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        openScreen(
                                          context,
                                          AddReportIssueScreen(isFromIssueHistory: true, reportId: item.reportId, isResolved: item.status == 2 ? true : false),
                                        );
                                      },
                                      child: ItemIssueHistory(reportIssueHistory: item),
                                    );
                                  },
                                  newPageProgressIndicatorBuilder: (context) {
                                    return Container(
                                      margin: EdgeInsetsDirectional.symmetric(vertical: 10.h),
                                      alignment: AlignmentDirectional.center,
                                      child: Wrap(
                                        children: [
                                          CommonCircularProgressIndicator(
                                            color: getCurrentTheme(context).colorPrimary,
                                            size: 20.sp,
                                            strokeWidth: cpiStrokeWidthSmall,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  noMoreItemsIndicatorBuilder: (context) {
                                    return SizedBox(height: 0, width: 0);
                                  },
                                  invisibleItemsThreshold: 1,
                                ),
                                separatorBuilder: (BuildContext context, int index) {
                                  return ((state.items ?? []).length - 1) != index
                                      ? Divider(height: 40.h, color: getCurrentTheme(context).colorDivider, thickness: 1.sp)
                                      : Container();
                                },
                              );
                            },
                          );
                  }
                },
              ),
            ),
          ],
        ),
        Align(alignment: AlignmentDirectional.bottomCenter, child: button()),
      ],
    );
  }

  Widget _historyFiltersView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsetsDirectional.only(top: 20.h, bottom: 10.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
      child: Row(children: [_dayFilter(), SizedBox(width: 15.w), _generalIssueFilter(), SizedBox(width: 15.w), _issueStatusFilters()]),
    );
  }

  Widget _dayFilter() {
    return StreamBuilder<HistoryFilterModel>(
      stream: _bloc?.selectedRideHistoryFilterSubject,
      builder: (context, snapshot) {
        HistoryFilterModel? selectedFilter = snapshot.data;
        return GestureDetector(
          onTap: () {
            _bloc?.onDateFilterTap(selectedFilter);
          },
          child: dayFilterTabItemView(context, text: selectedFilter?.filterName ?? ""),
        );
      },
    );
  }

  Widget _issueStatusFilters() {
    return StreamBuilder<ApiResponse<ReportedIssueHistoryPojo>>(
      stream: _bloc?.subject,
      builder: (context, snap) {
        bool isLoading = snap.data?.status == Status.loading;
        return Row(
          spacing: 15.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Resolved
            StreamBuilder<bool>(
              stream: _bloc?.subjectResolvedFilter,
              builder: (context, snapshot) {
                bool selected = snapshot.data ?? false;
                return GestureDetector(
                  onTap:
                      isLoading
                          ? null
                          : () {
                            _bloc?.changeResolvedFilter(!selected);
                          },
                  child: filterTabItemView(context, isSelected: selected, text: languages.resolved),
                );
              },
            ),

            /// UnResolved
            StreamBuilder<bool>(
              stream: _bloc?.subjectUnResolvedFilter,
              builder: (context, snapshot) {
                bool selected = snapshot.data ?? false;
                return GestureDetector(
                  onTap:
                      isLoading
                          ? null
                          : () {
                            _bloc?.changeUnResolvedFilter(!selected);
                          },
                  child: filterTabItemView(context, isSelected: selected, text: languages.unResolved),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _generalIssueFilter() {
    return StreamBuilder<ApiResponse<ReportedIssueHistoryPojo>>(
      stream: _bloc?.subject,
      builder: (context, snap) {
        bool isLoading = snap.data?.status == Status.loading;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<bool>(
              stream: _bloc?.subjectGeneralIssueFilter,
              builder: (context, snapshot) {
                bool selected = snapshot.data ?? false;
                return GestureDetector(
                  onTap:
                      isLoading
                          ? null
                          : () {
                            _bloc?.changeGeneralIssueFilter(!selected);
                          },
                  child: filterTabItemView(context, isSelected: selected, text: languages.general),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget button() {
    return CustomRoundedButton(
      context,
      languages.addIssue,
      () {
        openScreen(context, getIntFromSettingBox(hiveAppMode) == AppMode.driver ? const IssueDriverRideHistory() : const IssuePassengerRideHistory());
      },
      minWidth: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding, vertical: getBottomMargin()),
    );
  }
}
