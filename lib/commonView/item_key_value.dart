import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../networking/base_dl.dart';
import '../utils/utils.dart';

class ItemKeyValue extends StatelessWidget {
  final KeyValueModel keyValueModel;

  const ItemKeyValue({super.key, required this.keyValueModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: (keyValueModel.setDivider ?? false) ? EdgeInsets.zero : EdgeInsetsDirectional.only(bottom: 4.h, top: 10.h),
      child: Column(
        children: [
          (keyValueModel.setDivider ?? false)
              ? Padding(padding: EdgeInsets.symmetric(vertical: 15.h), child: Divider(color: getCurrentTheme(context).colorBorder, height: 1.h))
              : Container(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  keyValueModel.key,
                  textAlign: TextAlign.start,
                  style: bodyText(
                    context: context,
                    fontSize: (keyValueModel.setBold ?? false) ? textSize18px : textSize16px,
                    fontWeight: (keyValueModel.setBold ?? false) ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: GestureDetector(
                  onTap: keyValueModel.setButton,
                  child: Container(
                    padding: keyValueModel.setButton != null ? EdgeInsets.symmetric(vertical: 8.5.h, horizontal: 10.w) : null,
                    child: Text(
                      keyValueModel.value,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyText(
                        context: context,
                        fontSize: (keyValueModel.setBold ?? false) ? textSize18px : textSize16px,
                        fontWeight: (keyValueModel.setBold ?? false) ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
