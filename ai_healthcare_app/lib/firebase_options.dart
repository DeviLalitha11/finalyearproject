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
    apiKey: 'AIzaSyAmBZclKPIVZfd0p5-xe6cNlWcXO5A8FfE',
    appId: '1:257428517544:web:ce45baf41a3b684b90089d',
    messagingSenderId: '257428517544',
    projectId: 'ai-healthcare-prediction',
    authDomain: 'ai-healthcare-prediction.firebaseapp.com',
    storageBucket: 'ai-healthcare-prediction.firebasestorage.app',
    measurementId: 'G-LRG1NX9K1G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5AsTUdtnj3zzbU6SViNiav9dX9XiqGvU',
    appId: '1:257428517544:android:6a5905db561faebc90089d',
    messagingSenderId: '257428517544',
    projectId: 'ai-healthcare-prediction',
    storageBucket: 'ai-healthcare-prediction.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsTByFFjm3vZQlIpKyTlVr7HjGqqus5Mg',
    appId: '1:257428517544:ios:2b68f5b36d673d8690089d',
    messagingSenderId: '257428517544',
    projectId: 'ai-healthcare-prediction',
    storageBucket: 'ai-healthcare-prediction.firebasestorage.app',
    iosClientId: '257428517544-745h8uul78tknmqki06ujst823mmo6i9.apps.googleusercontent.com',
    iosBundleId: 'com.example.aiHealthcareApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDsTByFFjm3vZQlIpKyTlVr7HjGqqus5Mg',
    appId: '1:257428517544:ios:2b68f5b36d673d8690089d',
    messagingSenderId: '257428517544',
    projectId: 'ai-healthcare-prediction',
    storageBucket: 'ai-healthcare-prediction.firebasestorage.app',
    iosClientId: '257428517544-745h8uul78tknmqki06ujst823mmo6i9.apps.googleusercontent.com',
    iosBundleId: 'com.example.aiHealthcareApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAmBZclKPIVZfd0p5-xe6cNlWcXO5A8FfE',
    appId: '1:257428517544:web:02e3f2edcd7203c090089d',
    messagingSenderId: '257428517544',
    projectId: 'ai-healthcare-prediction',
    authDomain: 'ai-healthcare-prediction.firebaseapp.com',
    storageBucket: 'ai-healthcare-prediction.firebasestorage.app',
    measurementId: 'G-81XT31CG0K',
  );

}