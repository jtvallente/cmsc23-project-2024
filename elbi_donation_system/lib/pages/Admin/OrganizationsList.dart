import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:elbi_donation_system/components/details_modal.dart';
import 'package:elbi_donation_system/components/section_header.dart';
import 'package:elbi_donation_system/components/stream_list_tile.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/providers/FirebaseAdminProvider.dart';
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart';
import 'package:flutter/widgets.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class OrganizationsListPage extends StatefulWidget {
  final Stream<QuerySnapshot> organizationsStream;
  const OrganizationsListPage({required this.organizationsStream, super.key});

  @override
  _OrganizationsListPageState createState() => _OrganizationsListPageState();
}

class _OrganizationsListPageState extends State<OrganizationsListPage> {
  //TODO: create separate interface for reused functions
  String getFileType(String base64String) {
    final prefix = base64String.substring(0, 15);
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

  nullFunc() {}

  @override
  void initState() {
    super.initState();
    // Initialize the organization stream
    Provider.of<FirebaseUserProvider>(context, listen: false)
        .fetchAllOrganizations();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot>? organizationsStream =
        context.watch<FirebaseUserProvider>().organizationStream;

    return Scaffold(
      appBar: AppBar(
        title: Text('Organizations List'),
      ),
      body: Column(
        children: [
          SectionHeader(
              title: "All Organizations",
              icon: Icons.groups,
              color: ProjectColors().purplePrimary),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: StreamBuilder(
              stream: widget.organizationsStream,
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
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No Orgs Found"),
                  );
                }

                List<User> organizations = [];
                snapshot.data!.docs.forEach((doc) {
                  User user = User.fromJson(doc.data() as Map<String, dynamic>);
                  user.userId = doc.id;
                  organizations.add(user);
                });

                return ListView.builder(
                  itemCount: organizations.length,
                  itemBuilder: (context, index) {
                    return StreamListTile(
                        color: organizations[index].isApproved
                            ? ProjectColors().greenPrimary
                            : ProjectColors().yellowPrimary,
                        modal: DetailsModal(
                            title: organizations[index].name,
                            description: organizations[index].description,
                            body: Column(
                              children: [
                                Text(organizations[index].password),
                                Text(organizations[index].email),
                                Text(organizations[index].contactNo)
                              ],
                            ),
                            action: Container()),
                        leading: Icon(Icons.groups_2_sharp),
                        title: Text(organizations[index].name),
                        trailing: Text(organizations[index].isApproved
                            ? "Approved"
                            : "For Review"));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
