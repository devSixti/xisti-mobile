import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../appThemeManager/app_theme_colors.dart';
import 'map_utils.dart';

/// Keeps Google Map JSON styles in sync when the user changes app theme in preferences.
class MapStyleHotReloadHandle {
  MapStyleHotReloadHandle._(this._dispose);

  final VoidCallback _dispose;

  void dispose() => _dispose();
}

typedef MapStyleExtrasCallback = Future<void> Function();

class MapStyleHotReload {
  MapStyleHotReload._();

  static final List<_MapStyleRegistration> _registrations = [];
  static bool _listening = false;

  static MapStyleHotReloadHandle bind({
    required BuildContext context,
    required void Function(String style) onStyle,
    MapStyleExtrasCallback? onExtras,
  }) {
    _ensureListening();
    late _MapStyleRegistration registration;
    registration = _MapStyleRegistration(
      isMounted: () => context.mounted,
      onStyle: onStyle,
      onExtras: onExtras,
      loadInitial: () => _applyFromContext(context, onStyle, onExtras),
    );
    _registrations.add(registration);
    unawaited(registration.loadInitial());

    return MapStyleHotReloadHandle._(() {
      _registrations.remove(registration);
    });
  }

  static void _ensureListening() {
    if (_listening) {
      return;
    }
    _listening = true;
    themeModeChangeListener.addListener(_onThemeChanged);
  }

  static Future<void> _onThemeChanged() async {
    final style = await loadMapStyleJsonForCurrentTheme();
    final snapshot = List<_MapStyleRegistration>.from(_registrations);
    for (final registration in snapshot) {
      if (!registration.isMounted()) {
        continue;
      }
      registration.onStyle(style);
      if (registration.onExtras != null) {
        await registration.onExtras!();
      }
    }
  }

  static Future<String> loadMapStyleJsonForCurrentTheme() async {
    final themeMode = themeModeChangeListener.value;
    final path = themeMode == 2 ? AppThemeColors.dark().mapStyle : AppThemeColors.light().mapStyle;
    if (path.trim().isEmpty) {
      return rootBundle.loadString('assets/mapStyle/map_style.json');
    }
    return rootBundle.loadString(path);
  }

  static Future<void> _applyFromContext(
    BuildContext context,
    void Function(String style) onStyle,
    MapStyleExtrasCallback? onExtras,
  ) async {
    await setMapStyle(
      context: context,
      callback: (style) async {
        onStyle(style);
        if (onExtras != null) {
          await onExtras();
        }
      },
    );
  }
}

class _MapStyleRegistration {
  _MapStyleRegistration({
    required this.isMounted,
    required this.onStyle,
    required this.onExtras,
    required this.loadInitial,
  });

  final bool Function() isMounted;
  final void Function(String style) onStyle;
  final MapStyleExtrasCallback? onExtras;
  final Future<void> Function() loadInitial;
}
