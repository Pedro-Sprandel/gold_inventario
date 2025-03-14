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
    apiKey: 'AIzaSyCw_IDer6FDjDtSWbBBze_HlccYBsCZ9EI',
    appId: '1:185343472652:web:2a1ec548fa21439a1cea29',
    messagingSenderId: '185343472652',
    projectId: 'goldinventario-2868a',
    authDomain: 'goldinventario-2868a.firebaseapp.com',
    storageBucket: 'goldinventario-2868a.firebasestorage.app',
    measurementId: 'G-V113ZXFK04',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDihNDdbNQbLF5LngY_r3tuNWXQ9p73mxc',
    appId: '1:185343472652:android:dbf3c3ac0fe899a31cea29',
    messagingSenderId: '185343472652',
    projectId: 'goldinventario-2868a',
    storageBucket: 'goldinventario-2868a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC373i3yR7uMcgeljJ4kcrCV_j8ft3a-qQ',
    appId: '1:185343472652:ios:0c6b35e9c148d20d1cea29',
    messagingSenderId: '185343472652',
    projectId: 'goldinventario-2868a',
    storageBucket: 'goldinventario-2868a.firebasestorage.app',
    iosBundleId: 'com.goldinventory.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC373i3yR7uMcgeljJ4kcrCV_j8ft3a-qQ',
    appId: '1:185343472652:ios:0c6b35e9c148d20d1cea29',
    messagingSenderId: '185343472652',
    projectId: 'goldinventario-2868a',
    storageBucket: 'goldinventario-2868a.firebasestorage.app',
    iosBundleId: 'com.goldinventory.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCw_IDer6FDjDtSWbBBze_HlccYBsCZ9EI',
    appId: '1:185343472652:web:a9d39cdf887957321cea29',
    messagingSenderId: '185343472652',
    projectId: 'goldinventario-2868a',
    authDomain: 'goldinventario-2868a.firebaseapp.com',
    storageBucket: 'goldinventario-2868a.firebasestorage.app',
    measurementId: 'G-274XEY17D8',
  );
}
