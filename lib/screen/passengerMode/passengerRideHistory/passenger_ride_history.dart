import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../commonView/common_circular_progress_indicator.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/no_record_found.dart';
import '../../../commonView/statusView/passenger_ride_status_view.dart';
import '../../../networking/api_response.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import '../passengerHome/passenger_home.dart';
import '../passengerRideDetail/passenger_ride_detail.dart';
import '../passengerRunningRide/passenger_running_ride.dart';
import 'item_passenger_ride_history.dart';
import 'passenger_ride_history_bloc.dart';
import 'passenger_ride_history_dl.dart';
import 'passenger_ride_history_shimmer.dart';

class PassengerRideHistory extends StatefulWidget {
  const PassengerRideHistory({super.key});

  @override
  State<PassengerRideHistory> createState() => _PassengerRideHistoryState();
}

class _PassengerRideHistoryState extends State<PassengerRideHistory> {
  PassengerRideHistoryBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= PassengerRideHistoryBloc(context);
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
          openScreenWithClearPrevious(context, const PassengerHome());
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
                openScreenWithClearPrevious(context, const PassengerHome());
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(languages.rideHistory, style: toolbarStyle(context: context)),
        ),
        body: _buildPassengerRideHistory(context),
      ),
    );
  }

  Widget _buildPassengerRideHistory(BuildContext context) {
    return Column(
      children: [
        _historyFilterView(),
        SizedBox(height: 5.h),
        Expanded(
          child: StreamBuilder<ApiResponse<PassengerRideHistoryPojo>>(
            stream: _bloc?.subject,
            builder: (context, snapHistory) {
              switch (snapHistory.data?.status ?? Status.loading) {
                case Status.loading:
                  return PassengerHistoryShimmer();
                case Status.error:
                  return NoRecordFound(message: snapHistory.data?.message ?? "");
                case Status.completed:
                  List<PassengerRideListItem> rideList = snapHistory.data?.data?.rides ?? [];

                  return rideList.isEmpty
                      ? NoRecordFound(image: "empty_ride_history.png", message: languages.orderNotFound)
                      : PagingListener(
                        controller:
                            _bloc?.pagingController ?? PagingController<int, PassengerRideListItem>(getNextPageKey: (state) => 1, fetchPage: (pageKey) => []),
                        builder: (context, state, fetchNextPage) {
                          return PagedListView<int, PassengerRideListItem>.separated(
                            shrinkWrap: true,
                            state: state,
                            fetchNextPage: fetchNextPage,
                            padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 5.h, bottom: 50.h),
                            builderDelegate: PagedChildBuilderDelegate(
                              itemBuilder: (context, item, index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (item.rideStatus != passengerCancel && ((item.rideStatus < passengerPayment) && (item.rideStatus >= passengerArrive))) {
                                      openScreen(context, PassengerRunningRide(rideId: item.rideId));
                                    } else {
                                      openScreen(context, PassengerRideDetail(rideId: item.rideId));
                                    }
                                  },
                                  child: ItemPassengerRideHistory(item: item),
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
    return StreamBuilder<ApiResponse<PassengerRideHistoryPojo>>(
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
