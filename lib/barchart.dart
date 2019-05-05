import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

//TODO: not impt: DayChart

class MonthChart extends StatelessWidget {
  /// Returns a Chart with 28 - 31 day values.
  /// Pass in a list with minutes for each day in their respective indexes.
  final List<int> data;
  const MonthChart({@required this.data,});
  @override
  Widget build(BuildContext context) {
    List<MinutesPerDay> monthData = [];
    for (var i = 0; i < data.length; i++) {
      monthData.add(MinutesPerDay((i+1).toString(), data[i], Colors.green));
    }
    return Chart(data: monthData,);
  }
}

class WeekChart extends StatelessWidget {
  /// Return a Chart with 7 values for each day in a week.
  final int mon;
  final int tue;
  final int wed;
  final int thu;
  final int fri;
  final int sat;
  final int sun;
  const WeekChart({this.mon: 0, this.tue: 0, this.wed: 0, this.thu: 0, this.fri: 0, this.sat: 0, this.sun: 0,});
  @override
  Widget build(BuildContext context) {
    List<MinutesPerDay> data = [
      MinutesPerDay('Mon', mon, Colors.green),
      MinutesPerDay('Tue', tue, Colors.green),
      MinutesPerDay('Wed', wed, Colors.green),
      MinutesPerDay('Thu', thu, Colors.green),
      MinutesPerDay('Fri', fri, Colors.green),
      MinutesPerDay('Sat', sat, Colors.green),
      MinutesPerDay('Sun', sun, Colors.green),
    ];
    return Chart(data: data,);
  }
}


class Chart extends StatelessWidget {
  /// Returns a Bar Chart with the values from Monday to Sunday.
  final List<MinutesPerDay> data;
  const Chart({@required this.data});
  @override
  Widget build(BuildContext context) {
    var series = [
      new charts.Series(
        domainFn: (MinutesPerDay minuteData, _) => minuteData.day,
        measureFn: (MinutesPerDay minuteData, _) => minuteData.minutes,
        colorFn: (MinutesPerDay minuteData, _) => minuteData.color,
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