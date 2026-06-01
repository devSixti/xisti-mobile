import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../utils/utils.dart';
import '../Login/login_screen.dart';
import 'item_on_boarding_pages.dart';
import 'on_boarding_pages_bloc.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  OnBoardingPagesBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= OnBoardingPagesBloc(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      appBar: const CommonAppBar(toolbarHeight: 0, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin()),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CarouselSlider.builder(
                  itemCount: _bloc?.onBoardingList.length ?? 0,
                  itemBuilder: (BuildContext context, int index, int realIndex) {
                    return ItemOnBoardingPages(data: _bloc!.onBoardingList[index]);
                  },
                  carouselController: _bloc?.carouselController,
                  options: CarouselOptions(
                    initialPage: 0,
                    viewportFraction: 1,
                    disableCenter: true,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      _bloc?.changeSelectedPos(index);
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              StreamBuilder<int>(
                stream: _bloc?.selectedPos,
                builder: (context, snapSelectedPos) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: (_bloc?.onBoardingList ?? []).map<Widget>((s) => indicator(s.id == (snapSelectedPos.data ?? 0))).toList(),
                  );
                },
              ),
              CustomRoundedButton(
                context,
                languages.login,
                () {
                  openScreenWithClearPrevious(context, LoginScreen());
                },
                minWidth: double.maxFinite,
                margin: EdgeInsetsDirectional.only(top: 50.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
