import 'package:flutter/material.dart';
import 'themecolors.dart';
import 'dart:async';
import 'goals.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flushbar/flushbar.dart';

/// This page shows a focus timer where the user can set a timer to focus on their work.
/// TODO OVERALL:
/// 1. Running in background when screen is switched off
/// 2. Decide whether the timer should be cancelled when the user gets out of that specific screen. Probably?
/// 3. Decide on exactly what we are doing with the timing data. Is there a need to add the timestamps to database?
/// 4. Appearances: Animated pudding showing time spent.
/// 5. Stats: Bar charts

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
  Timer _timer;

  @override
  void initState() {
    _displayedDuration = _initialDuration;
    super.initState();
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
                    //TODO: DISCUSS: Should timer be cancelled? If not run in background is quite hard...
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
        backgroundColor: widget.goal.color,
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
                    content: Center(child:
                    Text('Are you sure you want to delete this goal?')
                    ),
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
                child: Container(
                  // TODO: APPEARANCE: Add a pudding indicator of time spent
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
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
                            // TODO: RESEARCH: Will this still run if the screen is turned off?
                            setState(() {
                              if (_displayedDuration > const Duration(seconds: 0))
                                _displayedDuration = _displayedDuration - Duration(seconds: 1);
                                // TODO: Callback when timer finishes: Add (timestamp & duration) to database, add to timetable? make a ding sound, etc.
                              else {
                                timer.cancel();
                                _buttonText = 'Start';
                                _displayedDuration = _initialDuration;
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
                                        // TODO: terminate goal. DISCUSS: do we still add timestamp to database?
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
              Tab(
                child: Text('Day'),
              ),
              Tab(child: Text('Week')),
              Tab(child: Text('Month')),
            ],
          ),
        ),
        body: TabBarView(children: [
          // TODO: Add Bar charts for day, week, and month view.
          Text('Day'),
          Text('Week'),
          Text('Month'),
        ]),
      ),
    );
  }
}
