import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/service_mode_util.dart';
import '../../../utils/shared_ride_kind.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';
import 'passenger_field_box.dart';
import 'xisti_section_label.dart';

class SharedRideFields extends StatelessWidget {
  final String tripKind;
  final TextEditingController originController;
  final TextEditingController destinationController;
  final TextEditingController? fareController;
  final DateTime? tripDate;
  final ValueChanged<DateTime> onDateChanged;

  const SharedRideFields({
    super.key,
    required this.tripKind,
    required this.originController,
    required this.destinationController,
    this.fareController,
    required this.tripDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateHint = languages.selectSharedRideDate;
    final normalizedKind = SharedRideKind.normalize(tripKind);
    final originLabel = SharedRideKind.originHint(normalizedKind);
    final destinationLabel = SharedRideKind.destinationHint(normalizedKind);
    final dateLabel = tripDate != null
        ? '${tripDate!.day.toString().padLeft(2, '0')}/${tripDate!.month.toString().padLeft(2, '0')}/${tripDate!.year}'
        : dateHint;

    final accent = XistiUiTokens.accentForMode(ServiceModeKind.expreso);
    final theme = getCurrentTheme(context);

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: commonHorizontalPadding,
        end: commonHorizontalPadding,
        bottom: 10.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          XistiSectionLabel(label: 'Detalle del recorrido', accent: accent),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: accent.withValues(alpha: 0.35)),
              color: accent.withValues(alpha: 0.05),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                children: [
                  PassengerBoxTextField(
                    key: ValueKey('shared-origin-$normalizedKind'),
                    controller: originController,
                    label: originLabel,
                    hint: originLabel,
                    icon: Icons.trip_origin,
                  ),
                  SizedBox(height: 12.h),
                  PassengerBoxTextField(
                    key: ValueKey('shared-destination-$normalizedKind'),
                    controller: destinationController,
                    label: destinationLabel,
                    hint: destinationLabel,
                    icon: Icons.flag_outlined,
                  ),
                  SizedBox(height: 12.h),
                  PassengerBoxDateField(
                    hint: dateHint,
                    valueLabel: dateLabel,
                    icon: Icons.calendar_today,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tripDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) onDateChanged(picked);
                    },
                  ),
                  if (fareController != null) ...[
                    SizedBox(height: 12.h),
                    PassengerBoxTextField(
                      controller: fareController,
                      hint: languages.contributionPerPersonCop,
                      icon: Icons.payments_outlined,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            languages.sharedRideContributionNotice,
            style: bodyText(context: context, fontSize: textSize12px, textColor: theme.colorTextLight),
          ),
        ],
      ),
    );
  }
}
