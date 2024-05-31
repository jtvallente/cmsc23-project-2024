import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart'; // Import the provider

class OrganizationProfile extends StatefulWidget {
  @override
  _OrganizationProfileState createState() => _OrganizationProfileState();
}

class _OrganizationProfileState extends State<OrganizationProfile> {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Profile'),
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
            Text(
              'Description: ${user.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            SwitchListTile(
              title: Text('Open for Donations'),
              value: user.openForDonations,
              onChanged: (bool newValue) {
                setState(() {
                  user.openForDonations = newValue;
                });
                final provider =
                    Provider.of<FirebaseUserProvider>(context, listen: false);
                provider.updateUser(user);
              },
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
          ],
        ),
      ),
    );
  }
}
