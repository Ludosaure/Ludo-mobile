
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/domain/models/game_category.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:http/http.dart' as http;

@injectable
class CategoryProvider {
  final String _endpoint = '${AppConstants.API_URL}/category';

  Future<List<GameCategory>> listCategories(String token) async {
    final response = await http.get(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $token',
      }
    ).catchError((error) {
      if (error is SocketException) {
        throw ServiceUnavailableException('errors.service-unavailable'.tr());
      }

      throw InternalServerException('errors.unknown'.tr());
    });

    if (response.statusCode == HttpCode.UNAUTHORIZED) {
      throw ForbiddenException('errors.forbidden-access'.tr());
    } else if (response.statusCode != HttpCode.OK) {
      throw InternalServerException('errors.unknown'.tr());
    }

    List<GameCategory> categories = [];

    jsonDecode(response.body)["categories"].forEach((category) {
      categories.add(GameCategory.fromJson(category));
    });

    return categories;
  }
}