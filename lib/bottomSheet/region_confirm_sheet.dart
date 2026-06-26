import 'dart:async';

import 'package:flutter/material.dart';

import 'common_bottom_sheet.dart';
import '../main.dart';
import '../services/market_config_repo.dart';
import '../services/xisti_region_service.dart';
import '../utils/utils.dart';
import '../utils/xisti_region_catalog.dart';

Future<bool?> showRegionConfirmSheet(
  BuildContext context,
  XistiRegionPrompt prompt,
) {
  final city = prompt.resolved.city.displayName;
  final country = prompt.resolved.country.displayName;
  final currency = prompt.resolved.country.currencySymbol;
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CommonBottomSheet(
        title: languages.regionConfirmTitle(city),
        message: prompt.countryChanged
            ? languages.regionConfirmCountryMessage(country, currency)
            : languages.regionConfirmCityMessage(city, country),
        positiveButtonTxt: languages.yes,
        negativeButtonTxt: languages.no,
        onPositivePress: () => Navigator.pop(context, true),
        onNegativePress: () => Navigator.pop(context, false),
      );
    },
  );
}

Future<void> handleRegionPromptIfNeeded(
  BuildContext context,
  double lat,
  double lng, {
  required void Function(ResolvedXistiRegion region) onRegionApplied,
}) async {
  final prompt = XistiRegionService.promptForCoordinates(lat, lng);
  if (prompt == null) {
    onRegionApplied(XistiRegionService.activeRegion());
    return;
  }

  if (!context.mounted) return;
  final confirmed = await showRegionConfirmSheet(context, prompt);
  if (!context.mounted) return;

  if (confirmed == true) {
    XistiRegionService.applyRegion(prompt.resolved);
    unawaited(syncMarketConfig(
      countryId: prompt.resolved.country.id,
      cityId: prompt.resolved.city.id,
    ));
    onRegionApplied(prompt.resolved);
    return;
  }

  if (prompt.cityChanged) {
    XistiRegionService.declineCity(prompt.resolved);
  }
  onRegionApplied(XistiRegionService.activeRegion());
}
