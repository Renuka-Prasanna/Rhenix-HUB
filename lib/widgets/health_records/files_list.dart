import 'package:precision_hub/widgets/health_records/file_list_button.dart';
import 'package:precision_hub/widgets/health_records/file_type.dart';

late String filename = "";
late String extension;

class HomeController {
  final recent = const [
    FileDetail(
      name: "heartrate.jpeg",
      //size: 2000000,
      type: FileType.jpeg,
    ),
    FileDetail(
      name: "bloodpressure.pdf",
      //size: 5000000,
      type: FileType.pdf,
    ),
    FileDetail(
      name: "heartrate.png",
      //size: 2000000,
      type: FileType.png,
    ),
    FileDetail(
      name: "sugarlevel.docx",
      //size: 10000000,
      type: FileType.doc,
    ),
    FileDetail(
      name: "heartrate.png",
      //size: 2000000,
      type: FileType.png,
    ),
  ];
}
