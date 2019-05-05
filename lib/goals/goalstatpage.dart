import 'package:pudding_flutter/goals/goals.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pudding_flutter/goals/barchart.dart';
import 'package:pudding_flutter/auth.dart';

class GoalStatPage extends StatelessWidget {
  final Goal goal;

  GoalStatPage({@required this.goal});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: goal.color,
          title: Text('Stats'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(child: Text('Week')),
              Tab(child: Text('Month')),
            ],
          ),
        ),
        body: TabBarView(children: [
          WeekTab(),
          MonthTab(),
        ]),
      ),
    );
  }
}

class MonthTab extends StatelessWidget {
  const MonthTab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MonthChart(
        data: [0,0,0,0,0,0,1,2,333,23,400,102,167,256,302,40,10,0,0,0,0]
    );
  }
}

class WeekTab extends StatelessWidget {
  final Goal goal;
  const WeekTab({
    Key key,
    this.goal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('goals').document(user.uid).collection('userGoals').document(goal.id).collection('events').snapshots(),
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              Text('Hello', style: TextStyle(color: Colors.white),),
              Expanded(
                child: WeekChart(
                  mon: 5,
                  tue: 2,
                  wed: 29,
                  thu: 300,
                  fri: 40,
                  sat: 186,
                ),
              ),
            ],
          );
        }
    );
  }
}