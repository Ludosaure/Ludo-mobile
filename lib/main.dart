import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  //Assign publishable key to flutter_stripe
  // /!\ ne fonctionne pas sur la version web
  Stripe.publishableKey =
      "pk_test_51NGLjAJ5n1NSvDOyGv9PteSw7835HWvCxj2eDX6v0nPoar5QfCQ04NgREpPHo8xzr0Hvfs5ux1EQE7YaOpGxPBcv00hQEoqper";

  configureDependencies();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: dotenv.env['API_KEY']!,
      appId: dotenv.env['API_ID']!,
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['PROJECT_ID']!,
    ));
  } else {
    await Firebase.initializeApp();
  }

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
