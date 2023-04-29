import 'package:flutter/material.dart';
import 'package:ludo_mobile/utils/custom_theme.dart';

class FormFieldDecoration extends InputDecoration {

  static InputDecoration textField(String label) {
    return InputDecoration(
      fillColor: CustomTheme.formColor,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      labelText: label,
      isDense: true,
    );
  }

  static InputDecoration passwordField(
      String label,
      VoidCallback onPressed,
      bool obscureText,
    ) {
    return InputDecoration(
      fillColor: CustomTheme.formColor,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      labelText: label,
      isDense: true,
      suffixIcon: IconButton(
        splashRadius: 10,
        onPressed: onPressed,
        icon: obscureText
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility),
      ),
    );
  }
}
