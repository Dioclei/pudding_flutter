import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:flutter/material.dart';
import 'timetable.dart';

void handleNewDate(date) {
  print("handleNewDate ${date}");}

class NewCalendar extends StatefulWidget {
  NewCalendar({Key key,}) : super(key: key);

  @override
  NewCalendarState createState() => NewCalendarState();
}


class NewCalendarState extends State<NewCalendar> {

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: new Calendar(
          onDateSelected: (date)
          {
          handleNewDate(date);
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Timetable()),
          );
          }
          
          ,

          isExpandable: true,
          //this is to build the mon, sat, sun, those things on top
          //dayBuilder: (BuildContext context, DateTime day) {
          //  return new InkWell(
            //  onTap: () => print("OnTap ${day}"),
            //this is to build the container to change the calendar shape into boxes, in this case, with white border
            //  child: new Container(
             //   decoration: new BoxDecoration(
              //      border: new Border.all(color: Colors.white)),
               //this is to add the dates inside the calendar boxes
               // child: new Text(
                 // day.day.toString(),
                //),
            //  ),
       //    );
        //  },
        )
    );
  }
}