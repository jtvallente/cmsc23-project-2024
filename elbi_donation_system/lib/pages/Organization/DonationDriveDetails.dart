import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/donationdrive.dart';
import 'package:provider/provider.dart';
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart';
import 'dart:convert';

class DonationDriveDetails extends StatefulWidget {
  @override
  _DonationDriveDetailsState createState() => _DonationDriveDetailsState();
}

class _DonationDriveDetailsState extends State<DonationDriveDetails> {
  final _formKey = GlobalKey<FormState>();
  late DonationDrive donationDrive;
  late String name;
  late String description;
  late String status;
  late DateTime dateTime;
  List<String> photos = [];
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      donationDrive =
          ModalRoute.of(context)!.settings.arguments as DonationDrive;
      name = donationDrive.name;
      description = donationDrive.description;
      status = donationDrive.status;
      dateTime = donationDrive.dateTime;
      photos = List<String>.from(donationDrive.photos);
      _isInitialized = true;
    }
  }

  void _updateDonationDrive() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      DonationDrive updatedDonationDrive = DonationDrive(
        donationDriveId: donationDrive.donationDriveId,
        name: name,
        description: description,
        organizationId: donationDrive.organizationId,
        photos: photos,
        donations: donationDrive.donations,
        status: status,
        dateTime: dateTime,
      );

      context
          .read<FirebaseUserProvider>()
          .updateDonationDrive(updatedDonationDrive);
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    // Implement image picking logic here and add to photos list
    // Example: Pick an image and convert it to base64, then add to photos list
  }

  void _deleteDonationDrive() async {
    if (status == 'Ongoing') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Cannot delete an ongoing donation drive. Please complete it first.')),
      );
    } else {
      try {
        await context
            .read<FirebaseUserProvider>()
            .deleteDonationDrive(donationDrive.donationDriveId);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting donation drive: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Drive Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) {
                  name = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  description = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: status,
                decoration: InputDecoration(labelText: 'Status'),
                onChanged: (String? newValue) {
                  setState(() {
                    status = newValue!;
                  });
                },
                items: <String>['Ongoing', 'Completed']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                initialValue: dateTime.toString(),
                decoration: InputDecoration(labelText: 'Date and Time'),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: dateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != dateTime) {
                    setState(() {
                      dateTime = picked;
                    });
                  }
                },
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Add Photo'),
              ),
              Wrap(
                children: photos.map((photo) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.memory(
                      base64Decode(photo),
                      width: 100,
                      height: 100,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text('Donations:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...donationDrive.donations.map((donation) {
                return ListTile(
                  title: Text('Donation ID: ${donation.donationId}'),
                );
              }).toList(),
              ElevatedButton(
                onPressed: _updateDonationDrive,
                child: Text('Save'),
              ),
              ElevatedButton(
                onPressed: _deleteDonationDrive,
                child: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
