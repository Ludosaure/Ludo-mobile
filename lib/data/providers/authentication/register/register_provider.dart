import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/data/providers/authentication/register/register_request.dart';

import 'package:http/http.dart' as http;
import 'package:ludo_mobile/utils/app_constants.dart';

@injectable
class RegisterProvider {
  final baseUrl = AppConstants.API_URL;

  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/register'),
      body: {
        'email': request.email,
        'password': request.password,
        'confirmPassword': request.confirmPassword,
        'firstname': request.firstname,
        'lastname': request.lastname,
        'phone': request.phone,
      },
    );

    if (response.statusCode == HttpCode.CREATED) {
      return RegisterResponse();
    } else if (response.statusCode == HttpCode.CONFLICT) {
      throw const EmailAlreadyUsedException(
          'Un compte utilisant cet email existe déjà'
      );
    } else {
      throw Exception('Erreur inconnue');
    }
  }

  Future<RegisterResponse> resendConfirmAccountEmail(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/resend-confirmation-mail'),
      body: {
        'email': email,
      },
    );

    if (response.statusCode == HttpCode.OK) {
      return RegisterResponse();
    } else if (response.statusCode == HttpCode.NOT_FOUND) {
      return RegisterResponse();
    } else {
      throw Exception('Erreur inconnue');
    }
  }
}

class RegisterResponse {}
