import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'dart:convert';

class DonorOrgDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final organization = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${organization.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${organization.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Description: ${organization.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Contact No: ${organization.contactNo}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Addresses:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: organization.addresses
                  .map((address) => Text('- $address'))
                  .toList(),
            ),
            SizedBox(height: 8),
            Text(
              'Proof of Legitimacy:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: organization.proofOfLegitimacyBase64.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.memory(
                      base64Decode(organization.proofOfLegitimacyBase64[index]),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/make_donation',
                  arguments: {'OrganizationId': organization.userId},
                );
              },
              child: Text('Donate'),
            ),
          ],
        ),
      ),
    );
  }
}
