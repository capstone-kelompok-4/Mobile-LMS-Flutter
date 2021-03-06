// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAWxFG0xU_TL1lrdPk05LE7pmNCeOwoIYI',
    appId: '1:318659695825:web:cbeeda75ec269301f8e1f0',
    messagingSenderId: '318659695825',
    projectId: 'lms-capstone-alterra',
    authDomain: 'lms-capstone-alterra.firebaseapp.com',
    databaseURL: 'https://lms-capstone-alterra-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'lms-capstone-alterra.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA0OLBngtR0PZc7eb3rv06kepkkU-YneLI',
    appId: '1:318659695825:android:1c21d266baf03e85f8e1f0',
    messagingSenderId: '318659695825',
    projectId: 'lms-capstone-alterra',
    databaseURL: 'https://lms-capstone-alterra-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'lms-capstone-alterra.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtePYC0jKJOUMV9QFd8nQ-RWFJtjH9Usg',
    appId: '1:318659695825:ios:c70ea841291d747df8e1f0',
    messagingSenderId: '318659695825',
    projectId: 'lms-capstone-alterra',
    databaseURL: 'https://lms-capstone-alterra-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'lms-capstone-alterra.appspot.com',
    iosClientId: '318659695825-6v7l41j40rmrvs04qviv2cjhdf2jsf7m.apps.googleusercontent.com',
    iosBundleId: 'com.fourthsense.lms',
  );
}
