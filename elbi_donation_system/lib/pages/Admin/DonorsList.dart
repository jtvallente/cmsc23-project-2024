import 'package:elbi_donation_system/components/details_modal.dart';
import 'package:elbi_donation_system/components/section_header.dart';
import 'package:elbi_donation_system/components/stream_list_tile.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/models/users.dart';

class DonorsListPage extends StatefulWidget {
  final Stream<QuerySnapshot> donorsStream;
  const DonorsListPage({required this.donorsStream, super.key});
  @override
  _DonorsListPageState createState() => _DonorsListPageState();
}

class _DonorsListPageState extends State<DonorsListPage> {
  nullFunc() {}
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          SectionHeader(
              title: "All Donors",
              icon: Icons.person,
              color: ProjectColors().purplePrimary),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: StreamBuilder(
              stream: widget.donorsStream,
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
                    child: Text("No Donors Found"),
                  );
                }

                List<User> donors = [];
                snapshot.data!.docs.forEach((doc) {
                  User user = User.fromJson(doc.data() as Map<String, dynamic>);
                  user.userId = doc.id;
                  donors.add(user);
                });

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: donors.length,
                  itemBuilder: (context, index) {
                    return StreamListTile(
                        color: ProjectColors().purplePrimary,
                        modal: DetailsModal(
                            title: donors[index].name,
                            description: donors[index].username,
                            body: Column(children: [
                              Text(donors[index].contactNo),
                              Text(donors[index].email),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: donors[index].addresses.length,
                                  itemBuilder: (context, i) {
                                    return Text(donors[index].addresses[i]);
                                  })
                            ]),
                            action: Container()),
                        leading: Icon(Icons.person),
                        title: Text(donors[index].name),
                        trailing: Text(donors[index].username));
                  },
                );
              },
            ),
          )
        ]));
  }
}
