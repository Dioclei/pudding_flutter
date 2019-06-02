import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:pudding_flutter/social/social.dart';
import 'package:pudding_flutter/goals/goals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pudding_flutter/auth/auth.dart';
import 'package:pudding_flutter/main.dart';
import 'package:pudding_flutter/goals/goalpage.dart';
import 'package:pudding_flutter/themecolors.dart';

/// There are a few types of cards that can appear in the dashboard
/// - Timetable (Next Event)
/// - Goals (Manage Goals)
/// - Invites: If there is only 1 invite, it will show the invite in full. If there is more than 1, it will say 'Manage invites'
/// - Friend Requests: Each friend request is a card.
/// It seems this is the best place to manage friend requests because it is quick.

AppBar dashboardAppBar(context) {
  return AppBar(
    title: Text("Dashboard"),
    elevation: .1,
  );
}

class DashboardFloatingActionButton extends StatelessWidget {
  final MyHomePageState parent;
  DashboardFloatingActionButton({@required this.parent});
  @override
  Widget build(BuildContext context) {
    final List<UnicornButton> childButtons = [
      UnicornButton(
          hasLabel: true,
          labelText: "Add Friend",
          labelBackgroundColor: Colors.transparent,
          labelHasShadow: false,
          labelColor: Colors.brown,
          currentButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: backgroundColor,
            mini: true,
            child: Icon(Icons.person_add, color: Colors.brown,),
            onPressed: () {
              parent.setState(() {
                parent.selectedIndex = 3;
                showSearch(context: context, delegate: SocialSearchDelegate());
              });
            },
          )
      ),
      UnicornButton(
          hasLabel: true,
          labelText: "Add Goal",
          labelBackgroundColor: Colors.transparent,
          labelHasShadow: false,
          labelColor: Colors.brown,
          currentButton: FloatingActionButton(
            heroTag: 'goals',
            backgroundColor: backgroundColor,
            mini: true,
            child: Icon(Icons.outlined_flag, color: Colors.brown,),
            onPressed: () {
              parent.setState(() {
                parent.selectedIndex = 2;
                addGoal(context);
              });
            },
          )
      ),
      UnicornButton(
          hasLabel: true,
          labelText: "Add Event",
          labelBackgroundColor: Colors.transparent,
          labelHasShadow: false,
          labelColor: Colors.brown,
          currentButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: backgroundColor,
            mini: true,
            child: Icon(Icons.event, color: Colors.brown,),
            onPressed: () {
              parent.setState(() {
                parent.selectedIndex = 1;
              });
            },
          )
      ),
    ];

    return UnicornDialer(
      backgroundColor: backgroundColor.withOpacity(0.9),
      parentButtonBackground: Colors.brown,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.add),
      childButtons: childButtons,
    );
  }
}

class Dashboard extends StatefulWidget {
  final MyHomePageState parent;
  Dashboard(this.parent);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          DashboardCard(
            title: 'Next Event',
            action: 'Next Lesson in 5min',
            colors: [Colors.blue[400], Colors.blue[700]],
            content: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Physics Lecture',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            'LT5',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '8:30 - 9:30',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          DashboardCard(
            title: 'Goals',
            action: 'Manage Goals',
            colors: [Colors.green[400], Colors.green[700]],
            onTap: () {
              print('Hello');
              widget.parent.setState(() {
                widget.parent.selectedIndex = 2;
              });
            },
            content: StreamBuilder(
                stream: Firestore.instance
                    .collection('goals')
                    .document(user.uid)
                    .collection('userGoals')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List goals = [];
                    goals = snapshot.data.documents.map((doc) {
                      return new Goal(
                        id: doc.documentID,
                        title: doc['title'],
                        color: Color(doc['colorValue']),
                        selectedPuddingIndex: doc['selectedPuddingIndex'],
                      );
                    }).toList();
                    return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: goals.length,
                        itemBuilder: (context, i) {
                          return Center(
                            child: GoalPostIt(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GoalPage(goal: goals[i]))),
                                goal: goals[i]),
                          );
                        },
                        separatorBuilder: (context, i) {
                          return Container(
                            width: 16.0,
                            color: Colors.transparent,
                          );
                        });
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                }),
          ),
          DashboardCard(
            title: 'New Invite',
            action: 'Accept/Decline',
            colors: [Colors.red[400], Colors.red[700]],
            content: Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('icons/dason.jpeg'),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
                      child: Text(
                        'Dason Yeo',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                        'Hey, just want to meet up for some homework and lunch. Are you free?',
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '12:00 - 13:00',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DashboardCard(
            title: 'New Friend Request',
            action: 'View Profile/Decline'
              ,
            height: 110,
            colors: [Colors.pink[400], Colors.pink[700]],
            onTap: () => print('go to friend req'),
            content: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('icons/dason.jpeg'),
                        fit: BoxFit.cover),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3.5, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0.5),
                        child: Text(
                          'Dason Yeo',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.5),
                        child: Text(
                          '2018.dason.yeo@ejc.edu.sg',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                OutlineButton(
                  child: Text('Accept', style: TextStyle(color: Colors.white),),
                  onPressed: () => print('accept'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ],
            )
          ),
          Container(
            height: 75,
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final Widget content;
  final List<Color> colors;
  final String title;
  final String action;
  final Function onTap;
  final double height;

  DashboardCard(
      {@required this.colors,
      @required this.title,
      @required this.action,
      @required this.content,
      this.onTap,
      this.height: 170,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 1.0)],
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: colors),
        ),
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: onTap,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            action,
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
                    child: content,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoalPostIt extends StatelessWidget {
  final Goal goal;
  final Function onTap;
  GoalPostIt({@required this.goal, @required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset.fromDirection(pi / 4, 1.0),
              )
            ],
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.pink[50],
          ),
          width: 100,
          height: 100,
          child: Material(
            borderRadius: BorderRadius.circular(15.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      child: Image(
                          image: AssetImage(
                              'icons/pudding${goal.selectedPuddingIndex}.png')),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                        child: Center(
                            child: Text(
                          goal.title,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.0, color: Colors.brown),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            height: 10,
            width: 10,
            decoration:
            BoxDecoration(color: goal.color, shape: BoxShape.circle),
          ),
        ),
      ],
    );
  }
}
