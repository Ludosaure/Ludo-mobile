import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/authentication/login/login_request.dart';

import '../../../models/user.dart';
import 'package:http/http.dart' as http;

@injectable
class LoginProvider {
  final baseUrl = dotenv.env['API_URL']!;

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/login'),
      body: {
        'email': request.email,
        'password': request.password,
      },
    );

    //TODO changer par 200 quand back modifié
    if (response.statusCode == 201) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
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

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      LoginResponse(
        accessToken: json["accessToken"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "user": user.toJson(),
      };
}