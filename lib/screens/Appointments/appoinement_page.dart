import 'package:flutter/material.dart';
import 'package:precision_hub/screens/Appointments/new_appointment.dart';
import 'package:precision_hub/screens/Appointments/new_appointment_ui.dart/previous_appointment.dart';
import 'package:precision_hub/screens/Appointments/new_appointment_ui.dart/upcoming_appointments.dart';
import 'package:precision_hub/screens/Login/login_page.dart';
import 'package:precision_hub/screens/qr_scan_page.dart';
import 'package:precision_hub/widgets/User_Provider.dart';
import 'package:precision_hub/widgets/custom_widgets/home_top_splash.dart';
import 'package:precision_hub/widgets/custom_widgets/nav_drawer.dart';
import 'package:precision_hub/widgets/health_records/header_text.dart';

final user = UserProvider();

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: ListView(
        children: [
          const HomeTopSplash(imagePath: 'assets/images/curescience_logo.png'),
          const NewAppointment(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          const HeaderText("Upcoming Appointments"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          const UpcomingAppointments(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.001),
          const HeaderText("Previous Appointments"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          const PreviousAppointmentD(),
        ],
      ),
    );
  }
}
