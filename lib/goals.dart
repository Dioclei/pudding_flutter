import 'package:charts_common/common.dart';
import 'package:flutter/material.dart';

AppBar goalsAppBar(BuildContext context) {
  return AppBar(
    title: Text('Goals'),
  );
}

FloatingActionButton goalsFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    child: Icon(Icons.library_add),
    elevation: 2.0,
    onPressed: () {
      print("Goals Action Button pressed!");
    },
  );
}

class Goals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Index 3: Goals');
  }
}