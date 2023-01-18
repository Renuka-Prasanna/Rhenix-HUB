import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as getx;

import 'package:intl/intl.dart';
import 'package:precision_hub/dynamic_links/ui/home_screen.dart';
import 'package:precision_hub/dynamic_links/utils/constants/app_constants.dart';
import 'package:precision_hub/dynamic_links/utils/dialog_utils.dart';
import 'package:precision_hub/fetchfunctions/getZoomUrl.dart';
import 'package:precision_hub/fetchfunctions/new_appoitment_function.dart';
import 'package:precision_hub/fetchfunctions/user_info.dart';
import 'package:precision_hub/models/userModel.dart';
import 'package:precision_hub/screens/Appointments/new_appointment_ui.dart/new_appointment_page.dart';
import 'package:precision_hub/screens/Appointments/new_appointment_ui.dart/upcoming_appointments.dart';
import 'package:precision_hub/screens/doctor_patient/doctor_home.dart';
import 'package:precision_hub/utils/use_12_hour_format.dart';
import 'package:precision_hub/widgets/custom_widgets/time_picker.dart';

import '../../../widgets/custom_widgets/date_picker.dart';

class AddAppointment extends StatefulWidget {
  const AddAppointment({Key? key}) : super(key: key);

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final _storage = const FlutterSecureStorage();

  //form key to submit the form
  final _formKey = GlobalKey<FormState>();

  //switch for zoom url
  bool isSwitched = false;

  //initial values for date and time
  DateTime currTime = DateTime.now();
  String appointmentDate = DateFormat('MMMM d, y').format(DateTime.now());
  String appointmentTime = "";

  //variables used to send mail
  String userFullname = "";
  String userPhone = "";

  //date and time controllers
  TextEditingController appointmentDateController = TextEditingController();
  TextEditingController appointmentTimeController = TextEditingController();

  //varaibles for deep linking
  late BranchUniversalObject buo;
  late BranchLinkProperties lp;
  late BranchResponse response;
  String result = "";

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future getUserData() async {
    String? phone = await _storage.read(key: 'Phone');
    UserData userInfo = await UserInfo.fetchUserInfo(phone!);
    setState(() {
      userFullname = userInfo.fullName;
      userPhone = userInfo.usersPhone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: (getx.Get.arguments['image'].contains(".svg"))
                              ? const NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                              : NetworkImage(getx.Get.arguments['image']),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              getx.Get.arguments['doctorName'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              getx.Get.arguments['speciality'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Select Date",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Available Slots",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TimePicker(
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
                          getZoomUrl(appointmentDateController.text, appointmentTimeController.text, "Priyanka");
                        }
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
                child: const Text("Book Appointment"),
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      await newAppointment(userPhone, getx.Get.arguments['doctorName'], appointmentDateController.text,
                              appointmentTimeController.text, appointmentTimeController.text, uniqueZoomUrl, password) ==
                          true) {
                    _generateDeepLink(context);

                    DateTime date = DateFormat('MMMM d, y').parse(appointmentDate);
                    DateTime time = DateFormat.jm().parse(appointmentTime);
                    // afterAppointment(
                    //     userFullname, date, time, doctorName, uniqueZoomUrl, password, phone, code, appointmentDate);

                 //   Navigator.of(context).pop();
                   // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewAppointmentPage()));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const NewAppointmentPage()),
                    );
                    Fluttertoast.showToast(
                        msg: "Appointment Booked successfully",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                Navigator.of(context).pop();
                  //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const NewAppointmentPage()));
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
    );
  }

  void clearForm() {
    appointmentDateController.clear();
    appointmentTimeController.clear();
    appointmentDate = "";
    appointmentTime = "";
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
