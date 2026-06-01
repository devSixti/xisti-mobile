import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../commonView/common_circular_progress_indicator.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/no_record_found.dart';
import '../../../commonView/statusView/driver_ride_status_view.dart';
import '../../../networking/api_response.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import '../driverHome/driver_home.dart';
import '../driverRideDetail/driver_ride_detail.dart';
import '../driverRunningRide/driver_running_ride.dart';
import 'driver_ride_history_bloc.dart';
import 'driver_ride_history_dl.dart';
import 'driver_ride_history_shimmer.dart';
import 'item_driver_ride_history.dart';

class DriverRideHistory extends StatefulWidget {
  const DriverRideHistory({super.key});

  @override
  State<DriverRideHistory> createState() => _DriverRideHistoryState();
}

class _DriverRideHistoryState extends State<DriverRideHistory> {
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (!Navigator.canPop(context)) {
          openScreenWithClearPrevious(context, const DriverHome());
        } else {
          Navigator.pop(context);
        }
      },
      child: ScaffoldWithSafeArea(
        backgroundColor: getCurrentTheme(context).colorScaffoldBg,
        appBar: CommonAppBar(
          centerTitle: true,
          leading: backButtonForAppBarCustom(
            context: context,
            onBackPress: () {
              if (!Navigator.canPop(context)) {
                openScreenWithClearPrevious(context, const DriverHome());
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(languages.rideHistory, style: toolbarStyle(context: context)),
        ),
        body: _buildDriverRideHistory(context),
      ),
    );
  }

  Widget _buildDriverRideHistory(BuildContext context) {
    return Column(
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
                  List<DriverRideListItem> rideList = snapHistory.data?.data?.rideHistoryList ?? [];

                  if (rideList.isEmpty) {
                    return NoRecordFound(image: "empty_ride_history.png", message: languages.orderNotFound);
                  } else {
                    return PagingListener(
                      controller:
                          _bloc?.pagingController ?? PagingController<int, DriverRideListItem>(getNextPageKey: (state) => 1, fetchPage: (pageKey) => []),
                      builder: (context, state, fetchNextPage) {
                        return PagedListView<int, DriverRideListItem>.separated(
                          shrinkWrap: true,
                          state: state,
                          fetchNextPage: fetchNextPage,
                          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 5.h, bottom: 50.h),
                          builderDelegate: PagedChildBuilderDelegate(
                            itemBuilder: (context, item, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (item.rideStatus != DriverRideStatus.driverCancel &&
                                      (((item.rideStatus) < DriverRideStatus.driverCompleted) && ((item.rideStatus) >= DriverRideStatus.driverArrive))) {
                                    openScreen(context, DriverRunningRide(rideId: item.rideId, serviceId: item.serviceId));
                                  } else {
                                    openScreen(context, DriverRideDetail(rideId: item.rideId));
                                  }
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
              }
            },
          ),
        ),
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
}

/*PagedListView<int, DriverRideListItem>(
                    state: ,
                    fetchNextPage: fetchNextPage,
                    padding: EdgeInsetsDirectional.only(top: 10.h, bottom: 100.h),
                    shrinkWrap: true,
                    builderDelegate: PagedChildBuilderDelegate<RideListItem>(
                      itemBuilder: (context, item, index) {
                        return GestureDetector(
                          onTap: () {
                            // openScreen(context, DriverRideDetails(rideId: item.rideId ?? 0));
                          },
                          child: PsHistoryItem(item: item),
                        );
                      },
                      newPageProgressIndicatorBuilder: (_) {
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
                    ),
                  )*/
