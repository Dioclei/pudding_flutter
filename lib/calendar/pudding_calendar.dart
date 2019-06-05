import 'package:flutter/material.dart';
import 'calendar_carousel.dart';


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

class _PudCalendarState extends State<PudCalendar> with SingleTickerProviderStateMixin {

  TabController _tabController;

  List<Tab> dateTabs = [
    Tab(
      child: Text(
        'MON\n3 Jun',
        textAlign: TextAlign.center,
      ),
    ),
    Tab(
      child: Text(
        'TUE\n4 Jun',
        textAlign: TextAlign.center,
      ),
    ),
    Tab(
      child: Text(
        'WED\n5 Jun',
        textAlign: TextAlign.center,
      ),
    ),
    Tab(
      child: Text(
        'THU\n6 Jun',
        textAlign: TextAlign.center,
      ),
    ),
    Tab(
      child: Text(
        'FRI\n7 Jun',
        textAlign: TextAlign.center,
      ),
    ),
    Tab(
      child: Text(
        'SAT\n8 Jun',
        textAlign: TextAlign.center,
      ),
    ),
    Tab(
      child: Text(
        'SUN\n9 Jun',
        textAlign: TextAlign.center,
      ),
    ),
    Tab(
      child: Text(
        'MON\n10 Jun',
        textAlign: TextAlign.center,
      ),
    ),
    Tab(
      child: Text(
        'TUE\n11 Jun',
        textAlign: TextAlign.center,
      ),
    ),
    Tab(
      child: Text(
        'WED\n12 Jun',
        textAlign: TextAlign.center,
      ),
    ),
  ];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: dateTabs.length, initialIndex: 3);
    _tabController.addListener(_updateDateList);
    super.initState();
  }

  void _updateDateList() {
    setState(() {
      int offset = _tabController.index - _tabController.previousIndex;
      if (offset > 0) { //if user scrolled to the right
        for (var i = offset; i > 0; i--) {
          // TODO: Use a pageview instead.
          // TODO: grab last date and add [offset] more dates, then delete the first [offset] dates actually dont need to delete?
          dateTabs.add(Tab(
            child: Text('TEST\n11 Aug', textAlign: TextAlign.center,),
          ));
          _tabController = TabController(vsync: this, length: dateTabs.length, initialIndex: 3);
          _tabController.addListener(_updateDateList);
        }
      } else if (offset < 0) { //if user scrolled to the left
        for (var i = offset; i < 0; i++) {
          // TODO: grab first date and add [offset] more dates in the other direction (left), then delete the last [offset] dates
          dateTabs.insert(0, Tab(
            child: Text('TEST\n11 Aug', textAlign: TextAlign.center,)
          ));
          _tabController = TabController(vsync: this, length: dateTabs.length, initialIndex: 3);
          _tabController.addListener(_updateDateList);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.event_note), onPressed: () {print('Pressed');})
        ],
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: dateTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
          children: dateTabs.map((Tab tab) {
            return Center(child:
              SingleChildScrollView(
                child: Table(
                  columnWidths: {
                    0: FixedColumnWidth((queryData.size.width)/3),
                    1: FixedColumnWidth((queryData.size.width)/3*2)
                  },
                  border: TableBorder(horizontalInside: BorderSide(width: 0.5, color: Colors.grey), verticalInside: BorderSide(width: 0.5, color: Colors.grey)),
                  children: <TableRow>[
                    TableRow(
                      children: [
                        Container(
                          height: 50,
                        ),
                        Container(
                          height: 50,
                        )
                      ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            color: Colors.lightBlueAccent,
                            height: 50,
                          ),
                          Container(
                            height: 50,
                          )
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container()
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container()
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container()
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container()
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container()
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container()
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container()
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container()
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container()
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container()
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container()
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container()
                        ]
                    ),

                  ],

                ),
              ),
            );
          }).toList(),
      ),
    );
  }
}




