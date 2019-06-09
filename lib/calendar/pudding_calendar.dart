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
  DateTime selectedDate; /// refers to the final destination date that the user selects
  DateTime currentPageDate; /// refers to the current date displayed on the PageView
  bool animating;
  PageController _pageController;
  MediaQueryData queryData;

  @override
  void initState() {
    today = DateTime.now();
    currentPageDate = selectedDate = getDate(today);
    _pageController = PageController(initialPage: 999999);
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
                  _pageController.animateToPage(999999, duration: Duration(seconds: 1), curve: Curves.ease).whenComplete(() {
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
            child: Calendar(
              selectedDate: selectedDate,
              onDateChanged: (date) {
                if (date != selectedDate) {
                  setState(() {
                    int offset =
                        getDate(date).difference(getDate(today)).inDays;
                    animating = true;
                    _pageController.animateToPage(999999 + offset,
                        duration: Duration(seconds: 1), curve: Curves.ease).whenComplete(() {
                          animating = false;
                          setState(() {
                            selectedDate = currentPageDate;
                          });
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
                  int offset = i - 999999;
                  setState(() {
                    currentPageDate = today.add(Duration(days: offset));
                    if (animating == false)
                      selectedDate = currentPageDate;
                  });
                },
                itemBuilder: (context, i) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            getMonthDay(currentPageDate)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Index: $i'),
                      ),
                      Expanded(
                        child: Timetable(
                          tooday: currentPageDate,
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
