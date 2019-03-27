import 'package:flutter/material.dart';

AppBar dashboardAppBar(context) {
  return AppBar(
    title: Text('Dashboard'),
  );
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Index 0: Dashboard');
  }
}