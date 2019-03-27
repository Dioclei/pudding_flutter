import 'package:flutter/material.dart';
import 'calendar_carousel.dart';

AppBar timetableAppBar(BuildContext context) {
  return AppBar(
    title: Text('Timetable'),
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