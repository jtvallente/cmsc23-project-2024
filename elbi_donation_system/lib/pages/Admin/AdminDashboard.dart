import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/pages/Admin/AdminDonations.dart';
import 'package:elbi_donation_system/pages/Admin/AdminPendingOrgs.dart';
import 'package:elbi_donation_system/pages/Admin/DonorsList.dart';
import 'package:elbi_donation_system/pages/Admin/OrganizationsList.dart';
import 'package:elbi_donation_system/providers/FirebaseAdminProvider.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/Admin.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart'; // Adjust the import path accordingly
import 'dart:convert';
import 'package:mime/mime.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final Admin adminData = ModalRoute.of(context)?.settings.arguments as Admin;
    Stream<QuerySnapshot> usersStream =
        context.watch<FirebaseAdminProvider>().users;
    Stream<QuerySnapshot> organizationsStream = FirebaseFirestore.instance
        .collection('users')
        .where('isOrganization', isEqualTo: true)
        .where('isApproved', isEqualTo: true)
        .snapshots();
    Stream<QuerySnapshot> donorsStream = FirebaseFirestore.instance
        .collection('users')
        .where('isOrganization', isEqualTo: false)
        .where('isApproved', isEqualTo: false)
        .snapshots();
    Stream<QuerySnapshot> donationsStream =
        context.watch<FirebaseAdminProvider>().donationsStream;

    List<Widget> adminPages = [
      AdminPendingOrgsPage(usersStream: usersStream),
      OrganizationsListPage(organizationsStream: organizationsStream),
      DonorsListPage(donorsStream: donorsStream),
      AdminDonations(donationsStream: donationsStream)
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions_rounded),
            label: 'Pending',
            backgroundColor: ProjectColors().purplePrimary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Organizations',
            backgroundColor: ProjectColors().purplePrimary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Donors',
            backgroundColor: ProjectColors().purplePrimary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake_rounded),
            label: 'Donations',
            backgroundColor: ProjectColors().purplePrimary,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: FormBanner(
          color: ProjectColors().purplePrimary,
          gradient: ProjectColors().purplePrimaryGradient,
          title: "ADMIN",
          subtitle: "WELCOME,",
          isRoot: true,
          actions: [],
          widget: adminPages[_selectedIndex]),

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
    );
  }
}
