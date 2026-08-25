
        import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
        import 'package:flutter/foundation.dart' show kIsWeb;

        class DefaultFirebaseOptions {
          static FirebaseOptions get currentPlatform {
            if (kIsWeb) {
              return const FirebaseOptions(
                apiKey: "AIzaSyB7lkCT9qabljIr4kzeEVlUnsplKNHGqwA",
                appId: "1:179307236494:web:dfb1bd9c13477588cd0ddf",
                messagingSenderId: "179307236494",
                projectId: "sheikh-hussein-app-c3c07",
              );
            }
            throw UnsupportedError(
              'DefaultFirebaseOptions are not configured for this platform.',
            );
          }
        }