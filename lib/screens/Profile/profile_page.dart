import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as getx;

import 'package:http/http.dart';
import 'package:precision_hub/fetchfunctions/user_info.dart';
import 'package:precision_hub/fetchfunctions/fetch_file_function.dart';
import 'package:precision_hub/screens/Login/login_with_code.dart';
import 'package:precision_hub/models/filesModel.dart';
import 'package:precision_hub/models/userModel.dart';
import 'package:precision_hub/screens/Registration/height_weight_picker.dart';
import 'package:precision_hub/widgets/custom_widgets/weight_picker.dart';
import 'package:precision_hub/widgets/health_records/header_text.dart';

import '../Vitals/vitals_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  static var httpClient = HttpClient();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController weightController = TextEditingController();
  TextEditingController fieldText = TextEditingController();

  //for profile pic to selected
  final _storage = const FlutterSecureStorage();
  late File selectedfile;
  late PlatformFile fileselected;
  late String encoded;
  File file = File("");

  //info variables that will be fetched.
  String fullName = "";
  String phoneNum = "";
  String email = "";
  String zipCode = "";
  String gender = "";
  String weight = "";
  String weightUnit = "";
  String height = "";
  String heightUnit = "";

  //height values ft/in or m/cm
  String feet = "";
  String inch = "";
  String meter = "";
  String cm = "";

  //edit Height
  static List<String> heightList = ['ft/in', 'm/cm'];
  String heightTypeCurrentValue = heightList[1];

  static List<String> weightList = ['kg', 'lbs'];
  String weightCurrentValue = weightList[0];

  static List<String> feetList = ['2', '3', '4', '5', '6', '7', '8'];
  String feetCurrentValue = feetList[0];

  static List<String> inchList = List<String>.generate(12, (i) => "$i");
  String inchCurrentValue = inchList[0];

  static List<String> meterList = ['1', '2', '3', '4'];
  String meterCurrValue = meterList[0];

  static List<String> cmList = List<String>.generate(100, (i) => "$i");
  String cmCurrValue = cmList[0];

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    String? phone = await _storage.read(key: 'Phone');
    UserData userInfo = await UserInfo.fetchUserInfo(phone!);
    print('Profile page phone');
    print(phone);
    UserAdditionalInfo additionalInfo = await UserInfo.fetchUserAdditionInfo(phone);
    setState(
      () {
        fullName = userInfo.fullName;
        phoneNum = userInfo.usersPhone;
        email = userInfo.email;
        zipCode = userInfo.zipCode;
        gender = userInfo.gender;
        weight = additionalInfo.weight;
        weightUnit = additionalInfo.weightUnit;
        heightUnit = additionalInfo.heighUnit;
        feet = additionalInfo.feet;
        inch = additionalInfo.inch;
        meter = additionalInfo.meter;
        cm = additionalInfo.cm;
        print("---------profilepage-----------");
        print(fullName);
        print(phoneNum);
        print("-------------------------------");
        if (heightUnit == "ft/in") {
          height = additionalInfo.feet + "`" + additionalInfo.inch;
        } else if (heightUnit == "m/cm") {
          height = additionalInfo.meter + "`" + additionalInfo.cm;
        }
      },
    );

    UserInfo.fetchUserAdditionInfo(phoneNum);
  }

  // void getUserDat() async {
  //   String? phone = await _storage.read(key: 'Phone');
  //   UserData userInfo = await UserInfo.fetch_UserInfo(orCode!);
  //   UserAdditionalInfo additionalInfo = await UserInfo.fetch_UserAdditionInfo(orCode);
  //   setState(
  //         () {
  //       fullName = userInfo.fullName;
  //       phoneNum = userInfo.usersPhone;
  //       email = userInfo.email;
  //       zipCode = userInfo.zipCode;
  //       gender = userInfo.gender;
  //       weight = additionalInfo.weight;
  //       weightUnit = additionalInfo.weightUnit;
  //       heightUnit = additionalInfo.heighUnit;
  //       feet = additionalInfo.feet;
  //       inch = additionalInfo.inch;
  //       meter = additionalInfo.meter;
  //       cm = additionalInfo.cm;
  //       if (heightUnit == "ft/in") {
  //         height = additionalInfo.feet + "`" + additionalInfo.inch;
  //       } else if (heightUnit == "m/cm") {
  //         height = additionalInfo.meter + "`" + additionalInfo.cm;
  //       }
  //     },
  //   );
  //
  //   UserInfo.fetchUserAdditionInfo(phoneNum);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.blue,
          onPressed: () {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottomOpacity: 0,
        elevation: 0,
      ),
      body: FutureBuilder<List<Files>>(
        future: FetchFile.fetchFiles(
            phone: phoneNum, path: "https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/fetchprofilepicghp"),
        builder: (context, AsyncSnapshot<List<Files>> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
            );
          }

          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, i) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: 230,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 35,
                              left: 20,
                              child: Material(
                                child: Container(
                                  height: 180,
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade300,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 20.0,
                                        offset: const Offset(-10.0, 10.0),
                                        spreadRadius: 4.0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            (snapshot.data!.isEmpty)
                                ? Positioned(
                                    top: 0,
                                    left: 30,
                                    child: Card(
                                      elevation: 10.0,
                                      shadowColor: Colors.grey.withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        height: 200,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                                NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Positioned(
                                    top: 0,
                                    left: 30,
                                    child: Card(
                                      elevation: 10.0,
                                      shadowColor: Colors.grey.withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        height: 200,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://ghpuploads.s3.ap-south-1.amazonaws.com/${snapshot.data![i].userphone}/profile/${snapshot.data![i].name}'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            Positioned(
                              top: 80,
                              left: MediaQuery.of(context).size.width / 2 + 10,
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    Text(
                                      fullName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                    Text(
                                      phoneNum,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 45,
                              right: 20,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    pickfile();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      buildListTile("Email", email),
                      buildListTile("Gender", gender),
                      buildListTile("Zipcode", zipCode),
                      buildListTile("Height", "$height $heightUnit"),
                      buildListTile("Weight", "$weight $weightUnit"),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(280,20,0,0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // const Flexible(child: HeaderText("Edit Info")),
                            // const SizedBox(
                            //   width: 1,
                            // ),
                            Flexible(
                              child: Container(
                                width:60,
                                height:60,
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.white,
                                    iconSize: 40,
                                    onPressed: () {
                                      getx.Get.defaultDialog(
                                        title: "Edit Info",
                                        content: Column(
                                          children: [
                                            const HeaderText("Height"),
                                            HeightWeightPicker(
                                              heightTypeCurrentValue: heightUnit,
                                              onChanged: (String? newValue) => {
                                                if (mounted)
                                                  {
                                                    setState(
                                                      () {
                                                        heightTypeCurrentValue = newValue ?? heightTypeCurrentValue;
                                                        heightUnit = heightTypeCurrentValue;
                                                      },
                                                    ),
                                                  }
                                              },
                                              feetCurrentValue: feet,
                                              onChangedFeet: (String? newValue) => {
                                                if (mounted)
                                                  {
                                                    setState(
                                                      () {
                                                        clearText();
                                                        feetCurrentValue = newValue ?? feetCurrentValue;
                                                        if (heightUnit == 'ft/in') {
                                                          feet = feetCurrentValue;
                                                        }
                                                      },
                                                    ),
                                                  }
                                              },
                                              inchCurrentValue: inch,
                                              onChangedInch: (String? newValue) => {
                                                if (mounted)
                                                  {
                                                    setState(
                                                      () {
                                                        inchCurrentValue = newValue ?? inchCurrentValue;
                                                        if (heightUnit == 'ft/in') {
                                                          inch = inchCurrentValue;
                                                        }
                                                      },
                                                    ),
                                                  }
                                              },
                                              meterCurrValue: meter,
                                              onChangedMeter: (String? newValue) => {
                                                if (mounted)
                                                  {
                                                    setState(
                                                      () {
                                                        meterCurrValue = newValue ?? meterCurrValue;
                                                        if (heightUnit == 'm/cm') {
                                                          meter = meterCurrValue;
                                                        }
                                                      },
                                                    ),
                                                  }
                                              },
                                              cmCurrValue: cm,
                                              onChangedCm: (String? newValue) => {
                                                if (mounted)
                                                  {
                                                    setState(
                                                      () {
                                                        cmCurrValue = newValue ?? cmCurrValue;
                                                        if (heightUnit == 'm/cm') {
                                                          cm = cmCurrValue;
                                                        }
                                                      },
                                                    ),
                                                  }
                                              },
                                            ),
                                            const HeaderText("Weight"),
                                            WeightPicker(
                                              editValue: weightUnit,
                                              onChanged: (String? newValue) => {
                                                if (mounted)
                                                  {
                                                    setState(
                                                      () {
                                                        weightCurrentValue = newValue ?? weightCurrentValue;
                                                        weightUnit = weightCurrentValue;
                                                      },
                                                    ),
                                                  }
                                              },
                                              controllerWeight: weightController..text = weight,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                if (await UserInfo.updateAdditionalInfo(
                                                    phoneNum, heightUnit, feet, inch, meter, cm, weightUnit, weightController.text)) {
                                                  //    ScaffoldMessenger.of(context).showSnackBar(
                                                  //    const SnackBar(
                                                  //     content: Text(
                                                  //       "Saved Successfully",
                                                  //     ),
                                                  //      duration: Duration(seconds: 1,milliseconds: 1000),
                                                  //   ),
                                                  // );
                                                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
                                                  print("Entered exit");
                                                  // Navigator.of(context).pop();
                                                  // super.dispose();

                                                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
                                                  getx.Get.back();
                                                  Fluttertoast.showToast(
                                                      msg: "Saved Successfully",
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.green,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => ProfilePage()),
                                                  );
                                                }
                                              },
                                              child:const Text("Submit"))
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildListTile(String title, String subtitle) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.blue)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //pick profile pic from gallery
  void pickfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      fileselected = result.files.first;
      final bytes = File(fileselected.path as String).readAsBytesSync();
      encoded = base64Encode(bytes);
      //put it into s3 bucket
      putintos3();
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage()));
      await Future.delayed(const Duration(seconds: 1));
      Fluttertoast.showToast(
          msg: "Uploaded Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {}
  }

  Future<bool> putintos3() async {
    var filename = fileselected.name + phoneNum;
    String dateTime = DateTime.now().toString();
    String dbAttributes =
        '{"filename": "$filename" ,"name":"${fileselected.name}" ,"userphone":"$phoneNum","Extension": "${fileselected.extension}","dateTime":"$dateTime" }';
    print(fileselected.name);
    Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/profilepicghp');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"ImageName": "${fileselected.name}" , "img64":"$encoded", "dbAttributes": $dbAttributes}';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    return true;
  }

  void clearText() {
    fieldText.clear();
  }
}
