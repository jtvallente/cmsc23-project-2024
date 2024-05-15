import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';

class DonorDashboard extends StatefulWidget {
  @override
  _DonorDashboardState createState() => _DonorDashboardState();
}

class _DonorDashboardState extends State<DonorDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: ProjectColors().greenPrimary,
          child: const Icon(Icons.add, color: Colors.white, weight: 10),
          onPressed: () => Navigator.pushNamed(context, '/make_donation')),
      body: FormBanner(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, color: Colors.white))
        ],
        gradient: ProjectColors().greenPrimaryGradient,
        color: ProjectColors().greenPrimary,
        title: "Juan Dela Cruz",
        subtitle: "Welcome,",
        widget: SingleChildScrollView(
            child: SizedBox(height: MediaQuery.of(context).size.height)),
      ),
    );
  }
}
