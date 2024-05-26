import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:elbi_donation_system/models/donation.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //get all orgs that are approved
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
}
