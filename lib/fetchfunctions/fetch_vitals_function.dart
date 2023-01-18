import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:precision_hub/models/vitalsModel.dart';

Future fetchVitals(String phone) async {
  Uri url = Uri.parse('https://8y984iapei.execute-api.ap-south-1.amazonaws.com/ghp_vitals_new');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"userphone": "$phone"}';
  Response response = await post(url, headers: headers, body: json);
  var jsonData = jsonDecode(response.body);
  List<Vitals> vitals = [];
  for (var u in jsonData) {
    Vitals vital = Vitals(u['Systolic'], u['Diastolic'], u['SugarLevel'], u['HeartRate'], u['VitalDate'], u['VitalTime']);
    vitals.add(vital);
  }
  vitals.sort((a, b) => combineDateTime(b).compareTo(combineDateTime(a)));
  return vitals;
}

//combined date and time to sort in descending order

DateTime combineDateTime(Vitals vital) {
  DateTime date = DateFormat('MMMM d, y').parse(vital.vitalDate);
  TimeOfDay time = TimeOfDay.fromDateTime(DateFormat.jm().parse(vital.vitalTime));
  return date.add(Duration(hours: time.hour, minutes: time.minute));
}
