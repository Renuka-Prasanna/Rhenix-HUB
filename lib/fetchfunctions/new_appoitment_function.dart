import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

const _storage = FlutterSecureStorage();
Future<bool> newAppointment(String currPhone, String doctorName, String appointmentDate, String appointmentTime, String appointmentEndTime,
    String zoomUrl, String password) async {
  String? currPhone = await _storage.read(key: 'Phone');
  var phone = currPhone! + appointmentDate + appointmentTime;
  Map<String, String> headers1 = {"Content-type": "application/json"};
  String json1 =
      '{"User": "$phone","DoctorName": "$doctorName","AppointmentDate": "$appointmentDate", "AppointmentTime": "$appointmentTime","AppointmentEndTime": "$appointmentEndTime","phone": "$currPhone","ZoomUrl": "$zoomUrl","Password": "$password" }';
  Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP');
  Response response = await post(url, headers: headers1, body: json1);
  int statusCode = response.statusCode;
  return true;
}
