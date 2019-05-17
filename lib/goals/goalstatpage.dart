import 'package:pudding_flutter/goals/goals.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pudding_flutter/goals/barchart.dart';
import 'package:pudding_flutter/auth.dart';
import 'package:pudding_flutter/goals/dateparser.dart';

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
          WeekTab(goal: goal,),
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

class WeekTab extends StatefulWidget {
  final Goal goal;
  const WeekTab({
    Key key,
    @required this.goal,
  }) : super(key: key);

  @override
  _WeekTabState createState() => _WeekTabState();
}

class _WeekTabState extends State<WeekTab> {

  String currentWeekIdentifier;

  @override
  void initState() {
    currentWeekIdentifier = '${getWeekYear(DateTime.now().toUtc())}-${getWeekOfYear(DateTime.now().toUtc())}';
    /*
    final cRef = Firestore.instance.collection('goals').document(user.uid).collection('userGoals').document(widget.goal.id).collection('events');
    cRef.add({'completedDate': DateTime.now().toIso8601String(), 'durationInMinutes': 32});
    cRef.add({'completedDate': DateTime(2019, 5, 7).toIso8601String(), 'durationInMinutes': 16});
    cRef.add({'completedDate': DateTime(2019, 5, 8).toIso8601String(), 'durationInMinutes': 12});
    cRef.add({'completedDate': DateTime(2019, 5, 9).toIso8601String(), 'durationInMinutes': 44});
    cRef.add({'completedDate': DateTime(2019, 5, 10).toIso8601String(), 'durationInMinutes': 34});
    cRef.add({'completedDate': DateTime(2019, 5, 11).toIso8601String(), 'durationInMinutes': 55});
    cRef.add({'completedDate': DateTime(2019, 5, 12).toIso8601String(), 'durationInMinutes': 11});
    cRef.add({'completedDate': DateTime(2019, 5, 13).toIso8601String(), 'durationInMinutes': 23});
    cRef.add({'completedDate': DateTime(2019, 5, 14).toIso8601String(), 'durationInMinutes': 123});
    cRef.add({'completedDate': DateTime(2019, 5, 15).toIso8601String(), 'durationInMinutes': 45});
    cRef.add({'completedDate': DateTime(2019, 5, 16).toIso8601String(), 'durationInMinutes': 12});
    cRef.add({'completedDate': DateTime(2019, 5, 17).toIso8601String(), 'durationInMinutes': 16});
    cRef.add({'completedDate': DateTime(2019, 5, 18).toIso8601String(), 'durationInMinutes': 32});
    cRef.add({'completedDate': DateTime(2019, 5, 19).toIso8601String(), 'durationInMinutes': 42});
    cRef.add({'completedDate': DateTime(2019, 5, 20).toIso8601String(), 'durationInMinutes': 60});
    cRef.add({'completedDate': DateTime(2019, 5, 21).toIso8601String(), 'durationInMinutes': 18});
    cRef.add({'completedDate': DateTime(2019, 5, 22).toIso8601String(), 'durationInMinutes': 19});*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String displayedWeekNumber = currentWeekIdentifier.split('-')[1];//;
    String displayedYearNumber = currentWeekIdentifier.split('-')[0];//;
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.chevron_left, color: Colors.white,), onPressed: () => setState(() => currentWeekIdentifier = decrementWeekIdentifier(currentWeekIdentifier)),),
            Text('Week $displayedWeekNumber of Year $displayedYearNumber', style: TextStyle(color: Colors.white),),
            IconButton(icon: Icon(Icons.chevron_right, color: Colors.white,), onPressed: () => setState(() => currentWeekIdentifier = incrementWeekIdentifier(currentWeekIdentifier)),),
          ],
        ),
        StreamBuilder(
            stream: Firestore.instance.collection('goals').document(user.uid).collection('userGoals').document(widget.goal.id).collection('events').snapshots(),
            builder: (context, snapshot) {
              Map<String, Map<DateTime, int>> dataMap = {};
              if (snapshot.hasData) {
                snapshot.data.documents.map((doc) {
                  final DateTime date = DateTime.parse(doc['completedDate']);
                  final DateTime completedDate = DateTime(date.year, date.month, date.day); //clean up the date (no time data)
                  final String weekIdentifier = getYearWeekString(completedDate); //String looks like this: YYYY-(INT)
                  if (dataMap[weekIdentifier] == null) //checks whether there is any date data inside that specific week
                    dataMap[weekIdentifier] = {completedDate: doc['durationInMinutes']};
                  else if (dataMap[weekIdentifier][completedDate] == null) { //checks whether the actual date itself has any data
                    dataMap[weekIdentifier][completedDate] = doc['durationInMinutes'];
                  } else
                    dataMap[weekIdentifier][completedDate] += doc['durationInMinutes'];
                }).toList();
                print(dataMap);
                if (dataMap[currentWeekIdentifier] != null) {
                  List weekData = [0, 0, 0, 0, 0, 0, 0,];
                  dataMap[currentWeekIdentifier].keys.forEach((DateTime date) {
                    weekData[date.weekday - 1] = dataMap[currentWeekIdentifier][date];
                  });
                  return Expanded(
                    child: WeekChart(
                      mon: weekData[0],
                      tue: weekData[1],
                      wed: weekData[2],
                      thu: weekData[3],
                      fri: weekData[4],
                      sat: weekData[5],
                      sun: weekData[6],
                    ),
                  );
                } else return Expanded(
                  child: WeekChart(), //empty bar chart
                );
              } else return Center(child: CircularProgressIndicator());
            }
        ),
      ],
    );
  }
}

String incrementWeekIdentifier(String weekIdentifier) {
  ///splices the weekIdentifier & increases week number.
  int newWeekNumber = int.parse(weekIdentifier.split('-')[1]);
  int newYearNumber = int.parse(weekIdentifier.split('-')[0]);
  newWeekNumber += 1;
  if (newWeekNumber > 52) {
    newWeekNumber = 1;
    newYearNumber += 1;
  }
  return '${newYearNumber.toString()}-${newWeekNumber.toString()}';
}

String decrementWeekIdentifier(String weekIdentifier) {
  ///splices the weekIdentifier & increases week number.
  int newWeekNumber = int.parse(weekIdentifier.split('-')[1]);
  int newYearNumber = int.parse(weekIdentifier.split('-')[0]);
  newWeekNumber -= 1;
  if (newWeekNumber < 1) {
    newWeekNumber = 52;
    newYearNumber -= 1;
  }
  return '${newYearNumber.toString()}-${newWeekNumber.toString()}';
}