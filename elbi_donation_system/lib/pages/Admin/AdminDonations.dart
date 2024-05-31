import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/components/details_modal.dart';
import 'package:elbi_donation_system/components/section_header.dart';
import 'package:elbi_donation_system/components/stream_list_tile.dart';
import 'package:elbi_donation_system/models/donation.dart';
import 'package:elbi_donation_system/providers/FirebaseAdminProvider.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/Admin.dart';
import 'package:provider/provider.dart'; // Adjust the import path accordingly

class AdminDonations extends StatelessWidget {
  final Stream<QuerySnapshot> donationsStream;
  const AdminDonations({required this.donationsStream, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          SectionHeader(
              title: "Donations",
              icon: Icons.groups,
              color: ProjectColors().purplePrimary),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: StreamBuilder(
              stream: donationsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error encountered! ${snapshot.error}"),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
                        snapshot.data?.docs[index].data()
                            as Map<String, dynamic>);
                    thisDonation.donationId = snapshot.data!.docs[index].id;
                    return StreamListTile(
                        color: thisDonation.status == "Pending"
                            ? ProjectColors().yellowPrimary
                            : ProjectColors().greenPrimary,
                        modal: DetailsModal(
                            title: "${thisDonation.category} Donation",
                            description: "Description",
                            body: Column(children: [
                              Text(thisDonation.donationId),
                              Text(thisDonation.contactNumber),
                            ]),
                            action: Container()),
                        leading: Icon(Icons.handshake),
                        title: Text(thisDonation.donationId),
                        trailing: Text(thisDonation.status));
                  }),
                );
              },
            ),
          )
        ]));
  }
}
