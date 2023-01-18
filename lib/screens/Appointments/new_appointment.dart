import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ical/serializer.dart';
import 'package:precision_hub/dynamic_links/ui/home_screen.dart';
import 'package:precision_hub/dynamic_links/utils/dialog_utils.dart';
import 'package:precision_hub/fetchfunctions/get_code.dart';
import 'package:precision_hub/fetchfunctions/user_info.dart';
import 'package:precision_hub/screens/Appointments/appoinement_page.dart';
import 'package:precision_hub/screens/doctor_patient/doctor_home.dart';
import 'package:precision_hub/utils/use_12_hour_format.dart';
import 'package:precision_hub/widgets/User_Provider.dart';
import 'package:precision_hub/widgets/custom_widgets/date_picker.dart';
import 'package:precision_hub/widgets/custom_widgets/drop_down.dart';
import 'package:precision_hub/widgets/custom_widgets/time_picker.dart';
import 'package:precision_hub/widgets/health_records/header_text.dart';
import 'package:precision_hub/widgets/in_app_notifications/local_notification_service.dart';

import '../../dynamic_links/utils/constants/app_constants.dart';
import '../../models/userModel.dart';
import '../Login/sendotp.dart';

final user = UserProvider();
var phone;

TextEditingController doctorNameController = TextEditingController();
TextEditingController doctorFirstNameController = TextEditingController();
TextEditingController doctorLastNameController = TextEditingController();
TextEditingController appointmentDateController = TextEditingController();
TextEditingController appointmentNewDateController = TextEditingController();
TextEditingController appointmentTimeController = TextEditingController();
TextEditingController appointmentEndTimeController = TextEditingController();

String appointmentTime = "";
String appointmentDate = "";
String doctorName = "";

class NewAppointment extends StatefulWidget {
  const NewAppointment({Key? key}) : super(key: key);

  @override
  State<NewAppointment> createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  final _storage = const FlutterSecureStorage();

  String userFullname = "";
  String userPhone = "";
  String code = "";

  String currDoctorName = '';
  List<String> doctorsList = ["Add a Doctor"];
  List<String> doctorsList1 = [];

  final _formKey = GlobalKey<FormState>();

  DateTime currTime = DateTime.now();
  ICalendar invite = ICalendar();

  String uniqueZoomUrl = "";
  String password = "";

  LocalNotificationService service = LocalNotificationService();

  bool isSwitched = false;
  String result = "";
  @override
  void initState() {
    super.initState();
    getUserData();
    appointmentDate = "";
    getuser().then(
      (id) {
        setState(() {
          getcode(phone);
          fetchDoctorList(phone);
          print(fetchDoctorList(phone));
          currDoctorName = doctorsList[0];
        });
      },
    );
    service = LocalNotificationService();
    service.intialize();
    FlutterBranchSdk.validateSDKIntegration();
    Future.delayed(Duration.zero, () {
      listenDeepLinkData(context);
    });
    initializeDeepLinkData();
  }

  Future fetchDoctorList(String phone) async {
    //await Future.delayed(Duration(seconds: 2));
    Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/fetchdoctorslist');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"userPhone": "$phone"}';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    List<dynamic> jsonData = jsonDecode(response.body);

    setState(() {
      if (jsonData.isEmpty) {
        doctorsList = doctorsList;
      } else {
        doctorsList = jsonData.map((e) => e.toString()).toList();
      }
    });
  }

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

  late BranchUniversalObject buo;
  late BranchLinkProperties lp;
  late BranchResponse response;

  @override
  void dispose() {
    super.dispose();
    streamSubscriptionDeepLink.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.09,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.02),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 230, 246, 254),
              ),
            ),
            onPressed: () {
              doctorNameController.text = doctorsList[0];

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.04),
                          ),
                          scrollable: true,
                          alignment: Alignment.center,
                          title: const HeaderText("New Appointment"),
                          content: Stack(
                            children: <Widget>[
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    DropDown(
                                      leftAndRightPadding: MediaQuery.of(context).size.height * 0.015,
                                      borderRadius: MediaQuery.of(context).size.height * 0.02,
                                      dropdownItems: doctorsList,
                                      hint: const Text("Doctors"),
                                      onPressed: (String newValue) {
                                        setState(
                                          () {
                                            doctorNameController.text = newValue;
                                            doctorName = doctorNameController.text;
                                          },
                                        );
                                      },
                                    ),
                                    DatePicker(
                                      label: "Date",
                                      circularRadius: MediaQuery.of(context).size.height * 0.02,
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime(
                                            currTime.year,
                                            currTime.month,
                                            currTime.day + 1,
                                          ),
                                          firstDate: DateTime(
                                            currTime.year,
                                            currTime.month,
                                            currTime.day + 1,
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
                                              appointmentDate = formattedDate;
                                              appointmentDateController.text = appointmentDate;
                                            },
                                          );
                                        } else {}
                                      },
                                      controller: appointmentDateController,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          child: TimePicker(
                                            label: " Time",
                                            controller: appointmentTimeController,
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
                                                    appointmentTimeController.text = formattedTime;
                                                    appointmentTime = appointmentTimeController.text;
                                                  },
                                                );
                                              } else {}
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Add video call link',
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Switch(
                                            value: isSwitched,
                                            onChanged: (value) {
                                              setState(() {
                                                isSwitched = value;
                                                if (isSwitched == true) {
                                                  getZoomUrl(
                                                      appointmentDateController.text, appointmentTimeController.text, doctorNameController.text);
                                                }
                                              });
                                            },
                                            activeColor: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                                      child: ElevatedButton(
                                        child: const Text("Submit"),
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate() &&
                                              await newAppointment(phone, doctorNameController.text, appointmentDateController.text,
                                                      appointmentTimeController.text, appointmentEndTimeController.text, uniqueZoomUrl, password) ==
                                                  true) {
                                            _generateDeepLink(context);
                                            DateTime date = DateFormat('MMMM d, y').parse(appointmentDate);
                                            DateTime time = DateFormat.jm().parse(appointmentTime);

                                            // afterAppointment(
                                            //     userFullname, date, time, doctorName, uniqueZoomUrl, password, phone, code, appointmentDate);

                                            Navigator.of(context, rootNavigator: true).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Saved Successfully",
                                                ),
                                              ),
                                            );
                                          }

                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AppointmentPage()));
                                          setState(
                                            () {
                                              clearForm();
                                            },
                                          );
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
                    ),
                  );
                },
              );
            },
            child: Wrap(
              children: [
                Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.008,
                ),
                Text(
                  "New Appointment",
                  style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getuser() async {
    final currentUser = await _storage.readAll();
    phone = currentUser['Phone'];
  }

  void clearForm() {
    doctorName = "";
    doctorFirstNameController.clear();
    doctorLastNameController.clear();
    appointmentNewDateController.clear();
    appointmentEndTimeController.clear();
    appointmentDateController.clear();
    appointmentTimeController.clear();
    appointmentDate = "";
    appointmentTime = "";
  }

  Future getUserData() async {
    String? phone = await _storage.read(key: 'Phone');
    UserData userInfo = await UserInfo.fetchUserInfo(phone!);
    setState(() {
      userFullname = userInfo.fullName;
      userPhone = userInfo.usersPhone;
    });
  }

  Future<bool> addToDoctorsList(String phone, List<dynamic> doctorsList) async {
    Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/doctorslist');
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> requestBody = {"User": phone, "doctorsList": doctorsList};
    Response response = await post(url, headers: headers, body: jsonEncode(requestBody));
    return true;
  }

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

  //deeplinking

  void listenDeepLinkData(BuildContext context) async {
    streamSubscriptionDeepLink = FlutterBranchSdk.initSession().listen((data) {
      if (data.containsKey(AppConstants.clickedBranchLink) && data[AppConstants.clickedBranchLink] == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorsHome(
                      phone: data["ammu"],
                    )));
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
    });
  }

  //To Setup Data For Generation Of Deep Link
  void initializeDeepLinkData() {
    buo = BranchUniversalObject(
      canonicalIdentifier: AppConstants.branchIoCanonicalIdentifier,
      contentMetadata: BranchContentMetaData()..addCustomMetadata("ammu", phone),
    );
    FlutterBranchSdk.registerView(buo: buo);

    lp = BranchLinkProperties();
    lp.addControlParam(AppConstants.controlParamsKey, '1');
  }

  //To Generate Deep Link For Branch Io
  void _generateDeepLink(BuildContext context) async {
    BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      result = response.result;
      ToastUtils.displayToast("${response.result}");
    } else {}
  }
}
