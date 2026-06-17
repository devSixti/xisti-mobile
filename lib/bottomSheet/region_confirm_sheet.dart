import 'dart:async';

import 'package:flutter/material.dart';

import 'common_bottom_sheet.dart';
import '../hive/hive_helper.dart';
import '../services/market_config_repo.dart';
import '../services/xisti_region_service.dart';
import '../utils/utils.dart';
import '../utils/xisti_region_catalog.dart';

String _regionTitle(String city) {
  switch (getLanguageFromUserPrefBox()) {
    case 'en':
      return 'Are you in $city?';
    case 'pt':
      return 'Você está em $city?';
    default:
      return '¿Estás en $city?';
  }
}

String _regionMessage(XistiRegionPrompt prompt) {
  final city = prompt.resolved.city.displayName;
  final country = prompt.resolved.country.displayName;
  final currency = prompt.resolved.country.currencySymbol;
  final lang = getLanguageFromUserPrefBox();
  if (prompt.countryChanged) {
    switch (lang) {
      case 'en':
        return 'We detected $country. We will update currency ($currency) and minimum fares.';
      case 'pt':
        return 'Detectamos $country. Vamos atualizar a moeda ($currency) e as tarifas mínimas.';
      default:
        return 'Detectamos $country. Actualizaremos la moneda ($currency) y las tarifas mínimas.';
    }
  }
  switch (lang) {
    case 'en':
      return 'We will update map zones for $city, $country.';
    case 'pt':
      return 'Vamos atualizar as zonas do mapa para $city, $country.';
    default:
      return 'Actualizaremos las zonas del mapa para $city, $country.';
  }
}

Future<bool?> showRegionConfirmSheet(
  BuildContext context,
  XistiRegionPrompt prompt,
) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CommonBottomSheet(
        title: _regionTitle(prompt.resolved.city.displayName),
        message: _regionMessage(prompt),
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
