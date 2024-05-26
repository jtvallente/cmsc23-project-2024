import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/api/FirebaseUserAPI.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:elbi_donation_system/models/donation.dart';
import 'package:elbi_donation_system/providers/FirebaseAuthUserProvider.dart';

class FirebaseUserProvider with ChangeNotifier {
  FirebaseUserAPI firebaseService = FirebaseUserAPI();
  List<Donation> _userDonations = [];
  Stream<QuerySnapshot>? _organizationStream;

  List<String> _proofOfLegitimacyBase64 = [];
  List<File> _selectedFiles = [];
  List<String> _photos = [];

  List<String> get proofOfLegitimacyBase64 => _proofOfLegitimacyBase64;
  List<File> get selectedFiles => _selectedFiles;
  List<String> get photos => _photos;
  List<Donation> get userDonations => _userDonations;
  Stream<QuerySnapshot>? get organizationStream => _organizationStream;

  Future<void> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      _selectedFiles.addAll(files);

      for (File file in files) {
        List<int> fileBytes = await file.readAsBytes();
        String base64File = base64Encode(fileBytes);
        _proofOfLegitimacyBase64.add(base64File);
      }

      notifyListeners();
    }
  }

  Future<void> addPickedFile(File file) async {
    _selectedFiles.add(file);

    List<int> fileBytes = await file.readAsBytes();
    String base64File = base64Encode(fileBytes);
    print(base64File);
    _photos.add(base64File);

    notifyListeners();
  }

  void removeFilePhoto(int index) {
    _selectedFiles.removeAt(index);
    _photos.removeAt(index);
    notifyListeners();
  }

  void removeFileMedia(int index) {
    _selectedFiles.removeAt(index);
    _proofOfLegitimacyBase64.removeAt(index);
    notifyListeners();
  }

  // Create a donation
  Future<void> createDonation(Donation newDonation) async {
    try {
      await firebaseService.addDonation(newDonation);
      notifyListeners();
    } catch (e) {
      print("Error creating donation: $e");
    }
  }

  // Fetch user-specific donations
  Future<void> fetchUserDonations(String userId) async {
    print("USER ID: $userId");
    try {
      _userDonations = await firebaseService.getDonationsForUser(userId);
      notifyListeners();
    } catch (e) {
      print("Error fetching user donations: $e");
    }
  }

  Future<DocumentSnapshot> getUserDocument(String userId) async {
    try {
      // Get the user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userDoc;
    } catch (e) {
      // Handle any errors
      print('Error fetching user document: $e');
      throw e;
    }
  }

  Future<void> fetchAllOrganizations() async {
    try {
      _organizationStream = firebaseService.getAllOrganizations();
      notifyListeners();
    } catch (e) {
      print('Error fetching all organizations: $e');
    }
  }

  // Update a donation
  Future<void> updateDonation(Donation donation) async {
    try {
      await firebaseService.updateDonation(donation);
      notifyListeners();
    } catch (e) {
      print("Error updating donation: $e");
    }
  }
}
