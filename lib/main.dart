import 'package:flutter/material.dart';
import 'themecolors.dart';
import 'auth.dart';
import 'signinpage.dart';
import 'pudding_calendar.dart';
import 'package:pudding_flutter/social/social.dart';
import 'timetable.dart';
import 'package:pudding_flutter/goals/goals.dart';
import 'dashboard.dart';
import 'package:pudding_flutter/pudding_calendar.dart';
import 'package:flutter/services.dart';
import 'package:unicorndial/unicorndial.dart';


/// Set this to false if the initial sign in page is creating issues for you!
/// Note that setting this to false will cause errors in the social functions.
const bool signInEnabled = false;

void main() {
  (signInEnabled)
      ? runApp(checkIfSignedIn() ? MyApp() : SignInRoute()) //checks if signed in.
      : runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: backgroundColor));
}

final ThemeData themeData = ThemeData(
  fontFamily: 'Product Sans',
  primarySwatch: Colors.brown,
  canvasColor: Colors.yellow[100],
);

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
  MyHomePageState createState() => MyHomePageState();


}


class MyHomePageState extends State<MyHomePage> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    final _widgetOptions = [
      Dashboard(this),
      PudCalendar(),
      Goals(),
      Social(),
    ];

    /// Dashboard Floating Action Child Buttons
    final List<UnicornButton> childButtons = [
      UnicornButton(
          hasLabel: true,
          labelText: "Add Friend",
          labelBackgroundColor: Colors.transparent,
          labelHasShadow: false,
          labelColor: Colors.brown,
          currentButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.redAccent,
            mini: true,
            child: Icon(Icons.person_add),
            onPressed: () {
              setState(() {
                selectedIndex = 3;
              });
              },
          )
      ),
      UnicornButton(
          hasLabel: true,
          labelText: "Add Goal",
          labelBackgroundColor: Colors.transparent,
          labelHasShadow: false,
          labelColor: Colors.brown,
          currentButton: FloatingActionButton(
            heroTag: 'goals',
            backgroundColor: Colors.blueAccent,
            mini: true,
            child: Icon(Icons.library_add),
            onPressed: () {
              setState(() {
                selectedIndex = 2;
                addGoal(context);
              });
              },
          )
      ),
      UnicornButton(
          hasLabel: true,
          labelText: "Add Event",
          labelBackgroundColor: Colors.transparent,
          labelHasShadow: false,
          labelColor: Colors.brown,
          currentButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.yellow,
            mini: true,
            child: Icon(Icons.add_comment),
            onPressed: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          )
      ),
    ];
    final dashboardFloatingActionButton = UnicornDialer(
      backgroundColor: backgroundColor.withOpacity(0.9),
      parentButtonBackground: Colors.brown,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.add),
      childButtons: childButtons,
    );

    /// App Bars
    final _appBarOptions = [
      dashboardAppBar(context),
      calendarAppBar(context),
      goalsAppBar(context),
      socialAppBar(context),
    ];

    /// Floating Action Buttons
    final _changingFAB = [
      dashboardFloatingActionButton,
      calendarFloatingActionButton(context),
      goalsFloatingActionButton(context),
      socialFloatingActionButton(context),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _appBarOptions.elementAt(selectedIndex),
      floatingActionButton: _changingFAB.elementAt(selectedIndex),/*(_selectedIndex != 0)
          ? _changingFAB.elementAt(_selectedIndex -
          1) // -1 because at _selectedIndex = 1 (calendar), FAB is index 0.
          : null,*/
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
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),

      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}