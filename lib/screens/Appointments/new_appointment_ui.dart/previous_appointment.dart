import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:precision_hub/widgets/custom_widgets/commonText.dart';

var phone;

class PreviousAppointmentD extends StatefulWidget {
  const PreviousAppointmentD({Key? key}) : super(key: key);

  @override
  State<PreviousAppointmentD> createState() => _PreviousAppointmentDState();
}

class _PreviousAppointmentDState extends State<PreviousAppointmentD> {
  final _storage = const FlutterSecureStorage();

  final List<Color> listColors = [
    const Color.fromARGB(255, 236, 232, 254),
    const Color.fromARGB(255, 230, 244, 255),
    const Color.fromARGB(255, 255, 241, 220),
    const Color.fromARGB(255, 227, 239, 217),
    const Color.fromARGB(255, 251, 231, 228)
  ];

  @override
  void initState() {
    super.initState();
    getuser().then((id) {
      setState(() {});
      print(phone);
    });
  }

  Future previousAppointments(String phone) async {
    String currDate = DateFormat('MMMM d, y').format(DateTime.now()).toString();
    Uri url = Uri.parse('https://is6kkaby26.execute-api.ap-south-1.amazonaws.com/fetchingAppointments/fetchappointmentsghp');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"Phone": "$phone"}';
    Response response = await post(url, headers: headers, body: json);
    var jsonData = jsonDecode(response.body);

    List<Appointment> appointments = [];
    for (var u in jsonData) {
      Appointment appointment = Appointment(u['DoctorName'], u['AppointmentDate'], u['AppointmentTime']);
      if (DateFormat('MMMM d, y').parse(appointment.appointmentDate).isBefore(DateTime.now())) {
        appointments.add(appointment);

      }
    }

    appointments.sort((a, b) => combineDateTime(b).compareTo(combineDateTime(a)));
    return appointments;
  }

  DateTime combineDateTime(Appointment vital) {
    DateTime date = DateFormat('MMMM d, y').parse(vital.appointmentDate);
    TimeOfDay time = TimeOfDay.fromDateTime(DateFormat.jm().parse(vital.appointmentTime));
    return date.add(Duration(hours: time.hour, minutes: time.minute));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: previousAppointments(phone),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
            );
          } else if (snapshot.data.length == 0) {
            return const Center(
              child: Text('No previous appointments'),
            );
          } else
            // ignore: curly_braces_in_flow_control_structures
            return Scrollbar(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.008,
                  ),
                 itemCount: 5 ,
                  itemBuilder: (context, i) {
                    return Card(
                      color: listColors[(listColors.length) % (i + 1)],
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month),
                                  Text(
                                    "  " + snapshot.data[i].appointmentDate,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.timer),
                                  Text(
                                    "  " + snapshot.data[i].appointmentTime,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 8),
                            child: CommonText(
                              text: "Physician Name: " + snapshot.data[i].doctorName,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 8),
                            child: CommonText(
                              text: "Health Condition: ",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 8),
                            child: CommonText(
                              text: "Drugs Prescribed: ",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // ElevatedButton(
                          //     onPressed: () {
                          //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FileUploadPage()));
                          //     },
                          //     child: const Text("Files")),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
        },
      ),
    );
  }

  getuser() async {
    final currentUser = await _storage.readAll();
    phone = currentUser['Phone'];
  }
}

class Appointment {
  String doctorName;
  String appointmentDate;
  String appointmentTime;
  Appointment(this.doctorName, this.appointmentDate, this.appointmentTime);
}
