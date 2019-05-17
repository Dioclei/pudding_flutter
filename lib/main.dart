import 'package:flutter/material.dart';
import 'themecolors.dart';
import 'auth.dart';
import 'signinpage.dart';
import 'pudding_calendar.dart';
import 'package:pudding_flutter/social/social.dart';
import 'timetable.dart';
import 'package:pudding_flutter/goals/goals.dart';
import 'dashboard.dart';

/// Set this to false if the initial sign in page is creating issues for you!
/// Note that setting this to false will cause errors in the social functions.
const bool signInEnabled = false;

void main() {
  (signInEnabled)
      ? runApp(checkIfSignedIn() ? MyApp() : SignInRoute()) //checks if signed in.
      : runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pudding',
      theme: themeData,
      home: MyHomePage(),
      routes: <String, WidgetBuilder> {
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();


}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;

  final _widgetOptions = [
    Dashboard(),
    PudCalendar(),
    Goals(),
    Social(),
  ];

  @override
  Widget build(BuildContext context) {
    final _appBarOptions = [
      dashboardAppBar(context),
      calendarAppBar(context),
      goalsAppBar(context),
      socialAppBar(context),
    ];

    final _changingFAB = <FloatingActionButton>[
      calendarFloatingActionButton(context),
      goalsFloatingActionButton(context),
      socialFloatingActionButton(context),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _appBarOptions.elementAt(_selectedIndex),
      floatingActionButton: (_selectedIndex != 0)
          ? _changingFAB.elementAt(_selectedIndex -
          1) // -1 because at _selectedIndex = 1 (calendar), FAB is index 0.
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: backgroundColor,
              icon: Icon(Icons.home, color: Colors.brown[600],),
              title: Text(
                "Dashboard", style: TextStyle(color: Colors.brown[600]),)),
          BottomNavigationBarItem(
              backgroundColor: backgroundColor,
              icon: Icon(Icons.table_chart, color: Colors.brown[600],),
              title: Text(
                "Calendar", style: TextStyle(color: Colors.brown[600]),)),
          BottomNavigationBarItem(
              backgroundColor: backgroundColor,
              icon: Icon(Icons.flag, color: Colors.brown[600],),
              title: Text(
                "Goals", style: TextStyle(color: Colors.brown[600]),)),
          BottomNavigationBarItem(
              backgroundColor: backgroundColor,
              icon: Icon(Icons.people, color: Colors.brown[600],),
              title: Text(
                "Social", style: TextStyle(color: Colors.brown[600]),)),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}