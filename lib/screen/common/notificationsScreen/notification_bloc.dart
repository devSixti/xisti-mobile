import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/utils.dart';
import 'notification_repo.dart';
import 'notifications_dl.dart';

class NotificationBloc extends Bloc {
  final BuildContext context;
  PagingController<int, MassNotificationItem>? pagingController;

  NotificationBloc(this.context) {
    pagingController ??= PagingController<int, MassNotificationItem>(
      value: PagingState<int, MassNotificationItem>(),
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) async {
        return await getNotificationsListApi(pageKey);
      },
    );

    getNotificationsListApi(1);
  }

  final NotificationsRepo _repo = NotificationsRepo();
  final subject = BehaviorSubject<ApiResponse<NotificationsPojo>>();

  Future<List<MassNotificationItem>> getNotificationsListApi(int currentPage) async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        getNotificationsListApi(currentPage);
      },
    )) {
      if (currentPage == 1) {
        pagingController?.value = PagingState<int, MassNotificationItem>();
        subject.sink.add(ApiResponse.loading());
      }
      try {
        var response = NotificationsPojo.fromJson(await _repo.callNotificationsApi(currentPage, perPage: 30));

        String message = getApiMsg(response.message);

        if (!context.mounted) return [];
        if (isApiStatus(context, response.status, message, true)) {
          pagingController?.value =
              pagingController?.value.copyWith(
                hasNextPage: currentPage != response.lastPage,
                isLoading: false,
                error: null,
                keys: [...?pagingController?.value.keys, currentPage],
                pages: [...?pagingController?.value.pages, response.massNotificationList],
              ) ??
              PagingState();
          if (currentPage == 1) {
            if ((response.massNotificationList).isNotEmpty) {
              subject.sink.add(ApiResponse.completed(response));
            } else {
              subject.sink.add(ApiResponse.error(languages.noRecordFound));
            }
          }
          return response.massNotificationList;
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
    subject.close();
  }
}
