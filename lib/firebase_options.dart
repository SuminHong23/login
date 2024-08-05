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
    apiKey: 'AIzaSyBTkY-jvN3N4l4_Tk0Yk2u7t_JvcILSL2k',
    appId: '1:941025538402:web:9ef99f7d988f462c617c3b',
    messagingSenderId: '941025538402',
    projectId: 'mylogin-69e20',
    authDomain: 'mylogin-69e20.firebaseapp.com',
    storageBucket: 'mylogin-69e20.appspot.com',
    measurementId: 'G-R1B53YLLX0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCRas8tkiGjcGdwS2576PrxKzw9i9uaaHM',
    appId: '1:941025538402:android:ffe69a448a1de816617c3b',
    messagingSenderId: '941025538402',
    projectId: 'mylogin-69e20',
    storageBucket: 'mylogin-69e20.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmggHAfLiMfjznyC6OZRVqhhjuJbapUiE',
    appId: '1:941025538402:ios:fab36acb8dba313f617c3b',
    messagingSenderId: '941025538402',
    projectId: 'mylogin-69e20',
    storageBucket: 'mylogin-69e20.appspot.com',
    iosBundleId: 'com.example.untitled',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCmggHAfLiMfjznyC6OZRVqhhjuJbapUiE',
    appId: '1:941025538402:ios:fab36acb8dba313f617c3b',
    messagingSenderId: '941025538402',
    projectId: 'mylogin-69e20',
    storageBucket: 'mylogin-69e20.appspot.com',
    iosBundleId: 'com.example.untitled',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBTkY-jvN3N4l4_Tk0Yk2u7t_JvcILSL2k',
    appId: '1:941025538402:web:ef10ed86958a25fd617c3b',
    messagingSenderId: '941025538402',
    projectId: 'mylogin-69e20',
    authDomain: 'mylogin-69e20.firebaseapp.com',
    storageBucket: 'mylogin-69e20.appspot.com',
    measurementId: 'G-BBGP2NGX7J',
  );
}
