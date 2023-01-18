import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:precision_hub/widgets/User_Provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final user = UserProvider();
const _storage = FlutterSecureStorage();
String userphone = "";
String? qrcodefromweb = "";
var phone;
var username;
String status = "denied";

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  late Barcode result;
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    getUserid().then((id) {
      setState(() {});
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.resumeCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 50),
          Text(
            "Go to www.smarthub.com ",
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
          ),
          Text(
            "to upload files from computer",
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
          ),
          const SizedBox(height: 30),
          Expanded(flex: 4, child: _buildQrView(context)),
          Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                controller.resumeCamera();
              },
              child: const Text('Resume', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  getUserid() async {
    final currentUser = await _storage.readAll();
    phone = currentUser['Phone'];
    username = currentUser['FullName'];
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      cameraFacing: CameraFacing.back,
      onQRViewCreated: _onQRViewCreated,
      formatsAllowed: const [BarcodeFormat.qrcode],
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blueAccent,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        qrcodefromweb = result.code;
        controller.dispose();
        Fluttertoast.showToast(
            msg: "Scanned successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();

        if (result.code != null) {
          weblogin();
        }
        //weblogin();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

void weblogin() async {
  Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/qrloginghp');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"phone": "$phone","webqrcode":"$qrcodefromweb","username":"$username", "status":"approved"}';
  Response response = await post(url, headers: headers, body: json);
  int statusCode = response.statusCode;
  var list = jsonDecode(response.body);
}
