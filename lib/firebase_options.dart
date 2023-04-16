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
    apiKey: 'AIzaSyAw3wtzwd5Pu55vlBTYJYHeY6uu4G_yGEw',
    appId: '1:620984871250:web:94f23a51a8623b254b328b',
    messagingSenderId: '620984871250',
    projectId: 'caleg-383907',
    authDomain: 'caleg-383907.firebaseapp.com',
    storageBucket: 'caleg-383907.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIB_vplhlxmerAu52yC5s3312LTnbv5cI',
    appId: '1:620984871250:android:5961def92e1fd3ce4b328b',
    messagingSenderId: '620984871250',
    projectId: 'caleg-383907',
    storageBucket: 'caleg-383907.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAL4aKJLqj6odak4iHU98LYaG3d1kCAxbg',
    appId: '1:620984871250:ios:46817fb8651b9cf94b328b',
    messagingSenderId: '620984871250',
    projectId: 'caleg-383907',
    storageBucket: 'caleg-383907.appspot.com',
    iosClientId: '620984871250-s47qu2bmvp3ois1cqv33u25ijjum61cc.apps.googleusercontent.com',
    iosBundleId: 'com.example.calegAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAL4aKJLqj6odak4iHU98LYaG3d1kCAxbg',
    appId: '1:620984871250:ios:46817fb8651b9cf94b328b',
    messagingSenderId: '620984871250',
    projectId: 'caleg-383907',
    storageBucket: 'caleg-383907.appspot.com',
    iosClientId: '620984871250-s47qu2bmvp3ois1cqv33u25ijjum61cc.apps.googleusercontent.com',
    iosBundleId: 'com.example.calegAdmin',
  );
}
