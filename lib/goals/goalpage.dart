import 'package:flutter/material.dart';
import 'package:pudding_flutter/themecolors.dart';
import 'dart:async';
import 'package:pudding_flutter/goals/goals.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pudding_flutter/auth/auth.dart';
import 'package:pudding_flutter/goals/goalstatpage.dart';

/// This page shows a focus timer where the user can set a timer to focus on their work.

/// When timer completes, add datetime.toiso8601string & duration to database.
/// Stats will grab the datatime & duration & display it.

class GoalPage extends StatefulWidget {
  final Goal goal;

  GoalPage({@required this.goal});

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  String _buttonText = 'Start';
  Duration _initialDuration = Duration(minutes: 25); /// Duration set at first.
  Duration _displayedDuration;
  Timer _timer; //instantiate a timer.

  @override
  void initState() {
    _displayedDuration = _initialDuration;
    _timer = Timer(Duration.zero, () {});
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    print('disposed timer!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    exit() {
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: BackButtonIcon(), onPressed: () {
          if (_timer != null)
            if (_timer.isActive){
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    content: Text('Are you sure you want to leave? This will forfeit your current progress!'),
                    //TODO: Callback if timer is forfeited.
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          _timer.cancel();
                          _displayedDuration = _initialDuration;
                          Navigator.pop(context);
                          exit();
                        },
                        child: Text('Yes'),
                      ),
                      FlatButton(
                        child: Text('No'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
                }
            );
          } else Navigator.pop(context);
            else Navigator.pop(context);

        }),
        backgroundColor: Colors.brown,
        title: Text(widget.goal.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.timeline),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GoalStatPage(
                          goal: widget.goal,
                        ))),
          ),
          IconButton(
            icon: Icon(Icons.archive),
            onPressed: () => showDialog(
                context: context,
              builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    title: Text('Archive Goal'),
                    content: Text('Are you sure you want to delete this goal?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          archiveGoal(widget.goal).whenComplete(() {
                            Navigator.pop(context);
                            exit();
                            Flushbar(
                              message: 'Goal successfully archived!',
                              icon: Icon(Icons.archive),
                              duration: Duration(seconds: 3),
                            ).show(context);
                          });
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  );
              }
            )
          )

        ],
      ),
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Let's get going!",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Image(
                  image: AssetImage(
                    'icons/pudding${widget.goal.selectedPuddingIndex}.png',
                    //TODO: Animate Pudding
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (_timer.isActive)
                      print('timer is active!');
                    else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                              ),
                              title: Text('Set Duration'),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  NumberPicker.integer(
                                      initialValue: _displayedDuration.inMinutes,
                                      minValue: 5,
                                      maxValue: 120,
                                      onChanged: (num) {
                                        print(num);
                                        setState(() {
                                          _initialDuration = Duration(minutes: num);
                                          _displayedDuration = _initialDuration;
                                        });
                                      }),
                                  Text('minutes', style: TextStyle(fontWeight: FontWeight.bold),),
                                ],
                              ),
                            );
                          });
                    }
                  },
                  child: Text(
                    '${_displayedDuration.inMinutes}:${_displayedDuration.toString().substring(5, 7)}',
                    style: TextStyle(fontSize: 36.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () => setState(() {
                        if (_buttonText == 'Start') {
                          _buttonText = 'Give up';
                          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                            setState(() {
                              if (_displayedDuration > const Duration(seconds: 0)) {
                                _displayedDuration = _displayedDuration - Duration(seconds: 1);
                                print(_displayedDuration.inSeconds);
                              }
                              else {
                                /// Callback when timer finishes.
                                timer.cancel();
                                _buttonText = 'Start';
                                _displayedDuration = _initialDuration;
                                Firestore.instance.collection('goals').document(user.uid).collection('userGoals').document(widget.goal.id).collection('events')
                                    .add({
                                      'durationInMinutes': _initialDuration.inMinutes,
                                      'dateCompleted': DateTime.now().toIso8601String(),
                                    });
                              }
                            });
                          });
                        } else if (_buttonText == 'Give up') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0))),
                                  content: Text(
                                    'Are you sure you want to give up?',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Yes'),
                                      onPressed: () {
                                        _timer.cancel();
                                        _displayedDuration = _initialDuration;
                                        setState(() => _buttonText = 'Start');
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      }),
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  ),
                  color: widget.goal.color,
                  child: Text(
                    _buttonText,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
