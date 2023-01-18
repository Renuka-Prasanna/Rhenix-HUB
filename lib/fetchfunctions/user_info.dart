import 'dart:convert';
import 'package:http/http.dart';
import 'package:precision_hub/models/userModel.dart';

class UserInfo {
  static Future<UserData> fetchUserInfo(String phone) async {
    Uri url = Uri.parse('https://ebucmtnqn5.execute-api.ap-south-1.amazonaws.com/Seniorcitizensignup/');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"Phone": "$phone"}';
    Response response = await post(url, headers: headers, body: json);
    var jsonData = jsonDecode(response.body);
    // print($jsondata);
    UserData userData =
        UserData(jsonData[0]['Users_Pavan'], jsonData[0]['FullName'], jsonData[0]['Email'], jsonData[0]['Zipcode'], jsonData[0]['Gender']);
    return userData;
  }

  static Future<UserAdditionalInfo> fetchUserAdditionInfo(String phone) async {
    Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/additionalinfo/fetchadditionalinfo');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"Phone": "$phone"}';
    Response response = await post(url, headers: headers, body: json);
    var jsonData = jsonDecode(response.body);
    UserAdditionalInfo userAdditinalData = UserAdditionalInfo(jsonData[0]['Feet'], jsonData[0]['Inch'].toString(), jsonData[0]['Meter'],
        jsonData[0]['Centimeter'], jsonData[0]['Weight'].toString(), jsonData[0]['HeightUnit'], jsonData[0]['WeightUnit']);
    return userAdditinalData;
  }


  static Future<bool> updateAdditionalInfo(
      String phone, String heightUnit, String feet, String inch, String meter, String cm, String weightUnit, String weight) async {
    Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/additionalinfo/editadditionalinfo');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"Phone": "$phone" , "HeightUnit":"$heightUnit","Feet":"$feet", "Inch": $inch,"Meter": "$meter" , "Cm":"$cm","WeightUnit":"$weightUnit", "Weight": $weight}';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    return true;
  }

  // static Future<UserData> fetch_UserInfo(String orCode) async {
  //   Uri url = Uri.parse('https://ebucmtnqn5.execute-api.ap-south-1.amazonaws.com/Seniorcitizensignup/');
  //   Map<String, String> headers = {"Content-type": "application/json"};
  //   String json = '{"Phone": "$orCode"}';
  //   Response response = await post(url, headers: headers, body: json);
  //   var jsonData = jsonDecode(response.body);
  //   UserData userData =
  //   UserData(jsonData[0]['Users_Pavan'], jsonData[0]['FullName'], jsonData[0]['Email'], jsonData[0]['Zipcode'], jsonData[0]['Gender']);
  //   return userData;
  // }
  //
  // static Future<UserAdditionalInfo> fetch_UserAdditionInfo(String orCode) async {
  //   Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/additionalinfo/fetchadditionalinfo');
  //   Map<String, String> headers = {"Content-type": "application/json"};
  //   String json = '{"Phone": "$orCode"}';
  //   Response response = await post(url, headers: headers, body: json);
  //   var jsonData = jsonDecode(response.body);
  //   UserAdditionalInfo userAdditinalData = UserAdditionalInfo(jsonData[0]['Feet'], jsonData[0]['Inch'].toString(), jsonData[0]['Meter'],
  //       jsonData[0]['Centimeter'], jsonData[0]['Weight'].toString(), jsonData[0]['HeightUnit'], jsonData[0]['WeightUnit']);
  //   return userAdditinalData;
  // }
  //
  //
  // static Future<bool> updateUserInfo(
  //     String orCode, String heightUnit, String feet, String inch, String meter, String cm, String weightUnit, String weight) async {
  //   Uri url = Uri.parse('https://ikgivv8zsc.execute-api.ap-south-1.amazonaws.com/new_appointment_GHP/additionalinfo/editadditionalinfo');
  //   Map<String, String> headers = {"Content-type": "application/json"};
  //   String json =
  //       '{"Phone": "$orCode" , "HeightUnit":"$heightUnit","Feet":"$feet", "Inch": $inch,"Meter": "$meter" , "Cm":"$cm","WeightUnit":"$weightUnit", "Weight": $weight}';
  //   Response response = await post(url, headers: headers, body: json);
  //   int statusCode = response.statusCode;
  //   return true;
  // }
}
