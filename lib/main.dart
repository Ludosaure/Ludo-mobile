import 'package:flutter/material.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:easy_localization/easy_localization.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  configureDependencies();

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
