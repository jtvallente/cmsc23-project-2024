import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/models/users.dart';

class DonorsListPage extends StatefulWidget {
  @override
  _DonorsListPageState createState() => _DonorsListPageState();
}

class _DonorsListPageState extends State<DonorsListPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> donorsStream = FirebaseFirestore.instance
        .collection('users')
        .where('isOrganization', isEqualTo: false)
        .where('isApproved', isEqualTo: false)
        .snapshots();

    return Container(
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.all(15.0),
      child: StreamBuilder(
        stream: donorsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
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
            itemCount: donors.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(donors[index].name),
                leading: Text(donors[index].username),
              );
            },
          );
        },
      ),
    );
  }
}
