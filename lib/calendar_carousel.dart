import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  Calendar({Key key,}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _currentDate = DateTime.now();
  EventList<Event> _markedDateMap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> dates) {
          this.setState(() => _currentDate = date);
        },
        weekdayTextStyle: TextStyle(
          fontFamily: 'Product Sans',
          fontSize: 18,
        ),
        markedDateMoreCustomTextStyle: TextStyle(
          fontFamily: 'Product Sans',
          fontSize: 18,
        ),
        weekendTextStyle: TextStyle(
          color: Colors.red,
          fontFamily: 'Product Sans',
          fontSize: 18,
        ),
        daysTextStyle: TextStyle(
          fontFamily: 'Product Sans',
          fontSize: 18,
        ),
        nextDaysTextStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'Product Sans'
        ),
        prevDaysTextStyle: TextStyle(
          fontFamily: 'Product Sans',
          fontSize:16,
        ),
        thisMonthDayBorderColor: Colors.grey,
        headerTextStyle: TextStyle(
          fontFamily: 'Product Sans',
          color: Colors.brown,
          fontSize: 25,
        ),
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
//      markedDates: _markedDate,
        weekFormat: false,
        markedDatesMap: _markedDateMap,
        height: 420.0,
        selectedDateTime: _currentDate,
        daysHaveCircularBorder: null,

        /// null for not rendering any border, true for circular border, false for rectangular border
      ),
    );
  }
}