import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/custom_text_field.dart';
import '../../../utils/utils.dart';

/// Peso y dimensiones del paquete en home (modo Envío), antes de ofertar tarifa.
class DeliveryQuickFields extends StatefulWidget {
  final String weightKg;
  final String heightCm;
  final String widthCm;
  final String lengthCm;
  final ValueChanged<String> onWeightChanged;
  final ValueChanged<String> onHeightChanged;
  final ValueChanged<String> onWidthChanged;
  final ValueChanged<String> onLengthChanged;

  const DeliveryQuickFields({
    super.key,
    required this.weightKg,
    required this.heightCm,
    required this.widthCm,
    required this.lengthCm,
    required this.onWeightChanged,
    required this.onHeightChanged,
    required this.onWidthChanged,
    required this.onLengthChanged,
  });

  @override
  State<DeliveryQuickFields> createState() => _DeliveryQuickFieldsState();
}

class _DeliveryQuickFieldsState extends State<DeliveryQuickFields> {
  late final TextEditingController _weight;
  late final TextEditingController _height;
  late final TextEditingController _width;
  late final TextEditingController _length;

  @override
  void initState() {
    super.initState();
    _weight = TextEditingController(text: widget.weightKg);
    _height = TextEditingController(text: widget.heightCm);
    _width = TextEditingController(text: widget.widthCm);
    _length = TextEditingController(text: widget.lengthCm);
  }

  @override
  void didUpdateWidget(covariant DeliveryQuickFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController(_weight, widget.weightKg, oldWidget.weightKg);
    _syncController(_height, widget.heightCm, oldWidget.heightCm);
    _syncController(_width, widget.widthCm, oldWidget.widthCm);
    _syncController(_length, widget.lengthCm, oldWidget.lengthCm);
  }

  void _syncController(TextEditingController c, String next, String prev) {
    if (next != prev && c.text != next) {
      c.text = next;
    }
  }

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _width.dispose();
    _length.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: commonHorizontalPadding,
        end: commonHorizontalPadding,
        top: 8.h,
        bottom: 4.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalles del paquete',
            style: bodyText(context: context, fontSize: textSize12px, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          TextFormFieldCustom(
            controller: _weight,
            hint: 'Peso (kg)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
            setError: false,
            onChanged: widget.onWeightChanged,
            prefix: Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w),
              child: Icon(Icons.scale_outlined, size: 22.sp, color: getCurrentTheme(context).colorIconCommon),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: TextFormFieldCustom(
                  controller: _height,
                  hint: 'Alto (cm)',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  setError: false,
                  onChanged: widget.onHeightChanged,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextFormFieldCustom(
                  controller: _width,
                  hint: 'Ancho (cm)',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  setError: false,
                  onChanged: widget.onWidthChanged,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextFormFieldCustom(
                  controller: _length,
                  hint: 'Largo (cm)',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  setError: false,
                  onChanged: widget.onLengthChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
