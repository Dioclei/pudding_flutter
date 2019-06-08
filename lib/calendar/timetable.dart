import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event_creator.dart';

AppBar timetableAppBar(BuildContext context) {
  return AppBar(
    title: Text('put selected date here '),
  );
}

class VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 30.0,
      width: 1.0,
      color: Colors.black38,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}

class ParentWidget extends StatefulWidget {
  ParentWidget({
    Key key,
    @required this.today,
  }) : super(key: key);
  DateTime today;
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;
  bool _taps = false;
  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  void _handleTaps(bool newValue) {
    setState(() {
      _taps = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Timetable(
        ontaps: _handleTaps,
        taps: _taps,
        tooday: widget.today,
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}

class Timetable extends StatelessWidget {
  final bool active;
  final ValueChanged<bool> onChanged;
  final bool taps;
  final ValueChanged<bool> ontaps;
  Timetable(
      {Key key,
        this.active: false,
        this.taps: false,
        @required this.tooday,
        this.onChanged,
        this.ontaps})
      : super(key: key);
  DateTime tooday;
  /* The _card function is to generate individual card widgets for the list
  * view without overcrowding the ListView with repetitive code*/
  void _handleTap() {
    onChanged(!active);
  }

  void _handleSecondTap() {
    ontaps(!taps);
  }

  Widget _card(context, label) {
    return new Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          // Expanded(child: Text(label), ),
          //Expanded(child:Container(
          //height: 30,
          //width: 2,
          //color: Colors.grey[400],
          //),),
          Expanded(
            child: Material(
              color: Colors.grey[400],
              child: InkWell(
                onTap: () {
                  if (taps == true) {
                    _handleTap();
                    //_handleSecondTap(); somewhere somehow _handleSecondTap() needs to be false after u tap
                    print("HIYA");
                    //replace this with push to the add event page
                  } else {
                    _handleTap();
                    _handleSecondTap();
                  }
                },
                onDoubleTap: () {},

                //textColor: Colors.white,
                //padding: const EdgeInsets.all(0.0),

                /*
                  TODO: Forcefully merged this part. Not sure if still needed.
                  RaisedButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventCreator())
                    );
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                 */

                child: Container(
                  //width: 200,

                  decoration: BoxDecoration(
                      color: active ? Colors.blue : Colors.grey[400]
                    //if u want to gradient it I guess...
                    //  gradient: LinearGradient(

                    // colors: active ? <Color>[
                    // Color(0xFF0D47A1),
                    //Color(0xFF1976D2),
                    //Color(0xFF42A5F5),
                    //] : <Color>[
                    //      Colors.grey[600],
                    //      Color(0xFFBDBDBD),
                    //    ],
                    // ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    active ? '+Add Event' : '',
                    style: active
                        ? TextStyle(color: Colors.white)
                        : TextStyle(color: Colors.grey[400]),
                  ),
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* Building a new page for timetable: */
  @override
  Widget build(BuildContext context) {
    //this is the format for formatting date and getting 2015-12-01 - currenthour : currentminute
    //String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(today);
    String formattedDate = DateFormat('dd-MM-yyyy').format(tooday);
    return Container(
      child: ListView.separated(
        itemCount: 24,
        itemBuilder: (context, i) {
          return _card(context, '${i.toString().padLeft(2, '0')}:00-${(i+1).toString().padLeft(2, '0')}:00   ');
        },
        separatorBuilder: (context, i) {
          return Divider();
        },
      ),
    );
  }
}


