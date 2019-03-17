import 'package:flutter/material.dart';


class Social extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                color: Colors.red,
                width: 50,
                height: 50,
                child: Icon(Icons.face),
              )
            ],
          ),
          Column(
            children: <Widget>[

            ],
          )
        ],
      ),
    );
  }
}