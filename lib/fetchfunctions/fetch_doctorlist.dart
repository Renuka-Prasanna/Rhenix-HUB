import 'dart:convert';
import 'package:http/http.dart';
import 'package:precision_hub/models/doctorlistModel.dart';

Future<List<DoctorInfo>> fetchDoctorsList() async {
  Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/fetchdoctorslist');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"Zipcode": "29506"}';
  Response response = await post(url, headers: headers, body: json);
  var jsonData = jsonDecode(response.body);
  List<DoctorInfo> doctorList = [];
  for (var doctor in jsonData) {
    DoctorInfo doctorinfo = DoctorInfo(doctor['doctor_name'], doctor['speciality1'], doctor['image']);
    doctorList.add(doctorinfo);
  }
  return doctorList;
}
