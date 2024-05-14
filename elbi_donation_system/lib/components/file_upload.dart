import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';

class FormFileUpload extends StatefulWidget {
  final String label;
  final Function() onTap;
  const FormFileUpload({required this.label, required this.onTap, super.key});

  @override
  State<FormFileUpload> createState() => _FormFileUploadState();
}

class _FormFileUploadState extends State<FormFileUpload> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.label),
          ElevatedButton(
              onPressed: () {},
              child: const Row(children: [
                Icon(Icons.upload_file),
                SizedBox(
                  width: 10,
                ),
                Text("Upload Files")
              ]))
        ],
      ),
    );
  }
}
