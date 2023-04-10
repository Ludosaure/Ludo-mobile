import 'package:flutter/material.dart';

class CustomTheme {
  static MaterialColor primary = MaterialColor(
    const Color.fromRGBO(125, 43, 136, 1).value,
    const <int, Color>{
      50: Color.fromRGBO(125, 43, 136, 0.1),
      100: Color.fromRGBO(125, 43, 136, 0.2),
      200: Color.fromRGBO(125, 43, 136, 0.3),
      300: Color.fromRGBO(125, 43, 136, 0.4),
      400: Color.fromRGBO(125, 43, 136, 0.5),
      500: Color.fromRGBO(125, 43, 136, 0.6),
      600: Color.fromRGBO(125, 43, 136, 0.7),
      700: Color.fromRGBO(125, 43, 136, 0.8),
      800: Color.fromRGBO(125, 43, 136, 0.9),
      900: Color.fromRGBO(125, 43, 136, 1),
    },
  );

  static MaterialColor primaryLight = MaterialColor(
    const Color.fromRGBO(164, 106, 171, 1).value,
    const <int, Color>{
      50: Color.fromRGBO(164, 106, 171, 0.1),
      100: Color.fromRGBO(164, 106, 171, 0.2),
      200: Color.fromRGBO(164, 106, 171, 0.3),
      300: Color.fromRGBO(164, 106, 171, 0.4),
      400: Color.fromRGBO(164, 106, 171, 0.5),
      500: Color.fromRGBO(164, 106, 171, 0.6),
      600: Color.fromRGBO(164, 106, 171, 0.7),
      700: Color.fromRGBO(164, 106, 171, 0.8),
      800: Color.fromRGBO(164, 106, 171, 0.9),
      900: Color.fromRGBO(164, 106, 171, 1),
    },
  );
}
