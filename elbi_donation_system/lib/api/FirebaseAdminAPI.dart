import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseAdminAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  Stream<QuerySnapshot> getAllUsers() {
    return db.collection('users').snapshots();
  }

  Stream<QuerySnapshot> getAllDonations() {
    return db.collection('donation').snapshots();
  }

  Future<void> approveUser(String userId) async {
    try {
      // Get a reference to the user document in Firestore
      DocumentReference userRef = db.collection('users').doc(userId);
      // Update the isApproved attribute to true
      await userRef.update({'isApproved': true});
    } catch (e) {
      throw Exception('Failed to approve user: $e');
    }
  }
}
