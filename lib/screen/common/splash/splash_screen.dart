import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../utils/utils.dart';
import 'splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashBloc? _bloc;

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
      appBar: CommonAppBar(toolbarHeight: 0, backgroundColor: Colors.transparent, systemOverlayStyle: AppThemeColors.dark().systemUiOverlayStyle),
      body: SafeArea(
        top: false,
        child: Container(
          color: const Color(0xFF0B0B0B),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/splash_bg.png',
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: commonHorizontalPadding),
                child: Image.asset(
                  'assets/images/xisti/logo_full.png',
                  width: 300.w,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    setImagesBasedOnTheme(context, 'splash_logo.png'),
                    width: 300.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
