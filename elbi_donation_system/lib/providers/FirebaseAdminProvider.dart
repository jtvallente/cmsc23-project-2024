import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/api/FirebaseAdminAPI.dart';
import 'package:flutter/material.dart';

class FirebaseAdminProvider with ChangeNotifier {
      FirebaseAdminAPI firebaseService = FirebaseAdminAPI();
  //Firebase admin functionality here
    late Stream<QuerySnapshot> _usersStream;

  FirebaseAdminProvider(){
    fetchUsers();
  }

  Stream<QuerySnapshot> get users => _usersStream;

  void fetchUsers(){
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
  }
}
