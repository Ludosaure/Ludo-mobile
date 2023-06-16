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

  static Future<String?> getTokenFromLocalStorage() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();

    return localStorage.getString('token');
  }

  static Future<void> saveUserToLocalStorage(User user, String token) async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();

    localStorage.setString('user', jsonEncode(user.toJson()));
    localStorage.setString('token', token);
  }

  static Future<void> saveFirebaseUserIdToLocalStorage(String userId) async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();

    localStorage.setString('firebaseUserId', userId);
  }

  static Future<String?> getFirebaseUserIdFromLocalStorage() async {
    final SharedPreferences localStorage =
    await SharedPreferences.getInstance();

    return localStorage.getString('firebaseUserId');
  }

  static Future<void> removeUserFromLocalStorage() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();

    localStorage.remove('user');
    localStorage.remove('token');
  }
}