import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/providers/FirebaseAdminProvider.dart';
import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/Admin.dart';
import 'package:provider/provider.dart'; // Adjust the import path accordingly

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Admin adminData = ModalRoute.of(context)?.settings.arguments as Admin;
    Stream<QuerySnapshot> usersStream = context.watch<FirebaseAdminProvider>().users;
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: StreamBuilder(
        stream: usersStream,
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
              User user = User.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              user.userId = snapshot.data!.docs[index].id;
              return Dismissible(
                key: Key(user.userId.toString()),
                
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ),
                child: ListTile(
                  title: Text(user.name),
                  leading: Text(user.username),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    // children: [
                    //   IconButton(
                    //     onPressed: () {
                    //       showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) => TodoModal(
                    //           type: 'Edit',
                    //           item: todo,
                    //         ),
                    //       );
                    //     },
                    //     icon: const Icon(Icons.create_outlined),
                    //   ),
                    //   IconButton(
                    //     onPressed: () {
                    //       showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) => TodoModal(
                    //           type: 'Delete',
                    //           item: todo,
                    //         ),
                    //       );
                    //     },
                    //     icon: const Icon(Icons.delete_outlined),
                    //   )
                    // ],
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
