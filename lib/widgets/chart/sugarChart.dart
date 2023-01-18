import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:precision_hub/widgets/chart/sugarData.dart';

class SubscriberChartDummy extends StatefulWidget {
  final List<SugarLevel> data;
  int length;

  SubscriberChartDummy({Key? key, required this.data, required this.length}) : super(key: key);

  @override
  State<SubscriberChartDummy> createState() => _SubscriberChartDummyState();
}

class _SubscriberChartDummyState extends State<SubscriberChartDummy> {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<SugarLevel, String>> series = [
      charts.Series(
          id: "Sugar Level",
          data: widget.data,
          domainFn: (SugarLevel series, _) => series.month,
          measureFn: (SugarLevel series, _) => series.sugarLevel,
          colorFn: (SugarLevel series, _) => series.barColor,
          labelAccessorFn: (SugarLevel series, _) => '${series.sugarLevel}')
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
                "Last 7 days of Sugar Level",
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
