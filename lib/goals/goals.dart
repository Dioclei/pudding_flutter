import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pudding_flutter/auth.dart';
import 'package:pudding_flutter/goals/goalcreationpage.dart';
import 'package:pudding_flutter/goals/goalpage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:pudding_flutter/goals/goalarchivepage.dart';
import 'package:pudding_flutter/themecolors.dart';

/// GOALS
/// Data Structure
/// collection('goals')
///   document(user.uid)
///     collection('userGoals')
///       document(goal_id)
///         name: String
///         desc: String
///         colorValue: Color.value
///         collection('events') TODO: implement adding events and calculating the duration.
///           document(event_id)
///             durationInMinutes: int
///             completedDate: DateTime.now().toIso8601String()

AppBar goalsAppBar(BuildContext context) {
  return AppBar(
    title: Text('Goals'),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.unarchive),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GoalArchivePage())),
      )
    ],
  );
}

FloatingActionButton goalsFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    child: Icon(Icons.outlined_flag),
    elevation: 2.0,
    onPressed: () {
      addGoal(context);
    },
  );
}

addGoal(context) {
  showDialog(
    context: context,
    builder: (context) {
      return GoalCreationPage();
    },
  );
}

class Goals extends StatefulWidget {
  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  @override
  Widget build(BuildContext context) {
    final BuildContext overallContext = context;
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
                .map((doc) {
                  return new Goal(
                      id: doc.documentID,
                      title: doc['title'],
                      color: Color(doc['colorValue']),
                      selectedPuddingIndex: doc['selectedPuddingIndex'],
                    );
                })
                .toList();
            if (goalList.length != 0) {
                  return ListView.builder(
                      itemCount: goalList.length,
                      itemBuilder: (context, i) {
                        final Goal currentGoal = goalList[i];
                        return Dismissible(
                          key: Key(currentGoal.id),
                          child: GoalsCard(
                            goal: currentGoal,
                            onTap: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => GoalPage(goal: currentGoal)))
                          ),
                          direction: DismissDirection.endToStart,
                          background:  Container(
                            color: Colors.green,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Archive', style: TextStyle(color: Colors.white),),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                  child: Icon(Icons.archive,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          confirmDismiss: (direction) {
                            return showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                                    title: Text('Archive Goal'),
                                    content: Text('Are you sure you want to archive this goal ${currentGoal.title}?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text('Yes'),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text('No'),
                                      ),
                                    ],
                                  );
                              }
                            );
                          },
                          onDismissed: (direction) {
                            archiveGoal(currentGoal).whenComplete(() {
                              setState(() {});
                              Flushbar(
                                message: '${currentGoal.title} goal successfully archived!',
                                mainButton: FlatButton(
                                  child: Text('Undo', style: TextStyle(color: Colors.white),),
                                  onPressed: () => unarchiveGoal(currentGoal).whenComplete(() {
                                    setState(() {});
                                  }),
                                ),
                                duration: Duration(seconds: 3),
                              ).show(overallContext);
                            });
                          },
                          onResize: () {

                          },
                        );
                      });
            } else
              return Center(
                child: Text("It's feeling empty in here... Add a new goal!"),
              );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }
}

class Goal {
  String id;
  String title;
  Color color;
  int selectedPuddingIndex;

  Goal(
      {this.id, @required this.title,
      @required this.color,
      this.selectedPuddingIndex: 0});
}

class GoalsCard extends StatelessWidget {
  final Goal goal;
  final Function onTap;

  GoalsCard({@required this.goal, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(1.0, 2.0, 1.0, 2.0),
        child: Material(
          elevation: 1.0,
          color: backgroundColor,
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: <Widget>[
                Container(
                  width: 10.0,
                  color: goal.color,
                ),
                Image(image: AssetImage('icons/pudding${goal.selectedPuddingIndex}.png'),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(goal.title, style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('Time Spent')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
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
}*/

Future<Goal> addGoalToDestination({@required Goal goal, @required String destination}) async {
  if (!['userGoals', 'archive'].contains(destination))
    throw Exception("Incorrect destination stated! Only 'userGoals' and 'archive' are allowed.");
  Goal addedGoal;
  await Firestore.instance
      .collection('goals')
      .document(user.uid)
      .collection(destination)
      .add({
    'title': goal.title,
    'colorValue': goal.color.value,
    'selectedPuddingIndex': goal.selectedPuddingIndex,
  }).then((doc) {
    goal.id = doc.documentID;
    addedGoal = goal;
  });
  return addedGoal;
}


Future<Goal> archiveGoal(Goal goal) async {
  Goal archivedGoal;
  await Firestore.instance.collection('goals').document(user.uid).collection('userGoals').document(goal.id).delete().whenComplete(() {
    addGoalToDestination(goal: goal, destination: 'archive').then((goal) => archivedGoal = goal);
  });
  return archivedGoal;
}

Future<Goal> unarchiveGoal(Goal goal) async {
  Goal unarchivedGoal;
  await Firestore.instance.collection('goals').document(user.uid).collection('archive').document(goal.id).delete().whenComplete(() {
    addGoalToDestination(goal: goal, destination: 'userGoals').then((goal) => unarchivedGoal = goal);
  });
  return unarchivedGoal;
}

Future deleteGoal(Goal goal) {
  return Firestore.instance.collection('goals').document(user.uid).collection('archive').document(goal.id).delete();
}