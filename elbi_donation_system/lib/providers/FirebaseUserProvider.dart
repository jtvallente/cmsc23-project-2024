import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/api/FirebaseUserAPI.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:elbi_donation_system/models/donation.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/models/donationdrive.dart';

class FirebaseUserProvider with ChangeNotifier {
  FirebaseUserAPI firebaseService = FirebaseUserAPI();
  List<Donation> _userDonations = [];
  List<DonationDrive> _userDonationDrives = []; // Add this line
  Stream<QuerySnapshot>? _organizationStream;
  Stream<QuerySnapshot>? _organizationDonationsStream;
  Stream<QuerySnapshot>? _donationDrivesStream;

  List<String> _proofOfLegitimacyBase64 = [];
  List<File> _selectedFiles = [];
  List<String> _photos = [];

  List<String> get proofOfLegitimacyBase64 => _proofOfLegitimacyBase64;
  List<File> get selectedFiles => _selectedFiles;
  List<String> get photos => _photos;
  List<Donation> get userDonations => _userDonations;
  List<DonationDrive> get userDonationDrives =>
      _userDonationDrives; // Add this line
  Stream<QuerySnapshot>? get organizationStream => _organizationStream;
  Stream<QuerySnapshot>? get organizationDonationsStream =>
      _organizationDonationsStream;
  Stream<QuerySnapshot>? get donationDrivesStream => _donationDrivesStream;

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

  // Update a user
  Future<void> updateUser(User user) async {
    try {
      await firebaseService.updateUser(user);
      notifyListeners();
    } catch (e) {
      print("Error updating donation: $e");
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

  // Update a donation
  Future<void> updateByQr(String donationId) async {
    try {
      await firebaseService.updateByQr(donationId);
      notifyListeners();
    } catch (e) {
      print("Error updating donation: $e");
    }
  }

  // Get the donations sent to an org
  Future<void> getAllUserDonations(String uid) async {
    try {
      _organizationDonationsStream = firebaseService.getAllUserDonations(uid);
      notifyListeners();
    } catch (e) {
      print("Error fetching donations: $e");
    }
  }

  // Create a donation drive
  Future<void> createDonationDrive(DonationDrive newDonationDrive) async {
    try {
      await firebaseService.addDonationDrive(newDonationDrive);
      notifyListeners();
    } catch (e) {
      print("Error creating donation drive: $e");
    }
  }

  // Fetch donation drives for an organization
  Future<void> fetchDonationDrives(String uid) async {
    try {
      _donationDrivesStream = firebaseService.getDonationDrives(uid);
      notifyListeners();
    } catch (e) {
      print("Error fetching donation drives: $e");
    }
  }

  // Fetch all donation drives for a user
  Future<void> fetchAllDonationDrives(String organizationId) async {
    try {
      _userDonationDrives =
          await firebaseService.getDonationDrivesForUser(organizationId);
      notifyListeners();
    } catch (e) {
      print('Error fetching donation drives: $e');
    }
  }

  // Add donation to a donation drive
  Future<void> addDonationToDrive(Donation donation, String driveId) async {
    try {
      await firebaseService.addDonationToDrive(donation, driveId);
      notifyListeners();
    } catch (e) {
      print('Error adding donation to drive: $e');
    }
  }

  Future<void> updateDonationDrive(DonationDrive donationDrive) async {
    try {
      await firebaseService.updateDonationDrive(donationDrive);
      notifyListeners();
    } catch (e) {
      print("Error updating donation drive: $e");
    }
  }

  Future<void> deleteDonationDrive(String uid) async {
    try {
      await firebaseService.deleteDonationDrive(uid);
      notifyListeners();
    } catch (e) {
      print("Error updating donation drive: $e");
    }
  }
}
