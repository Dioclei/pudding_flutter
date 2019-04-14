import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'goals.dart';

class GoalCreationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoalCreationPageState();
}

class _GoalCreationPageState extends State<GoalCreationPage> {
  String title = '';
  Color selectedColor = Colors.lightBlue;

  /// For Title Field Validation
  final _titleController = TextEditingController();
  bool _titleValidate = false;

  /// Stages:
  /// 0 - Title field & visual indication of color selected.
  /// 1 - Color selection (if the color picker is pressed)
  /// 2 - Pudding Selection
  int stage;

  @override
  void initState() {
    super.initState();
    stage = 0;
  }

  @override
  Widget build(BuildContext context) {
    ///Color picker buttons
    List<Widget> colorButtons = [
      circleButton(
          color: Colors.redAccent,
          onPressed: () => setState(() {
            selectedColor = Colors.redAccent;
            stage = 0;
          })),
      circleButton(
          color: Colors.red,
          onPressed: () => setState(() {
            selectedColor = Colors.red;
            stage = 0;
          })),
      circleButton(
          color: Colors.blueAccent,
          onPressed: () => setState(() {
            selectedColor = Colors.blueAccent;
            stage = 0;
          })),
      circleButton(
          color: Colors.blue,
          onPressed: () => setState(() {
            selectedColor = Colors.blue;
            stage = 0;
          })),
      circleButton(
          color: Colors.lightBlue,
          onPressed: () => setState(() {
            selectedColor = Colors.lightBlue;
            stage = 0;
          })),
      circleButton(
          color: Colors.lightBlueAccent,
          onPressed: () => setState(() {
            selectedColor = Colors.lightBlueAccent;
            stage = 0;
          })),
      circleButton(
          color: Colors.greenAccent,
          onPressed: () => setState(() {
            selectedColor = Colors.greenAccent;
            stage = 0;
          })),
      circleButton(
          color: Colors.green,
          onPressed: () => setState(() {
            selectedColor = Colors.green;
            stage = 0;
          })),
      circleButton(
          color: Colors.lightGreen,
          onPressed: () => setState(() {
            selectedColor = Colors.lightGreen;
            stage = 0;
          })),
      circleButton(
          color: Colors.lightGreenAccent,
          onPressed: () => setState(() {
            selectedColor = Colors.lightGreenAccent;
            stage = 0;
          })),
    ];

    List<Widget> contentStages = [
      /// Stage 0 - Title Field
      Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Title',
                  errorText: _titleValidate ? 'Title cannot be empty' : null,
                ),
                controller: _titleController,
                onChanged: (input) {
                  title = _titleController.text;
                },
              ),
            ),
            Container(
              width: 60.0,
              child: circleButton(
                  color: selectedColor,
                  onPressed: () => setState(() {
                        stage = 1;
                      })),
            )
          ],
        ),
      ),

      /// Stage 1 - Color Picker
      Container(
        width: 200.0,
        height: 200.0,
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          children: colorButtons,
        ),
      ),

      /// Stage 2 - Pudding Picker
      Container(
        height: 200,
          child: PuddingPicker()
      ),
    ];

    List<List<Widget>> actionStages = [
      /// Stage 0 - Title Field
      [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              if (_titleController.text.trim().isEmpty)
                _titleValidate = true;
              else {
                _titleValidate = false;
                stage = 2;
              }
            });
          },
          child: Text('Next'),
        ),
      ],

      /// Stage 1 - Color Picker
      [
        FlatButton(
          onPressed: () => setState(() {
                stage = 0;
              }),
          child: Text('Back'),
        ),
      ],

      /// Stage 2 - Pudding Picker
      [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        FlatButton(
          onPressed: () => setState(() {stage = 0;}),
          child: Text('Back'),
        ),
        FlatButton(
          onPressed: () {
            Goal goal = new Goal(
              title: title,
              color: selectedColor,
              timeSpent: Duration(days: 0),
              selectedPuddingIndex: selectedPuddingIndex,
            );
            Firestore.instance
                .collection('goals')
                .document(user.uid)
                .collection('userGoals')
                .add({
              'title': goal.title,
              'colorValue': goal.color.value,
              'timeSpent': goal.timeSpent.toString(),
              'selectedPuddingIndex': goal.selectedPuddingIndex,
            });
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    ];

    List<Text> textStages = [
      Text('Create Goal'),
      Text('Pick a Color'),
      Text('Pick a Pudding'),
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: textStages[stage],
      content: contentStages[stage],
      actions: actionStages[stage],
    );
  }
}

RawMaterialButton circleButton({Color color, Function onPressed}) {
  return RawMaterialButton(
    onPressed: onPressed,
    shape: CircleBorder(),
    elevation: 4.0,
    fillColor: color,
  );
}

int selectedPuddingIndex = 0;

class PuddingPicker extends StatefulWidget {
  @override
  _PuddingPickerState createState() => _PuddingPickerState();
}

class _PuddingPickerState extends State<PuddingPicker> {
  int selectedIndex;
  List<bool> selected = [false, false, false, false];

  @override
  void initState() {
    select(selectedPuddingIndex);
    // remembers previously selected index even if you go back.
    // Also remembers even if you close the dialog.
    // Unintended but it's a bug feature!
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2.0, mainAxisSpacing: 2.0),
      children: <Widget>[
        PuddingButton(onTap: () => setState(() {
          select(0);
        }), assetImage: AssetImage('icons/default_pudding.png'), selected: selected[0],),
        PuddingButton(onTap: () => setState(() {
          select(1);
        }), assetImage: AssetImage('icons/default_pudding.png'), selected: selected[1],),
        PuddingButton(onTap: () => setState(() {
          select(2);
        }), assetImage: AssetImage('icons/default_pudding.png'), selected: selected[2],),
        PuddingButton(onTap: () => setState(() {
          select(3);
        }), assetImage: AssetImage('icons/default_pudding.png'), selected: selected[3],),
      ],
    );
  }

  void select(int index) {
    selected = [false, false, false, false];
    selected[index] = true;
    selectedPuddingIndex = index;
  }
}

class PuddingButton extends StatelessWidget {
  final Function onTap;
  final AssetImage assetImage;
  final bool selected;

  PuddingButton({@required this.onTap, @required this.assetImage, @required this.selected});

  @override
  Widget build(BuildContext context) {
    return (selected) ? Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: Container(
            child: Image(
              image: assetImage,
            ),
          ),
        ),
        Icon(Icons.check, color: Colors.black,)
      ],
    ) : GestureDetector(
      onTap: onTap,
      child: Container(
        child: Image(
          image: assetImage,
        ),
      ),
    );
  }
}