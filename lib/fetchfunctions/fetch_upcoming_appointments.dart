import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:precision_hub/models/appointment_model.dart';

Future<List<Appointment>> fetchUpcomingAppointments(String phone) async {
  Uri url = Uri.parse('https://is6kkaby26.execute-api.ap-south-1.amazonaws.com/fetchingAppointments/fetchappointmentsghp');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"Phone": "$phone"}';
  Response response = await post(url, headers: headers, body: json);
  int statusCode = response.statusCode;
  var jsonData = jsonDecode(response.body);

  List<Appointment> appointments = [];
  for (var u in jsonData) {
    Appointment appointment = Appointment(u['DoctorName'], u['AppointmentDate'], u['AppointmentTime']);
    if (DateFormat('MMMM d, y').parse(appointment.appointmentDate).isAfter(DateTime.now())) {
      appointments.add(appointment);
    }
  }
  print(appointments.length);
  appointments.sort((a, b) => combineDateTime(a).compareTo(combineDateTime(b)));

  return appointments;
}

DateTime combineDateTime(Appointment vital) {
  DateTime date = DateFormat('MMMM d, y').parse(vital.appointmentDate);
  TimeOfDay time = TimeOfDay.fromDateTime(DateFormat.jm().parse(vital.appointmentTime));
  return date.add(Duration(hours: time.hour, minutes: time.minute));
}
