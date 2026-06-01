import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../blocs/bloc.dart';
import '../../../../../utils/utils.dart';
import '../wallet_home_dl.dart';
import 'wallet_transaction_repo.dart';

class WalletTransactionBloc extends Bloc {
  final BuildContext context;
  final int walletTransactionType;
  PagingController<int, TransactionsItem>? pagingController;

  WalletTransactionBloc({required this.context, required this.walletTransactionType}) {
    pagingController ??= PagingController<int, TransactionsItem>(
      value: PagingState<int, TransactionsItem>(),
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) async {
        return await getTransactionListApiCall(walletTransactionType, pageKey);
      },
    );
    getTransactionListApiCall(walletTransactionType, 1);
  }

  final walletTransactionListSubject = BehaviorSubject<ApiResponse<WalletTransactionPojo>>();

  final _repo = WalletTransactionRepo();

  Future<List<TransactionsItem>> getTransactionListApiCall(int orderBy, int currentPage) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => getTransactionListApiCall(orderBy, currentPage))) {
      if (currentPage == 1 && !walletTransactionListSubject.isClosed) {
        pagingController?.value = PagingState<int, TransactionsItem>();
        walletTransactionListSubject.sink.add(ApiResponse.loading());
      }
      try {
        WalletTransactionPojo response = WalletTransactionPojo.fromJson(
          await _repo.getWalletTransactionsListApi(dateFilter: 0, perPage: 10, page: currentPage, orderBy: orderBy),
        );

        if (!context.mounted) return [];
        if (isApiStatus(context, response.status, response.message, false, showMess: true)) {
          pagingController?.value =
              pagingController?.value.copyWith(
                hasNextPage: currentPage != response.lastPage,
                isLoading: false,
                error: null,
                keys: [...?pagingController?.value.keys, currentPage],
                pages: [...?pagingController?.value.pages, response.transactions ?? []],
              ) ??
              PagingState();
          if ((response.transactions ?? []).isNotEmpty) {
            if (!walletTransactionListSubject.isClosed) walletTransactionListSubject.sink.add(ApiResponse.completed(response));
          } else {
            if (!walletTransactionListSubject.isClosed) walletTransactionListSubject.sink.add(ApiResponse.error(languages.noRecordFound));
          }
        } else {
          if (!walletTransactionListSubject.isClosed) walletTransactionListSubject.sink.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        if (languages.apiErrorCancelMsg == e.toString()) {
          if (!walletTransactionListSubject.isClosed) walletTransactionListSubject.sink.add(ApiResponse.loading());
        } else {
          if (!walletTransactionListSubject.isClosed) walletTransactionListSubject.sink.add(ApiResponse.error(e.toString()));
        }
        if (context.mounted) openSimpleSnackbar(context, e.toString());
      }
    }
    return [];
  }

  @override
  void dispose() {
    walletTransactionListSubject.close();
  }
}
