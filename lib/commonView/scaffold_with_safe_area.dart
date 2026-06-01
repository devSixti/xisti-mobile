import 'package:flutter/material.dart';

import '../utils/utils.dart';

class ScaffoldWithSafeArea extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool? extendBody;
  final bool? extendBodyBehindAppBar;
  final bool topPadding, bottomPadding;

  const ScaffoldWithSafeArea({
    super.key,
    this.appBar,
    this.body,
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.topPadding = false,
    this.bottomPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBody: extendBody ?? false,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
      body: gestureNavigation ? body : SafeArea(top: topPadding, bottom: bottomPadding, child: body ?? Container()),
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
