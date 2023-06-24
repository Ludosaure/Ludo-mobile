import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/data/providers/user/update_user_request.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

@injectable
class UserProvider {
  final String baseUrl = '${AppConstants.API_URL}/user';

  Future<User> getMyInfos(String token) async {
    final http.Response response = await http
        .get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).catchError((error) {
      if (error is SocketException) {
        throw ServiceUnavailableException(
          'errors.service-unavailable'.tr(),
        );
      }
      throw InternalServerException('errors.unknown'.tr());
    });

    if (response.statusCode == HttpCode.BAD_REQUEST) {
      throw BadRequestException(
        "errors.error-loading-user-data".tr(),
      );
    }

    if (response.statusCode != HttpCode.OK) {
      throw InternalServerException(
        "errors.unknown".tr(),
      );
    }

    return User.fromJson(jsonDecode(response.body));
  }

  Future<User> updateUser(String token, UpdateUserRequest user) async {
    final http.Response response = await http
        .put(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user),
    ).catchError((error) {
      if (error is SocketException) {
        throw ServiceUnavailableException(
          'errors.service-unavailable'.tr(),
        );
      }
      throw InternalServerException('errors.unknown'.tr());
    });

    if (response.statusCode == HttpCode.BAD_REQUEST) {
      throw BadRequestException("${'errors.user-edition-failed'.tr()} ${response.body}");
    }

    if (response.statusCode != HttpCode.OK) {
      throw InternalServerException(
        "errors.unknown".tr(),
      );
    }

    return User.fromJson(jsonDecode(response.body));
  }
}
