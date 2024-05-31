import 'donation.dart';

class DonationDrive {
  String donationDriveId;
  String name;
  String description;
  String organizationId;
  List<String> photos; // Store image URLs or base64 strings
  List<Donation> donations; // List of Donation objects
  String status;
  DateTime dateTime;

  DonationDrive({
    required this.donationDriveId,
    required this.organizationId,
    required this.name,
    required this.description,
    required this.photos,
    required this.donations,
    required this.status,
    required this.dateTime,
  });

  // Convert a DonationDrive object into a Map
  Map<String, dynamic> toJson() {
    return {
      'donationDriveId': donationDriveId,
      'name': name,
      'description': description,
      'organizationId': organizationId,
      'photos': photos,
      'donations': donations.map((donation) => donation.toJson()).toList(),
      'status': status,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Create a DonationDrive object from a Map
  factory DonationDrive.fromJson(Map<String, dynamic> json) {
    return DonationDrive(
      donationDriveId: json['donationDriveId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      organizationId: json['organizationId'] as String,
      photos: List<String>.from(json['photos'] as List<dynamic>),
      donations: (json['donations'] as List<dynamic>)
          .map((item) => Donation.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      dateTime:
          DateTime.parse(json['dateTime'] ?? DateTime.now().toIso8601String()),
    );
  }
}
