import 'package:flutter/material.dart';
import 'package:elbi_donation_system/api/FirebaseAuthAdminAPI.dart';
import 'package:elbi_donation_system/models/Admin.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthAdminProvider with ChangeNotifier {
  final FirebaseAuthAdminAPI _authAPI = FirebaseAuthAdminAPI();
  Admin? currentAdmin;

  Future<bool> login(String username, String password) async {
    currentAdmin = await _authAPI.loginWithUsername(username, password);
    if (currentAdmin != null) {
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          currentAdmin =
              await _authAPI.getAdminByEmail(userCredential.user!.email!);
          notifyListeners();
          return true;
        }
      } catch (e) {
        print('Error during Google Sign-In: $e');
      }
    }
    return false;
  }

  String get adminName => currentAdmin?.name ?? 'Admin';
}
