import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/providers/FirebaseAdminProvider.dart';
import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/Admin.dart';
import 'package:provider/provider.dart'; // Adjust the import path accordingly

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final Admin adminData = ModalRoute.of(context)?.settings.arguments as Admin;
    Stream<QuerySnapshot> usersStream =
        context.watch<FirebaseAdminProvider>().users;
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: usersStream,
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
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text("No Users Found"),
                  );
                }

                List<User> organizations = [];
                snapshot.data!.docs.forEach((doc) {
                  User user = User.fromJson(doc.data() as Map<String, dynamic>);
                  user.userId = doc.id;
                  if (user.isOrganization == true && user.isApproved == false) {
                    organizations.add(user);
                  }
                });

                return ListView.builder(
                  itemCount: organizations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(organizations[index].name),
                      leading: Text(organizations[index].username),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Update the user's isApproved attribute to true
                          context
                              .read<FirebaseAdminProvider>()
                              .approveUser(organizations[index].userId);
                        },
                        child: Text('Approve'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/donors_list');
            },
            child: Text('Donors List'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/organizations_list');
            },
            child: Text('Organization List'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/donations_list');
            },
            child: Text('Donations List'),
          ),
        ],
      ),
    );
  }
}
