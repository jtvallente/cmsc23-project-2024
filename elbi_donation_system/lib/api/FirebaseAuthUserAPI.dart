import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth userAuth = FirebaseAuth.instance;

  User? getUser() {
    return userAuth.currentUser;
  }

  Stream<User?> userSignedIn() {
    return userAuth.authStateChanges();
  }

  Future<String?> login(String email, String password) async {
    try {
      await userAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return e.message;
      } else if (e.code == 'invalid-credential') {
        return e.message;
      } else {
        return "Failed at ${e.code}: ${e.message}";
      }
    }
  }

  Future<void> register(String email, String password) async {
    UserCredential credential;
    try {
      credential = await userAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
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
}
