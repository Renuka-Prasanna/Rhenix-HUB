import 'dart:convert';
import 'package:http/http.dart';
import 'package:precision_hub/models/filesModel.dart';

class FetchFile {
  static Future<List<Files>> fetchFiles({required String phone, required String path}) async {
    Uri url = Uri.parse(path);
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"userphone": "$phone"}';
    Response response = await post(url, headers: headers, body: json);
    var jsonData = jsonDecode(response.body);
    List<Files> files = [];
    for (var u in jsonData) {
      if (u['Extension'] != 'ics') {
        Files file = Files(u['name'], u['Extension'], u['userphone'], u['dateTime']);
        files.add(file);
      }
    }
    files.sort(
      (a, b) => b.dateTime.compareTo(a.dateTime),
    );
    return files;
  }
}
