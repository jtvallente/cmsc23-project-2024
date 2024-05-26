import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elbi_donation_system/providers/FirebaseAuthUserProvider.dart';
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/models/donation.dart';

class OrganizationDashboard extends StatefulWidget {
  @override
  _OrganizationDashboardState createState() => _OrganizationDashboardState();
}

class _OrganizationDashboardState extends State<OrganizationDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firebaseUid =
          Provider.of<FirebaseAuthUserProvider>(context, listen: false)
                  .currentUserId ??
              '';
      _fetchUserDonations(firebaseUid);
    });
  }

  Future<void> _fetchUserDonations(String uid) async {
    final userProvider =
        Provider.of<FirebaseUserProvider>(context, listen: false);
    await userProvider.getAllUserDonations(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthUserProvider>(
      builder: (context, authProvider, _) {
        String userName = authProvider.currentUser?.name ?? 'User';
        String firebaseUid = authProvider.currentUserId ?? '';
        return Scaffold(
          body: FormBanner(
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu, color: Colors.white),
              ),
            ],
            gradient: ProjectColors().greenPrimaryGradient,
            color: ProjectColors().greenPrimary,
            title: userName,
            subtitle: "Welcome,",
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Donations made by the user',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/organization_profile',
                      arguments: authProvider.currentUser,
                    );
                  },
                  child: Text('Profile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/make_donation_drive',
                      arguments: authProvider.currentUser,
                    );
                  },
                  child: Text('Make Donation Drive'),
                ),
                Consumer<FirebaseUserProvider>(
                  builder: (context, userProvider, _) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: userProvider.organizationDonationsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No donations found'));
                        }

                        final donations = snapshot.data!.docs.map((doc) {
                          return Donation.fromJson(
                              doc.data() as Map<String, dynamic>);
                        }).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: donations.map((donation) {
                            return ListTile(
                              title: Text(donation.donationId),
                              subtitle: Text('Donor ID: ${donation.donorId}'),
                              trailing: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/organization_donation_details',
                                    arguments: donation,
                                  );
                                },
                                child: Text('View'),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
