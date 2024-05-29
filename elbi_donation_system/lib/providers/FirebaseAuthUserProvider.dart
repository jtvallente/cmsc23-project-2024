import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/users.dart' as model;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../api/FirebaseAuthUserAPI.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class FirebaseAuthUserProvider with ChangeNotifier {
  model.User? _currentUser;
  final FirebaseAuthAPI _authAPI = FirebaseAuthAPI();
  String? _currentUserEmail;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  model.User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  String? get currentUserId => _authAPI.getUser()?.uid;

  FirebaseAuthUserProvider() {
    _loadUserFromPrefs();
    _authAPI.userSignedIn().listen(_onAuthStateChanged);
  }

  Future<void> _saveUserToPrefs(model.User user, String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUser', json.encode(user.toJson()));
    prefs.setString('currentUserEmail', email);
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('currentUser');
    final userEmail = prefs.getString('currentUserEmail');
    if (userData != null && userEmail != null) {
      _currentUser = model.User.fromJson(json.decode(userData));
      _currentUserEmail = userEmail;
      notifyListeners();
    }
  }

  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('currentUser');
    prefs.remove('currentUserEmail');
  }

  Future<bool> login(String input, String password) async {
    String email;

    if (EmailValidator.validate(input)) {
      email = input;
    } else {
      final result = await _getEmailFromUsername(input);
      if (result == null) {
        throw Exception('Username not found');
      }
      email = result;
    }

    String? errorMessage = await _authAPI.login(email, password);
    if (errorMessage == null || errorMessage.isEmpty) {
      model.User? user = await _authAPI.getUserData(_authAPI.getUser()!.uid);
      if (user != null) {
        _currentUser = user;
        _currentUserEmail = email;
        await _saveUserToPrefs(user, email);
        notifyListeners();
        return true;
      }
      return false;
    } else {
      throw Exception(errorMessage);
    }
  }

  Future<String?> _getEmailFromUsername(String username) async {
    final querySnapshot = await firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data()['email'] as String?;
    }
    return null;
  }

  Future<void> logout() async {
    await _authAPI.logout();
    _currentUser = null;
    _currentUserEmail = null;
    await _clearUserFromPrefs();
    notifyListeners();
  }

  Future<void> register(
      String email, String password, model.User newUser) async {
    try {
      await _authAPI.register(email, password);
      String uid = _authAPI.getUser()!.uid;
      newUser.userId = uid;
      await _authAPI.saveUserData(newUser, uid);
      _currentUser = newUser;
      _currentUserEmail = email;
      await _saveUserToPrefs(newUser, email);
      notifyListeners();
    } catch (error) {
      print("Error registering user: $error");
    }
  }

  Future<bool> signInWithGoogle() async {
    String? errorMessage = await _authAPI.signInWithGoogle();
    if (errorMessage == null) {
      model.User? user = await _authAPI.getUserData(_authAPI.getUser()!.uid);
      if (user != null) {
        _currentUser = user;
        _currentUserEmail = _authAPI.getUser()!.email;
        await _saveUserToPrefs(user, _currentUserEmail!);
        notifyListeners();
        return true;
      }
      return false;
    } else {
      throw Exception(errorMessage);
    }
  }

  void updateUser(model.User updatedUser) {
    _currentUser = updatedUser;
    if (_currentUserEmail != null) {
      _saveUserToPrefs(updatedUser, _currentUserEmail!);
    }
    notifyListeners();
  }

  void _onAuthStateChanged(auth.User? firebaseUser) {
    if (firebaseUser == null) {
      _currentUser = null;
      _currentUserEmail = null;
      _clearUserFromPrefs();
      notifyListeners();
    } else {
      // Load user data if user is logged in
      _authAPI.getUserData(firebaseUser.uid).then((user) {
        if (user != null) {
          _currentUser = user;
          _currentUserEmail = firebaseUser.email;
          _saveUserToPrefs(user, firebaseUser.email!);
          notifyListeners();
        }
      });
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    final querySnapshot = await firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}
