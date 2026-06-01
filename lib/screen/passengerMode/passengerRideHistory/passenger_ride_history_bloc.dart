import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/day_filter_bottom_sheet.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import 'passenger_ride_history_dl.dart';
import 'passenger_ride_history_repo.dart';

class PassengerRideHistoryBloc extends Bloc {
  final BuildContext context;

  PassengerRideHistoryBloc(this.context) {
    getDayFilterList();

    pagingController ??= PagingController<int, PassengerRideListItem>(
      value: PagingState<int, PassengerRideListItem>(),
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) async {
        return await getRideHistoryApiCall(pageKey);
      },
    );

    getRideHistoryApiCall(1);
  }

  PagingController<int, PassengerRideListItem>? pagingController;

  final _repo = PassengerRideHistoryRepo();

  late HistoryFilterModel filterSelected;
  int filterType = FilterType.filterTypeDefault;

  List<HistoryFilterModel> filterList = [];
  final List<int> selectedRideFilterIds = [];

  final subject = BehaviorSubject<ApiResponse<PassengerRideHistoryPojo>>();
  final selectedRideHistoryFilterSubject = BehaviorSubject<HistoryFilterModel>();
  final completeFilterSubject = BehaviorSubject<bool>();
  final onGoingFilterSubject = BehaviorSubject<bool>();
  final cancelledFilterSubject = BehaviorSubject<bool>();

  void getDayFilterList() {
    filterList.add(HistoryFilterModel(FilterType.filterTypeToday, languages.txtToday));
    filterList.add(HistoryFilterModel(FilterType.filterTypeLast7Days, languages.txtLast7Days));
    filterList.add(HistoryFilterModel(FilterType.filterTypeThisMonth, languages.txtThisMonth));
    filterList.add(HistoryFilterModel(FilterType.filterTypeYear, languages.txtYear));
    filterList.add(HistoryFilterModel(FilterType.filterTypeAll, languages.txtAll));

    filterSelected = filterList.firstWhere((element) => element.filterType == filterType, orElse: () => filterList[0]);
    selectedRideHistoryFilterSubject.sink.add(filterSelected);
  }

  void selectFilter(int filterType) {
    int index = filterList.indexWhere((element) => element.filterType == filterType);
    if (index == -1) index = 0;
    filterSelected = filterList[index];
    selectedRideHistoryFilterSubject.sink.add(filterSelected);
    getRideHistoryApiCall(1);
  }

  void changeCompetedFilter(bool selected) {
    completeFilterSubject.add(selected);
    if (selected) {
      selectedRideFilterIds.add(2);
    } else {
      selectedRideFilterIds.remove(2);
    }
    getRideHistoryApiCall(1);
  }

  void changeOnGoingFilter(bool selected) {
    onGoingFilterSubject.add(selected);
    if (selected) {
      selectedRideFilterIds.add(1);
    } else {
      selectedRideFilterIds.remove(1);
    }
    getRideHistoryApiCall(1);
  }

  void changeCancelledFilter(bool selected) {
    cancelledFilterSubject.add(selected);
    if (selected) {
      selectedRideFilterIds.add(3);
    } else {
      selectedRideFilterIds.remove(3);
    }
    getRideHistoryApiCall(1);
  }

  void onDateFilterTap(HistoryFilterModel? selectedFilter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DayFilterBottomSheet(
          selectedFilter: selectedFilter?.filterType ?? 0,
          filterSort: filterList,
          applyFilter: (applyFilter) {
            selectFilter(applyFilter.filterType);
          },
        );
      },
    );
  }

  Future<List<PassengerRideListItem>> getRideHistoryApiCall(int currentPage) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => getRideHistoryApiCall(currentPage))) {
      if (currentPage == 1) {
        pagingController?.value = PagingState<int, PassengerRideListItem>();
        subject.sink.add(ApiResponse.loading());
      }
      try {
        var response = PassengerRideHistoryPojo.fromJson(
          await _repo.getPassengerRideHistoryApi(
            filterType: filterSelected.filterType,
            // orderStatus: selectedRideFilterIds.toString().replaceAll("[", "").replaceAll("]", ""),
            orderStatus: selectedRideFilterIds.join(','),
            page: currentPage,
          ),
        );

        String message = getApiMsg(response.message);

        if (!context.mounted) return [];
        if (isApiStatus(context, response.status, message, true)) {
          if (currentPage == 1) {
            if ((response.rides ?? []).isNotEmpty) {
              subject.sink.add(ApiResponse.completed(response));
            } else {
              subject.sink.add(ApiResponse.error(languages.noRecordFound));
            }
          }

          pagingController?.value =
              pagingController?.value.copyWith(
                hasNextPage: currentPage != response.lastPage,
                isLoading: false,
                error: null,
                keys: [...?pagingController?.value.keys, currentPage],
                pages: [...?pagingController?.value.pages, response.rides ?? []],
              ) ??
              PagingState();

          return response.rides ?? [];
        } else {
          subject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        subject.sink.add(ApiResponse.error(e.toString()));
      }
    }
    return [];
  }

  @override
  void dispose() {
    pagingController?.dispose();
    subject.close();
    selectedRideHistoryFilterSubject.close();
    completeFilterSubject.close();
    onGoingFilterSubject.close();
    cancelledFilterSubject.close();
  }
}
