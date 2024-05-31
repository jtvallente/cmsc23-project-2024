import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/components/details_modal.dart';
import 'package:elbi_donation_system/components/section_header.dart';
import 'package:elbi_donation_system/components/stream_list_tile.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/providers/FirebaseAdminProvider.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AdminPendingOrgsPage extends StatefulWidget {
  final Stream<QuerySnapshot> usersStream;
  const AdminPendingOrgsPage({required this.usersStream, super.key});

  @override
  State<AdminPendingOrgsPage> createState() => _AdminPendingOrgsPageState();
}

class _AdminPendingOrgsPageState extends State<AdminPendingOrgsPage> {
  String getFileType(String base64String) {
    final prefix = base64String.substring(0, 15); // Adjust length as needed
    switch (prefix) {
      case '/9j/4AA':
        return '.jpeg';
      case 'iVBORw0KGgo':
        return '.png';
      case 'R0lGODdh':
        return '.gif';
      case 'UklGR':
        return '.webp';
      case 'JVBERi0':
        return '.pdf';
      default:
        return 'unknown';
    }
  }

  openFileFromBase64String(encoded) async {
    final encodedStr = encoded;
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getTemporaryDirectory()).path;
    File file = File("$dir/" +
        DateTime.now().millisecondsSinceEpoch.toString() +
        getFileType(encoded));
    await file.writeAsBytes(bytes);
    OpenFilex.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.usersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text("No Users Found"),
          );
        }

        List<User> organizations = [];
        for (var doc in snapshot.data!.docs) {
          User user = User.fromJson(doc.data() as Map<String, dynamic>);
          user.userId = doc.id;
          //organizations.add(user);
          if (user.isOrganization == true && user.isApproved == false) {
            organizations.add(user);
          }
          print(organizations);
        }

        return Container(
          height: MediaQuery.of(context).size.height / 2,
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                    title: "Organizations\nPending Approval",
                    icon: Icons.pending_actions_rounded,
                    color: ProjectColors().purplePrimary),
                organizations.length == 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: organizations.length,
                          itemBuilder: (context, index) {
                            return StreamListTile(
                                color: ProjectColors().yellowPrimary,
                                modal: DetailsModal(
                                    title: organizations[index].name,
                                    description:
                                        organizations[index].description,
                                    body: organizations[index]
                                            .proofOfLegitimacyBase64
                                            .isNotEmpty
                                        ? SingleChildScrollView(
                                            child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: organizations[index]
                                                .proofOfLegitimacyBase64
                                                .length,
                                            itemBuilder: (context, i) {
                                              return Card(
                                                child: ListTile(
                                                    leading:
                                                        Icon(Icons.file_copy),
                                                    title: Text(
                                                        "Proof of Legitimacy ${index + 1}"),
                                                    onTap: () =>
                                                        openFileFromBase64String(
                                                            organizations[index]
                                                                    .proofOfLegitimacyBase64[
                                                                i])),
                                              );
                                            },
                                          ))
                                        : Text(
                                            "No proof of legitimacy uploaded"),
                                    action: PrimaryButton(
                                        label: "Approve",
                                        onTap: () => context
                                            .read<FirebaseAdminProvider>()
                                            .approveUser(
                                                organizations[index].userId),
                                        gradient: ProjectColors()
                                            .greenPrimaryGradient,
                                        fillWidth: true)),
                                leading: Icon(Icons.groups_2_sharp),
                                title: Text(organizations[index].name),
                                trailing: Text(organizations[index].isApproved
                                    ? "Approved"
                                    : "For Review"));
                          },
                        ),
                      )
                    : Text("There are no pending organizations left"),
              ],
            ),
          ),
        );
      },
    );
  }
}
