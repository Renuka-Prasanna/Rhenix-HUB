import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:precision_hub/widgets/health_records/custom_button.dart';

class Category2 extends StatefulWidget {
  Category2({Key? key}) : super(key: key);

  final buttons = [
    CustomButtonWatches(
      icon: Icons.picture_as_pdf,
      color: Colors.redAccent,
      label: "PDF",
      onPressed: () {
        _selectFile(['pdf']);
      },
    ),
    CustomButtonWatches(
      icon: Icons.document_scanner,
      color: Colors.orangeAccent,
      label: "Doc",
      onPressed: () {
        _selectFile(['doc']);
      },
    ),
    CustomButtonWatches(
      icon: Icons.image,
      color: Colors.lightBlue,
      label: "Image",
      onPressed: () {
        _selectFile(['jpeg', 'png']);
      },
    ),
  ];

  @override
  State<Category2> createState() => _Category2State();

  static Future<FilePickerResult> _selectFile(List<String> allowedExtension) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtension,
    );
    return Future.value(result);
  }
}

class _Category2State extends State<Category2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: widget.buttons
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: e,
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
