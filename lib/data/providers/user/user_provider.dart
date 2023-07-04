import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/core/http_helper.dart';
import 'package:ludo_mobile/data/providers/user/update_user_request.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

@injectable
class UserProvider {
  final String baseUrl = '${AppConstants.API_URL}/user';

  Future<User> updateUser(String token, UpdateUserRequest user) async {
    final http.Response response = await http
        .put(
      Uri.parse(baseUrl),
      headers: HttpHelper.getHeaders(token),
      body: jsonEncode(user),
    ).catchError((error) {
      HttpHelper.handleRequestException(error);
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
