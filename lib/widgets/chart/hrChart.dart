import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:precision_hub/widgets/chart/hrData.dart';

class SubscriberChart extends StatefulWidget {
  final List<HeartRate> data;
  int lengthOfHrList;

  SubscriberChart({required this.data, required this.lengthOfHrList});

  @override
  State<SubscriberChart> createState() => _SubscriberChartState();
}

class _SubscriberChartState extends State<SubscriberChart> {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<HeartRate, String>> series = [
      charts.Series(
          id: "Heart Rate",
          data: widget.data,
          domainFn: (HeartRate series, _) => series.month,
          measureFn: (HeartRate series, _) => series.sugarLevel,
          colorFn: (HeartRate series, _) => series.barColor,
          labelAccessorFn: (HeartRate series, _) => '${series.sugarLevel}'),
    ];
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.95,
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
      child: Card(
        child: Container(
          decoration: const BoxDecoration(color: Color.fromARGB(255, 230, 246, 254)),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          child: Column(
            children: <Widget>[
              const Text(
                "Last 7 days of Heart Rate",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                  barRendererDecorator: charts.BarLabelDecorator<String>(),
                  domainAxis: const charts.OrdinalAxisSpec(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
