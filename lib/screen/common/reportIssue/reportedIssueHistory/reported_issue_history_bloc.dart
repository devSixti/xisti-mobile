import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../blocs/bloc.dart';
import '../../../../bottomSheet/day_filter_bottom_sheet.dart';
import '../../../../networking/base_dl.dart';
import '../../../../utils/utils.dart';
import 'reported_issue_history_dl.dart';
import 'reported_issue_history_repo.dart';

class ReportedIssueHistoryBloc extends Bloc {
  final BuildContext context;

  ReportedIssueHistoryBloc(this.context) {
    getDayFilterList();
    pagingController ??= PagingController<int, ReportIssueHistory>(
      value: PagingState<int, ReportIssueHistory>(),
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) async {
        return await getIssueHistoryApiCall(pageKey);
      },
    );
    getIssueHistoryApiCall(1);
  }

  final _repo = ReportedIssueHistoryRepo();

  late HistoryFilterModel filterSelected;
  int filterType = FilterType.filterTypeDefault;
  PagingController<int, ReportIssueHistory>? pagingController;

  final List<int> selectedOrderFilterIds = [];
  List<HistoryFilterModel> filterList = [];

  final selectedRideHistoryFilterSubject = BehaviorSubject<HistoryFilterModel>();

  final subject = BehaviorSubject<ApiResponse<ReportedIssueHistoryPojo>>();
  final subjectResolvedFilter = BehaviorSubject<bool>();
  final subjectUnResolvedFilter = BehaviorSubject<bool>();
  final subjectGeneralIssueFilter = BehaviorSubject.seeded(false);

  //--------------------------------------Api Calling Start----------------------------
  Future<List<ReportIssueHistory>> getIssueHistoryApiCall(int currentPage) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => getIssueHistoryApiCall(currentPage))) {
      if (currentPage == 1) {
        pagingController?.value = PagingState<int, ReportIssueHistory>();
        subject.sink.add(ApiResponse.loading());
      }
      try {
        ReportedIssueHistoryPojo response = ReportedIssueHistoryPojo.fromJson(
          await _repo.getIssueHistoryApi(filterType, currentPage, localTimeZone, selectedOrderFilterIds.join(','), subjectGeneralIssueFilter.value ? 1 : 0),
        );

        if (!context.mounted) return [];
        if (isApiStatus(context, response.status, response.message, true)) {
          if (currentPage == 1) {
            if ((response.reportIssueHistory).isNotEmpty) {
              subject.sink.add(ApiResponse.completed(response));
            } else {
              subject.sink.add(ApiResponse.error(languages.noRecordFound));
            }
          }
          debugPrint("my list length : ${pagingController?.value.items?.length}");

          pagingController?.value =
              pagingController?.value.copyWith(
                hasNextPage: currentPage != response.lastPage,
                isLoading: false,
                error: null,
                keys: [...?pagingController?.value.keys, currentPage],
                pages: [...?pagingController?.value.pages, response.reportIssueHistory],
              ) ??
              PagingState();

          return response.reportIssueHistory;
        } else {
          subject.sink.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        subject.sink.add(ApiResponse.error(e.toString()));
        if (context.mounted) openSimpleSnackbar(context, e.toString());
      }
    }
    return [];
  }

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
    this.filterType = filterSelected.filterType;
    selectedRideHistoryFilterSubject.sink.add(filterSelected);
    getIssueHistoryApiCall(1);
  }

  void changeResolvedFilter(bool selected) {
    subjectResolvedFilter.add(selected);
    if (selected) {
      selectedOrderFilterIds.add(2);
    } else {
      selectedOrderFilterIds.remove(2);
    }
    subjectGeneralIssueFilter.sink.add(false);
    getIssueHistoryApiCall(1);
  }

  void changeUnResolvedFilter(bool selected) {
    subjectUnResolvedFilter.add(selected);
    if (selected) {
      selectedOrderFilterIds.add(1);
    } else {
      selectedOrderFilterIds.remove(1);
    }
    subjectGeneralIssueFilter.sink.add(false);
    getIssueHistoryApiCall(1);
  }

  void changeGeneralIssueFilter(bool selected) {
    subjectGeneralIssueFilter.sink.add(selected);
    selectedOrderFilterIds.clear();
    subjectUnResolvedFilter.add(false);
    subjectResolvedFilter.add(false);
    getIssueHistoryApiCall(1);
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

  @override
  void dispose() {
    subject.close();
    subjectResolvedFilter.close();
    subjectUnResolvedFilter.close();
  }
}
