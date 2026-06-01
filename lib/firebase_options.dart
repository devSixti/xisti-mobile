// PLACEHOLDER — Regenerar con: flutterfire configure --project=xisti-app
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Configure Firebase for web via flutterfire configure.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: '1:REPLACE:android:REPLACE',
    messagingSenderId: 'REPLACE',
    projectId: 'REPLACE_ME',
    databaseURL: 'https://REPLACE_ME-default-rtdb.firebaseio.com',
    storageBucket: 'REPLACE_ME.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: '1:REPLACE:ios:REPLACE',
    messagingSenderId: 'REPLACE',
    projectId: 'REPLACE_ME',
    databaseURL: 'https://REPLACE_ME-default-rtdb.firebaseio.com',
    storageBucket: 'REPLACE_ME.firebasestorage.app',
    iosClientId: 'REPLACE.apps.googleusercontent.com',
    iosBundleId: 'com.app.xisti',
  );
}
