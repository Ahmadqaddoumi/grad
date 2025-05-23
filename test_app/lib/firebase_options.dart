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
    apiKey: 'AIzaSyCKfmuLiY6EsMWi-o8UJ5jb0BD1efheS2c',
    appId: '1:1044667441169:web:2ee6fa702c1e97bf85d1b0',
    messagingSenderId: '1044667441169',
    projectId: 'graduation-project-48d98',
    authDomain: 'graduation-project-48d98.firebaseapp.com',
    storageBucket: 'graduation-project-48d98.firebasestorage.app',
    measurementId: 'G-5418H7DFEM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZruFiQILFXgJD3G26zPewTfeltnGREz8',
    appId: '1:1044667441169:android:9ed81ec331bc555985d1b0',
    messagingSenderId: '1044667441169',
    projectId: 'graduation-project-48d98',
    storageBucket: 'graduation-project-48d98.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCRYsw3bIPsuWUjeFNI9VKlQ1Pfiks1kiw',
    appId: '1:1044667441169:ios:d4a6c6c96e609c9685d1b0',
    messagingSenderId: '1044667441169',
    projectId: 'graduation-project-48d98',
    storageBucket: 'graduation-project-48d98.firebasestorage.app',
    iosBundleId: 'com.example.testApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCRYsw3bIPsuWUjeFNI9VKlQ1Pfiks1kiw',
    appId: '1:1044667441169:ios:d4a6c6c96e609c9685d1b0',
    messagingSenderId: '1044667441169',
    projectId: 'graduation-project-48d98',
    storageBucket: 'graduation-project-48d98.firebasestorage.app',
    iosBundleId: 'com.example.testApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCKfmuLiY6EsMWi-o8UJ5jb0BD1efheS2c',
    appId: '1:1044667441169:web:725e60dab64af95285d1b0',
    messagingSenderId: '1044667441169',
    projectId: 'graduation-project-48d98',
    authDomain: 'graduation-project-48d98.firebaseapp.com',
    storageBucket: 'graduation-project-48d98.firebasestorage.app',
    measurementId: 'G-65M9GYET3G',
  );
}
