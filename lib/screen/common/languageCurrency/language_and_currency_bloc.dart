import 'dart:async';

import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/utils.dart';
import '../../driverMode/driverHome/driver_home.dart';
import '../../passengerMode/passengerHome/passenger_home.dart';
import '../Login/login_screen.dart';
import '../onBoarding/on_boarding_screen.dart';
import 'language_and_currency_dl.dart';
import 'language_and_currency_repo.dart';

class LanguageAndCurrencyBloc extends Bloc {
  final LanguageAndCurrencyRepo _languageAndCurrencyRepo = LanguageAndCurrencyRepo();
  BuildContext context;

  LanguageAndCurrencyBloc(this.context) {
    getCurrencyData();
    getLanguageData();
  }

  List<LanguageListItem> spLanguage = [
    LanguageListItem("English", "en"),
    LanguageListItem("Español", "es"),
    LanguageListItem("Français", "fr"),
    LanguageListItem("Italiano", "it"),
    LanguageListItem("Português", "pt"),
  ];

  LanguageListItem? language;
  CurrencyListItem? currency;
  AppThemeListItem? themeItem;
  final _languageController = BehaviorSubject<List<LanguageListItem>>();
  final _selectedLanguageController = BehaviorSubject<LanguageListItem>();
  final _selectedCurrencyController = BehaviorSubject<CurrencyListItem>();
  final _selectedThemeController = BehaviorSubject<AppThemeListItem>();
  final _languageAndCurrencySubject = BehaviorSubject<ApiResponse<LanguageAndCurrencyResponse>>();
  final BehaviorSubject<ApiResponse<BaseModel>> _updateSubject = BehaviorSubject<ApiResponse<BaseModel>>();

  BehaviorSubject<ApiResponse<BaseModel>> get updateSubject => _updateSubject;

  Stream<List<LanguageListItem>> get streamLanguage => _languageController.stream;

  Stream<ApiResponse<LanguageAndCurrencyResponse>> get languageAndCurrencySubject => _languageAndCurrencySubject.stream;

  Stream<LanguageListItem> get streamSelectedLanguage => _selectedLanguageController.stream;

  Stream<CurrencyListItem> get streamSelectedCurrency => _selectedCurrencyController.stream;

  void setSelectedLanguage(LanguageListItem language) {
    this.language = language;
    _selectedLanguageController.sink.add(language);
  }

  void setSelectedCurrency(CurrencyListItem currency) {
    this.currency = currency;
    _selectedCurrencyController.sink.add(currency);
  }

  void setSelectedTheme(AppThemeListItem themeItem) {
    this.themeItem = themeItem;
    _selectedThemeController.sink.add(themeItem);
    putDataInSettingBox(hiveAppTheme, themeItem.appThemeCode);
    checkAndChangeThemeMode();
  }

  void setLanguageData(List<LanguageListItem> languageList) {
    _languageController.sink.add(languageList);
  }

  void getLanguageData() {
    int index = spLanguage.indexWhere((element) => element.languageCode == defaultLanguage /*prefGetString(prefSelectedLanguageCode)*/);
    if (index == -1) {
      language = spLanguage[0];
    } else {
      language = spLanguage[index];
    }
    setSelectedLanguage(language!);
    _languageController.sink.add(spLanguage);
  }

  Future<void> getCurrencyData() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => getCurrencyData())) {
      _languageAndCurrencySubject.sink.add(ApiResponse.loading());
      try {
        var response = LanguageAndCurrencyResponse.fromJson(await _languageAndCurrencyRepo.getLanguageAndCurrency());
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true)) {
          setAuthKey(response.appKey ?? "");
          if ((response.currencyList).isNotEmpty) {
            int index = response.currencyList.indexWhere((element) => element.currencySymbol == getStringFromSettingBox(hiveSelectedCurrency));
            if (index == -1) {
              currency = response.currencyList[0];
            } else {
              currency = response.currencyList[index];
            }
            setSelectedCurrency(currency!);
          }
          _languageAndCurrencySubject.sink.add(ApiResponse.completed(response));
        } else {
          _languageAndCurrencySubject.sink.add(ApiResponse.error(response.message));
        }
      } catch (e) {
        _languageAndCurrencySubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> updateLanguageAndCurrency(bool isFromHome) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => updateLanguageAndCurrency(isFromHome))) {
      _updateSubject.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(await _languageAndCurrencyRepo.updateCountryAndCurrency(language!.languageCode, currency!.currencySymbol));
        _updateSubject.sink.add(ApiResponse.completed(response));

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true)) {
          putDataInSettingBox(hiveSelectedCurrency, currency?.currencySymbol ?? defaultCurrency);
          setChangedLanguage(
            context,
            language!.languageCode,
            nextAction: () {
              if (getIntFromSettingBox(hiveAppMode) == AppMode.driver) {
                openScreenWithClearPrevious(context, isFromHome ? const DriverHome() : const LoginScreen());
              } else {
                openScreenWithClearPrevious(context, isFromHome ? const PassengerHome() : const LoginScreen());
              }
            },
          );
        }
      } catch (e) {
        _updateSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void submit(BuildContext context, bool isFromHome) {
    if (!isFromHome) {
      putDataInSettingBox(hiveSelectedCurrency, currency?.currencySymbol ?? defaultCurrency);
      setChangedLanguage(
        context,
        language!.languageCode,
        nextAction: () {
          if (!getBoolFromSettingBox(hiveIsShownOnBoarding)) {
            putDataInSettingBox(hiveIsShownOnBoarding, true);
            openScreenWithClearPrevious(context, const OnBoardingScreen());
          } else {
            openScreenWithClearPrevious(context, const LoginScreen());
          }
        },
      );
    } else {
      updateLanguageAndCurrency(isFromHome);
    }
  }

  @override
  void dispose() {
    _updateSubject.close();
    _languageController.close();
    _languageAndCurrencySubject.close();
    _selectedLanguageController.close();
    _selectedCurrencyController.close();
  }
}
