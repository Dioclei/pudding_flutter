import 'package:flutter/material.dart';
import 'calendar_carousel.dart';

AppBar timetableAppBar(BuildContext context) {
  return AppBar(
    title: Text('Timetable'),
  );
}

FloatingActionButton timetableFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    child: Icon(Icons.add_comment),
    elevation: 2.0,
    onPressed: () {
      print("Timetable Action Button pressed!");
    },
  );
}

class Timetable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Index 1: Timetable'),
          Calendar(),
        ],
      ),
    );
  }
}