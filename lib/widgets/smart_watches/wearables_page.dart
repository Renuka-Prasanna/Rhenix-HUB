import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:precision_hub/models/vitalsModel.dart';
import 'package:precision_hub/screens/Login/login_page.dart';
import 'package:precision_hub/screens/qr_scan_page.dart';
import 'package:precision_hub/widgets/User_Provider.dart';
import 'package:precision_hub/widgets/chart/hrData.dart';
import 'package:precision_hub/widgets/chart/sugarData.dart';
import 'package:precision_hub/widgets/custom_widgets/connect_wearabales.dart';
import 'package:precision_hub/widgets/custom_widgets/home_top_splash.dart';
import 'package:precision_hub/widgets/custom_widgets/nav_drawer.dart';

final user = UserProvider();

class WearablesPage extends StatefulWidget {
  const WearablesPage({Key? key}) : super(key: key);

  @override
  State<WearablesPage> createState() => _WearablesPageState();
}

class _WearablesPageState extends State<WearablesPage> {
  static const int NO_OF_DAYS = 7;
  final _storage = const FlutterSecureStorage();
  List<SugarLevel> sugarLevelList = [];
  List<HeartRate> heartRateList = [];
  int lengthOfList = 0;
  int lengthOfHrList = 0;
  DateTime currDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    updateVitals();
  }

  void updateVitals() async {
    String? phone = await _storage.read(key: 'Phone');
    List<Vitals> vitalsList = await fetchVitals(phone!);
    setState(
      () {
        vitalsList = List<DateTime>.generate(NO_OF_DAYS, (index) => DateTime.now().subtract(Duration(days: NO_OF_DAYS - index))).map<Vitals>((date) {
          try {
            return vitalsList.where((vital) => vital.vitalDate == DateFormat('MMMM d, y').format(date)).first;
          } on StateError catch (_, error) {
            print("no vital record found for $date, so padding with dummy data");
            return Vitals("0", "0", "0", "0", DateFormat('MMMM d, y').format(date), "0:00");
          }
        }).toList();
        sugarLevelList = vitalsList
            .map(
              (vital) => SugarLevel(
                month: DateFormat('E').format(DateFormat('MMMM d, y').parse(vital.vitalDate)),
                sugarLevel: int.parse(vital.sugarLevel),
                barColor: charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor),
              ),
            )
            .toList();
        heartRateList = vitalsList
            .map(
              (vital) => HeartRate(
                month: DateFormat('E').format(DateFormat('MMMM d, y').parse(vital.vitalDate)),
                sugarLevel: int.parse(vital.heartRate),
                barColor: charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor),
              ),
            )
            .toList();

        print(sugarLevelList);

        lengthOfList = sugarLevelList.length;
        lengthOfHrList = heartRateList.length;
      },
    );
  }

  Future<List<Vitals>> fetchVitals(String phone) async {
    Uri url = Uri.parse('https://8y984iapei.execute-api.ap-south-1.amazonaws.com/ghp_vitals_new');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"userphone": "$phone"}';
    Response response = await post(url, headers: headers, body: json);

    var jsonData = jsonDecode(response.body);

    List<Vitals> vitals = [];
    for (var u in jsonData) {
      Vitals vital = Vitals(u['Systolic'], u['Diastolic'], u['SugarLevel'], u['HeartRate'], u['VitalDate'], u['VitalTime']);
      vitals.add(vital);
    }

    vitals.sort((a, b) => (combineDateTime(b).compareTo(combineDateTime(a))));
    return vitals;
  }

  DateTime combineDateTime(Vitals vital) {
    DateTime date = DateFormat('MMMM d, y').parse(vital.vitalDate);
    TimeOfDay time = TimeOfDay.fromDateTime(DateFormat.jm().parse(vital.vitalTime));
    return date.add(Duration(hours: time.hour, minutes: time.minute));
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
      body: ListView(
        children: [
          const HomeTopSplash(imagePath: 'assets/images/curescience_logo.png'),
          const ConnectWearables(),
          HRChart(
            data: heartRateList,
            lengthOfHrList: lengthOfHrList,
          ),
          BarChart(
            data: sugarLevelList,
            length: lengthOfList,
          ),
        ],
      ),
    );
  }
}
