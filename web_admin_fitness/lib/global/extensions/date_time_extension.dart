import 'package:intl/intl.dart';

import '../gen/i18n.dart';

extension DateTimeExtension on DateTime {
  String formatDateTime(I18n i18n) {
    return '${(DateFormat.Hm('vi').format(this))} ${formatDate()}';
  }

  String formatDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String formatTime(I18n i18n) {
    return '${DateFormat.Hm('vi').format(this)} ';
  }

  bool isSameDayOrAfter(DateTime other) => isAfter(other) || isSameDay(other);

  bool isSameDayOrBefore(DateTime other) => isBefore(other) || isSameDay(other);

  bool isSameDay(DateTime? other) =>
      other != null &&
      year == other.year &&
      month == other.month &&
      day == other.day;

  bool isBetweenDays(DateTime? start, DateTime? end) {
    var isAfterStartDay = start != null ? isSameDayOrAfter(start) : true;
    var isBeforeEndDay = end != null ? isSameDayOrBefore(end) : true;

    return isAfterStartDay && isBeforeEndDay;
  }

  bool isTimeBefore(DateTime other) =>
      hour < other.hour || (hour == other.hour && minute < other.minute);

  bool isSameTimeOrBefore(DateTime other) =>
      isTimeBefore(other) || (hour == other.hour && minute == other.minute);

  DateTime combineTime(DateTime other) =>
      DateTime(year, month, day, other.hour, other.minute, other.second);

  DateTime setTime([
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) =>
      DateTime(
          year, month, day, hour, minute, second, millisecond, microsecond);
}
