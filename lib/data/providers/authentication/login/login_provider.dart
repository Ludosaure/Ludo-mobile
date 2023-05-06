import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/data/providers/authentication/login/login_request.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

import 'package:http/http.dart' as http;

@injectable
class LoginProvider {
  final baseUrl = AppConstants.API_URL;

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/login'),
      body: {
        'email': request.email,
        'password': request.password,
      },
    );

    if (response.statusCode == HttpCode.OK) {
      return LoginResponse.fromJson(
        jsonDecode(response.body),
      );
    } else if (response.statusCode == HttpCode.BAD_REQUEST ||
        response.statusCode == HttpCode.NOT_FOUND) {
      throw const BadCredentialsException(
        "Erreur d'authentification, votre email ou votre mot de passe sont invalides",
      );
    } else if (response.statusCode == HttpCode.FORBIDDEN) {
      throw const UnverifiedAccountException(
          "Vous n'avez pas encore vérifié votre compte");
    } else {
      throw Exception('Erreur inconnue');
    }
  }
}

class LoginResponse {
  LoginResponse({
    required this.accessToken,
    required this.user,
  });

  String accessToken;
  User user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json["accessToken"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "user": user.toJson(),
      };
}
