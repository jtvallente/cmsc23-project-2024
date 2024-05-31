import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elbi_donation_system/providers/FirebaseAuthUserProvider.dart';
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart';
import 'package:elbi_donation_system/models/donation.dart'; // Import Donation model

class DonorDashboard extends StatefulWidget {
  @override
  _DonorDashboardState createState() => _DonorDashboardState();
}

class _DonorDashboardState extends State<DonorDashboard> {
  Future<void>? _futureDonations;

  @override
  void initState() {
    super.initState();
    final firebaseUid =
        Provider.of<FirebaseAuthUserProvider>(context, listen: false)
                .currentUserId ??
            '';
    _futureDonations = _fetchUserDonations(firebaseUid);
  }

  Future<void> _fetchUserDonations(String uid) async {
    final userProvider =
        Provider.of<FirebaseUserProvider>(context, listen: false);
    await userProvider.fetchUserDonations(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthUserProvider>(
      builder: (context, authProvider, _) {
        String userName = authProvider.currentUser?.name ?? 'User';
        String firebaseUid = authProvider.currentUserId ?? '';
        print("Current User ID: $firebaseUid");

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
            isRoot: true,
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
                    Navigator.pushNamed(context, '/donor_profile',
                        arguments: authProvider.currentUser);
                  },
                  child: Text('Profile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/donor_organization_list');
                  },
                  child: Text('View Organizations'),
                ),
                Consumer<FirebaseUserProvider>(
                  builder: (context, userProvider, _) {
                    return FutureBuilder<void>(
                      future: _futureDonations,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        final donations = userProvider.userDonations;
                        if (donations.isEmpty) {
                          return Center(child: Text('No donations found'));
                        }

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
                                    '/donor_donation_details',
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
