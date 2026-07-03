import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';
import 'passenger_field_box.dart';
import 'xisti_section_label.dart';

class AcarreoQuickFields extends StatelessWidget {
  final TextEditingController descriptionController;
  final TextEditingController fareController;
  final DateTime? estimatedDate;
  final ValueChanged<DateTime> onDateChanged;

  const AcarreoQuickFields({
    super.key,
    required this.descriptionController,
    required this.fareController,
    required this.estimatedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateHint = languages.estimatedServiceDate;
    final dateLabel = estimatedDate != null
        ? '${estimatedDate!.day.toString().padLeft(2, '0')}/${estimatedDate!.month.toString().padLeft(2, '0')}/${estimatedDate!.year}'
        : dateHint;
    final accent = XistiBrand.purple;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: commonHorizontalPadding,
        end: commonHorizontalPadding,
        bottom: 10.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          XistiSectionLabel(label: 'Detalle de la carga', accent: accent),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: accent.withValues(alpha: 0.35)),
              color: accent.withValues(alpha: 0.06),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                children: [
                  PassengerBoxTextField(
                    controller: descriptionController,
                    hint: languages.errandDescription,
                    maxLines: 3,
                  ),
                  SizedBox(height: 12.h),
                  PassengerBoxTextField(
                    controller: fareController,
                    hint: languages.proposedValueRequired,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12.h),
                  PassengerBoxDateField(
                    hint: dateHint,
                    valueLabel: dateLabel,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: estimatedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) onDateChanged(picked);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
