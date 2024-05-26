import 'dart:convert'; // Import to decode base64 images
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:elbi_donation_system/models/donation.dart'; // Import the Donation model
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart'; // Import the provider

class OrganizationDonationDetails extends StatefulWidget {
  @override
  _OrganizationDonationDetailsState createState() =>
      _OrganizationDonationDetailsState();
}

class _OrganizationDonationDetailsState
    extends State<OrganizationDonationDetails> {
  @override
  Widget build(BuildContext context) {
    final Donation donation =
        ModalRoute.of(context)!.settings.arguments as Donation;

    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Donation ID: ${donation.donationId}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Donor ID: ${donation.donorId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Organization ID: ${donation.OrganizationId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Category: ${donation.category}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Delivery Method: ${donation.deliveryMethod}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Weight: ${donation.weight} kg',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Contact Number: ${donation.contactNumber}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Status:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: donation.status,
              items: <String>[
                'Pending',
                'Confirmed',
                'Scheduled for pick up',
                'Complete',
                'Cancelled'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  donation.status = newValue!;
                });
                final provider =
                    Provider.of<FirebaseUserProvider>(context, listen: false);
                provider.updateDonation(donation);
              },
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${donation.dateTime.toLocal()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            if (donation.addresses != null &&
                donation.addresses!.isNotEmpty) ...[
              Text(
                'Addresses:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...donation.addresses!.map((address) => Text('- $address')),
            ],
            SizedBox(height: 8),
            if (donation.photos != null && donation.photos!.isNotEmpty) ...[
              Text(
                'Photos:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: donation.photos!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.memory(
                        base64Decode(donation.photos![index]),
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
