import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:precision_hub/fetchfunctions/fetch_doctorlist.dart';
import 'package:precision_hub/models/doctorlistModel.dart';
import 'package:precision_hub/screens/Appointments/new_appointment_ui.dart/add_appointment.dart';
import 'package:auto_size_text/auto_size_text.dart';

final List<Color> listColors = [
  const Color.fromARGB(255, 236, 232, 254),
  const Color.fromARGB(255, 230, 244, 255),
  const Color.fromARGB(255, 255, 241, 220),
  const Color.fromARGB(255, 227, 239, 217),
  const Color.fromARGB(255, 251, 231, 228)
];

class NewDoctorsList extends StatefulWidget {
  const NewDoctorsList({Key? key}) : super(key: key);

  @override
  State<NewDoctorsList> createState() => _NewDoctorsListState();
}

class _NewDoctorsListState extends State<NewDoctorsList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Book Appointment",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            margin: const EdgeInsets.only(top: 20, left: 10, right: 5),
            child: FutureBuilder<List<DoctorInfo>>(
              future: fetchDoctorsList(),
              builder: (context, AsyncSnapshot<List<DoctorInfo>> snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No Doctors available'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, i) {
                      return doctorsList(snapshot.data![i].doctorImg, snapshot.data![i].doctorName, snapshot.data![i].speciality, 0, () {
                        Get.to(() => const AddAppointment(), arguments: {
                          "image": snapshot.data![i].doctorImg,
                          "doctorName": snapshot.data![i].doctorName,
                          "speciality": snapshot.data![i].speciality,
                        });
                      });
                    },
                  );
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Widget doctorsList(String imgUrl, String name, String speciality, int index, Function() onPressed) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.17,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: listColors[index],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: (imgUrl.contains(".svg"))
                    ? const NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                    : NetworkImage(imgUrl),
              ),
            ),
          ),
          Container(
            // margin: const EdgeInsets.only(left: 15, top: 10),
            margin: const EdgeInsets.fromLTRB(120,0,0,0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: AutoSizeText(
                        name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: AutoSizeText(
                        speciality,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            // margin: const EdgeInsets.fromLTRB(0,20,0,0),
            height: 40,
            width: 120,
            margin: const EdgeInsets.fromLTRB(250,80,0,0),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue.shade200,
                onPrimary: Colors.black,
                // minimumSize: Size(100,20),
                side: const BorderSide(color: Colors.blue),
              ),
              child: const Text(
                'Book',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
