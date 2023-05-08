import 'dart:convert';

import 'package:ludo_mobile/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  static Future<User?> getUserFromLocalStorage() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();

    User? user;
    final String? stringifiedUser = localStorage.getString('user');
    if (stringifiedUser != null) {
      user = User.fromJson(jsonDecode(stringifiedUser));
    }

    return user;
  }
}