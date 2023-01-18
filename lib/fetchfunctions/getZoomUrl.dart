import 'dart:convert';

import 'package:http/http.dart';

String uniqueZoomUrl = "";
String password = "";

Future<List<dynamic>> getZoomUrl(String date, String time, String doctorName) async {
  Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/zoomurlghp');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"Date": "$date","Time": "$time","DoctorsName": "$doctorName" }';
  Response response = await post(url, headers: headers, body: json);
  int statusCode = response.statusCode;
  var list = jsonDecode(response.body);
  print(list['body']);
  uniqueZoomUrl = list['body'][0];
  password = list['body'][1];
  return list['body'];
}
