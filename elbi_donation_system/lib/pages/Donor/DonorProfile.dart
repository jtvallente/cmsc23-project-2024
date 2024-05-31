import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/providers/FirebaseAuthUserProvider.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class DonorProfile extends StatefulWidget {
  @override
  _DonorProfileState createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text('Donor Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Name: ${user.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Donor ID: ${user.userId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'E-mail: ${user.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Username: ${user.username}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Contact Number: ${user.contactNo}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            if (user.addresses != null && user.addresses!.isNotEmpty) ...[
              Text(
                'Addresses:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...user.addresses!.map((address) => Text('- $address')),
            ],
            SizedBox(height: 8),
            if (user.proofOfLegitimacyBase64 != null &&
                user.proofOfLegitimacyBase64!.isNotEmpty) ...[
              Text(
                'Photos:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: user.proofOfLegitimacyBase64!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.memory(
                        base64Decode(user.proofOfLegitimacyBase64![index]),
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
            PrimaryButton(
                label: "Logout",
                onTap: () {
                  context.read<FirebaseAuthUserProvider>().logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                gradient: ProjectColors().redPrimaryGradient,
                fillWidth: false)
          ],
        ),
      ),
    );
  }
}
