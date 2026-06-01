import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../commonView/common_circular_progress_indicator.dart';
import '../../../../../commonView/common_view.dart';
import '../../../../../commonView/custom_rounded_button.dart';
import '../../../../../commonView/no_record_found.dart';
import '../../../../../networking/api_response.dart';
import '../../../../../networking/base_dl.dart';
import '../../../../../utils/utils.dart';
import '../../../../driverMode/driverRideHistory/driver_ride_history_bloc.dart';
import '../../../../driverMode/driverRideHistory/driver_ride_history_dl.dart';
import '../../../../driverMode/driverRideHistory/driver_ride_history_shimmer.dart';
import '../../../../driverMode/driverRideHistory/item_driver_ride_history.dart';
import '../../addReportIssue/add_report_issue_screen.dart';

class IssueDriverRideHistory extends StatefulWidget {
  const IssueDriverRideHistory({super.key});

  @override
  State<IssueDriverRideHistory> createState() => _IssueDriverRideHistoryState();
}

class _IssueDriverRideHistoryState extends State<IssueDriverRideHistory> {
  DriverRideHistoryBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= DriverRideHistoryBloc(context);
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
      backgroundColor: getCurrentTheme(context).colorScaffoldBg,
      appBar: CommonAppBar(
        centerTitle: true,
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        title: Text(languages.chooseAnOrderWithIssue, style: toolbarStyle(context: context)),
      ),
      body: _buildIssueDriverRideHistory(context),
    );
  }

  Widget _buildIssueDriverRideHistory(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _historyFilterView(),
            SizedBox(height: 5.h),
            Expanded(
              child: StreamBuilder<ApiResponse<DriverRideHistoryPojo>>(
                stream: _bloc?.subject,
                builder: (context, snapHistory) {
                  switch (snapHistory.data?.status ?? Status.loading) {
                    case Status.loading:
                      return DriverHistoryShimmer(enabled: true);
                    case Status.error:
                      return NoRecordFound(message: snapHistory.data?.message ?? "");
                    case Status.completed:
                      return PagingListener(
                        controller:
                            _bloc?.pagingController ?? PagingController<int, DriverRideListItem>(getNextPageKey: (state) => 1, fetchPage: (pageKey) => []),
                        builder: (context, state, fetchNextPage) {
                          return PagedListView<int, DriverRideListItem>.separated(
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
                                    openScreen(context, AddReportIssueScreen(rideNo: item.rideNo.toString(), rideId: item.rideId, isFromIssueHistory: false));
                                  },
                                  child: ItemDriverRideHistory(item: item),
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
        Align(alignment: AlignmentDirectional.bottomCenter, child: _button(context)),
      ],
    );
  }

  Widget _historyFilterView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsetsDirectional.only(top: 20.h, bottom: 10.h, start: commonHorizontalPadding, end: commonHorizontalPadding),
      child: Row(children: [_dayFilter(), SizedBox(width: 15.w), _orderStatusFilters()]),
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

  Widget _orderStatusFilters() {
    return StreamBuilder<ApiResponse<DriverRideHistoryPojo>>(
      stream: _bloc?.subject,
      builder: (context, snap) {
        bool isLoading = snap.hasData && snap.data?.status == Status.loading;
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 15.w,
          children: [
            StreamBuilder<bool>(
              stream: _bloc?.completeFilterSubject,
              builder: (context, snapshot) {
                bool selected = snapshot.data ?? false;
                return GestureDetector(
                  onTap:
                      isLoading
                          ? null
                          : () {
                            _bloc?.changeCompetedFilter(!selected);
                          },
                  child: filterTabItemView(context, isSelected: selected, text: languages.completed),
                );
              },
            ),

            StreamBuilder<bool>(
              stream: _bloc?.onGoingFilterSubject,
              builder: (context, snapshot) {
                bool selected = snapshot.data ?? false;
                return GestureDetector(
                  onTap:
                      isLoading
                          ? null
                          : () {
                            _bloc?.changeOnGoingFilter(!selected);
                          },
                  child: filterTabItemView(context, isSelected: selected, text: languages.ongoing),
                );
              },
            ),

            StreamBuilder<bool>(
              stream: _bloc?.cancelledFilterSubject,
              builder: (context, snapshot) {
                bool selected = snapshot.data ?? false;
                return GestureDetector(
                  onTap:
                      isLoading
                          ? null
                          : () {
                            _bloc?.changeCancelledFilter(!selected);
                          },
                  child: filterTabItemView(context, isSelected: selected, text: languages.cancelled),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _button(BuildContext context) {
    return CustomRoundedButton(
      context,
      languages.reportGeneralIssue,
      () {
        openScreen(context, const AddReportIssueScreen(rideNo: "0", rideId: 0, isFromIssueHistory: false));
      },
      minWidth: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding, vertical: getBottomMargin()),
    );
  }
}
