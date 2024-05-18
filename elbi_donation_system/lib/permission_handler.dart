// lib/permission_handler.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions(BuildContext context) async {
  var cameraStatus = await Permission.camera.request();
  var storageStatus = await Permission.storage.request();

  if (cameraStatus.isGranted && storageStatus.isGranted) {
    await Permission.storage.request().isGranted;
  } else {
    // Handle the case when permissions are not granted
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Permissions Required'),
        content: Text(
            'This app needs camera and storage permissions to take and select images.'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Open Settings'),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
