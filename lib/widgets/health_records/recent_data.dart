import 'package:flutter/material.dart';
import 'package:precision_hub/widgets/health_records/file_list_button.dart';
import 'package:precision_hub/widgets/health_records/header_text.dart';

class Recent extends StatelessWidget {
  Recent({required this.data, Key? key}) : super(key: key);

  final List<FileDetail> data;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderText('File Explorer'),
        const SizedBox(height: 10),
        ...data
            .map(
              (e) => FileListButton(
                data: e,
                onPressed: () {},
              ),
            )
            .toList()
      ],
    );
  }
}
