import 'package:flutter/material.dart';

AppBar timetableAppBar(BuildContext context) {
  return AppBar(
    title: Text('put selected date here'),
  );
}

class Timetable extends StatelessWidget {

  /* The _card function is to generate individual card widgets for the list
  * view without overcrowding the ListView with repetitive code*/
  Widget _card(context,label){
    return new Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(label),
          Container(
            height: 30,
            width: 2,
            color: Colors.grey[400],
          ),
          RaisedButton(
            onPressed: (){},
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text('+ Add Event')
            ),
          ),
        ],
      ),
    );
  }

  /* Building a new page for timetable: */
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('SELECTED DATE HERE'),
      ),
      body: Center(
        child:
          ListView(
            children: [
              _card(context, '0000-0100'),
              _card(context, '0100-0200'),
              _card(context, '0200-0300'),
              _card(context, '0300-0400'),
              _card(context, '0400-0500'),
              _card(context, '0500-0600'),
              _card(context, '0600-0700'),
              _card(context, '0700-0800'),
              _card(context, '0800-0900'),
              _card(context, '0900-1000'),
              _card(context, '1000-1100'),
              _card(context, '1100-1200'),
              _card(context, '1200-1300'),
              _card(context, '1300-1400'),
              _card(context, '1400-1500'),
              _card(context, '1500-1600'),
              _card(context, '1600-1700'),
              _card(context, '1700-1800'),
              _card(context, '1800-1900'),
              _card(context, '1900-2000'),
              _card(context, '2000-2100'),
              _card(context, '2100-2200'),
              _card(context, '2200-2300'),
              _card(context, '2300-0000'),],),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: Icon(Icons.add_alarm),
        backgroundColor: Colors.brown[600],
      ),
    );
  }
}