import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
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
    ).catchError((error) {
      if (error is SocketException) {
        throw ServiceUnavailableException('errors.service-unavailable'.tr());
      }

      throw InternalServerException('errors.unknown'.tr());
    });

    if (response.statusCode == HttpCode.CREATED) {
      return RegisterResponse();
    } else if (response.statusCode == HttpCode.CONFLICT) {
      throw EmailAlreadyUsedException('errors.email-already-used'.tr());
    } else {
      throw Exception('errors.unknown'.tr());
    }
  }

  Future<RegisterResponse> resendConfirmAccountEmail(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/resend-confirmation-mail'),
      body: {
        'email': email,
      },
    ).catchError((error) {
      if (error is SocketException) {
        throw ServiceUnavailableException('errors.service-unavailable'.tr());
      }

      throw InternalServerException('errors.unknown'.tr());
    });

    if (response.statusCode == HttpCode.OK) {
      return RegisterResponse();
    } else if (response.statusCode == HttpCode.NOT_FOUND) {
      return RegisterResponse();
    } else {
      throw Exception('errors.unknown'.tr());
    }
  }
}

class RegisterResponse {}
