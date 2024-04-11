// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:fl_chart/fl_chart.dart';

class TimeSeriesChart extends StatefulWidget {
  const TimeSeriesChart({
    Key? key,
    this.width,
    this.height,
    required this.currdata,
    required this.voltdata,
    required this.isMonthly,
  }) : super(key: key);

  final double? width;
  final double? height;
  final dynamic currdata;
  final dynamic voltdata;

  final bool isMonthly;
  @override
  _TimeSeriesChartState createState() => _TimeSeriesChartState();
}

class _TimeSeriesChartState extends State<TimeSeriesChart> {
  @override
  Widget build(BuildContext context) {
    List<FlSpot> currspots = [];
    double maxY = 0;

    widget.currdata.forEach((k, v) => {
          v > maxY ? maxY = v : maxY = maxY,
          currspots.add(FlSpot(k.toDouble(), v.toDouble()))
        });
    List<FlSpot> voltspots = [];
    widget.voltdata.forEach((k, v) => {
          v > maxY ? maxY = v : maxY = maxY,
          voltspots.add(FlSpot(k.toDouble(), v.toDouble()))
        });

    return Container(
        child: Column(
      children: [
        Row(children: [
          Spacer(),
          Container(
            width: 10.0,
            height: 10.0,
            color: Colors.red,
          ),
          SizedBox(width: 3),
          Text('Current in amperes'),
          Spacer()
        ]),
        Row(children: [
          Spacer(),
          Container(width: 10.0, height: 10.0, color: Colors.green),
          SizedBox(width: 3),
          Text('Voltage in volts'),
          Spacer(),
        ]),
        Expanded(
            child: AspectRatio(
          aspectRatio: 2,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally:
                    true, // Set this to true to fit the tooltip inside horizontally
                fitInsideVertically: true,
              )),
              lineBarsData: [
                LineChartBarData(
                    spots: currspots,
                    isStrokeCapRound: true,
                    isCurved: true,
                    dotData: FlDotData(
                      show: true,
                    ),
                    color: Colors.red),
                LineChartBarData(
                    spots: voltspots,
                    isStrokeCapRound: true,
                    isCurved: true,
                    dotData: FlDotData(
                      show: true,
                    ),
                    color: Colors.green),
              ],

              borderData: FlBorderData(
                  border:
                      const Border(bottom: BorderSide(), left: BorderSide())),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) => Container(),
                    showTitles: true,
                    reservedSize: 10,
                  ),
                ),
                rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                        getTitlesWidget: (value, meta) => Container(),
                        showTitles: true,
                        reservedSize: 20)),
              ),
              maxY: maxY + 20,
              minY: 0, // Set the minimum y-axis value to 0
            ),
          ),
        ))
      ],
    ));
  }

  SideTitles get _bottomTitles {
    return SideTitles(
      showTitles: true,
      interval: widget.isMonthly ? 1 : 1, // Adjust interval based on isMonthly
      getTitlesWidget: (value, meta) {
        String text = '';
        if (widget.isMonthly) {
          // Map the value to the corresponding month
          switch (value.toInt()) {
            case 1:
              text = ' Jan';
              break;
            case 2:
              text = ' Feb';
              break;
            case 3:
              text = ' Mar';
              break;
            case 4:
              text = ' Apr';
              break;
            case 5:
              text = ' May';
              break;
            case 6:
              text = ' Jun';
              break;
            case 7:
              text = ' Jul';
              break;
            case 8:
              text = ' Aug';
              break;
            case 9:
              text = ' Sep';
              break;
            case 10:
              text = ' Oct';
              break;
            case 11:
              text = ' Nov';
              break;
            case 12:
              text = ' Dec';
              break;
          }
        } else {
          // Map the value to the corresponding day
          switch (value.toInt()) {
            case 1:
              text = ' Mon';
              break;
            case 2:
              text = ' Tue';
              break;
            case 3:
              text = ' Wed';
              break;
            case 4:
              text = ' Thu';
              break;
            case 5:
              text = ' Fri';
              break;
            case 6:
              text = ' Sat';
              break;
            case 7:
              text = ' Sun';
              break;
          }
        }
        return Text(text);
      },
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
