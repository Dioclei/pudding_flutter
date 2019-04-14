import 'package:flutter/material.dart';
import 'auth.dart';
import 'signinpage.dart';
import 'social.dart';
import 'timetable.dart';
import 'goals.dart';
import 'dashboard.dart';

/// Set this to false if the initial sign in page is creating issues for you!
/// Note that setting this to false will cause errors in the social functions.
const bool signInEnabled = true;

void main() {
  (signInEnabled)
      ? runApp(checkIfSignedIn() ? MyApp() : SignInRoute()) //checks if signed in.
      : runApp(MyApp());
}

final ThemeData themeData = ThemeData(
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

final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

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
    Timetable(),
    Goals(),
    Social(),
  ];

  @override
  Widget build(BuildContext context) {
    showInSnackBar('Successfully logged in!');
    final _appBarOptions = [
      dashboardAppBar(context),
      timetableAppBar(context),
      goalsAppBar(context),
      socialAppBar(context),
    ];

    final _changingFAB = <FloatingActionButton>[
      timetableFloatingActionButton(context),
      goalsFloatingActionButton(context),
      socialFloatingActionButton(context),
    ];

    return Scaffold(
      key: scaffoldKey,
      appBar: _appBarOptions.elementAt(_selectedIndex),
      floatingActionButton: (_selectedIndex != 0)
          ? _changingFAB.elementAt(_selectedIndex -
          1) // -1 because at _selectedIndex = 1 (timetable), FAB is index 0.
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.brown[600],),
              title: Text(
                "Dashboard", style: TextStyle(color: Colors.brown[600]),)),
          BottomNavigationBarItem(
              icon: Icon(Icons.table_chart, color: Colors.brown[600],),
              title: Text(
                "Timetable", style: TextStyle(color: Colors.brown[600]),)),
          BottomNavigationBarItem(
              icon: Icon(Icons.flag, color: Colors.brown[600],),
              title: Text(
                "Goals", style: TextStyle(color: Colors.brown[600]),)),
          BottomNavigationBarItem(
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

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }
}
