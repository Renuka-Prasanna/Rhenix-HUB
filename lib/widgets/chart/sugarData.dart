import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:precision_hub/widgets/chart/sugarChart.dart';

class BarChart extends StatefulWidget {
  final List<SugarLevel> data;
  int length;
  BarChart({Key? key, required this.data, required this.length}) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SubscriberChartDummy(
          data: widget.data,
          length: widget.length,
        ),
      ),
    );
  }
}

class SugarLevel {
  final String month;
  final int sugarLevel;
  final charts.Color barColor;

  SugarLevel({required this.month, required this.sugarLevel, required this.barColor});
}
