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
    return Scaffold(
      appBar: AppBar(
        title: Text('${formattedDate}'),
      ),
      body: Container(
        child: ListView(
          children: [
            _card(context, '00:00-01:00   '),
            Divider(),
            _card(context, '01:00-02:00   '),
            Divider(),
            _card(context, '02:00-03:00   '),
            Divider(),
            _card(context, '03:00-04:00   '),
            Divider(),
            _card(context, '04:00-05:00   '),
            Divider(),
            _card(context, '05:00-06:00   '),
            Divider(),
            _card(context, '06:00-07:00   '),
            Divider(),
            _card(context, '07:00-08:00   '),
            Divider(),
            _card(context, '08:00-09:00   '),
            Divider(),
            _card(context, '09:00-10:00   '),
            Divider(),
            _card(context, '10:00-11:00   '),
            Divider(),
            _card(context, '11:00-12:00   '),
            Divider(),
            _card(context, '12:00-13:00   '),
            Divider(),
            _card(context, '13:00-14:00   '),
            Divider(),
            _card(context, '14:00-15:00   '),
            Divider(),
            _card(context, '15:00-16:00   '),
            Divider(),
            _card(context, '16:00-17:00   '),
            Divider(),
            _card(context, '17:00-18:00   '),
            Divider(),
            _card(context, '18:00-19:00   '),
            Divider(),
            _card(context, '19:00-20:00   '),
            Divider(),
            _card(context, '20:00-21:00   '),
            Divider(),
            _card(context, '21:00-22:00   '),
            Divider(),
            _card(context, '22:00-23:00   '),
            Divider(),
            _card(context, '23:00-00:00   '),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_alarm),
        backgroundColor: Colors.brown[600],
      ),
      backgroundColor: Colors.yellow[100],
    );
  }
}
