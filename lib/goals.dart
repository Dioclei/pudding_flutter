import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';

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
            ? Icon(Icons.apps,)
            : Icon(Icons.list,),
        onPressed: () => print('Change layout'), //TODO: Change layout with stateful widget.
      ),
    ],
  );
}

FloatingActionButton goalsFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    child: Icon(Icons.library_add),
    elevation: 2.0,
    onPressed: () {
      print("Add goal!"); //TODO: Implement adding goals & archiving goals
    },
  );
}

class Goals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('goals').document(user.uid).snapshots(),
        builder: (context, snapshot) {
          switch (currentLayout) {
            case Layout.list:
              return ListView.builder(itemBuilder: null); //TODO: Implement ListView goals
            case Layout.grid:
              return GridView.builder(gridDelegate: null, itemBuilder: null) //TODO: Implement GridView goals
          }
        }
    );
  }
}

class Goal {
  String name;
  String desc;
  Color color;
  Duration timeSpent;

  Goal({
    @required this.name,
    this.desc: '',
    this.timeSpent: const Duration(seconds: 0),
    this.color: Colors.blue
  });
}

class GoalsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 100.0,
      ),
    );
  }
}