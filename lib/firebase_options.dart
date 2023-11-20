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
        return macos;
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
    apiKey: 'AIzaSyCzGNPjUeeH_mK5bs8EeoDKz7igzt8qNGE',
    appId: '1:330731007959:web:676012d4f58d14986d2592',
    messagingSenderId: '330731007959',
    projectId: 'bookoodle-79747',
    authDomain: 'bookoodle-79747.firebaseapp.com',
    storageBucket: 'bookoodle-79747.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIrRK65T8QS6aFDi1NsR9-2zHMNnQi1-o',
    appId: '1:330731007959:android:a67685bdb757cf156d2592',
    messagingSenderId: '330731007959',
    projectId: 'bookoodle-79747',
    storageBucket: 'bookoodle-79747.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWtyb0yCT37HwTkIAHVE94LG_5KVrFnKU',
    appId: '1:330731007959:ios:ab9db2987713b7016d2592',
    messagingSenderId: '330731007959',
    projectId: 'bookoodle-79747',
    storageBucket: 'bookoodle-79747.appspot.com',
    iosBundleId: 'com.example.bookoodle',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCWtyb0yCT37HwTkIAHVE94LG_5KVrFnKU',
    appId: '1:330731007959:ios:d8c14f6d6b76fed76d2592',
    messagingSenderId: '330731007959',
    projectId: 'bookoodle-79747',
    storageBucket: 'bookoodle-79747.appspot.com',
    iosBundleId: 'com.example.bookoodle.RunnerTests',
  );
}