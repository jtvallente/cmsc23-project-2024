import 'package:flutter/material.dart';
import 'package:elbi_donation_system/api/FirebaseAuthAdminAPI.dart';
import 'package:elbi_donation_system/models/Admin.dart';

class FirebaseAuthAdminProvider with ChangeNotifier {
  final FirebaseAuthAdminAPI _authAPI = FirebaseAuthAdminAPI();
  Admin? currentAdmin;

  Future<bool> login(String email, String password) async {
    currentAdmin = await _authAPI.login(email, password);
    if (currentAdmin != null) {
      notifyListeners();
      return true;
    }
    return false;
  }

  String get adminName => currentAdmin?.name ?? 'Admin';
}
