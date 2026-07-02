import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../commonView/common_view.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/utils.dart';

class SupportDetailPage extends StatefulWidget {
  final String title, pageDetail;

  const SupportDetailPage({
    super.key,
    required this.title,
    required this.pageDetail,
  });

  @override
  State<SupportDetailPage> createState() => _SupportDetailPageState();
}

class _SupportDetailPageState extends State<SupportDetailPage>
    with WidgetsBindingObserver {
  InAppWebViewController? _webViewController;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.resumed:
        checkThemeMode();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.paused:
        break;
    }
    if (state == AppLifecycleState.resumed) {
      checkThemeMode();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void checkThemeMode() {
    _applyTheme(_isLightTheme());
    _webViewController?.reload();
  }

  bool _isLightTheme() {
    if (mounted) {
      return getCurrentTheme(context).themeMode == 1;
    }
    return getIntFromSettingBox(hiveAppTheme, defaultValue: 1) == 1;
  }

  void _applyTheme(bool isLight) {
    setThemeMode(isLight ? lightModeCSS : darkModeCSS, isDark: !isLight);
  }

  void setThemeMode(String theme, {required bool isDark}) async {
    await _webViewController?.evaluateJavascript(
      source:
          """
            (function() {
              var existing = document.getElementById('support-theme-style');
              if (existing) existing.remove();
              var style = document.createElement('style');
              style.id = 'support-theme-style';
              style.innerHTML = `$theme`;
              document.head.appendChild(style);
              if ($isDark) {
                document.querySelectorAll('[style]').forEach(function(el) {
                  el.style.removeProperty('color');
                });
              }
            })();
          """,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      appBar: CommonAppBar(
        centerTitle: true,
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.title, style: toolbarStyle(context: context)),
      ),
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(transparentBackground: true),
        initialData: InAppWebViewInitialData(data: widget.pageDetail),
        onWebViewCreated: (controller) {
          _webViewController = controller;
          // Set background color to avoid flashing
          _webViewController?.evaluateJavascript(
            source: """
    document.body.style.backgroundColor = 'transparent';
    document.documentElement.style.backgroundColor = 'transparent';
  """,
          );
        },
        onLoadStop: (controller, url) async {
          _applyTheme(_isLightTheme());
        },
      ),
    );
  }

  String get darkModeCSS => """
    html, body {
      background-color: #121212 !important;
      color: #FFFFFF !important;
    }
    body, body *:not(a):not(a *) {
      color: #FFFFFF !important;
    }
    body p, body div, body span, body li, body ul, body ol,
    body h1, body h2, body h3, body h4, body h5, body h6,
    body td, body th, body strong, body em, body label, body blockquote {
      color: #FFFFFF !important;
    }
    a, a * {
      color: #BB86FC !important;
    }
  """;

  String get lightModeCSS => """
    body { background-color: white !important; color: black !important; }
    a { color: blue !important; }
  """;
}
