import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/authentication/login/login_provider.dart';
import 'package:ludo_mobile/data/providers/authentication/login/login_request.dart';
import 'package:ludo_mobile/data/providers/authentication/register/register_provider.dart';
import 'package:ludo_mobile/data/providers/authentication/register/register_request.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

@injectable
class AuthenticationRepository {
  final LoginProvider loginProvider;
  final RegisterProvider registerProvider;

  AuthenticationRepository({
    required this.loginProvider,
    required this.registerProvider,
  });

  Future<User> login(LoginRequest request) async {
    final response = await loginProvider.login(request);

    LocalStorageHelper.saveUserToLocalStorage(
      response.user,
      response.accessToken,
    );

    return response.user;
  }

  Future<void> logout() async {
    LocalStorageHelper.removeUserFromLocalStorage();
  }

  Future<void> register(RegisterRequest request) async {
    await registerProvider.register(request);
  }

  Future<void> resendConfirmAccountEmail(String email) async {
    await registerProvider.resendConfirmAccountEmail(email);
  }
}
