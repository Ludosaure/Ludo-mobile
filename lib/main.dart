import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ludo_mobile/firebase/service/custom_firebase_messaging_service.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app.dart';

void main() async {

  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  configureDependencies();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['API_KEY']!,
        appId: dotenv.env['API_ID']!,
        messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['PROJECT_ID']!,
      ),
    );

  } else {
    //Assign publishable key to flutter_stripe
    // /!\ ne fonctionne pas sur la version web
    Stripe.publishableKey =
    "pk_test_51NGLjAJ5n1NSvDOyGv9PteSw7835HWvCxj2eDX6v0nPoar5QfCQ04NgREpPHo8xzr0Hvfs5ux1EQE7YaOpGxPBcv00hQEoqper";

    await Firebase.initializeApp();
  }

  CustomFirebaseMessagingService.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('fr'),
      ],
      fallbackLocale: const Locale('fr'),
      path: 'assets/translations',
      child: const MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

