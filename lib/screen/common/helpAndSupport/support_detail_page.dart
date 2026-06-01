import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../commonView/common_view.dart';
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
    if (PlatformDispatcher.instance.platformBrightness == Brightness.light) {
      setThemeMode(lightModeCSS);
    } else if (PlatformDispatcher.instance.platformBrightness ==
        Brightness.dark) {
      setThemeMode(darkModeCSS);
    }
    _webViewController?.reload();
  }

  void setThemeMode(String theme) async {
    await _webViewController?.evaluateJavascript(
      source:
          """
            (function() {
              var style = document.createElement('style');
              style.innerHTML = `$theme`;
              document.head.appendChild(style);
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
          // Inject CSS for theme
          getCurrentTheme(context).themeMode == 1
              ? setThemeMode(lightModeCSS)
              : setThemeMode(darkModeCSS);
        },
      ),
    );
  }

  String get darkModeCSS => """
    body { background-color: #121212 !important; color: white !important; }
    a { color: #bb86fc !important; }
  """;

  String get lightModeCSS => """
    body { background-color: white !important; color: black !important; }
    a { color: blue !important; }
  """;
}
