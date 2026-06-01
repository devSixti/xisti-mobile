import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/api_response.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import 'item_app_theme.dart';
import 'item_currency.dart';
import 'item_language.dart';
import 'language_and_currency_bloc.dart';
import 'language_and_currency_dl.dart';
import 'language_and_currency_shimmer.dart';

class LanguageAndCurrency extends StatefulWidget {
  final bool isFromHome;

  const LanguageAndCurrency({super.key, this.isFromHome = false});

  @override
  State<StatefulWidget> createState() => _LanguageAndCurrencyState();
}

class _LanguageAndCurrencyState extends State<LanguageAndCurrency> {
  bool isFromHome = false;
  LanguageAndCurrencyBloc? _bloc;

  @override
  void didChangeDependencies() {
    isFromHome = widget.isFromHome;
    _bloc ??= LanguageAndCurrencyBloc(context);
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
      appBar: CommonAppBar(
        leading:
            Navigator.canPop(context)
                ? backButtonForAppBarCustom(
                  context: context,
                  onBackPress: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                )
                : null,
        title: Text(languages.preferences, style: toolbarStyle(context: context)),
        centerTitle: true,
      ),
      body: _buildLanguageAndCurrency(context),
    );
  }

  Widget _buildLanguageAndCurrency(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(top: 15.h, start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 150.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(languages.selectAppTheme, style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize20px)),
              ItemAppTheme(
                defaultSelected: getIntFromSettingBox(hiveAppTheme),
                onSelectionChanged: (value) {
                  _bloc?.setSelectedTheme(value);
                },
              ),

              Container(
                margin: EdgeInsetsDirectional.only(top: 20.h),
                child: Text(languages.selectLanguage, style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize18px)),
              ),
              ItemLanguage(
                languageList: _bloc?.spLanguage ?? [],
                defaultSelected: _bloc?.spLanguage.indexWhere((element) => element.languageCode == getLanguageFromUserPrefBox()),
                onSelectionChanged: (value) {
                  _bloc?.setSelectedLanguage(value);
                },
              ),
              Container(
                margin: EdgeInsetsDirectional.only(top: 20.h),
                child: Text(languages.selectCurrency, style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize18px)),
              ),
              StreamBuilder<ApiResponse<LanguageAndCurrencyResponse>>(
                stream: _bloc?.languageAndCurrencySubject,
                builder: (context, snapCurrency) {
                  if (snapCurrency.hasData) {
                    switch (snapCurrency.data?.status ?? Status.loading) {
                      case Status.loading:
                        return const SelectLanguageAndCurrencyShimmer(enabled: true);
                      case Status.completed:
                        List<CurrencyListItem> currencyList = snapCurrency.data?.data?.currencyList ?? [];
                        CurrencyListItem currencyListItem = currencyList.firstWhere(
                          (element) => element.currencySymbol == getStringFromSettingBox(hiveSelectedCurrency),
                          orElse: () {
                            return CurrencyListItem();
                          },
                        );
                        return ItemCurrency(
                          currencyList: currencyList,
                          defaultSelected: currencyListItem.currencyId,
                          onSelectionChanged: (value) {
                            _bloc?.setSelectedCurrency(value);
                          },
                        );
                      case Status.error:
                        return AppErrorWidget(
                          onRetryPressed: () {
                            _bloc?.getCurrencyData();
                          },
                          errorMessage: snapCurrency.data?.message,
                        );
                    }
                  }
                  return const SelectLanguageAndCurrencyShimmer(enabled: true);
                },
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: getCurrentTheme(context).colorScaffoldBg,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!widget.isFromHome)
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 10.h),
                    child: Text(
                      languages.preferenceMsg,
                      textAlign: TextAlign.center,
                      style: bodyText(context: context, fontWeight: FontWeight.w500, fontSize: textSize14px),
                    ),
                  ),
                updateButton(_bloc!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget updateButton(LanguageAndCurrencyBloc bloc) {
    return StreamBuilder(
      stream: bloc.streamSelectedCurrency,
      builder: (context, selectedItemSnapshot) {
        return StreamBuilder<ApiResponse<BaseModel>>(
          stream: bloc.updateSubject.stream,
          builder: (context, snap) {
            var isLoading = snap.hasData && snap.data?.status == Status.loading;
            return CustomRoundedButton(
              context,
              languages.update,
              (!selectedItemSnapshot.hasData || isLoading)
                  ? null
                  : () {
                    bloc.submit(context, isFromHome);
                  },
              setProgress: isLoading,
              minWidth: double.maxFinite,
              margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin(), top: 15.h),
            );
          },
        );
      },
    );
  }
}
