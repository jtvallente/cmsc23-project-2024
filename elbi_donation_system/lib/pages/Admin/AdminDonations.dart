import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/models/donation.dart';
import 'package:elbi_donation_system/providers/FirebaseAdminProvider.dart';
import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/Admin.dart';
import 'package:provider/provider.dart'; // Adjust the import path accordingly

class AdminDonations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> donationsStream =
        context.watch<FirebaseAdminProvider>().donationsStream;
    return Scaffold(
      appBar: AppBar(
        title: Text('All Donations'),
      ),
      body: StreamBuilder(
        stream: donationsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Users Found"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Donation thisDonation = Donation.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              thisDonation.donationId = snapshot.data!.docs[index].id;
              return Dismissible(
                key: Key(thisDonation.donationId.toString()),
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ),
                child: ListTile(
                  title: Text(thisDonation.donationId),
                  leading: Text(thisDonation.donorId),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
