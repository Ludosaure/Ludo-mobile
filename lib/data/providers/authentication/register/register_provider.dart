import 'package:injectable/injectable.dart';
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
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == HttpCode.CREATED) {
      return RegisterResponse();
    } else {
      throw Exception('Erreur inconnue');
    }
  }

  Future<RegisterResponse> resendConfirmAccountEmail(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/resend-confirmation-email'),
      body: {
        'email': email,
      },
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == HttpCode.CREATED) { //TODO changer par 200 quand l'api sera fix
      return RegisterResponse();
    } else {
      throw Exception('Erreur inconnue');
    }
  }

}

class RegisterResponse {

}