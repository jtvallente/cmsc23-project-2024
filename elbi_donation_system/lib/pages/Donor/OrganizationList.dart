import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/components/section_header.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // To decode the base64 image

class DonorOrganizationList extends StatefulWidget {
  @override
  _DonorOrganizationListState createState() => _DonorOrganizationListState();
}

class _DonorOrganizationListState extends State<DonorOrganizationList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FirebaseUserProvider>(context, listen: false)
          .fetchAllOrganizations();
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot>? organizationsStream =
        context.watch<FirebaseUserProvider>().organizationStream;

    return organizationsStream == null
        ? Center(child: CircularProgressIndicator())
        : Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              SectionHeader(
                  title: "Donations",
                  icon: Icons.groups,
                  color: ProjectColors().greenPrimary),
              SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: StreamBuilder(
                    stream: organizationsStream,
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
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text("No Orgs Found"),
                        );
                      }

                      List<User> organizations = [];
                      snapshot.data!.docs.forEach((doc) {
                        User user =
                            User.fromJson(doc.data() as Map<String, dynamic>);
                        user.userId = doc.id;
                        organizations.add(user);
                      });

                      return ListView.builder(
                        itemCount: organizations.length,
                        itemBuilder: (context, index) {
                          // Extract the profile picture from the array or use a placeholder
                          List<dynamic> proofOfLegitimacyBase64 =
                              organizations[index].proofOfLegitimacyBase64;
                          String profilePicture;
                          if (proofOfLegitimacyBase64.isNotEmpty) {
                            profilePicture = proofOfLegitimacyBase64[0];
                          } else {
                            profilePicture =
                                ''; // Placeholder image base64 or URL
                          }

                          return ListTile(
                            leading: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage: proofOfLegitimacyBase64
                                          .isNotEmpty
                                      ? MemoryImage(
                                          base64Decode(profilePicture))
                                      : AssetImage(
                                              'assets/placeholder_image.png')
                                          as ImageProvider,
                                ),
                                if (organizations[index].openForDonations)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.green,
                                      size: 12,
                                    ),
                                  ),
                              ],
                            ),
                            title: Text(
                              organizations[index].name,
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              organizations[index].username,
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/donor_org_details',
                                      arguments: organizations[index],
                                    );
                                  },
                                  child: Text('View'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (organizations[index].openForDonations) {
                                      Navigator.pushNamed(
                                        context,
                                        '/make_donation',
                                        arguments: {
                                          'OrganizationId':
                                              organizations[index].userId,
                                        },
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Org is not open for donations"),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text('Donate'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ))
            ]));
  }
}
