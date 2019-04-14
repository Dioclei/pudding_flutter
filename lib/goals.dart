import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'goalcreationpage.dart';
import 'goalpage.dart';

/// GOALS
/// Data Structure
/// collection('goals')
///   document(user.uid)
///     collection('userGoals')
///       totalDuration: Duration.toString TODO: implement calculation of totalDuration.
///       document(goal_id)
///         name: String
///         desc: String
///         timeSpent: Duration.toString
///         colorValue: Color.value
///         collection('events') TODO: implement adding events and calculating the duration.
///           document(event_id)
///             startTime: Timestamp
///             endTime: Timestamp

enum Layout {
  list,
  grid,
}

Layout currentLayout = Layout.list;

AppBar goalsAppBar(BuildContext context) {
  return AppBar(
    title: Text('Goals'),
    actions: <Widget>[
      IconButton(
        icon: (currentLayout == Layout.list)
            ? Icon(
                Icons.apps,
              )
            : Icon(
                Icons.list,
              ),
        onPressed: () =>
            print('Change layout'), //TODO: Change layout with stateful widget.
      ),
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => print('Open settings'), //TODO: Goals settings: like whether to lock up the screen etc.? or shld we just lock the screen anyway
      )
    ],
  );
}

FloatingActionButton goalsFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    child: Icon(Icons.library_add),
    elevation: 2.0,
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) {
          return GoalCreationPage();
        },
      );
    },
  );
}

class Goals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('goals')
            .document(user.uid)
            .collection('userGoals')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List goalList = [];
            goalList = snapshot.data.documents
                .map((doc) => new Goal(
                      title: doc['title'],
                      color: Color(doc['colorValue']),
                      timeSpent: parseDuration(doc['timeSpent']),
                      selectedPuddingIndex: doc['selectedPuddingIndex'],
                    ))
                .toList();
            if (goalList.length != 0) {
              switch (currentLayout) {
                case Layout.list:
                  return ListView.builder(
                      itemCount: goalList.length,
                      itemBuilder: (context, i) {
                        return GoalsCard(
                          goal: goalList[i],
                        );
                      }); //TODO: Implement ListView goals
                case Layout.grid:
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0),
                      itemBuilder: (context, i) {
                        return GoalsCard(
                          goal: goalList[i],
                        );
                      }); //TODO: Implement GridView goals
              }
            } else
              return Center(
                child: Text('No goals. Add new goal?'),
              );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }
}

class Goal {
  String title;
  Color color;
  Duration timeSpent;
  int selectedPuddingIndex;

  Goal(
      {@required this.title,
      @required this.timeSpent,
      @required this.color,
      this.selectedPuddingIndex: 0});
}

class GoalsCard extends StatelessWidget {
  final Goal goal;

  GoalsCard({@required this.goal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => GoalPage(goal: goal))),
      child: Card(
        child: Container(
          height: 100.0,
          color: goal.color,
          child: ListTile(
            leading: Icon(Icons.library_music),
            title: Text(goal.title),
            subtitle: Text('Time spent: ${goal.timeSpent}, Selected Index: ${goal.selectedPuddingIndex}'),
          ),
        ),
      ),
    );
  }
}

Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}
