import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';

/// Create a DateTime picker widget for use in a [Dialog]
/// Can also be used outside a dialog
class SpinnerDateTimePicker extends StatefulWidget {
  const SpinnerDateTimePicker({
    super.key,
    required this.initialDateTime,
    required this.maximumDate,
    required this.minimumDate,
    this.use24hFormat = true,
    this.mode = CupertinoDatePickerMode.date,
    required this.didSetTime,
  });

  /// Callback called when set time button is tapped.
  final Function(DateTime) didSetTime;

  /// The initial date and/or time of the picker. Defaults to the present date
  /// and time and must not be null.
  final DateTime initialDateTime;

  /// The maximum selectable date that the picker can settle on.
  /// Can not be null.
  final DateTime maximumDate;

  /// The minimum selectable date that the picker can settle on.
  /// Can not be null.
  final DateTime minimumDate;

  /// Whether to use 24 hour format. Defaults to false.
  final bool use24hFormat;

  /// The mode of the date picker as one of [CupertinoDatePickerMode].
  /// Defaults to [CupertinoDatePickerMode.dateAndTime]. Cannot be null and
  /// value cannot change after initial build.
  /// Options:
  /// [CupertinoDatePickerMode.date]
  /// [CupertinoDatePickerMode.time]
  /// [CupertinoDatePickerMode.dateAndTime]
  final CupertinoDatePickerMode mode;

  @override
  State<SpinnerDateTimePicker> createState() => _SpinnerDateTimePickerState();
}

class _SpinnerDateTimePickerState extends State<SpinnerDateTimePicker> {
  late DateTime initialDate;
  late DateTime maximumDate;
  late DateTime minimumDate;
  late DateTime selectedDateTime;

  /// sets up the [DateTime] object to only use year, month, day, hour, minute.
  /// [Datetime] usually has additional values that seem to mess up the min-max dates in the spinner
  void setupDateTime() {
    DateTime now = DateTime.now();
    now = widget.initialDateTime;

    initialDate = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    selectedDateTime = initialDate;

    var max = widget.maximumDate;
    maximumDate = DateTime(max.year, max.month, max.day, max.hour, max.minute);

    var min = widget.minimumDate;
    minimumDate = DateTime(min.year, min.month, min.day, min.hour, min.minute);
  }

  @override
  void initState() {
    super.initState();
    setupDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.h,
      child: Stack(
        children: [
          CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                pickerTextStyle: bodyText(fontWeight: FontWeight.w500, context: context),
                dateTimePickerTextStyle: bodyText(fontWeight: FontWeight.w500,context: context),
                textStyle: bodyText(context: context),
              ),
            ),
            child: CupertinoDatePicker(
              initialDateTime: initialDate,
              maximumDate: maximumDate,
              minimumDate: minimumDate,
              use24hFormat: widget.use24hFormat,
              itemExtent: 35.h,
              mode: widget.mode,
              backgroundColor: Colors.transparent,
              selectionOverlayBuilder: myTimerOverlayBuilder,
              onDateTimeChanged: (dateTime) {
                widget.didSetTime(dateTime);
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 35.h, // adjust to align with itemExtent top
            child: Container(height: 1.sp, color: getCurrentTheme(context).colorTextFieldBorder),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 35.h * 2, // bottom line of the selected row
            child: Container(height: 1.sp, color: getCurrentTheme(context).colorTextFieldBorder),
          ),
        ],
      ),
    );
  }
}

Widget? myTimerOverlayBuilder(BuildContext context, {required int columnCount, required int selectedIndex}) {
  return Container(margin: EdgeInsetsDirectional.zero, width: double.infinity, padding: EdgeInsets.zero, decoration: BoxDecoration(color: Colors.transparent));
}
