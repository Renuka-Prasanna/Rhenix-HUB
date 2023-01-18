import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:precision_hub/fetchfunctions/fetch_file_function.dart';
import 'package:precision_hub/models/filesModel.dart';
import 'package:precision_hub/screens/Files/file_upload_page.dart';
import 'package:precision_hub/widgets/health_records/file_type.dart';
import 'package:precision_hub/widgets/health_records/file_type_icon.dart';

late String img64;

class NewFiles extends StatefulWidget {
  NewFiles({Key? key}) : super(key: key);

  @override
  State<NewFiles> createState() => _NewFilesState();
}

class _NewFilesState extends State<NewFiles> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getuser().then((id) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Card(
        child: FutureBuilder<List<Files>>(
          future: FetchFile.fetchFiles(phone: phone, path: "https://d1k0s0oz15.execute-api.ap-south-1.amazonaws.com/GHPfetch"),
          builder: (context, AsyncSnapshot<List<Files>> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No files here, please upload your files'),
              );
            } else
              // ignore: curly_braces_in_flow_control_structures
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  return ListTile(
                      leading: FileTypeIcon(FileType.values.byName(snapshot.data![i].extension)),
                      tileColor: const Color.fromARGB(255, 230, 246, 254),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(snapshot.data![i].name),
                      onTap: () {
                        _downloadFile("https://ghpuploads.s3.ap-south-1.amazonaws.com/${snapshot.data![i].userphone}/${snapshot.data![i].name}",
                            snapshot.data![i].name);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        highlightColor: Colors.red,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Are you sure you want to delete?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text(
                                      'Yes, Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      deleteFile(snapshot.data![i].userphone, snapshot.data![i].name);

                                    //  Navigator.pop(context);
                                    //  Navigator.of(context).pop();
                                    //   await Future.delayed(const Duration(seconds: 2));
                                //      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const FileUploadPage()));
                                      //  Navigator.popUntil(context, MaterialPageRoute(builder: (context) => const FileUploadPage()) => false);
                                      // Navigator.popUntil(context, MaterialPageRoute(
                                          //builder: (context) =>
                                         // const FileUploadPage()), (route) => false);
                                   //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const FileUploadPage()), (Route<dynamic> route) => route is FileUploadPage);
                                   //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const FileUploadPage()));
                                   //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                                   //      return const FileUploadPage(); }));
                                   //    await Future.delayed(const Duration(seconds: 1));
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => const FileUploadPage()),
                                      // );
                                      // Navigator.of(context).pop();

                                      // await Fluttertoast.showToast(
                                      //     msg: "Deleted Successfully",
                                      //     toastLength: Toast.LENGTH_LONG,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     timeInSecForIosWeb: 1,
                                      //     backgroundColor: Colors.red,
                                      //     textColor: Colors.white,
                                      //     fontSize: 16.0);
                                    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                                    //       return const FileUploadPage(); }));
                                    //
                                     },
                                  ),
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ));
                },
              );
          },
        ),
      ),
    );
  }

  getuser() async {
    final currentUser = await _storage.readAll();
    phone = currentUser['Phone'];
    print(phone);
    // curruser = currentUser['FullName'];
  }

  //to open file from the app
  static var httpClient = HttpClient();
  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getExternalStorageDirectory())!.path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    OpenFile.open(file.path);
    return file;
  }

  //function to delete file from the s3 as well as DB
  void deleteFile(String number, String filename) async {
    Uri url = Uri.parse('https://fb8xlu0ase.execute-api.ap-south-1.amazonaws.com/GHPdelfiles');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"phone_number": "$number", "filename":"$filename" }';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const FileUploadPage()));
    await Future.delayed(const Duration(seconds: 1));
  //  Navigator.of(context).pop();
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => const FileUploadPage()),
  //   );
 //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FileUploadPage()));
    Fluttertoast.showToast(
        msg: "Deleted Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
