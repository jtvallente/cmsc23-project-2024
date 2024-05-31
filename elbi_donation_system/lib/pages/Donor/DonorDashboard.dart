import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/pages/Donor/DonorDonations.dart';
import 'package:elbi_donation_system/pages/Donor/DonorOrgDetails.dart';
import 'package:elbi_donation_system/pages/Donor/OrganizationList.dart';
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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
    List<Widget> donorPages = [
      DonorDonations(futureDonations: _futureDonations!),
      DonorOrganizationList(),
    ];

    return Consumer<FirebaseAuthUserProvider>(
      builder: (context, authProvider, _) {
        String userName = authProvider.currentUser?.name ?? 'User';
        String firebaseUid = authProvider.currentUserId ?? '';
        print("Current User ID: $firebaseUid");

        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: ProjectColors().greenPrimary,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.handshake),
                label: 'Donations',
                backgroundColor: ProjectColors().greenPrimary,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.groups),
                label: 'Organizations',
                backgroundColor: ProjectColors().greenPrimary,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
          body: FormBanner(
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/donor_profile',
                        arguments: authProvider.currentUser);
                  },
                  icon: const Icon(Icons.person, color: Colors.white),
                ),
              ],
              gradient: ProjectColors().greenPrimaryGradient,
              color: ProjectColors().greenPrimary,
              title: userName,
              subtitle: "Welcome,",
              widget: donorPages[_selectedIndex]),
        );
      },
    );
  }
}