import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pudding_flutter/auth.dart';
import 'package:pudding_flutter/goals/goals.dart';
import 'package:flushbar/flushbar.dart';
import 'package:pudding_flutter/themecolors.dart';

class GoalArchivePage extends StatefulWidget {
  @override
  _GoalArchivePageState createState() => _GoalArchivePageState();
}

class _GoalArchivePageState extends State<GoalArchivePage> {
  @override
  Widget build(BuildContext context) {
    final BuildContext overallContext = context;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Archive'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('goals').document(user.uid).collection('archive').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Goal> goals = [];
            snapshot.data.documents.map((doc) {
              goals.add(new Goal(
                id: doc.documentID,
                color: Color(doc['colorValue']),
                selectedPuddingIndex: doc['selectedPuddingIndex'],
                title: doc['title'],
              ));
            }).toList();
            if (goals.length == 0) {
              return Center(
                child: Text('No archived goals.'),
              );
            } else return ListView.builder(
              itemCount: goals.length,
                itemBuilder: (context, i) {
                return Dismissible(
                  key: Key(goals[i].id),
                  child: GoalsCard(
                    goal: goals[i],
                    onTap: null,
                  ),
                  direction: DismissDirection.horizontal,
                  background:  Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: Icon(Icons.delete_forever,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Delete', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.green[800],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Unarchive', style: TextStyle(color: Colors.white),),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          child: Icon(Icons.unarchive,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  confirmDismiss: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      return showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
                              title: Text('Unarchive Goal'),
                              content: Text('Are you sure you want to archive this goal ${goals[i].title}?'),
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
                    } else if (direction == DismissDirection.startToEnd) {
                      return showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
                              title: Text('Delete Goal'),
                              content: Text('This goal ${goals[i].title} will be deleted forever! This cannot be undone. Are you sure?'),
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
                    }
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      unarchiveGoal(goals[i]).whenComplete(() {
                        setState(() {
                          Flushbar(
                            message: '${goals[i].title} goal successfully archived!',
                            mainButton: FlatButton(
                              child: Text('Undo', style: TextStyle(color: Colors.white),),
                              onPressed: () => archiveGoal(goals[i]).whenComplete(() {
                                setState(() {});
                              }),
                            ),
                            duration: Duration(seconds: 3),
                          ).show(overallContext);
                        });
                      });
                    } else if (direction == DismissDirection.startToEnd) {
                      deleteGoal(goals[i]).whenComplete(() {
                        setState(() {
                          Flushbar(
                            message: '${goals[i].title} goal deleted!',
                            backgroundColor: Colors.red[700],
                            duration: Duration(seconds: 3),
                          ).show(overallContext);
                        });
                      });
                    }
                  },
                );
            });
          } else return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}