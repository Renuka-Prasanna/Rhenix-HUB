import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:precision_hub/screens/Appointments/new_appointment_ui.dart/doctors_list.dart';
import 'package:precision_hub/screens/Appointments/new_appointment_ui.dart/previous_appointment.dart';
import 'package:precision_hub/screens/Appointments/new_appointment_ui.dart/upcoming_appointments.dart';

class NewAppointmentPage extends StatefulWidget {
  const NewAppointmentPage({Key? key}) : super(key: key);

  @override
  State<NewAppointmentPage> createState() => _NewAppointmentPageState();
}

class _NewAppointmentPageState extends State<NewAppointmentPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          Center(
            child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              horizontalTitleGap: MediaQuery.of(context).size.width / 4.5,
              title: Text(
                "Appointments",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 15),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(0.1),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue,
                ),
                isScrollable: true,
                controller: tabController,
                labelPadding: EdgeInsets.symmetric(horizontal: 30),
                tabs: const [
                  Tab(
                    child: Text("New", style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  Tab(
                    child: Text("Upcoming", style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  Tab(
                    child: Text("Previous", style: TextStyle(color: Colors.black, fontSize: 18)),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                NewDoctorsList(),
                UpcomingAppointments(),
                PreviousAppointmentD(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
