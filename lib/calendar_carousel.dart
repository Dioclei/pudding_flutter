import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:flutter/material.dart';
import 'timetable.dart';
import 'package:intl/intl.dart';

void handleNewDate(date, trial, taps) {

  print("handleNewDate ${date}");}

class Today {
  final DateTime getdate;

  //final String description;
//if u wanna add 2 ver of ur var
 // Today(this.getdate, this.description);
  Today(this.getdate);
}

class NewCalendar extends StatefulWidget {
  @override
  NewCalendarState createState() => NewCalendarState();
}


class NewCalendarState extends State<NewCalendar> {
  bool _taps = false;
 // bool _active = false;
  //void _handleTapboxChanged(bool newValue) {
    //setState(() {
      //_active = newValue;
    //});
  //}
  void _handleTaps(bool newValue) {
   setState(() {
     _taps = newValue;
   });
  }


  @override
  Widget build(BuildContext context) {

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child:
        buildcalendar(
         taps: _taps,
          //active: _active,
          //onChanged: _handleTapboxChanged,
         ontaps: _handleTaps,
        ),
    );
  }
}

class buildcalendar extends StatelessWidget {
  //final bool active;
  //final ValueChanged<bool> onChanged;
  final bool taps;
  final ValueChanged<bool> ontaps;

  buildcalendar(
      {Key key, this.taps : false, this.ontaps})
      : super(key: key);
  /* The _card function is to generate individual card widgets for the list
  * view without overcrowding the ListView with repetitive code*/
  //void _handleTap() {
    //onChanged(!active);
  //}
  void _handlesecondTap() {
    ontaps(!taps);
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: new Calendar(

          onDateSelected: (date)
          { DateTime pastdate ;
          bool trial = false;
            String formattedpastDate = '0';
            //makes it so that it's only the second tap which will open the timetable, intended anyways,
          //in reality it really did mean it's second tap open timetable, i can't seem to make it so that it's the second tap on the same date
              if (taps == true) {
                  _handlesecondTap();
                  String formattedtodate = DateFormat('dd-MM-yyyy').format(date);
                  if (formattedpastDate == formattedtodate){
                   Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => ParentWidget(today: date)),
                   );
              }
              }
              else {
                pastdate=date;
                formattedpastDate = DateFormat('dd-MM-yyyy').format(pastdate);
                handleNewDate(formattedpastDate, trial, taps);
                _handlesecondTap();

              }
          },

          isExpandable: true,
          //this is to build the mon, sat, sun, those things on top
         // dayBuilder: (BuildContext context, DateTime day) {
          //  return new
            //InkWell(
             // onTap: () {},
              //this is to build the container to change the calendar shape into boxes, in this case, with white border
             // child:
            //  InkWell(
              //  onTap: (){
              //    if(taps==true){Navigator.push(
              //      context,

              //      MaterialPageRoute(builder: (context) => ParentWidget(today: day)),
             //     );}
            //      _handleTap();
            //    },
              //  child : Container(
               //   decoration: new BoxDecoration(
                    //  borderRadius: new BorderRadius.circular(100.0) ,
                    //  border: active ? new Border.all(color: Colors.brown) :new Border.all(color: Colors.yellow[100]) ),
                  //this is to add the dates inside the calendar boxes
                //  child: new Center(
                   // child: Text(
                   //   day.day.toString(),
                 //     style: TextStyle(fontSize: 16),
                //    ),),
              //  ),
                 //gesture detector
            //  ) ,
          //  );
         // },
        )
    );
  }
}