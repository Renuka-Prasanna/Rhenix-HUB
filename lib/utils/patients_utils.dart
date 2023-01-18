import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:precision_hub/models/filesModel.dart';
import 'package:precision_hub/models/vitalsModel.dart';
import 'package:precision_hub/screens/doctor_patient/patients_files.dart';

class PatientInfo {
  static Future fetchVitals(String phone) async {
    Uri url = Uri.parse('https://8y984iapei.execute-api.ap-south-1.amazonaws.com/ghp_vitals_new');

    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"userphone": "$phone"}';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    var jsonData = jsonDecode(response.body);

    List<Vitals> vitals = [];
    for (var u in jsonData) {
      Vitals vital = Vitals(u['Systolic'], u['Diastolic'], u['SugarLevel'], u['HeartRate'], u['VitalDate'], u['VitalTime']);
      vitals.add(vital);
    }
    print(vitals.length);
    vitals.sort((a, b) => combineDateTime(b).compareTo(combineDateTime(a)));
    return vitals;
  }

  static Future<List<Files>> fetchFiles(String phone) async {
    Uri url = Uri.parse('https://d1k0s0oz15.execute-api.ap-south-1.amazonaws.com/GHPfetch');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"userphone": "$phone"}';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    var jsonData = jsonDecode(response.body);
    List<Files> files = [];
    for (var u in jsonData) {
      if (u['Extension'] != 'ics') {
        Files file = Files(u['name'], u['Extension'], u['userphone'], u['dateTime']);
        files.add(file);
      }
    }

    files.sort(
      (a, b) => b.dateTime.compareTo(a.dateTime),
    );

    return files;
  }

  static var httpClient = HttpClient();
  static Future<File> downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getTemporaryDirectory()).path;
    File file = File('$dir/$filename');
    print(dir);
    await file.writeAsBytes(bytes);
    OpenFile.open(file.path);
    return file;
  }

  static void deleteFile(String number, String filename, BuildContext context) async {
    Uri url = Uri.parse('https://fb8xlu0ase.execute-api.ap-south-1.amazonaws.com/GHPdelfiles');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"phone_number": "$number", "filename":"$filename" }';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;

    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PatientsFiles(
              phone: number,
            )));
    Fluttertoast.showToast(
        msg: "Deleted Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

DateTime combineDateTime(Vitals vital) {
  DateTime date = DateFormat('MMMM d, y').parse(vital.vitalDate);
  TimeOfDay time = TimeOfDay.fromDateTime(DateFormat.jm().parse(vital.vitalTime));
  return date.add(Duration(hours: time.hour, minutes: time.minute));
}
