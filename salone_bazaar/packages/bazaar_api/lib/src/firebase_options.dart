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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD2cC8iuLsp2luQXYKZtHvo6FU-6SAArq0',
    appId: '1:618975334192:web:79773bfc531a448e0742f5',
    messagingSenderId: '618975334192',
    projectId: 'salone-bazaar',
    authDomain: 'salone-bazaar.firebaseapp.com',
    storageBucket: 'salone-bazaar.appspot.com',
    measurementId: 'G-MLDX9H2S6E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-yzXv7MQMliOtdvO07M4X6piDVJ3ETlw',
    appId: '1:618975334192:android:298b9324d4c01a0c0742f5',
    messagingSenderId: '618975334192',
    projectId: 'salone-bazaar',
    storageBucket: 'salone-bazaar.appspot.com',
  );
}