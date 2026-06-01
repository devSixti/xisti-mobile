import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../commonView/common_circular_progress_indicator.dart';
import '../../../../../commonView/no_record_found.dart';
import '../../../../../networking/api_response.dart';
import '../../../../../utils/utils.dart';
import '../wallet_home_dl.dart';
import 'item_wallet_transaction.dart';
import 'wallet_transaction_bloc.dart';
import 'wallet_transaction_shimmer.dart';

class WalletTransaction extends StatefulWidget {
  final int walletTransactionType;

  const WalletTransaction({super.key, required this.walletTransactionType});

  @override
  State<WalletTransaction> createState() => WalletTransactionState();
}

class WalletTransactionState extends State<WalletTransaction> {
  WalletTransactionBloc? _bloc;

  void refreshData() {
    _bloc?.getTransactionListApiCall(widget.walletTransactionType, 1);
  }

  @override
  void didChangeDependencies() {
    _bloc ??= WalletTransactionBloc(context: context, walletTransactionType: widget.walletTransactionType);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      child: StreamBuilder<ApiResponse<WalletTransactionPojo>>(
        stream: _bloc?.walletTransactionListSubject,
        builder: (context, snap) {
          switch (snap.data?.status ?? Status.loading) {
            case Status.loading:
              return WalletTransactionShimmer();
            case Status.error:
              return NoRecordFound(message: snap.data?.message ?? "");
            case Status.completed:
              List<TransactionsItem> transactionList = snap.data?.data?.transactions ?? [];

              if (transactionList.isEmpty) {
                return NoRecordFound(image: "empty_wallet_transaction.png", message: languages.transactionNotFound);
              } else {
                // return ListView.separated(
                //   itemCount: transactionList.length,
                //   padding: EdgeInsetsDirectional.only(top: 10.h, bottom: 50.h),
                //   separatorBuilder: (context, index) {
                //     return Divider(height: 40.h, color: getCurrentTheme(context).colorDivider, thickness: 1.sp);
                //   },
                //   itemBuilder: (context, index) {
                //     return ItemWalletTransaction(item: transactionList[index]);
                //   },
                // );
                return PagingListener(
                  controller: _bloc?.pagingController ?? PagingController<int, TransactionsItem>(getNextPageKey: (state) => 1, fetchPage: (pageKey) => []),
                  builder: (context, state, fetchNextPage) {
                    return PagedListView<int, TransactionsItem>.separated(
                      shrinkWrap: true,
                      state: state,
                      fetchNextPage: fetchNextPage,
                      padding: EdgeInsetsDirectional.only(top: 5.h, bottom: 50.h),
                      builderDelegate: PagedChildBuilderDelegate(
                        itemBuilder: (context, item, index) {
                          return ItemWalletTransaction(item: item);
                        },
                        newPageProgressIndicatorBuilder: (context) {
                          return Container(
                            margin: EdgeInsetsDirectional.symmetric(vertical: 10.h),
                            alignment: AlignmentDirectional.center,
                            child: Wrap(
                              children: [
                                CommonCircularProgressIndicator(color: getCurrentTheme(context).colorPrimary, size: 20.sp, strokeWidth: cpiStrokeWidthSmall),
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
    );
  }
}
