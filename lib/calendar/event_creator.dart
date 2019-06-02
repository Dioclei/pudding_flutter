import 'package:flutter/material.dart';

class EventCreator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30.0),
          padding: const EdgeInsets.all(20.0),
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              /*Event Creator Placeholder*/
              TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Event name'),
              ),
              /*Start Date and Time placeholder*/
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              /*End Date and Time placeholder*/
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
