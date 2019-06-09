import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  Calendar({selectedDate, @required this.onDateChanged})
    : selectedDate = selectedDate ?? DateTime.now();
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      initialCalendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      selectedDay: selectedDate,
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(color: Colors.white),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white,),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white,),
        leftChevronPadding: EdgeInsets.all(4.0),
        rightChevronPadding: EdgeInsets.all(4.0),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white)
      ),
      calendarStyle: CalendarStyle(
        weekdayStyle: TextStyle(color: Colors.white),
      ),
      onDaySelected: (datetime, events) {
        print('Datetime: $datetime');
        print('Events: $events');
        onDateChanged(datetime);
      },
    );
  }
}