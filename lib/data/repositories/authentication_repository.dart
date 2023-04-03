import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/authentication/login/login_provider.dart';
import 'package:ludo_mobile/data/providers/authentication/login/login_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

@injectable
class AuthenticationRepository {
  final LoginProvider loginProvider;
  late SharedPreferences _localStorage;

  AuthenticationRepository({required this.loginProvider});

  Future<User> login(LoginRequest request) async {
    final response = await loginProvider.login(request);

    _localStorage = await SharedPreferences.getInstance();
    _localStorage.setString("token", response.accessToken);

    return response.user;
  }
}