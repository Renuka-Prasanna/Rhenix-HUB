import 'package:get/get.dart' as getx;
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:precision_hub/fetchfunctions/user_info.dart';
import 'package:precision_hub/fetchfunctions/fetch_file_function.dart';
import 'package:precision_hub/models/filesModel.dart';

import 'package:precision_hub/models/userModel.dart';

import 'package:precision_hub/screens/Appointments/new_appointment_ui.dart/new_appointment_page.dart';
import 'package:precision_hub/screens/Files/file_upload_page.dart';
import 'package:precision_hub/screens/Login/login_page.dart';
import 'package:precision_hub/screens/Profile/profile_page.dart';
import 'package:precision_hub/screens/Vitals/vitals_page.dart';
import 'package:precision_hub/screens/qr_scan_page.dart';
import 'package:precision_hub/widgets/User_Provider.dart';
import 'package:precision_hub/widgets/smart_watches/wearables_page.dart';

import '../../screens/Code/Code.dart';

final user = UserProvider();

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  final _storage = const FlutterSecureStorage();
  String fullName = "";
  String phoneNum = "";
  String qrCode = 'Unknown';

  List<Files> pics = [];
  String? profilePicURL = "";

  @override
  void initState() {
    super.initState();
    getUserData();
    getProfilePic();
  }

  void getUserData() async {
    String? phone = await _storage.read(key: 'Phone');
    UserData userInfo = await UserInfo.fetchUserInfo(phone!);
    setState(() {
      fullName = userInfo.fullName;
      phoneNum = userInfo.usersPhone;
    });
  }

  void getProfilePic() async {
    String? phone = await _storage.read(key: 'Phone');
    pics = await FetchFile.fetchFiles(
        path:
            "https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/fetchprofilepicghp",
        phone: phone!);
    profilePicURL =
        'https://ghpuploads.s3.ap-south-1.amazonaws.com/$phone/profile/${pics[0].name}';
    print(profilePicURL);
    print(pics[0]);
    print(pics);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: FutureBuilder<List<Files>>(
            future: FetchFile.fetchFiles(
                phone: phoneNum,
                path:
                    "https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/fetchprofilepicghp"),
            builder: (context, AsyncSnapshot<List<Files>> snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                  //   Container();
                );
              }
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                          color: Theme.of(context).primaryColor,
                          height: (MediaQuery.of(context).size.height * 0.08) +
                              MediaQuery.of(context).size.height * 0.075,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 30,
                                      left: 20,
                                      child: Text(
                                        fullName,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 20,
                                      child: Text(phoneNum,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 10,
                                      right: 20,
                                      child: Container(
                                        height: 75,
                                        width: 75,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              (pics[0].name != "")
                                                  ? profilePicURL!
                                                  : ('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Profile'),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ProfilePage())),
                      ),
                      ListTile(
                        leading: const Icon(Icons.favorite),
                        title: const Text('Vitals'),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const HomePage())),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_month),
                        title: const Text('Appointments'),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NewAppointmentPage())),
                      ),
                      ListTile(
                        leading: const Icon(Icons.file_present),
                        title: const Text('Health Records'),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const FileUploadPage())),
                      ),
                      ListTile(
                        leading: const Icon(Icons.watch),
                        title: const Text('Smart Watches'),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const WearablesPage())),
                      ),
                      ListTile(
                        leading: const Icon(Icons.qr_code_scanner),
                        title: const Text('Go to Web'),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const QRViewExample())),
                      ),

                      // ListTile(
                      //   leading: const Icon(Icons.location_on),
                      //   title: const Text('location'),
                      //   onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationPage())),
                      // ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Logout'),
                        onTap: () {
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
                                      getx.Get.offAll(() => Code());
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
                  );
                },
                // Remove padding
              );
            }));
  }

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
}
