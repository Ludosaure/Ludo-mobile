import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ludo_mobile/injection.dart';

import 'app.dart';

void main() async {
  if(kReleaseMode) {
    await dotenv.load(fileName: "lib/.env");
  } else {
    await dotenv.load(fileName: "lib/.env.dist");
  }
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  runApp(const MyApp());
}
