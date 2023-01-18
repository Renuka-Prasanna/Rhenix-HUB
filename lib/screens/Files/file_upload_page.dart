import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io' as IO;

import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:precision_hub/screens/Files/fetch_files.dart';
import 'package:precision_hub/screens/Login/login_page.dart';
import 'package:precision_hub/screens/Vitals/vitals_page.dart';
import 'package:precision_hub/screens/qr_scan_page.dart';
import 'package:precision_hub/widgets/User_Provider.dart';
import 'package:precision_hub/widgets/custom_widgets/home_top_splash.dart';
import 'package:precision_hub/widgets/custom_widgets/nav_drawer.dart';
import 'package:precision_hub/widgets/health_records/header_text.dart';

var phone;
var curruser;

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({Key? key}) : super(key: key);

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  late IO.File selectedfile;
  final _storage = const FlutterSecureStorage();
  final user = UserProvider();
  late String encodedFile;
  late PlatformFile fileselected;

  @override
  void initState() {
    super.initState();
    getuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        bottomOpacity: -1.0,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const QRViewExample();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('You want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Yes, Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          user.signOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const LoginPage();
                              },
                            ),
                          );
                        },
                      ),
                      TextButton(
                        child: const Text('No'),
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
        ],
      ),
      drawer: const NavDrawer(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const HomeTopSplash(imagePath: 'assets/images/curescience_logo.png'),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width * 0.7,
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
                    pickfile();
                  },
                  child: Wrap(
                    children: [
                      Icon(Icons.file_upload, color: Theme.of(context).primaryColor),
                      SizedBox(
                        width: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Text(
                        "Upload",
                        style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.025),
                child: const HeaderText("File Manager"),
              ),
              // IconButton(
              //   onPressed: () {
              //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FileUploadPage()));
              //   },
              //   color: Theme.of(context).primaryColor,
              //   icon: const Icon(Icons.refresh),
              // ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          NewFiles(),
        ],
      ),
    );
  }

  getuser() async {
    final currentUser = await _storage.readAll();
    phone = currentUser['Phone'];
    // curruser = currentUser['FullName'];
  }

  //function to pick file from device
  void pickfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      fileselected = result.files.first;
      final bytes = IO.File(fileselected.path as String).readAsBytesSync();
      encodedFile = base64Encode(bytes);
     putintos3();
      await Future.delayed(const Duration(seconds: 2));
      //Navigator.of(context).pop();
   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const FileUploadPage()));
  //     Navigator.of(context).push(
  //         MaterialPageRoute(
  //             builder: (context) =>
  //             const FileUploadPage()),
  //   );
   // //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
   //        builder: (context) =>
   //        const FileUploadPage()), (route) => false);
      await Future.delayed(const Duration(seconds: 1));
      // SizedBox(height: MediaQuery.of(context).size.height * 0.02);
       Fluttertoast.showToast(
          msg: "Uploaded Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {}
  }

  //put the seletced file into s3
  Future<bool> putintos3() async {
    var filename = fileselected.name + phone;
    String dateTime = DateTime.now().toString();
    String dbAttributes =
        '{"filename": "$filename" ,"name":"${fileselected.name}" ,"userphone":"$phone","Extension": "${fileselected.extension}","dateTime":"$dateTime" }';
    Uri url = Uri.parse('https://cbslu6alpj.execute-api.ap-south-1.amazonaws.com/fileuploadghp');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"ImageName": "${fileselected.name}" , "img64":"$encodedFile", "dbAttributes": $dbAttributes}';
    Response response = await post(url, headers: headers, body: json);
    return true;
  }
}
