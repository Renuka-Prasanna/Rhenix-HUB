import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

//file upload to s3
Future<bool> putintos3(String selectedFileName, File file, String phone) async {
  Uint8List bytes = file.readAsBytesSync();
  String img64 = base64Encode(bytes);
  var filename = selectedFileName + phone;
  String dateTime = DateTime.now().toString();
  String dbAttributes = '{"filename": "$filename" ,"name":"$selectedFileName" ,"userphone":"$phone","Extension": "ics","dateTime":"$dateTime" }';
  Uri url = Uri.parse('https://cbslu6alpj.execute-api.ap-south-1.amazonaws.com/fileuploadghp');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"ImageName": "$selectedFileName" , "img64":"$img64", "dbAttributes": $dbAttributes}';
  Response response = await post(url, headers: headers, body: json);
  int statusCode = response.statusCode;
  return true;
}

//generate ics file
var httpClient = HttpClient();
Future<File> downloadFile(String data, String filename, String phone) async {
  String dir = (await getTemporaryDirectory()).path;
  File file = File('$dir/$filename.ics');
  await file.writeAsString(data);
  await putintos3(filename, file, phone);
  return file;
}

//sending email
Future<bool> sendEmail(
    String doctorname, String patientName, String date, String phone, String countryCode, String fileName, String zoomUrl, String password) async {
  Map<String, String> headers1 = {"Content-type": "application/json"};
  String json1 =
      '{"DoctorsName": "$doctorname","PatientName": "$patientName","Date": "$date","phone": "$phone", "CountryCode": "$countryCode", "FileName": "$fileName","Url": "$zoomUrl","password":"$password" }';
  Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/sendemail');
  Response response = await post(url, headers: headers1, body: json1);
  int statusCode = response.statusCode;
  return true;
}
