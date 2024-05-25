import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/api/FirebaseAdminAPI.dart';
import 'package:flutter/material.dart';

class FirebaseAdminProvider with ChangeNotifier {
  FirebaseAdminAPI firebaseService = FirebaseAdminAPI();
  late Stream<QuerySnapshot> _usersStream;
  late Stream<QuerySnapshot> _donationsStream; // Make it nullable

  FirebaseAdminProvider() {
    fetchUsers();
    fetchAllDonations();
  }

  Stream<QuerySnapshot> get users => _usersStream;

  void fetchUsers() {
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  Stream<QuerySnapshot> get donationsStream => _donationsStream;

  void fetchAllDonations() {
    _donationsStream = firebaseService.getAllDonations();
    notifyListeners();
  }

  Future<void> approveUser(String userId) async {
    try {
      await firebaseService.approveUser(userId);
      notifyListeners();
    } catch (e) {
      print('Error approving user: $e');
    }
  }
}
