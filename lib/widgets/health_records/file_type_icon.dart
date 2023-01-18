import 'package:flutter/material.dart';
import 'package:precision_hub/widgets/health_records/file_type.dart';

class FileTypeIcon extends StatelessWidget {
  const FileTypeIcon(this.type, {this.size = 50, Key? key}) : super(key: key);

  final double size;
  final FileType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.red,
        gradient: _gradient(type),
        borderRadius: BorderRadius.circular(size / 5),
      ),
      child: _icon(type),
    );
  }

  Widget _icon(FileType type) {
    late IconData iconData;

    switch (type) {
      case FileType.pdf:
        iconData = Icons.picture_as_pdf;
        break;
      case FileType.png:
        iconData = Icons.image;
        break;
      case FileType.jpeg:
        iconData = Icons.image;
        break;
      case FileType.doc:
        iconData = Icons.document_scanner;
        break;
      case FileType.jpg:
        iconData = Icons.image;
        break;
      case FileType.ics:
        iconData = Icons.calendar_month;
        break;
      default:
        iconData = Icons.extension;
        break;
    }

    return Icon(
      iconData,
      color: Colors.white,
      size: size / 2,
    );
  }

  LinearGradient _gradient(FileType type) {
    switch (type) {
      case FileType.pdf:
        return const LinearGradient(colors: [
          Colors.redAccent,
          Colors.red,
        ]);
      case FileType.png:
        return const LinearGradient(colors: [
          Colors.greenAccent,
          Colors.green,
        ]);
      case FileType.doc:
        return const LinearGradient(colors: [
          Colors.orangeAccent,
          Colors.orange,
        ]);
      case FileType.jpeg:
        return const LinearGradient(colors: [
          Colors.lightBlueAccent,
          Colors.lightBlue,
        ]);
      case FileType.jpg:
        return const LinearGradient(colors: [
          Colors.lightBlueAccent,
          Colors.lightBlue,
        ]);
      case FileType.ics:
        return const LinearGradient(colors: [
          Colors.lightBlueAccent,
          Colors.lightBlue,
        ]);
      default:
        return const LinearGradient(colors: [
          Colors.deepOrangeAccent,
          Colors.deepOrange,
        ]);
    }
  }
}
