import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonView/common_circular_progress_indicator.dart';
import '../../../../commonView/common_view.dart';
import '../../../../hive/hive_helper.dart';
import '../../../../networking/api_response.dart';
import '../../../../utils/utils.dart';
import '../../../driverMode/driverHome/driver_home.dart';
import '../../../passengerMode/passengerHome/passenger_home.dart';
import 'walletTransactionsView/wallet_transaction.dart';
import 'wallet_home_bloc.dart';
import 'wallet_home_dl.dart';

class WalletHome extends StatefulWidget {
  const WalletHome({super.key});

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  WalletHomeBloc? _bloc;
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc ??= WalletHomeBloc(context, tabController);
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _bloc?.getWalletAmountApiCall();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    _bloc?.dispose();
    tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
                Navigator.pop(context);
              } else {
                if (getIntFromSettingBox(hiveAppMode) == AppMode.driver) {
                  openScreenWithClearPrevious(context, const DriverHome());
                } else {
                  openScreenWithClearPrevious(context, const PassengerHome());
                }
              }
            },
          ),
          title: Text(languages.wallet, style: toolbarStyle(context: context)),
        ),
        body: Padding(
          padding: EdgeInsetsDirectional.only(top: 20.h),
          child: Column(
            children: [
              walletAmount(),
              SizedBox(height: 20.h),
              walletOptions(),
              SizedBox(height: 20.h),
              Expanded(child: transactionHistoryView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget walletAmount() {
    return Container(
      constraints: BoxConstraints.expand(height: 151.h, width: double.maxFinite),
      padding: EdgeInsetsDirectional.all(15.sp),
      margin: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
      decoration: XistiAuthTokens.walletBalanceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: XistiAuthTokens.walletIconBg.withValues(alpha: 0.95),
            ),
            child: Icon(CustomIcons.wallet, color: XistiBrand.purple, size: 20.sp),
          ),

          SizedBox(height: 10.h),
          Text(
            languages.currentBalance,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: bodyText(context: context, fontSize: textSize14px, textColor: XistiAuthTokens.onGradientText.withValues(alpha: 0.9)),
          ),

          SizedBox(height: 5.h),
          StreamBuilder<double>(
            stream: _bloc?.walletAmountSubject,
            builder: (context, snap) {
              return StreamBuilder<ApiResponse<WalletBalancePojo>>(
                stream: _bloc?.getWalletBalanceSubject,
                builder: (context, snapLoading) {
                  return snapLoading.data?.status == Status.loading
                      ? Padding(
                          padding: EdgeInsetsDirectional.only(top: 10.h, start: 5.w),
                          child: CommonCircularProgressIndicator(strokeWidth: 3.sp, size: 20.sp, color: XistiAuthTokens.onGradientText),
                        )
                      : Text(
                          getAmountWithCurrency(snap.data ?? 0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: bodyText(
                            context: context,
                            textColor: XistiAuthTokens.onGradientText,
                            fontSize: textSize28px,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget walletOptions() {
    return StreamBuilder<ApiResponse<WalletBalancePojo>>(
      stream: _bloc?.getWalletBalanceSubject,
      builder: (context, snapLoading) {
        final isDriver = getIntFromSettingBox(hiveAppMode) == AppMode.driver;
        final canTopUp = getBoolFromSettingBox(hivePaymentTypeOnline);
        final canTransfer = getBoolFromSettingBox(hivePaymentTypeWallet);
        final canCashOut = isDriver && !getBoolFromSettingBox(hiveIsAutoSettle);
        final autoSettleDriver = getBoolFromSettingBox(hiveIsAutoSettle) && isDriver;

        return Container(
          width: double.maxFinite,
          margin: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
          child: autoSettleDriver
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (canTopUp)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: walletHistory()),
                          SizedBox(width: 20.sp),
                          Expanded(child: walletTopUp()),
                        ],
                      ),
                    if (canTransfer) ...[
                      if (canTopUp) SizedBox(height: 15.sp),
                      Row(
                        children: [
                          Expanded(child: walletTransfer()),
                        ],
                      ),
                    ],
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      spacing: 20.sp,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: walletHistory()),
                        if (canTransfer) Expanded(child: walletTransfer()),
                        if (canTopUp) Expanded(child: walletTopUp()),
                      ],
                    ),
                    if (canCashOut) ...[
                      SizedBox(height: 15.sp),
                      Row(
                        children: [
                          Expanded(child: walletCashOut()),
                        ],
                      ),
                    ],
                  ],
                ),
        );
      },
    );
  }

  Widget walletHistory() {
    return _walletOptionsItem(text: languages.history, isSelected: true);
  }

  Widget walletTransfer() {
    return GestureDetector(
      onTap: () {
        _bloc?.openWalletTransferScreen();
      },
      child: _walletOptionsItem(text: languages.transfer),
    );
  }

  Widget walletTopUp() {
    return StreamBuilder<ApiResponse<WalletBalancePojo>>(
      stream: _bloc?.getWalletBalanceSubject,
      builder: (context, snapLoading) {
        bool isLoading = snapLoading.data?.status == Status.loading;
        return GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  _bloc?.openTopUpScreen();
                },
          child: _walletOptionsItem(text: languages.topUp, isLoading: isLoading),
        );
      },
    );
  }

  Widget walletCashOut() {
    return GestureDetector(
      onTap: () {
        _bloc?.openCaseOutScreen();
      },
      child: _walletOptionsItem(text: languages.cashOut),
    );
  }

  Widget _walletOptionsItem({bool isSelected = false, bool isLoading = false, required String text}) {
    return Container(
      height: 45.h,
      width: double.maxFinite,
      alignment: AlignmentDirectional.center,
      margin: EdgeInsetsDirectional.symmetric(vertical: 0.5.sp),
      padding: EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(XistiAuthTokens.optionRadius),
        gradient: isSelected ? XistiAuthTokens.optionSelectedGradient : null,
        color: isSelected ? null : XistiBrand.lavenderGrey.withValues(alpha: 0.35),
        border: Border.all(
          color: isSelected ? Colors.transparent : XistiBrand.purple.withValues(alpha: 0.35),
          width: 0.5.sp,
        ),
      ),
      child: isLoading
          ? CommonCircularProgressIndicator(strokeWidth: 3.sp, size: 20.sp, color: XistiBrand.purple)
          : AutoSizeText(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: bodyText(
                context: context,
                fontSize: textSize14px,
                fontWeight: FontWeight.w600,
                textColor: isSelected ? XistiAuthTokens.onGradientText : getCurrentTheme(context).colorTextCommon,
              ),
            ),
    );
  }

  Widget transactionHistoryView() {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          transactionTypeTabView(),
          SizedBox(height: 10.h),
          Expanded(child: transactionList()),
        ],
      ),
    );
  }

  Widget transactionTypeTabView() {
    return Container(
      decoration: BoxDecoration(
        color: XistiBrand.lavenderGrey.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(XistiAuthTokens.optionRadius),
        border: Border.all(color: XistiBrand.purple.withValues(alpha: 0.25), width: 0.5.sp),
      ),
      child: TabBar(
        controller: tabController,
        splashFactory: NoSplash.splashFactory,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        labelPadding: EdgeInsetsDirectional.symmetric(vertical: 15.h),
        indicatorPadding: EdgeInsetsDirectional.all(5.h),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(XistiAuthTokens.optionRadius),
          gradient: XistiAuthTokens.optionSelectedGradient,
        ),
        labelColor: XistiAuthTokens.onGradientText,
        unselectedLabelColor: getCurrentTheme(context).colorTextCommon,
        labelStyle: bodyText(context: context, textColor: XistiAuthTokens.onGradientText, fontWeight: FontWeight.w600),
        unselectedLabelStyle: bodyText(context: context, textColor: getCurrentTheme(context).colorTextCommon, fontWeight: FontWeight.w500),
        onTap: (value) {},
        tabs: [
          Text(languages.all, textAlign: TextAlign.start),
          Text(languages.credit, textAlign: TextAlign.start),
          Text(languages.debit, textAlign: TextAlign.start),
        ],
      ),
    );
  }

  Widget transactionList() {
    return TabBarView(
      controller: tabController,
      children: [
        WalletTransaction(key: _bloc?.walletAllTransactionsScreenKey, walletTransactionType: WalletTransactionType.all),
        WalletTransaction(key: _bloc?.walletCreditTransactionsScreenKey, walletTransactionType: WalletTransactionType.credit),
        WalletTransaction(key: _bloc?.walletDebitTransactionsScreenKey, walletTransactionType: WalletTransactionType.debit),
      ],
    );
  }
}
