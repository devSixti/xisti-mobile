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
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/splash_bg.png"), fit: BoxFit.cover),
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [getCurrentTheme(context).colorSplashGradient1, getCurrentTheme(context).colorSplashGradient2],
            //   stops: [0.2, 0.5],
            //   transform: GradientRotation(-0.6),
            //   // tileMode: TileMode.decal
            // ),
          ),
          child: Stack(
            children: [
              // Image.asset("assets/images/splash_bg.png", fit: BoxFit.fitWidth,),
              Container(
                alignment: AlignmentDirectional.center,
                padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 150.h),
                child: Image.asset(setImagesBasedOnTheme(context, 'splash_logo.png'), width: 226.w, height: 183.h),
              ),
              // Align(
              //   alignment: AlignmentDirectional.bottomCenter,
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       SizedBox(height: 10.h),
              //       appVersionName(textColor: getCurrentTheme(context).colorStaticBlack),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
