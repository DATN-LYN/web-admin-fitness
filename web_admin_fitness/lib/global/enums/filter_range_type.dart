import 'package:jiffy/jiffy.dart';

import '../gen/i18n.dart';

enum FilterRangeType {
  weekly(),
  monthly(),
  yearly();

  DateTime? startDate({int? month, int? year}) {
    switch (this) {
      case FilterRangeType.weekly:
        return Jiffy().startOf(Units.WEEK).dateTime;
      case FilterRangeType.monthly:
        return getFirstDayOfMonth(month ?? Jiffy().month, year ?? Jiffy().year);
      case FilterRangeType.yearly:
        return getFirstDayOfYear(year ?? Jiffy().year);
    }
  }

  DateTime? endDate({int? month, int? year}) {
    switch (this) {
      case FilterRangeType.weekly:
        return Jiffy().endOf(Units.WEEK).dateTime;
      case FilterRangeType.monthly:
        return getLastDayOfMonth(month ?? Jiffy().month, year ?? Jiffy().year);
      case FilterRangeType.yearly:
        return getLastDayOfYear(year ?? Jiffy().year);
    }
  }

  String label(I18n i18n) {
    switch (this) {
      case FilterRangeType.weekly:
        return i18n.common_Weekly;
      case FilterRangeType.monthly:
        return i18n.common_Monthly;
      case FilterRangeType.yearly:
        return i18n.common_Yearly;
    }
  }

  String timeText(I18n i18n) {
    switch (this) {
      case FilterRangeType.weekly:
        return i18n.statistics_ThisWeek;
      case FilterRangeType.monthly:
        return i18n.statistics_ThisMonth;
      case FilterRangeType.yearly:
        return i18n.statistics_ThisMonth;
    }
  }

  DateTime getFirstDayOfMonth(int month, int year) {
    return DateTime(year, month, 1);
  }

  DateTime getLastDayOfMonth(int month, int year) {
    return DateTime(year, month + 1, 0);
  }

  DateTime getFirstDayOfYear(int year) {
    return DateTime(year, 1, 1);
  }

  DateTime getLastDayOfYear(int year) {
    return DateTime(year, 12, 31);
  }

  List<String> xValuesChart(I18n i18n, {int? month, int? year}) {
    final now = DateTime.now();

    switch (this) {
      case FilterRangeType.weekly:
        return i18n.weekDays_;
      case FilterRangeType.monthly:
        final daysInMonth = DateTime(now.year, (month ?? 1) + 1, 0).day;
        return List.generate(daysInMonth, (index) => (index + 1).toString());
      case FilterRangeType.yearly:
        return List.generate(12, (index) => (index + 1).toString());
    }
  }

  List<int> days({int? month}) {
    final now = DateTime.now();

    switch (this) {
      case FilterRangeType.weekly:
        return [1, 2, 3, 4, 5, 6, 7];
      case FilterRangeType.monthly:
        final daysInMonth = DateTime(now.year, (month ?? 1) + 1, 0).day;
        return List.generate(daysInMonth, (index) => index + 1);
      case FilterRangeType.yearly:
        return List.generate(12, (index) => index + 1);
    }
  }
}
