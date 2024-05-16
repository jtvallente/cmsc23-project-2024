import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:elbi_donation_system/apis/FirebaseUserAPI.dart';

class FirebaseUserProvider with ChangeNotifier {
  List<String> _proofOfLegitimacyBase64 = [];

  List<String> get proofOfLegitimacyBase64 => _proofOfLegitimacyBase64;
  File? _selectedFile;
  File? get selectedFile => _selectedFile;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      _selectedFile = file;
      List<int> fileBytes = await file.readAsBytes();
      String base64File = base64Encode(fileBytes);

      // Add the Base64 string to the list
      _proofOfLegitimacyBase64.add(base64File);

      notifyListeners();
    }
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
