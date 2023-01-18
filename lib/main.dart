import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:precision_hub/screens/Code/Code.dart';
import 'package:precision_hub/screens/Login/login_page.dart';
import 'package:precision_hub/screens/Vitals/vitals_page.dart';
import 'package:precision_hub/screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //FlutterBranchSdk.validateSDKIntegration();
  final _storage = FlutterSecureStorage();
  final all = await _storage.readAll();
  var status = false;
  if (all["status"] == "Authenticated") {
    status = true;
  } else {
    status = false;
  }

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  runApp(MyApp(
    page_status: status,
  ));
}

class MyApp extends StatelessWidget {
  final page_status;
  MyApp({
    this.page_status,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Precision Hub',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: page_status == true ? const Code() : const Splash2());
    // home: NewAppointment());
  }
}
