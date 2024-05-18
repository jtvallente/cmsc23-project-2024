import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../api/FirebaseAuthUserAPI.dart';
import 'package:random_string/random_string.dart';

class FirebaseAuthUserProvider with ChangeNotifier {
  User? _currentUser;
  FirebaseAuthAPI _authAPI = FirebaseAuthAPI();
  String? _currentUserEmail;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  FirebaseAuthUserProvider() {
    _loadUserFromPrefs();
    _authAPI.userSignedIn().listen(_onAuthStateChanged);
  }

  Future<void> _saveUserToPrefs(User user, String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUser', json.encode(user.toJson()));
    prefs.setString('currentUserEmail', email);
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('currentUser');
    final userEmail = prefs.getString('currentUserEmail');
    if (userData != null && userEmail != null) {
      _currentUser = User.fromJson(json.decode(userData));
      _currentUserEmail = userEmail;
      notifyListeners();
    }
  }

  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('currentUser');
    prefs.remove('currentUserEmail');
  }

  Future<bool> login(String email, String password) async {
    String? errorMessage = await _authAPI.login(email, password);
    if (errorMessage == null || errorMessage.isEmpty) {
      // Fetch user data from Firestore
      User? user = await _authAPI.getUserData(_authAPI.getUser()!.uid);
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

  Future<void> logout() async {
    await _authAPI.logout();
    _currentUser = null;
    _currentUserEmail = null;
    await _clearUserFromPrefs();
    notifyListeners();
  }

  Future<void> register(String email, String password, User newUser) async {
    await _authAPI.register(email, password);
    String uid = _authAPI.getUser()!.uid;
    await _authAPI.saveUserData(newUser, uid);
    _currentUser = newUser;
    _currentUserEmail = email;
    await _saveUserToPrefs(newUser, email);
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    _currentUser = updatedUser;
    if (_currentUserEmail != null) {
      _saveUserToPrefs(updatedUser, _currentUserEmail!);
    }
    notifyListeners();
  }

  void _onAuthStateChanged(dynamic firebaseUser) {
    if (firebaseUser == null) {
      _currentUser = null;
      _currentUserEmail = null;
      _clearUserFromPrefs();
    } else {
      // Do nothing specific for firebaseUser, user data should already be loaded from SharedPreferences.
      notifyListeners();
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    // Implement logic to check if the username exists in your backend or user database
    // For example, you could send a request to your backend API to check if the username is already taken
    return false;
  }
}
