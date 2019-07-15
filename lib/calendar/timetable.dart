import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event_creator.dart';

/// Parameters for adjusting sizes & color of the timetable layout.
const hourHeight = 60.0;
const timesWidth = 70.0;
const dividerOffset = 5.0;
final Color dividerColor = Colors.brown[300].withOpacity(0.2);
final Color addEventContainerColor = Colors.blue;

class Event {
  final DateTime startTime;
  final DateTime endTime;
  final Color eventColor;
  final String title;
  Event({@required this.startTime, @required this.endTime, @required this.eventColor, @required this.title});
}

class Timetable extends StatefulWidget {
  final DateTime currentDate;
  Timetable(
      {Key key, @required this.currentDate,})
      : super(key: key);
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  int selectedInt;
  List<Widget> times = [];
  List<Widget> timetableBoxes = [];
  List<Widget> timetableBoxDividers = [];
  List<Event> events = [];
  List<Widget> eventContainers = [];
  List<Widget> selector = []; // single child list
  List<Widget> verticalDivider = []; // single child list
  List<Widget> children = [];
  List<Widget> tappedChildren = [];

  @override
  void initState() {
    selectedInt = 0;
    times = List.generate(23, (i) {
      return LayoutId(
        id: "Time${i+1}",
        child: Center(child: Text('${(i+1).toString().padLeft(2, '0')}:00')),
      );
    });
    timetableBoxes = List.generate(24, (j) {
      return LayoutId(
        id: 'Box${j+1}',
        child: InkWell(
          onTap: () => setState(() {
            selectedInt = j+1;
          })
        )
      );
    });
    timetableBoxDividers = List.generate(23, (k) {
      return LayoutId(
        id: 'Divider${k+1}',
        child: Container(
          height: 1.0,
          color: dividerColor,
        )
      );
    });
    verticalDivider = [
      LayoutId(
          id: 'VerticalDivider',
          child: Container(
            width: 1.0,
            color: dividerColor,
          )
      ),
    ];
    selector = [
      LayoutId(
        id: 'Selector',
        child: Container(
            decoration: BoxDecoration(
                color: addEventContainerColor,
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Material(
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventCreator())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('+Add Event', style: TextStyle(color: Colors.white)),
                ),
              ),
            )
        ),
      )
    ];
    /// TODO: Retrieve Events based on widget.currentDate
    events = [
      Event(title: 'Slack off', startTime: DateTime(2019, 7, 15, 5, 00), endTime: DateTime(2019, 7, 15, 6, 54), eventColor: Colors.pink,),
      Event(title: 'Do Homework', startTime: DateTime(2019, 7, 15, 13, 53), endTime: DateTime(2019, 7, 15, 14, 45), eventColor: Colors.red,),
      Event(title: 'Complain with Angelo', startTime: DateTime(2019, 7, 15, 18, 15), endTime: DateTime(2019, 7, 15, 22, 34), eventColor: Colors.lightBlue[400],),
      Event(title: 'Sleeping with Tom', startTime: DateTime(2019, 7, 15, 15, 00), endTime: DateTime(2019, 7, 15, 17, 00), eventColor: Colors.purple,)
    ];
    eventContainers = List.generate(events.length, (e) {
      return LayoutId(id: 'Event${e+1}', child: EventContainer(event: events[e],));
    });


    /// Note: order of children widgets determines painting order.
    tappedChildren = times + timetableBoxes + timetableBoxDividers + verticalDivider + selector + eventContainers;
    children = times + timetableBoxes + timetableBoxDividers + verticalDivider + eventContainers;


    // TODO: grab data from Firebase/TableCalendar using currentDate to display events.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //this is the format for formatting date and getting 2015-12-01 - currenthour : currentminute
    //String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(today);
    String formattedDate = DateFormat('dd-MM-yyyy').format(widget.currentDate);

    return SingleChildScrollView(
      child: Container(
        height: 24 * hourHeight,
        child: CustomMultiChildLayout(
          delegate: TimetableLayoutDelegate(events: events, selectedInt: selectedInt, currentDate: widget.currentDate),
          children: selectedInt > 0 ? tappedChildren : children,
        ),
      ),
    );
  }
}

class TimetableLayoutDelegate extends MultiChildLayoutDelegate {
  final List<Event> events;
  final int selectedInt;
  final DateTime currentDate;
  TimetableLayoutDelegate({@required this.events, @required this.selectedInt, @required this.currentDate});

  @override
  void performLayout(Size size) {
    /// Layout Times
    if (hasChild('Time1')) {
      for (int i = 0; i < 23; i++) {
        layoutChild(
            'Time${i + 1}', BoxConstraints.tight(Size(timesWidth, hourHeight)));
        positionChild(
            'Time${i + 1}', Offset(0.0, (0.5 * hourHeight + i * hourHeight)));
      }
    }
    /// Layout Timetable Boxes
    if (hasChild('Box1')) {
      for (int j = 0; j < 24; j++) {
        layoutChild('Box${j + 1}', BoxConstraints.tight(
            Size(size.width - timesWidth - dividerOffset, hourHeight)));
        positionChild(
            'Box${j + 1}', Offset(timesWidth + dividerOffset, j * hourHeight));
      }
    }
    /// Layout Timetable Box Dividers
    if (hasChild('Divider1')) {
      for (int k = 0; k < 23; k++) {
        layoutChild('Divider${k + 1}',
            BoxConstraints.loose(Size(size.width - timesWidth, size.height)));
        positionChild(
            'Divider${k + 1}', Offset(timesWidth, (k + 1) * hourHeight));
      }
    }
    /// Layout Vertical Divider
    if (hasChild('VerticalDivider')) {
      layoutChild('VerticalDivider', BoxConstraints.loose(size));
      positionChild('VerticalDivider', Offset(timesWidth + dividerOffset, 0.0));
    }
    /// Layout Add Event Selector
    if (selectedInt > 0) {
      if (hasChild('Selector')) {
        layoutChild('Selector', BoxConstraints.tight(
            Size(size.width - timesWidth - dividerOffset, hourHeight)));
        positionChild('Selector',
            Offset(timesWidth + dividerOffset, (selectedInt - 1) * hourHeight));
      }
    }
    /// Layout Events
    if (events.length > 0) {
      for(int e = 0; e < events.length; e++) {
        Duration eventDuration = events[e].endTime.difference(events[e].startTime);
        double height;
        double offsetHeight;
        DateTime zeroTime = DateTime(events[e].startTime.year, events[e].startTime.month, events[e].startTime.day);
        if (eventDuration.inMinutes < 1440) {
          height = size.height / 1440 * eventDuration.inMinutes.abs();
          offsetHeight = size.height / 1440 * events[e].startTime.difference(zeroTime).inMinutes.abs();
        }
        layoutChild('Event${e+1}', BoxConstraints.tight(Size(size.width - timesWidth - dividerOffset, height)));
        positionChild('Event${e+1}',
          Offset(timesWidth + dividerOffset, offsetHeight)
        );
      }
    }
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }

  @override
  bool shouldRelayout(TimetableLayoutDelegate oldDelegate) {
    return selectedInt != oldDelegate.selectedInt || events != oldDelegate.events;
  }
}

class EventContainer extends StatelessWidget {
  final Event event;
  EventContainer({this.event});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: event.eventColor,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(event.title, style: TextStyle(color: Colors.white),),
      ),
    );
  }
}


/*
DOESNT WORK BTW
AddEventCard(
          selected: ('Box${j+1}' == selectedId),
          onTap: () {
            if ('Box${j+1}' == selectedId) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventCreator()));
            } else {
              setState(() {
                selectedId = 'Box${j+1}';
              });
            }
          },
          onDoubleTap: () {
            setState(() {
              selectedId = 'Box${j+1}';
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventCreator()));
            });
          },
        )

 */

/*
ListView.separated(
      itemCount: 24,
      itemBuilder: (context, i) {
        return AddEventCard(
          selected: (i == selectedIndex),
          onTap: () {
            if (i == selectedIndex) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventCreator()));
            } else {
              setState(() {
                selectedIndex = i;
              });
            }
          },
          onDoubleTap: () {
            setState(() {
              selectedIndex = i;
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventCreator()));
            });
          },
        );
      },
      separatorBuilder: (context, i) {
        return Divider(
          height: 0.0,
          color: Colors.brown[300],
        );
      },
    );
 */





