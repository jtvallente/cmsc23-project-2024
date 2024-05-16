import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FirebaseAuthUserProvider with ChangeNotifier {
  // Firebase authentication user functionality here

  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    // Serialize the User object to a JSON string
    prefs.setString('currentUser', json.encode(user.toJson()));
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('currentUser');
    if (userData != null) {
      // Deserialize the JSON string back to a User object
      _currentUser = User.fromJson(json.decode(userData));
      notifyListeners();
    }
  }

  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('currentUser');
  }

  Future<bool> login(String username, String password) async {
    // Mock login logic
    await Future.delayed(Duration(seconds: 1));
    print(username);
    print(password);

    // This is just for testing since api is not yet available
    //Francis, please add api asap.
    if (username == 'user' && password == 'password') {
      _currentUser = User(
        userId: '1',
        name: 'Test User',
        username: 'user',
        password: 'password',
        addresses: ['Address 1', 'Address 2'],
        contactNo: '1234567890',
        isOrganization: false,
        isApproved: true,
      );
      // Save the logged-in user to shared preferences
      await _saveUserToPrefs(_currentUser!);

      notifyListeners();
      return true;
    } else {
      throw Exception('Invalid username or password');
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _clearUserFromPrefs();
    notifyListeners();
  }

  Future<void> register(User newUser) async {
    // Mock registration logic
    await Future.delayed(Duration(seconds: 1));
    _currentUser = newUser;
    await _saveUserToPrefs(newUser);
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    _currentUser = updatedUser;
    _saveUserToPrefs(updatedUser);
    notifyListeners();
  }

  //NEED TO ADD METHOD HERE FOR CHECKING THE USERNAME (IF IT EXISTS OR NOTS)
}
