import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../blocs/bloc.dart';
import '../../../utils/utils.dart';
import 'on_boarding_pages_dl.dart';

class OnBoardingPagesBloc extends Bloc {
  BuildContext context;
  List<OnBoardingPojo> onBoardingList = [];

  OnBoardingPagesBloc(this.context) {
    onBoardingList = [
      OnBoardingPojo(0, setImagesBasedOnTheme(context, "ob_page1.png"), languages.obTitle1, languages.obMsg1),
      OnBoardingPojo(1, setImagesBasedOnTheme(context, "ob_page2.png"), languages.obTitle2, languages.obMsg2),
      OnBoardingPojo(2, setImagesBasedOnTheme(context, "ob_page3.png"), languages.obTitle3, languages.obMsg3),
    ];
  }

  final _selectedPosController = BehaviorSubject<int>.seeded(0);

  Stream<int> get selectedPos => _selectedPosController.stream;

  void changeSelectedPos(int page) {
    _selectedPosController.sink.add(page);
    carouselController.animateToPage(page);
  }

  CarouselSliderController carouselController = CarouselSliderController();

  @override
  void dispose() {
    _selectedPosController.close();
  }
}
