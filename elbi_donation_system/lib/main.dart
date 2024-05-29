import 'package:elbi_donation_system/pages/admin_sign_in.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/FirebaseAdminProvider.dart';
import 'providers/FirebaseAuthAdminProvider.dart';
import 'providers/FirebaseAuthUserProvider.dart';
import 'providers/FirebaseUserProvider.dart';
import 'providers/FirebaseDonationDrivesProvider.dart';
import 'providers/FirebaseDonationsProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'pages/user_sign_in.dart';
import 'pages/user_sign_up.dart';
import 'pages/Welcome.dart';

//ADMIN PAGES IMPORT
import 'pages/Admin/AdminDashboard.dart';
import 'pages/Admin/AdminDonorDetails.dart';
import 'pages/Admin/AdminOrgDetails.dart';
import 'pages/Admin/OrganizationsList.dart';
import 'pages/Admin/DonorsList.dart';
import 'pages/Admin/AdminDonations.dart';

//ORG PAGES IMPORT
import 'pages/Organization/DonationDriveDetails.dart';
import 'pages/Organization/DonationDrivesList.dart';
import 'pages/Organization/DonationList.dart';
import 'pages/Organization/MakeDonationDrive.dart';
import 'pages/Organization/OrganizationDashboard.dart';
import 'pages/Organization/OrganizationDonationDetails.dart';
import 'pages/Organization/OrganizationProfile.dart';

//USER PAGES IMPORT
import 'pages/Donor/DonorDashboard.dart';
import 'pages/Donor/DonorDonationDetails.dart';
import 'pages/Donor/DonorProfile.dart';
import 'pages/Donor/MakeDonation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAdminProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseAuthAdminProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseAuthUserProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseUserProvider()),
        ChangeNotifierProvider(create: (_) => DonationProvider()),
        ChangeNotifierProvider(create: (_) => DonationDriveProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: ProjectColors().greenPrimary)),
      // initial route
      initialRoute: '/',
      // routes
      routes: {
        '/': (context) => AdminDashboard(),
        '/admin_signin': (context) => AdminSignInPage(),
        '/user_signin': (context) => UserSignInPage(),
        '/user_signup': (context) => UserSignUpPage(),

        // Admin routes
        '/admin_dashboard': (context) => AdminDashboard(),
        '/admin_donor_details': (context) => AdminDonorDetails(),
        '/admin_org_details': (context) => AdminOrgDetails(),

        // Organization routes
        '/organization_dashboard': (context) => OrganizationDashboard(),
        '/donation_drive_details': (context) => DonationDriveDetails(),
        '/donation_drives_list': (context) => DonationDrivesList(),
        '/donation_list': (context) => DonationList(),
        '/make_donation_drive': (context) => MakeDonationDrive(),
        '/organization_donation_details': (context) =>
            OrganizationDonationDetails(),
        '/organization_profile': (context) => OrganizationProfile(),

        // Donor routes
        '/donor_dashboard': (context) => DonorDashboard(),
        '/donor_donation_details': (context) => DonorDonationDetails(),
        '/donor_profile': (context) => DonorProfile(),
        '/make_donation': (context) => MakeDonation(),
      },
    );
  }
}
