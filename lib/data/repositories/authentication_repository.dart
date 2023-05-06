import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/authentication/login/login_provider.dart';
import 'package:ludo_mobile/data/providers/authentication/login/login_request.dart';
import 'package:ludo_mobile/data/providers/authentication/register/register_provider.dart';
import 'package:ludo_mobile/data/providers/authentication/register/register_request.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class AuthenticationRepository {
  final LoginProvider loginProvider;
  final RegisterProvider registerProvider;
  late SharedPreferences _localStorage;

  AuthenticationRepository({
    required this.loginProvider,
    required this.registerProvider,
  });

  Future<User> login(LoginRequest request) async {
    final response = await loginProvider.login(request);

    _localStorage = await SharedPreferences.getInstance();
    _localStorage.setString("token", response.accessToken);
    _localStorage.setString("user", jsonEncode(response.user));

    return response.user;
  }

  Future<void> logout() async {
    _localStorage = await SharedPreferences.getInstance();
    _localStorage.remove("token");
    _localStorage.remove("user");
  }

  Future<void> register(RegisterRequest request) async {
    await registerProvider.register(request);
  }

  Future<void> resendConfirmAccountEmail(String email) async {
    await registerProvider.resendConfirmAccountEmail(email);
  }
}
