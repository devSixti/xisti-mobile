import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/custom_text_field.dart';
import '../../../utils/utils.dart';
import '../passengerHome/passenger_home_dl.dart';
import 'set_route_bloc.dart';

class ItemMultiStopAddress extends StatelessWidget {
  final SearchedLocation multiStopModel;
  final Function onClickRemove;
  final TextEditingController textEditingController = TextEditingController();
  final SetRouteBloc bloc;
  final int position;

  ItemMultiStopAddress({super.key, required this.multiStopModel, required this.onClickRemove, required this.bloc, required this.position});

  @override
  Widget build(BuildContext context) {
    if ((multiStopModel.name ?? "").isNotEmpty) {
      textEditingController.value = textEditingController.value.copyWith(text: multiStopModel.name ?? "");
      textEditingController.selection = TextSelection.collapsed(offset: textEditingController.text.length);
    }
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 20.h),
      child: TextFormFieldCustom(
        controller: textEditingController,
        hint: languages.searchLocation,
        onChanged: (value) {
          bloc.deBouncer.run(() {
            multiStopModel.name = value;
            bloc.getPlaces(value);
            bloc.selectedIndexController.sink.add(position + 3);
          });
        },
        onTap: () {
          bloc.selectedIndexController.sink.add(position + 3);
        },
        commonPrefixIcon: CustomIcons.stopPoint,
        suffix: InkWell(
          onTap: () {
            bloc.selectedIndexController.sink.add(position + 3);
            textEditingController.text = "";
            bloc.changeLocationSearch();
            textEditingController.clear();
            onClickRemove();
          },
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: 10.w, start: 10.w),
            child: Icon(CustomIcons.remove, color: getCurrentTheme(context).colorIconLight, size: 25.sp),
          ),
        ),
      ),
    );
  }
}
