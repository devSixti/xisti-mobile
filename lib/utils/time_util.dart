import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../appThemeManager/app_theme_colors.dart';
import '../hive/hive_helper.dart';
import '../main.dart';
import 'style_util.dart';

String formattedTime({required int timeInSecond}) {
  int hour, minute, seconds;
  hour = timeInSecond ~/ 3600;
  minute = ((timeInSecond - hour * 3600)) ~/ 60;
  seconds = timeInSecond - (hour * 3600) - (minute * 60);

  if (hour >= 1) {
    return "$hour ${languages.hour} : $minute ${languages.min}";
  } else if (minute >= 1) {
    return "$minute ${languages.min}";
  } else {
    return "$seconds ${languages.seconds}";
  }
}

String getTimeStampConvertDateTime({required int timeStamp, String returnFormat = ""}) {
  if (returnFormat.trim().isEmpty) {
    returnFormat = getConvertedDateAndTimeBasedOnFormat(false, false);
  }

  var parse = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  var formatDate = DateFormat(returnFormat, getLanguageFromUserPrefBox()).format(parse);
  return formatDate;
}

String getDateTime(
  String ourDate, {
  String returnFormat = "",
  String format = "yyyy-MM-dd HH:mm:ss",
  bool useLocalTime = false,
  bool showOnlyDate = false,
  bool showOnlyTime = false,
}) {
  String serverTimeZone = getStringFromSettingBox(hiveServerTimeZone);
  bool isUtc = (serverTimeZone.toUpperCase() == "UTC");
  var parse = DateFormat(format).parse(ourDate, isUtc);

  var detroit =
      useLocalTime
          ? tz.getLocation(localTimeZone)
          : isUtc
          ? tz.UTC
          : tz.getLocation(serverTimeZone);
  var now = tz.TZDateTime(detroit, parse.year, parse.month, parse.day, parse.hour, parse.minute, parse.second);
  var convertedDate = tz.TZDateTime.from(now, tz.getLocation(localTimeZone));

  if (returnFormat.trim().isEmpty) {
    returnFormat = getConvertedDateAndTimeBasedOnFormat(showOnlyDate, showOnlyTime);
  }
  var formatDate = DateFormat(returnFormat, getLanguageFromUserPrefBox()).format(convertedDate);
  return formatDate;
}

String getConvertedDateAndTimeBasedOnFormat(bool showOnlyDate, bool showOnlyTime) {
  String dateFormat = "dd/MM/yyyy";
  String timeFormat = isTime24HoursFormat ? "HH:mm" : "hh:mm aa";
  return showOnlyDate
      ? dateFormat
      : showOnlyTime
      ? timeFormat
      : "$dateFormat $timeFormat";
}

String getDateTimeWithoutTimezone(
  String ourDate, {
  String returnFormat = "yyyy-MM-dd hh:mm aa",
  String format = "yyyy-MM-dd hh:mm",
  bool useLocalTime = false,
}) {
  String serverTimeZone = getStringFromSettingBox(hiveServerTimeZone);
  bool isUtc = (serverTimeZone.toUpperCase() == "UTC");
  try {
    var parse = DateFormat(format).parse(ourDate, isUtc);
    var formatDate = DateFormat(returnFormat, getLanguageFromUserPrefBox()).format(parse);
    return formatDate;
  } catch (e) {
    return "--:--";
  }
}

String getDateTimeWithoutTimezoneFromObj(
  DateTime ourDate, {
  String returnFormat = "",
  String format = "yyyy-MM-dd HH:mm:ss",
  bool useLocalTime = false,
  bool showOnlyDate = false,
  bool showOnlyTime = false,
}) {
  if (returnFormat.trim().isEmpty) {
    returnFormat = getConvertedDateAndTimeBasedOnFormat(showOnlyDate, showOnlyTime);
  }
  try {
    var formatDate = DateFormat(returnFormat, getLanguageFromUserPrefBox()).format(ourDate);
    return formatDate;
  } catch (e) {
    return "--:--";
  }
}

DateTime getTimeAndDateObj(String ourDate) {
  String serverTimeZone = getStringFromSettingBox(hiveServerTimeZone, defaultValue: "UTC");
  bool isUtc = (serverTimeZone.toUpperCase() == "UTC");
  var parse = DateFormat("yyyy-MM-dd HH:mm:ss").parse(ourDate, isUtc);

  var detroit = isUtc ? tz.UTC : tz.getLocation(serverTimeZone);
  var now = tz.TZDateTime(detroit, parse.year, parse.month, parse.day, parse.hour, parse.minute, parse.second);
  var convertedDate = tz.TZDateTime.from(now, tz.getLocation(localTimeZone));
  return convertedDate;
}

String convertTimeToServerTime(DateTime dateTime, {bool onlyDate = false}) {
  String serverTimeZone = getStringFromSettingBox(hiveServerTimeZone);
  bool isUtc = (serverTimeZone.toUpperCase() == "UTC");
  final detroitTime = isUtc ? dateTime.toUtc() : tz.TZDateTime.from(dateTime, tz.getLocation(serverTimeZone));
  return DateFormat(onlyDate ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm:ss').format(detroitTime);
}

String timeAgo(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? languages.year : languages.years} ${languages.ago}";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? languages.month : languages.months} ${languages.ago}";
  }
  if (diff.inDays > 7) return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? languages.week : languages.weeks} ${languages.ago}";
  if (diff.inDays > 0) return "${diff.inDays} ${diff.inDays == 1 ? languages.day : languages.days} ${languages.ago}";
  if (diff.inHours > 0) return "${diff.inHours} ${diff.inHours == 1 ? languages.hour : languages.hours} ${languages.ago}";
  if (diff.inMinutes > 0) return "${diff.inMinutes} ${diff.inMinutes == 1 ? languages.minute : languages.minutes} ${languages.ago}";
  if (diff.inSeconds >= 3) return '${diff.inSeconds} ${languages.seconds} ${languages.ago}';
  return languages.justNow;
}

Future<DateTime?> selectDocumentExpiryDate(BuildContext context, {DateTime? initialDate}) => showDatePicker(
  context: context,
  initialDate: initialDate ?? DateTime.now().add(const Duration(hours: 1, seconds: 1)),
  firstDate: DateTime.now().add(const Duration(hours: 1)),
  initialEntryMode: DatePickerEntryMode.calendarOnly,
  lastDate: DateTime(DateTime.now().year + 30),
  builder: (BuildContext expiryDatePickerContext, Widget? child) {
    return Theme(
      data: Theme.of(expiryDatePickerContext).copyWith(
        primaryColor: getCurrentTheme(expiryDatePickerContext).colorPrimary,
        colorScheme:
            getCurrentTheme(expiryDatePickerContext).themeMode == 1
                ? ColorScheme.light(
                  primary: getCurrentTheme(expiryDatePickerContext).colorPrimary,
                  secondary: getCurrentTheme(expiryDatePickerContext).colorPrimary,
                )
                : ColorScheme.dark(
                  primary: getCurrentTheme(expiryDatePickerContext).colorPrimary,
                  secondary: getCurrentTheme(expiryDatePickerContext).colorPrimary,
                ),
        textTheme: TextTheme().copyWith(
          bodyMedium: bodyText(context: expiryDatePickerContext, textColor: getCurrentTheme(expiryDatePickerContext).colorTextCommon),
        ),
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
      ),
      child: child ?? Container(),
    );
  },
);

List<String> yearPickerList() {
  List<String> years = [];
  final int maxYear = DateTime.now().year + 1;
  for (int i = maxYear; i >= 1950; i--) {
    years.add(i.toString());
  }
  return years;
}
