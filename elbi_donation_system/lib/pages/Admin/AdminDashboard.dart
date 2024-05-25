import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/Admin.dart'; // Adjust the import path accordingly

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Admin adminData = ModalRoute.of(context)?.settings.arguments as Admin;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome, ${adminData.name}',
          style: TextStyle(fontSize: 24),
          
        ),
      ),
    );
  }
}
