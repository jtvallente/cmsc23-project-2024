import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/models/donationdrive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/models/donation.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Merged getUserDetail and getOrganizationDetails

  Future<List<User>> getUserDetail(String uid) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('user')
          .where('userId', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No details found for user $uid");
        return [];
      }

      List<User> user = [];
      for (var doc in querySnapshot.docs) {
        try {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          if (data == null) {
            print("Document data is null for document ID ${doc.id}");
            continue; // Skip this document
          }
          user.add(User.userFromJson(data));
        } catch (e) {
          print("Error parsing document ID ${doc.id}: $e");
        }
      }

      // I know this technically sends a list of 1 element but I didn't know how to return a single doc without getting into null safety
      return user;  
    } catch (e) {
      print('Error fetching user donations: $e');
      throw Exception('Failed to fetch donations: $e');
    }
  }

  // Donor User 

  Stream<QuerySnapshot> getAllOrganizations() {
    return firestore.collection('users')
      .where('isOrganization', isEqualTo: true)
      .snapshots();
  }
  
  Future<void> addDonation(Donation donation) async {
    try {
      await firestore
          .collection('donation')
          .doc(donation.donationId)
          .set(donation.donationToJson());
    } catch (e) {
      throw Exception('Failed to add donation: $e');
    }
  }

  Future<void> deleteDonation(String uid) async {
    try {
      await firestore
          .collection('donation')
          .doc(uid)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete donation: $e');
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
          donations.add(Donation.donationFromJson(data));
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

  // Organization User

  Stream<QuerySnapshot> getAllUserDonations(String uid) {
    return firestore.collection('donation')
      .where('organizationId', isEqualTo: uid)
      .snapshots();
  }

  Stream<QuerySnapshot> getDonationDrives(String uid) {
    return firestore.collection('donationDrive')
      .where('organizationId', isEqualTo: uid)
      .snapshots();
  }

  Future<void> addDonationDrive(DonationDrive donationDrive) async {
    try {
      await firestore
          .collection('donationDrive')
          .doc(donationDrive.donationDriveId)
          .set(donationDrive.donationDriveToJson());
    } catch (e) {
      throw Exception('Failed to add donation drive: $e');
    }
  }

  Future<void> updateDonationDrive(String donationDriveId) async {
    try {
      // Get a reference to the user document in Firestore
      DocumentReference userRef = firestore.collection('donationDrive').doc(donationDriveId);
      // Update the isApproved attribute to true
      await userRef.update({'status': "completed"}); // Assume ongoing by default
    } catch (e) {
      throw Exception('Failed to change donation drive status: $e');
    }
  }

  Future<void> deleteDonationDrive(String uid) async {
    try {
      await firestore
          .collection('donationDrive')
          .doc(uid)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete donation drive: $e');
    }
  }  
}
