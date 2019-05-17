import 'package:intl/intl.dart';


int getWeekOfYear(DateTime date) {
  final weekYearStartDate = getWeekYearStartDateForDate(date);
  final dayDiff = date.difference(weekYearStartDate).inDays;
  return ((dayDiff + 1) / 7).ceil();
}

DateTime getWeekYearStartDateForDate(DateTime date) {
  int weekYear = getWeekYear(date);
  return getWeekYearStartDate(weekYear);
}

int getWeekYear(DateTime date) {
  assert(date.isUtc);

  final weekYearStartDate = getWeekYearStartDate(date.year);

  // in previous week year?
  if(weekYearStartDate.isAfter(date)) {
    return date.year - 1;
  }

  // in next week year?
  final nextWeekYearStartDate = getWeekYearStartDate(date.year + 1);
  if (nextWeekYearStartDate.isBefore(date) || (nextWeekYearStartDate.day == date.day && nextWeekYearStartDate.month == date.month && nextWeekYearStartDate.year == date.year)) {
    return date.year + 1;
  }
  return date.year;
}

DateTime getWeekYearStartDate(int year) {
  final firstDayOfYear = DateTime.utc(year, 1, 1);
  final dayOfWeek = firstDayOfYear.weekday;
  if(dayOfWeek <= DateTime.thursday) {
    return firstDayOfYear.add(Duration(days: 1 - dayOfWeek));
  }
  else {
    return firstDayOfYear.add(Duration(days: 8 - dayOfWeek));
  }
}

String getYearWeekString(DateTime date) {
  /// returns a YYYY-INT string
  return '${getWeekYear(date.toUtc())}-${weekNumber(date.toUtc())}';
}

//just a formula
int weekNumber(DateTime date) {
  int ordinal = int.parse(DateFormat("D").format(date));
  return ((ordinal - date.weekday + 10) / 7).floor();
}