import 'package:elbi_donation_system/components/section_header.dart';
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorDonations extends StatefulWidget {
  final Future<void> futureDonations;
  const DonorDonations({super.key, required this.futureDonations});

  @override
  State<DonorDonations> createState() => _DonorDonationsState();
}

class _DonorDonationsState extends State<DonorDonations> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
                title: "Donations made by you",
                icon: Icons.handshake_rounded,
                color: ProjectColors().greenPrimary),
            Consumer<FirebaseUserProvider>(
              builder: (context, userProvider, _) {
                return FutureBuilder<void>(
                  future: widget.futureDonations,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final donations = userProvider.userDonations;
                    if (donations.isEmpty) {
                      return Center(child: Text('No donations found'));
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: donations.map((donation) {
                        return ListTile(
                          title: Text(donation.donationId),
                          subtitle: Text('Donor ID: ${donation.donorId}'),
                          trailing: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/donor_donation_details',
                                arguments: donation,
                              );
                            },
                            child: Text('View'),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ],
        ));
  }
}
