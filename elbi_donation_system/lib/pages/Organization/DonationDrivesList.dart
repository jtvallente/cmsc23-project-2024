import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/models/donationdrive.dart';

import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // To decode the base64 image

class DonationDrivesList extends StatefulWidget {
  @override
  _DonationDrivesListState createState() => _DonationDrivesListState();
}

class _DonationDrivesListState extends State<DonationDrivesList> {
  @override
  void initState() {
    super.initState();

    // Fetch the user argument from the route and call fetchDonationDrives
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final User user = ModalRoute.of(context)!.settings.arguments as User;
      context.read<FirebaseUserProvider>().fetchDonationDrives(user.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot>? donationDrivesStream =
        context.watch<FirebaseUserProvider>().donationDrivesStream;

    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Drives List'),
      ),
      body: donationDrivesStream == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: donationDrivesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error encountered! ${snapshot.error}"),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No Donation Drives Found"),
                  );
                }

                List<DonationDrive> orgDrives = [];
                snapshot.data!.docs.forEach((doc) {
                  DonationDrive donationDrive = DonationDrive.fromJson(
                      doc.data() as Map<String, dynamic>);
                  donationDrive.donationDriveId = doc.id;
                  orgDrives.add(donationDrive);
                });

                return ListView.builder(
                  itemCount: orgDrives.length,
                  itemBuilder: (context, index) {
                    // Extract the profile picture from the array or use a placeholder
                    List<dynamic> photo = orgDrives[index].photos;
                    String profilePicture;
                    if (photo.isNotEmpty) {
                      profilePicture = photo[0];
                    } else {
                      profilePicture = ''; // Placeholder image base64 or URL
                    }

                    return ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: photo.isNotEmpty
                                ? MemoryImage(base64Decode(profilePicture))
                                : AssetImage('assets/placeholder_image.png')
                                    as ImageProvider,
                          ),
                          if (orgDrives[index].status == "Ongoing")
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: 12,
                              ),
                            ),
                        ],
                      ),
                      title: Text(orgDrives[index].name),
                      subtitle: Text(orgDrives[index].description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/donation_drive_details',
                                arguments: orgDrives[index],
                              );
                            },
                            child: Text('View/Update'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
