import 'package:flutter/material.dart';
import 'themecolors.dart';
import 'auth.dart';
import 'signinpage.dart';
import 'package:pudding_flutter/calendar/pudding_calendar.dart';
import 'package:pudding_flutter/social/social.dart';
import 'package:pudding_flutter/goals/goals.dart';
import 'dashboard.dart';
import 'package:flutter/services.dart';


/// Set this to false if the initial sign in page is creating issues for you!
/// Note that setting this to false will cause errors in the social functions.
const bool signInEnabled = true;

void main() {
  (signInEnabled)
      ? runApp(checkIfSignedIn() ? MyApp() : SignInRoute()) //checks if signed in.
      : runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: backgroundColor));
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

    /// App Bars
    final _appBarOptions = [
      dashboardAppBar(context),
      calendarAppBar(context),
      goalsAppBar(context),
      null,
    ];

    /// Floating Action Buttons
    final _changingFAB = [
      DashboardFloatingActionButton(parent: this),
      calendarFloatingActionButton(context),
      goalsFloatingActionButton(context),
      SocialFloatingActionButton(parent: this),
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
