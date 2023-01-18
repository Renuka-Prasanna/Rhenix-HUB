// import 'dart:convert';
// import 'package:http/http.dart';
//
// String code = "";
// String zipcode = "";
// String newotp = "";
//
// void getcode(number) async {
//   Uri url = Uri.parse('https://dors1qol6j.execute-api.ap-south-1.amazonaws.com/Seniorcitizen_Countrycode/');
//   Map<String, String> headers = {"Content-type": "application/json"};
//   String json = '{"phone_number": "$number" }';
//   Response response = await post(url, headers: headers, body: json);
//   var list = jsonDecode(response.body);
//   code = list[0]["Country_Code"];
//   print(code);
//   zipcode = list[0]["Zipcode"];
// }
