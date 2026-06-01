import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/common_circular_progress_indicator.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/no_record_found.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/utils.dart';
import '../../driverMode/driverHome/driver_home.dart';
import '../../passengerMode/passengerHome/passenger_home.dart';
import '../notificationsScreen/notification_bloc.dart';
import 'item_notification_list.dart';
import 'notification_shimmer.dart';
import 'notifications_dl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationBloc? _bloc;

  @override
  void didChangeDependencies() {
    notificationState = this;
    _bloc ??= NotificationBloc(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    notificationState = null;
    notificationState = this;
    super.initState();
  }

  @override
  void dispose() {
    notificationState = null;
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onForegroundGained: () {
        notificationState = this;
      },
      onVisibilityGained: () {
        notificationState = this;
      },
      onFocusGained: () {
        notificationState = this;
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          if (Navigator.canPop(context)) {
            Navigator.pop(context, true);
          } else {
            if (getIntFromSettingBox(hiveAppMode) == AppMode.driver) {
              openScreenWithClearPrevious(context, const DriverHome());
            } else {
              openScreenWithClearPrevious(context, const PassengerHome());
            }
          }
        },
        child: ScaffoldWithSafeArea(
          appBar: CommonAppBar(
            centerTitle: true,
            leading: backButtonForAppBarCustom(
              context: context,
              onBackPress: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context, true);
                } else {
                  if (getIntFromSettingBox(hiveAppMode) == AppMode.driver) {
                    openScreenWithClearPrevious(context, const DriverHome());
                  } else {
                    openScreenWithClearPrevious(context, const PassengerHome());
                  }
                }
              },
            ),
            title: Text(languages.notifications, style: toolbarStyle(context: context)),
          ),
          body: _notificationWidget(),
        ),
      ),
    );
  }

  Widget _notificationWidget() {
    return StreamBuilder<ApiResponse<NotificationsPojo>>(
      stream: _bloc?.subject,
      builder: (context, snapNotificationData) {
        List<MassNotificationItem> massNotificationList = snapNotificationData.data?.data?.massNotificationList ?? [];
        return switch (snapNotificationData.data?.status ?? Status.loading) {
          Status.loading => const NotificationShimmer(enabled: true),
          Status.completed => _notificationList(massNotificationList),
          Status.error => NoRecordFound(message: snapNotificationData.data?.message ?? ""),
        };
      },
    );
  }

  Widget _notificationList(List<MassNotificationItem> massNotificationList) {
    return massNotificationList.isNotEmpty
        ? PagingListener(
          controller: _bloc?.pagingController ?? PagingController<int, MassNotificationItem>(getNextPageKey: (state) => 1, fetchPage: (pageKey) => []),
          builder: (context, state, fetchNextPage) {
            return PagedListView<int, MassNotificationItem>.separated(
              shrinkWrap: true,
              state: state,
              fetchNextPage: fetchNextPage,
              padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 5.h, bottom: 50.h),
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) {
                  return ItemNotificationList(massNotificationItem: item);
                },
                newPageProgressIndicatorBuilder: (context) {
                  return Container(
                    margin: EdgeInsetsDirectional.symmetric(vertical: 10.h),
                    alignment: AlignmentDirectional.center,
                    child: Wrap(
                      children: [CommonCircularProgressIndicator(color: getCurrentTheme(context).colorPrimary, size: 20.sp, strokeWidth: cpiStrokeWidthSmall)],
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
        )
        : NoRecordFound(message: languages.noRecordFound);
  }
}
