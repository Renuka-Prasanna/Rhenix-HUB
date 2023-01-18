import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:precision_hub/fetchfunctions/fetch_doctorlist.dart';
import 'package:precision_hub/fetchfunctions/after_appointment.dart';
import 'package:precision_hub/fetchfunctions/user_info.dart';
import 'package:precision_hub/models/appointment_model.dart';
import 'package:precision_hub/models/doctorlistModel.dart';
import 'package:precision_hub/models/userModel.dart';
import 'package:precision_hub/screens/Appointments/new_appointment_ui.dart/new_appointment_page.dart';
import 'package:precision_hub/screens/Code/AppRoutes.dart';
import 'package:precision_hub/utils/use_12_hour_format.dart';
import 'package:precision_hub/widgets/User_Provider.dart';
import 'package:precision_hub/widgets/custom_widgets/commonText.dart';
import 'package:precision_hub/widgets/custom_widgets/date_picker.dart';
import 'package:precision_hub/widgets/custom_widgets/edit_drop_down.dart';
import 'package:precision_hub/widgets/custom_widgets/time_picker.dart';
import 'package:precision_hub/widgets/health_records/header_text.dart';

final user = UserProvider();
var phone;

TextEditingController editAppointmentTimeController = TextEditingController();
TextEditingController editAppointmentDateController = TextEditingController();
TextEditingController editDoctorNameController = TextEditingController();
String appointmentDate = "";
String appointmentTime = "";
String doctorName = "";

class UpcomingAppointments extends StatefulWidget {
  const UpcomingAppointments({Key? key}) : super(key: key);

  @override
  State<UpcomingAppointments> createState() => _UpcomingAppointmentsState();
}

class _UpcomingAppointmentsState extends State<UpcomingAppointments> {
  final _storage = const FlutterSecureStorage();

  String userFullname = "";
  String userPhone = "";
  String code = "";

  List<String> doctorsList = [];
  List<DoctorInfo> newDoctorsList = [];

  final _formKey = GlobalKey<FormState>();
  DateTime currTime = DateTime.now();

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
    editAppointmentTimeController.text = "";
    editAppointmentDateController.text = "";
    editDoctorNameController.text = "";
    getuser().then(
      (id) {
        setState(() {
          doctorNames();
        });
      },
    );
  }

  Future<List<Appointment>> upcomingAppointments(String phone) async {
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
    appointments.sort((a, b) => combineDateTime(a).compareTo(combineDateTime(b)));

    return appointments;
  }

  DateTime combineDateTime(Appointment vital) {
    DateTime date = DateFormat('MMMM d, y').parse(vital.appointmentDate);
    TimeOfDay time = TimeOfDay.fromDateTime(DateFormat.jm().parse(vital.appointmentTime));
    return date.add(Duration(hours: time.hour, minutes: time.minute));
  }

  Future<List<String>> doctorNames() async {
    newDoctorsList = await fetchDoctorsList() ;
    doctorsList = newDoctorsList.map((e) => e.doctorName).toList();
    return doctorsList;
  }
  List<String> date = appointmentDate.split(",");
  // String dateno = appointmentDate.replaceAll(RegExp('[^0-9]'),'');
  // print(dateno);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Appointment>>(
      future: upcomingAppointments(phone),
      builder: (context, AsyncSnapshot<List<Appointment>> snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
          );
        } else if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No upcoming appointments'),
          );
        } else
          // ignore: curly_braces_in_flow_control_structures
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.008,
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.008),
                      tileColor: listColors[((listColors.length - 1) / (i + 1)).floor()],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.015),
                      ),

                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data![i].appointmentDate ,
                            // snapshot.data![i].appointmentDate[0] +  snapshot.data![i].appointmentDate[1] +  snapshot.data![i].appointmentDate[2],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.height * 0.003),
                          Text(
                            snapshot.data![i].appointmentTime,
                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.height * 0.003),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(1,0,0,0),
                            child: GestureDetector(
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                iconSize: 25,
                                onPressed: () {
                                  setState(() {
                                    doctorNames();
                                  });
                                  editDoctorNameController.text = snapshot.data![i].doctorName;
                                  editAppointmentDateController.text = snapshot.data![i].appointmentDate;
                                  editAppointmentTimeController.text = snapshot.data![i].appointmentTime;
                                  appointmentDate = snapshot.data![i].appointmentDate;
                                  appointmentTime = snapshot.data![i].appointmentTime;
                                  doctorName = snapshot.data![i].doctorName;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        alignment: Alignment.center,
                                        title: const HeaderText("Edit Appointment"),
                                        content: Stack(
                                          children: <Widget>[
                                            Form(
                                              key: _formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  EditDropDown(
                                                    editValue: snapshot.data![i].doctorName,
                                                    leftAndRightPadding: MediaQuery.of(context).size.height * 0.015,
                                                    borderRadius: MediaQuery.of(context).size.height * 0.02,
                                                    dropdownItems: doctorsList,
                                                    hint: const Text("Doctors"),
                                                    onPressed: (String newValue) {
                                                      setState(
                                                        () {
                                                          editDoctorNameController.text = newValue;
                                                          doctorName = editDoctorNameController.text;
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  DatePicker(
                                                    label: "Date",
                                                    circularRadius: MediaQuery.of(context).size.height * 0.02,
                                                    controller: editAppointmentDateController,
                                                    onTap: () async {
                                                      DateTime? pickedDate = await showDatePicker(
                                                        context: context,
                                                        initialDate: DateTime(
                                                          currTime.year,
                                                          currTime.month,
                                                          currTime.day,
                                                        ),
                                                        firstDate: DateTime(
                                                          currTime.year,
                                                          currTime.month,
                                                          currTime.day,
                                                        ),
                                                        lastDate: DateTime(
                                                          currTime.year + 1,
                                                          currTime.month,
                                                          currTime.day,
                                                        ),
                                                      );

                                                      if (pickedDate != null) {
                                                        String formattedDate = DateFormat('MMMM d, y').format(pickedDate);

                                                        setState(
                                                          () {
                                                            editAppointmentDateController.text = formattedDate;
                                                            appointmentDate = editAppointmentDateController.text;
                                                          },
                                                        );
                                                      } else {}
                                                    },
                                                  ),
                                                  TimePicker(
                                                    label: "Time",
                                                    controller: editAppointmentTimeController,
                                                    onTap: () async {
                                                      TimeOfDay? pickedTime = await showTimePicker(
                                                        initialTime: TimeOfDay.now(),
                                                        context: context,
                                                        builder: (context, child) {
                                                          return MediaQuery(
                                                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                                                            child: child ?? Container(),
                                                          );
                                                        },
                                                      );
                                                      if (pickedTime != null) {
                                                        String pickTimeIn24hrFormat = use12HourFormat(pickedTime, MaterialLocalizations.of(context));
                                                        DateTime parsedTime = DateFormat.jm().parse(pickTimeIn24hrFormat);
                                                        String formattedTime = DateFormat("h:mm a").format(parsedTime);
                                                        setState(
                                                          () {
                                                            editAppointmentTimeController.text = formattedTime;
                                                            appointmentTime = editAppointmentTimeController.text;
                                                          },
                                                        );
                                                      } else {}
                                                    },
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                                                    child: ElevatedButton(
                                                      child: const Text("Submit"),
                                                      onPressed: () async {
                                                        if (_formKey.currentState!.validate() &&
                                                            await updateAppointment(
                                                              snapshot.data![i].doctorName,
                                                              snapshot.data![i].appointmentDate,
                                                              snapshot.data![i].appointmentTime,
                                                              phone,
                                                              editDoctorNameController.text,
                                                              editAppointmentDateController.text,
                                                              editAppointmentTimeController.text,
                                                            )) {
                                                          Navigator.of(context).pop();

                                                          DateTime editedDate = DateFormat('MMMM d, y').parse(appointmentDate);
                                                          DateTime editedTtime = DateFormat.jm().parse(appointmentTime);

                                                          afterAppointment(userFullname, editedDate, editedTtime, doctorName, "jhadsowkieo", "ghjhi",
                                                              phone, code, appointmentDate);

                                                          Fluttertoast.showToast(
                                                              msg: "Appointment updated successfully",
                                                              toastLength: Toast.LENGTH_LONG,
                                                              gravity: ToastGravity.BOTTOM,
                                                              timeInSecForIosWeb: 1,
                                                              backgroundColor: Colors.green,
                                                              textColor: Colors.white,
                                                              fontSize: 16.0);
                                                          setState(() {
                                                            clearForm();
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),

                          Flexible(
                            child: GestureDetector(
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                iconSize: 25,
                                highlightColor: Colors.red,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Are you sure you want to remove?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text(
                                              'Yes, Remove',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () {

                                              DateTime deleteDate = DateFormat('MMMM d, y').parse(snapshot.data![i].appointmentDate);
                                              DateTime deleteTime = DateFormat.jm().parse(snapshot.data![i].appointmentTime);
                                              deleteAppointment(phone, snapshot.data![i].appointmentDate, snapshot.data![i].appointmentTime);
                                              deleteFile(phone, snapshot.data![i].appointmentDate + ".ics");

                                              Navigator.of(context).pop();
                                              // afterAppointment(userFullname, deleteDate, deleteTime, snapshot.data![i].DoctorName, "sdjf", "kdsjf",
                                              //     phone, code, snapshot.data![i].AppointmentDate);
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      minVerticalPadding: MediaQuery.of(context).size.height * 0.00015,
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CommonText(
                          //   text: "Physician name: " + snapshot.data![i].doctorName,
                          //   fontWeight: FontWeight.bold,
                          // ),
                          Text(
                            "  Physician name: " + snapshot.data![i].doctorName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
      },
    );
  }

  getuser() async {
    final currentUser = await _storage.readAll();
    phone = currentUser['Phone'];
  }

  void clearForm() {
    doctorName = "";
    editAppointmentDateController.text = "";
    editAppointmentTimeController.text = "";
    editDoctorNameController.text = "";
    appointmentDate = "";
    appointmentTime = "";
  }

  Future<bool> updateAppointment(String prevDoctorname, String prevAppointmentDate, String prevAppointmentTime, String phone,
      String updatedDoctorName, String updatedAppointmentDate, String updatedAppointmentTime) async {
    String dateTime = DateTime.now().toString();
    Map<String, String> headers1 = {"Content-type": "application/json"};
    String dbAttributes =
        '{"prevDoctorName": "$prevDoctorname" ,"prevAppointmentDate":"$prevAppointmentDate" ,"prevAppointmentTime": "$prevAppointmentTime","userphone":"$phone"}';
    Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/updateappointment');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"updatedDoctorName": "$updatedDoctorName" , "updatedAppointmentDate":"$updatedAppointmentDate","updatedAppointmentTime":"$updatedAppointmentTime", "dbAttributes": $dbAttributes}';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    return true;
  }

  void deleteAppointment(String phone, String updatedAppointmentDate, String updatedAppointmentTime) async {
    Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/deleteappointment');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"phone": "$phone", "updatedAppointmentDate":"$updatedAppointmentDate","updatedAppointmentTime":"$updatedAppointmentTime"}';
    Response response = await post(url, headers: headers, body: json);
   // Navigator.of(context).pop();
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewAppointmentPage()));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewAppointmentPage()),
    );
    Fluttertoast.showToast(
        msg: "Removed appointment successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void deleteFile(String number, String filename) async {
    Uri url = Uri.parse('https://fb8xlu0ase.execute-api.ap-south-1.amazonaws.com/GHPdelfiles');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"phone_number": "$number", "filename":"$filename" }';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
  }

  Future getUserData() async {
    String? phone = await _storage.read(key: 'Phone');
    UserData userInfo = await UserInfo.fetchUserInfo(phone!);
    setState(
      () {
        userFullname = userInfo.fullName;
        userPhone = userInfo.usersPhone;
      },
    );
  }

  void getcode(number) async {
    Uri url = Uri.parse('https://dors1qol6j.execute-api.ap-south-1.amazonaws.com/Seniorcitizen_Countrycode/');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"phone_number": "$number" }';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    var list = jsonDecode(response.body);
    code = list[0]["Country_Code"];
  }
}
