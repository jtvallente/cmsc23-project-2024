import 'dart:convert'; // Import to decode base64 images
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:elbi_donation_system/models/donation.dart'; // Import the Donation model
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart';
import 'package:elbi_donation_system/models/donationdrive.dart'; // Import the Donation model

class OrganizationDonationDetails extends StatefulWidget {
  @override
  _OrganizationDonationDetailsState createState() =>
      _OrganizationDonationDetailsState();
}

class _OrganizationDonationDetailsState
    extends State<OrganizationDonationDetails> {
  String? _selectedDriveId;

  @override
  Widget build(BuildContext context) {
    final Donation donation =
        ModalRoute.of(context)!.settings.arguments as Donation;
    final provider = Provider.of<FirebaseUserProvider>(context, listen: false);

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
                'Completed/Received',
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
            SizedBox(height: 16),
            if (!donation.isAddedToDrive)
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FutureBuilder<void>(
                        future: provider
                            .fetchAllDonationDrives(donation.OrganizationId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return Consumer<FirebaseUserProvider>(
                              builder: (context, provider, child) {
                                return StatefulBuilder(
                                  builder: (context, setModalState) {
                                    return Column(
                                      children: [
                                        Text(
                                          'Select a Donation Drive',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: provider
                                                .userDonationDrives.length,
                                            itemBuilder: (context, index) {
                                              DonationDrive drive = provider
                                                  .userDonationDrives[index];
                                              return RadioListTile<String>(
                                                title: Text(drive.name),
                                                value: drive.donationDriveId,
                                                groupValue: _selectedDriveId,
                                                onChanged: (String? value) {
                                                  setModalState(() {
                                                    _selectedDriveId = value;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: _selectedDriveId == null
                                              ? null
                                              : () async {
                                                  await provider
                                                      .addDonationToDrive(
                                                          donation,
                                                          _selectedDriveId!);
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    donation.isAddedToDrive =
                                                        true;
                                                  });
                                                },
                                          child: Text('Add to Drive'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                  );
                },
                child: Text('Add to Donation Drive'),
              ),
            if (donation.isAddedToDrive)
              Text('This donation has been added to a drive'),
          ],
        ),
      ),
    );
  }
}
