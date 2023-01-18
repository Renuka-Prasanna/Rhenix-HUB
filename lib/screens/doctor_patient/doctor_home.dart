import 'package:flutter/material.dart';
import 'package:precision_hub/screens/Vitals/fetch_vitals.dart';
import 'package:precision_hub/screens/doctor_patient/patients_files.dart';

class DoctorsHome extends StatefulWidget {
  String phone;
  DoctorsHome({Key? key, required this.phone}) : super(key: key);

  @override
  State<DoctorsHome> createState() => _DoctorsHomeState();
}

class _DoctorsHomeState extends State<DoctorsHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Access Patient's Data"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FetchVitals(
                          phone: widget.phone,
                        ),
                      ),
                    );
                  },
                  child: Text("Vitals")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientsFiles(
                          phone: widget.phone,
                        ),
                      ),
                    );
                  },
                  child: Text("Files")),
            ],
          ),
        ));
  }
}
