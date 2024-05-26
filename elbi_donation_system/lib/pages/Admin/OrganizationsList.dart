import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart'; // Adjust the import to use FirebaseUserProvider
import 'package:provider/provider.dart';

class OrganizationsListPage extends StatefulWidget {
  @override
  _OrganizationsListPageState createState() => _OrganizationsListPageState();
}

class _OrganizationsListPageState extends State<OrganizationsListPage> {
  @override
  void initState() {
    super.initState();
    // Initialize the organization stream
    Provider.of<FirebaseUserProvider>(context, listen: false)
        .fetchAllOrganizations();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot>? organizationsStream =
        context.watch<FirebaseUserProvider>().organizationStream;

    return Scaffold(
      appBar: AppBar(
        title: Text('Organizations List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: organizationsStream,
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
                    child: Text("No Orgs Found"),
                  );
                }

                List<User> organizations = [];
                snapshot.data!.docs.forEach((doc) {
                  User user = User.fromJson(doc.data() as Map<String, dynamic>);
                  user.userId = doc.id;
                  organizations.add(user);
                });

                return ListView.builder(
                  itemCount: organizations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(organizations[index].name),
                      leading: Text(organizations[index].username),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
