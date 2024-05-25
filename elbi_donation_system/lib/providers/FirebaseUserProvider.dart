import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/api/FirebaseUserAPI.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';

class FirebaseUserProvider with ChangeNotifier {
    FirebaseUserAPI firebaseService = FirebaseUserAPI();
  List<String> _proofOfLegitimacyBase64 = [];
  List<File> _selectedFiles = [];

  List<String> get proofOfLegitimacyBase64 => _proofOfLegitimacyBase64;
  List<File> get selectedFiles => _selectedFiles;



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

  void removeFile(int index) {
    _selectedFiles.removeAt(index);
    _proofOfLegitimacyBase64.removeAt(index);
    notifyListeners();
  }

  // Future<void> uploadFile() async {
  //   if (_selectedFile != null) {
  //     try {
  //       FirebaseUserAPI firebaseStorageService = FirebaseUserAPI();
  //       String downloadUrl = await firebaseStorageService.uploadFile(
  //         _selectedFile!,
  //         'uploads/${_selectedFile!.path.split('/').last}',
  //       );
  //       _downloadUrl = downloadUrl;
  //       notifyListeners();
  //     } catch (e) {
  //       throw Exception('File upload failed: $e');
  //     }
  //   }
  // }
}
