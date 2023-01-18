import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:precision_hub/screens/Registration/registration_page.dart';
import '../fetchfunctions/get_code.dart';

var password;

const _storage = FlutterSecureStorage();

class UserProvider {
  Future<bool> signIn(String phone) async {
    try {
      Uri url = Uri.parse('https://ebucmtnqn5.execute-api.ap-south-1.amazonaws.com/Seniorcitizensignup/');
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"Phone": "$phone"}';
      Response response = await post(url, headers: headers, body: json);
      print("$phone");
      int statusCode = response.statusCode;
      var list = jsonDecode(response.body);
      if (list.length == 0) {
        print("test-------------------------------------222222222---------------");
        await _storage.deleteAll();
        await _storage.write(key: "status", value: "Unauthenticated");
        final all = await _storage.readAll();

        return false;
      } else if (list[0]['Users_Pavan'] == "$phone") {

        print("test----------------------SignIN-Done-------444444444------------");
        if (phone == '7777771414') {
          confirmed(phone);
        }

        await _storage.deleteAll();
        await _storage.write(key: "Phone", value: list[0]['Users_Pavan']);
        await _storage.write(key: "UserName", value: list[0]['FullName']);
        await _storage.write(key: "Email", value: list[0]['Email']);
        await _storage.write(key: "Zipcode", value: list[0]['Zipcode']);
        await _storage.write(key: "finalcode", value: list[0]['finalcode']);
        await _storage.write(key: "status", value: "Authenticated");
        final all = await _storage.readAll();
        print(list[0]);
        print(list[0]['Users_Pavan']);
        print(list[0]['Email']);
        print(list[0]['FullName']);
        print(list[0]['Country_Code']);
        return true;
      } else {
        print("test----------------------------------------444444444------------");
        await _storage.deleteAll();
        await _storage.write(key: "status", value: "Unauthenticated");
        final all = await _storage.readAll();
        return false;
      }
    }
    catch (e) {
      print("test--------------------------------------55555555--------");
      await _storage.deleteAll();
      await _storage.write(key: "status", value: "Unauthenticated");
      final all = await _storage.readAll();

      return false;
    }
  }
  Future<bool> signInCode(String Phone1) async {
    try {
      Uri url = Uri.parse('https://ebucmtnqn5.execute-api.ap-south-1.amazonaws.com/Seniorcitizensignup/');
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"Phone": "$Phone1"}';
      Response response = await post(url, headers: headers, body: json);
      print("$Phone1");
      int statusCode = response.statusCode;
      var list = jsonDecode(response.body);
      if (list.length == 0) {
        print("test-------------------------------------222222222---------------");
        await _storage.deleteAll();
        await _storage.write(key: "status", value: "Unauthenticated");
        final all = await _storage.readAll();

        return false;
      } else if (list[0]['Users_Pavan'] == "$Phone1") {

        print("test----------------------SignIN-Done-------444444444------------");
        if (Phone1 == '7777771414') {
          confirmedcode(Phone1);
        }

        await _storage.deleteAll();
        await _storage.write(key: "Phone", value: list[0]['Users_Pavan']);
        await _storage.write(key: "UserName", value: list[0]['FullName']);
        await _storage.write(key: "Email", value: list[0]['Email']);
        await _storage.write(key: "Zipcode", value: list[0]['Zipcode']);
        await _storage.write(key: "finalcode", value: list[0]['finalcode']);
        await _storage.write(key: "status", value: "Authenticated");
        final all = await _storage.readAll();
        print(list[0]);
        print(list[0]['Users_Pavan']);
        print(list[0]['Email']);
        print(list[0]['FullName']);
        print(list[0]['Country_Code']);
        return true;
      } else {
        print("test----------------------------------------444444444------------");
        await _storage.deleteAll();
        await _storage.write(key: "status", value: "Unauthenticated");
        final all = await _storage.readAll();
        return false;
      }
    }
    catch (e) {
      print("test--------------------------------------55555555--------");
      await _storage.deleteAll();
      await _storage.write(key: "status", value: "Unauthenticated");
      final all = await _storage.readAll();

      return false;
    }
  }

  Future<bool> signUp(String phone, String fullName, String age, String zipcode, String gender, String countryCode, String email,String finalcode, String ComName) async {
    try {
      Uri url = Uri.parse('https://ebucmtnqn5.execute-api.ap-south-1.amazonaws.com/Seniorcitizensignup/');

      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"Phone": "$phone" }';
      Response response = await post(url, headers: headers, body: json);
      int statusCode = response.statusCode;
      var list = jsonDecode(response.body);
      if (list.length == 0) {
        Uri url = Uri.parse("https://0p6tpjwrhi.execute-api.ap-south-1.amazonaws.com/Stage_10");

        Map<String, String> headers1 = {"Content-type": "application/json"};
        String json1 =
            '{"Users_Pavan": "$phone","FullName": "$fullName","Age": "$age","Zipcode": "$zipcode","Gender": "$gender","Country_Code": "$countryCode","Email": "$email","finalcode": "$finalcode","ComName":"$ComName"}';
        Response response1 = await post(url, headers: headers1, body: json1);
        print("$phone");
        print("$countryCode");
        var list1 = jsonDecode(response1.body);
        return true;
      } else {
        list = [];
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> signOut() async {
    await _storage.deleteAll();
    await _storage.write(key: "status", value: "Unauthenticated");
    final all = await _storage.readAll();
    return true;
  }

  Future<bool> vitals(
    String phoneVitals,
    String systolic,
    String diastolic,
    String sugarLevel,
    String heartRate,
    String vitalDate,
    String vitalTime,
  ) async {
    var phone = phoneVitals + vitalDate + vitalTime;
    Map<String, String> headers1 = {"Content-type": "application/json"};
    String json1 =
        '{"Users_Pavan": "$phone","Systolic": "$systolic","Diastolic": "$diastolic","SugarLevel": "$sugarLevel","HeartRate": "$heartRate","VitalDate": "$vitalDate","VitalTime": "$vitalTime","Phone": "$phoneVitals"}';
    Uri url = Uri.parse('https://91i76ubsgh.execute-api.ap-south-1.amazonaws.com/Ghp_vitals');
    Response response = await post(url, headers: headers1, body: json1);
    int statusCode = response.statusCode;
    return true;
  }

  Future<bool> additionalInfo(
    String phone,
    String heightUnit,
    String weightUnit,
    String ft,
    String inch,
    String m,
    String cm,
    String weight,
  ) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"Phone": "$phone","HeightUnit": "$heightUnit","WeightUnit": "$weightUnit","Feet": "$ft","Inch": "$inch","Meter": "$m","Centimeter": "$cm","Weight": "$weight"}';
    Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/additionalinfo');
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    return true;
  }

  Future<bool> confirmed(String phone) async {
    Uri url = Uri.parse('https://ebucmtnqn5.execute-api.ap-south-1.amazonaws.com/Seniorcitizensignup/');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"Phone": "$phone"}';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    var list = jsonDecode(response.body);
    await _storage.deleteAll();
    await _storage.write(key: "Phone", value: list[0]['Users_Pavan']);
    await _storage.write(key: "Zipcode", value: list[0]['Zipcode']);
    await _storage.write(key: "Age", value: list[0]['Age']);
    await _storage.write(key: "FullName", value: list[0]['FullName']);
    await _storage.write(key: "Gender", value: list[0]['Gender']);
    await _storage.write(key: "Country_Code", value: list[0]['Country_Code']);
    await _storage.write(key: "status", value: "Authenticated");
    final all = await _storage.readAll();
    return true;
  }
  Future<bool> confirmedcode(String Phone1) async {
    Uri url = Uri.parse('https://ebucmtnqn5.execute-api.ap-south-1.amazonaws.com/Seniorcitizensignup/');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"Phone": "$Phone1"}';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    var list = jsonDecode(response.body);
    await _storage.deleteAll();
    await _storage.write(key: "Phone", value: list[0]['Users_Pavan']);
    await _storage.write(key: "Zipcode", value: list[0]['Zipcode']);
    await _storage.write(key: "Age", value: list[0]['Age']);
    await _storage.write(key: "FullName", value: list[0]['FullName']);
    await _storage.write(key: "Gender", value: list[0]['Gender']);
    await _storage.write(key: "Country_Code", value: list[0]['Country_Code']);
    await _storage.write(key: "finalcode", value: list[0]['finalcode']);
    await _storage.write(key: "status", value: "Authenticated");
    final all = await _storage.readAll();
    return true;
  }
}
