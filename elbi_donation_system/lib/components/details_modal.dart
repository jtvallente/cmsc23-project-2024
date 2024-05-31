import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';

class DetailsModal extends StatelessWidget {
  final String title;
  final String description;
  final Widget body;
  final Widget action;

  const DetailsModal(
      {super.key,
      required this.title,
      required this.body,
      required this.action,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [Text(title), Text(description), body, action],
                ),
              ],
            )),
      ),
    );
  }
}
