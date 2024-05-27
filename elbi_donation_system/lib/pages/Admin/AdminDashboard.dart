import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/providers/FirebaseAdminProvider.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/Admin.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart'; // Adjust the import path accordingly
import 'dart:convert';
import 'package:mime/mime.dart';

class AdminDashboard extends StatelessWidget {
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
      // Add more prefixes for other file types if needed
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
    //final Admin adminData = ModalRoute.of(context)?.settings.arguments as Admin;
    Stream<QuerySnapshot> usersStream =
        context.watch<FirebaseAdminProvider>().users;
    return Scaffold(
      body: FormBanner(
        color: ProjectColors().purplePrimary,
        gradient: ProjectColors().purplePrimaryGradient,
        title: "ADMIN",
        subtitle: "WELCOME,",
        actions: [],
        widget: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 10,
            child: StreamBuilder(
              stream: usersStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error encountered! ${snapshot.error}"),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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

                return ListView.builder(
                  itemCount: organizations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        // organizations[index].proofOfLegitimacyBase64.isNotEmpty
                        //     ? {
                        //         for (var file in organizations[index]
                        //             .proofOfLegitimacyBase64)
                        //           OpenFilex.open(
                        //               _createFileFromString(file) as String?)
                        //       }
                        //     : {print("No proof of legitimacy uploaded")};
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Flexible(
                                            child: Text(
                                                organizations[index].name)),
                                        Flexible(
                                            child: Text(organizations[index]
                                                .description)),
                                        organizations[index]
                                                .proofOfLegitimacyBase64
                                                .isNotEmpty
                                            ? Flexible(
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        organizations.length,
                                                    itemBuilder: (context, i) {
                                                      return ListTile(
                                                          leading: Icon(
                                                              Icons.file_copy),
                                                          title: Text(
                                                              "Proof of Legitimacy ${index + 1}"),
                                                          onTap: () =>
                                                              openFileFromBase64String(
                                                                  organizations[
                                                                          index]
                                                                      .proofOfLegitimacyBase64[i]));
                                                    }),
                                              )
                                            : Container(),
                                        // ListView.builder(itemBuilder: (context, i) {
                                        //   return ListTile(
                                        //       leading:
                                        //           Icon(Icons.file_copy_rounded),
                                        //       title: TextButton(
                                        //         child: Text(organizations[index]
                                        //             .proofOfLegitimacyBase64[i]),
                                        //         onPressed: () {},
                                        //       ));
                                        // })
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      title: Text(organizations[index].name),
                      leading: Text(organizations[index].username),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Update the user's isApproved attribute to true
                          context
                              .read<FirebaseAdminProvider>()
                              .approveUser(organizations[index].userId);
                        },
                        child: Text('Approve'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        //     ElevatedButton(
        //       onPressed: () {
        //         Navigator.pushNamed(context, '/donors_list');
        //       },
        //       child: Text('Donors List'),
        //     ),
        //     ElevatedButton(
        //       onPressed: () {
        //         Navigator.pushNamed(context, '/organizations_list');
        //       },
        //       child: Text('Organization List'),
        //     ),
        //     ElevatedButton(
        //       onPressed: () {
        //         Navigator.pushNamed(context, '/donations_list');
        //       },
        //       child: Text('Donations List'),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
