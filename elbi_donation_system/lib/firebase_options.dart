// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAJ3hR9dtbycM-7bcPfTMOcgUzKy2U_jk8',
    appId: '1:375537015706:web:d302fd9b7e98b876bfb823',
    messagingSenderId: '375537015706',
    projectId: 'cmsc23-elbi-donation-sys',
    authDomain: 'cmsc23-elbi-donation-sys.firebaseapp.com',
    storageBucket: 'cmsc23-elbi-donation-sys.appspot.com',
    measurementId: 'G-YD2GZ3RW6F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB59paZvb48borwNpJyxKYA55m5aOV2jAw',
    appId: '1:375537015706:android:f60ea8da005361d4bfb823',
    messagingSenderId: '375537015706',
    projectId: 'cmsc23-elbi-donation-sys',
    storageBucket: 'cmsc23-elbi-donation-sys.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9CqbIwoQGsmx4E456wcGF7GvZRmPNJN0',
    appId: '1:375537015706:ios:1658591a218edbfbbfb823',
    messagingSenderId: '375537015706',
    projectId: 'cmsc23-elbi-donation-sys',
    storageBucket: 'cmsc23-elbi-donation-sys.appspot.com',
    iosBundleId: 'com.example.elbiDonationSystem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9CqbIwoQGsmx4E456wcGF7GvZRmPNJN0',
    appId: '1:375537015706:ios:1658591a218edbfbbfb823',
    messagingSenderId: '375537015706',
    projectId: 'cmsc23-elbi-donation-sys',
    storageBucket: 'cmsc23-elbi-donation-sys.appspot.com',
    iosBundleId: 'com.example.elbiDonationSystem',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAJ3hR9dtbycM-7bcPfTMOcgUzKy2U_jk8',
    appId: '1:375537015706:web:d0647037dd13701dbfb823',
    messagingSenderId: '375537015706',
    projectId: 'cmsc23-elbi-donation-sys',
    authDomain: 'cmsc23-elbi-donation-sys.firebaseapp.com',
    storageBucket: 'cmsc23-elbi-donation-sys.appspot.com',
    measurementId: 'G-9Z4FQ6VX3T',
  );
}
