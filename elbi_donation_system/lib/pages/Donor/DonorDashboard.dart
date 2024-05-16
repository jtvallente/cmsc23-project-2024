import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elbi_donation_system/providers/FirebaseAuthUserProvider.dart';

class DonorDashboard extends StatefulWidget {
  @override
  _DonorDashboardState createState() => _DonorDashboardState();
}

class _DonorDashboardState extends State<DonorDashboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthUserProvider>(
      builder: (context, authProvider, _) {
        String userName = authProvider.currentUser?.name ?? 'User';
        return Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: ProjectColors().greenPrimary,
              child: const Icon(Icons.add, color: Colors.white),
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
            title: userName,
            subtitle: "Welcome,",
            widget: SingleChildScrollView(
                child: SizedBox(height: MediaQuery.of(context).size.height)),
          ),
        );
      },
    );
  }
}
