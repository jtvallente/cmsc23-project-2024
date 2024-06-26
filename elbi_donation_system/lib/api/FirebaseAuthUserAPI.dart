import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/models/users.dart' as model;
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthAPI {
  static final auth.FirebaseAuth userAuth = auth.FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  auth.User? getUser() {
    return userAuth.currentUser;
  }

  Stream<auth.User?> userSignedIn() {
    return userAuth.authStateChanges();
  }

  Future<String?> login(String email, String password) async {
    try {
      await userAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "";
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<model.User?> getUserData(String uid) async {
    DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return model.User.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> register(String email, String password) async {
    try {
      await userAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    await userAuth.signOut();
  }

  Future<void> saveUserData(model.User user, String uid) async {
    await firestore.collection('users').doc(uid).set(user.toJson());
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return "Sign in aborted by user";
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await userAuth.signInWithCredential(credential);
      return null;
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}
