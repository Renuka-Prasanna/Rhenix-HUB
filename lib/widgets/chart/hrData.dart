import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:precision_hub/widgets/chart/hrChart.dart';

class HRChart extends StatefulWidget {
  final List<HeartRate> data;
  int lengthOfHrList;

  HRChart({Key? key, required this.data, required this.lengthOfHrList}) : super(key: key);

  @override
  State<HRChart> createState() => _HRChartState();
}

class _HRChartState extends State<HRChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SubscriberChart(
          data: widget.data,
          lengthOfHrList: widget.lengthOfHrList,
        ),
      ),
    );
  }
}

class HeartRate {
  final String month;
  final int sugarLevel;
  final charts.Color barColor;

  HeartRate({required this.month, required this.sugarLevel, required this.barColor});
}
