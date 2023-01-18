import 'package:flutter/material.dart';
import 'package:precision_hub/fetchfunctions/fetch_vitals_function.dart';
import 'package:precision_hub/screens/Vitals/vitals_page.dart';

class FetchVitals extends StatefulWidget {
  String phone;
  FetchVitals({Key? key, required this.phone}) : super(key: key);

  @override
  State<FetchVitals> createState() => _FetchVitalsState();
}

class _FetchVitalsState extends State<FetchVitals> {
  late String img64;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomePage(),
                ));
          },
        ),
        title: const Text("Vitals History"),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.95,
          child: Card(
            child: FutureBuilder(
              future: fetchVitals(widget.phone),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                  );
                } else if (snapshot.data.length == 0) {
                  return const Center(
                    child: Text('No information here, please upload vitals'),
                  );
                } else
                  // ignore: curly_braces_in_flow_control_structures
                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.009),
                        tileColor: const Color.fromARGB(255, 230, 246, 254),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.020),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                               snapshot.data[i].vitalDate,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width:15),
                            Text(
                               snapshot.data[i].vitalTime,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // Text(
                            //   "Date: " + snapshot.data[i].vitalDate,
                            //   style: const TextStyle(fontWeight: FontWeight.bold),
                            // ),
                            // Text(
                            //   "Time: " + snapshot.data[i].vitalTime,
                            //   style: const TextStyle(fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                        minVerticalPadding: MediaQuery.of(context).size.height * 0.0017,
                        subtitle: Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.0030),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Systolic: " + snapshot.data[i].systolic,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Diastolic: " + snapshot.data[i].diastolic,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Heart Rate: " + snapshot.data[i].heartRate,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Sugar Level: " + snapshot.data[i].sugarLevel,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                        onTap: () {},
                      );
                    },
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}
