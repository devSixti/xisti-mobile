import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/custom_text_field.dart';
import '../../../main.dart';
import '../../../utils/utils.dart';

/// Campos rápidos en home para modo Encomiendas (compra + tope antes de ofertar tarifa).
class EncomiendaQuickFields extends StatelessWidget {
  final TextEditingController purchaseDescriptionController;
  final TextEditingController priceCapController;

  const EncomiendaQuickFields({
    super.key,
    required this.purchaseDescriptionController,
    required this.priceCapController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: commonHorizontalPadding,
        end: commonHorizontalPadding,
        bottom: 8.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormFieldCustom(
            controller: purchaseDescriptionController,
            hint: languages.whatToBuyHint,
            maxLine: 2,
            minLine: 1,
            setError: false,
            prefix: Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w),
              child: Icon(Icons.shopping_bag_outlined, size: 22.sp, color: getCurrentTheme(context).colorIconCommon),
            ),
          ),
          SizedBox(height: 10.h),
          TextFormFieldCustom(
            controller: priceCapController,
            hint: languages.priceCapHint,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            setError: false,
            prefix: Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w),
              child: Icon(Icons.payments_outlined, size: 22.sp, color: getCurrentTheme(context).colorIconCommon),
            ),
          ),
        ],
      ),
    );
  }
}
