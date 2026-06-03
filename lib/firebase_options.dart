// Generated from Firebase console configs (project: xisti-app-ad901).
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Configure Firebase for web via flutterfire configure.',
      );
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
    apiKey: 'AIzaSyCXWKfKbBGa0HCF8p084SXOfsKt96VZY8g',
    appId: '1:980764435052:android:4f3b06c480ee148e87ee49',
    messagingSenderId: '980764435052',
    projectId: 'xisti-app-ad901',
    databaseURL: 'https://xisti-app-ad901-default-rtdb.firebaseio.com',
    storageBucket: 'xisti-app-ad901.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7a_ZtJkpH2xBm7ChzzCUXdOvbbc4U-ts',
    appId: '1:980764435052:ios:42e8f22a7615f00d87ee49',
    messagingSenderId: '980764435052',
    projectId: 'xisti-app-ad901',
    databaseURL: 'https://xisti-app-ad901-default-rtdb.firebaseio.com',
    storageBucket: 'xisti-app-ad901.firebasestorage.app',
    iosBundleId: 'com.app.xisti',
  );
}

/// Android may auto-init Firebase natively; avoid [core/duplicate-app] on second init.
Future<void> ensureFirebaseInitialized() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
}
