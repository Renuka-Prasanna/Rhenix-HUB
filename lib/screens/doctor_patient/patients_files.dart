import 'package:flutter/material.dart';
import 'package:precision_hub/utils/patients_utils.dart';
import 'package:precision_hub/widgets/health_records/file_type.dart';
import 'package:precision_hub/widgets/health_records/file_type_icon.dart';

class PatientsFiles extends StatefulWidget {
  String phone;
  PatientsFiles({Key? key, required this.phone}) : super(key: key);

  @override
  State<PatientsFiles> createState() => _PatientsFilesState();
}

class _PatientsFilesState extends State<PatientsFiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text("Files"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: FutureBuilder(
              future: PatientInfo.fetchFiles(widget.phone),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No files here, please upload your files'),
                  );
                } else {
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                          leading: FileTypeIcon(FileType.values.byName(snapshot.data![i].extension)),
                          tileColor: Color.fromARGB(255, 230, 246, 254),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(snapshot.data![i].name),
                          onTap: () {
                            PatientInfo.downloadFile(
                                "https://ghpuploads.s3.ap-south-1.amazonaws.com/${snapshot.data![i].userphone}/${snapshot.data![i].name}",
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
                                        onPressed: () {
                                          PatientInfo.deleteFile(snapshot.data![i].userphone, snapshot.data![i].name, context);
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
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
