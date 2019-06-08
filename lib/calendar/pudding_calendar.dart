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
  DateTime selectedDate;
  bool animating;
  PageController _pageController;
  MediaQueryData queryData;

  @override
  void initState() {
    today = DateTime.now();
    selectedDate = getDate(today);
    _pageController = PageController(initialPage: 5000);
    animating = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Calendar'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.event_note),
              onPressed: () {
                setState(() {
                  _pageController.animateToPage(5000, duration: Duration(seconds: 1), curve: Curves.ease).whenComplete(() {
                    selectedDate = today;
                  });
                });
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Material(
            /// Fake App Bar Extension
            elevation: 4,
            color: Colors.brown,
            child: NewCalendar(
              selectedDate: selectedDate,
              onDateChanged: (date) {
                if (date != selectedDate) {
                  setState(() {
                    int offset =
                        getDate(date).difference(getDate(today)).inDays;
                    _pageController.animateToPage(5000 + offset,
                        duration: Duration(seconds: 1), curve: Curves.ease).whenComplete(() {
                          selectedDate = getDate(date);
                    });
                  });
                }
              },
            ),
          ),
          Expanded(
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) {
                  int offset = i - 5000;
                  setState(() {
                    selectedDate = today.add(Duration(days: offset));
                  });
                },
                itemBuilder: (context, i) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            getMonthDay(today.add(Duration(days: (i - 5000))))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Index: $i'),
                      ),
                      Expanded(
                        child: Timetable(
                          tooday: selectedDate,
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
