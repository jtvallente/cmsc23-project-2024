import 'donation.dart';

class DonationDrive {
  String donationDriveId;
  String name;
  List<String> photos; // Store image URLs or base64 strings
  List<Donation> donations; // List of Donation objects
  String status;

  DonationDrive({
    required this.donationDriveId,
    required this.name,
    required this.photos,
    required this.donations,
    required this.status,
  });
}
