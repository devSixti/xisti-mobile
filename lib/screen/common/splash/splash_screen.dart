import 'package:flutter/material.dart';

import '../../../commonView/common_view.dart';
import '../../../utils/rotating_splash_assets.dart';
import '../../../utils/utils.dart';
import 'splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashBloc? _bloc;
  late final String _splashAsset;

  @override
  void initState() {
    super.initState();
    _splashAsset = RotatingSplashAssets.selected;
  }

  @override
  void didChangeDependencies() {
    _bloc ??= SplashBloc(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: AppThemeColors.dark().systemUiOverlayStyle,
      ),
      body: ColoredBox(
        color: const Color(0xFF0B0B0B),
        child: Image.asset(
          _splashAsset,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          filterQuality: FilterQuality.high,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/splash_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
