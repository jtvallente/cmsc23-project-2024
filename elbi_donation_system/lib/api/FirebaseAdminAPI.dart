import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseAdminAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  Stream<QuerySnapshot> getAllUsers() {
    return db.collection('users').snapshots();
  }
}
