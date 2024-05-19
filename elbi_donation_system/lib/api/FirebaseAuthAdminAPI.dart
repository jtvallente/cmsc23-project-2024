import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elbi_donation_system/models/Admin.dart';

class FirebaseAuthAdminAPI {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Admin?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('admins')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
          return Admin(
            adminId: data['adminId'],
            name: data['name'],
            username: data['userName'],
            password: data['password'],
            email: data['email'],
          );
        } else {
          print('Admin document does not exist');
        }
      }
      return null;
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }
}
