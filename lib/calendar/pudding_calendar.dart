import 'package:flutter/material.dart';
import 'calendar_carousel.dart';
import 'package:pudding_flutter/dateparser.dart';
import 'package:pudding_flutter/calendar/timetable.dart';

FloatingActionButton calendarFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    child: Icon(Icons.event),
    elevation: 2.0,
    onPressed: () {
      print("Timetable Action Button pressed!");
    },
  );
}

class PudCalendar extends StatefulWidget {
  @override
  _PudCalendarState createState() => _PudCalendarState();
}

class _PudCalendarState extends State<PudCalendar> {
  DateTime today;
  DateTime currentDate;
  PageController _pageController;
  MediaQueryData queryData;

  @override
  void initState() {
    today = DateTime.now();
    currentDate = getDate(today);
    _pageController = PageController(initialPage: 5000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(getMonthDay(currentDate)),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.event_note),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: NewCalendar(),
                      );
                    });
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Container( /// Fake App Bar Extension
            width: queryData.size.width,
            decoration: BoxDecoration(
              color: Colors.brown,
              boxShadow: [BoxShadow(
                color: Colors.brown,
                blurRadius: 5.0,
              )]
            ),
            child: NewCalendar(),
          ),
          Expanded(
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) {
                  int offset = i - 5000;
                  setState(() {
                    if (offset == 0) {
                      currentDate = today;
                    } else if (offset > 0) {
                      currentDate =
                          getDate(today.add(Duration(days: offset.abs())));
                    } else {
                      currentDate =
                          getDate(today.subtract(Duration(days: offset.abs())));
                    }
                  });
                },
                itemBuilder: (context, i) {
                  return Timetable(
                    tooday: currentDate,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
