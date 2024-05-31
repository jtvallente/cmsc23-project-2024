import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:elbi_donation_system/models/donation.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/models/donationdrive.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get all orgs that are approved
  Stream<QuerySnapshot> getAllOrganizations() {
    return firestore
        .collection('users')
        .where('isApproved', isEqualTo: true)
        .where('isOrganization', isEqualTo: true)
        .snapshots();
  }

  Future<void> addDonation(Donation donation) async {
    try {
      await firestore
          .collection('donation')
          .doc(donation.donationId)
          .set(donation.toJson());
    } catch (e) {
      throw Exception('Failed to add donation: $e');
    }
  }

  Future<List<Donation>> getDonationsForUser(String uid) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('donation')
          .where('donorId', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No donations found for user $uid");
        return [];
      }

      List<Donation> donations = [];
      for (var doc in querySnapshot.docs) {
        try {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          if (data == null) {
            print("Document data is null for document ID ${doc.id}");
            continue; // Skip this document
          }
          donations.add(Donation.fromJson(data));
        } catch (e) {
          print("Error parsing document ID ${doc.id}: $e");
        }
      }

      return donations;
    } catch (e) {
      print('Error fetching user donations: $e');
      throw Exception('Failed to fetch donations: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await firestore
          .collection('users')
          .doc(user.userId)
          .update(user.toJson());
    } catch (e) {
      throw Exception('Failed to update donation: $e');
    }
  }

  Future<void> updateDonation(Donation donation) async {
    try {
      await firestore
          .collection('donation')
          .doc(donation.donationId)
          .update(donation.toJson());
    } catch (e) {
      throw Exception('Failed to update donation: $e');
    }
  }

  Stream<QuerySnapshot> getAllUserDonations(String uid) {
    return firestore
        .collection('donation')
        .where('OrganizationId', isEqualTo: uid)
        .snapshots();
  }

  Stream<QuerySnapshot> getDonationDrives(String uid) {
    return firestore
        .collection('donationDrive')
        .where('organizationId', isEqualTo: uid)
        .snapshots();
  }

  Future<List<DonationDrive>> getDonationDrivesForUser(
      String organizationId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('donationDrive')
          .where('organizationId', isEqualTo: organizationId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No donation drives found for organization $organizationId");
        return [];
      }

      List<DonationDrive> drives = [];
      for (var doc in querySnapshot.docs) {
        try {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          if (data == null) {
            print("Document data is null for document ID ${doc.id}");
            continue; // Skip this document
          }
          drives.add(DonationDrive.fromJson(data));
        } catch (e) {
          print("Error parsing document ID ${doc.id}: $e");
        }
      }

      return drives;
    } catch (e) {
      print('Error fetching donation drives: $e');
      throw Exception('Failed to fetch donation drives: $e');
    }
  }

  Future<void> addDonationDrive(DonationDrive donationDrive) async {
    try {
      await firestore
          .collection('donationDrive')
          .doc(donationDrive.donationDriveId)
          .set(donationDrive.toJson());
    } catch (e) {
      throw Exception('Failed to add donation drive: $e');
    }
  }

  Future<void> addDonationToDrive(Donation donation, String driveId) async {
    try {
      // Update donation to mark it as added to a drive
      await firestore
          .collection('donation')
          .doc(donation.donationId)
          .update({'isAddedToDrive': true, 'driveId': driveId});

      // Add the donation to the specified drive
      await firestore.collection('donationDrive').doc(driveId).update({
        'donations': FieldValue.arrayUnion([donation.toJson()])
      });
    } catch (e) {
      throw Exception('Failed to add donation to drive: $e');
    }
  }

  Future<void> updateDonationDrive(DonationDrive donationDrive) async {
    try {
      await FirebaseFirestore.instance
          .collection('donationDrive')
          .doc(donationDrive.donationDriveId)
          .update(donationDrive.toJson());
    } catch (e) {
      print("Error updating donation drive: $e");
    }
  }

  Future<void> deleteDonationDrive(String uid) async {
    try {
      await firestore.collection('donationDrive').doc(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete donation drive: $e');
    }
  }

  Future<void> updateByQr(String donationId) async {
    try {
      // Get the reference to the document
      DocumentReference docRef =
          firestore.collection('donation').doc(donationId);

      // Update the status field
      await docRef.update({'status': 'Completed/Received'});
    } catch (e) {
      print("Error updating donation: $e");
      throw e;
    }
  }
}
