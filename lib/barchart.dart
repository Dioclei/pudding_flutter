import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = [
      MinutesPerDay('Mon', 12, Colors.red),
      MinutesPerDay('Tue', 55, Colors.yellow),
      MinutesPerDay('Wed', 100, Colors.green),
      MinutesPerDay('Thu', 200, Colors.green),
      MinutesPerDay('Fri', 200, Colors.green),
      MinutesPerDay('Sat', 200, Colors.green),
      MinutesPerDay('Sun', 200, Colors.green),
    ];

    var series = [
      new charts.Series(
        domainFn: (MinutesPerDay minuteData, _) => minuteData.day,
        measureFn: (MinutesPerDay clickData, _) => clickData.minutes,
        colorFn: (MinutesPerDay clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    return charts.BarChart(
      series,
      animate: true,
    );
  }
}

class MinutesPerDay {
  final String day;
  final int minutes;
  final charts.Color color;

  MinutesPerDay(this.day, this.minutes, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}