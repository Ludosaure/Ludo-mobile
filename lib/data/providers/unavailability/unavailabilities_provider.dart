import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/core/http_helper.dart';
import 'package:ludo_mobile/core/repository_helper.dart';
import 'package:ludo_mobile/data/providers/unavailability/unavailability_json.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

@injectable
class UnavailabilitiesProvider {
  final String _baseUrl ='${AppConstants.API_URL}/unavailability';

  Future<void> createUnavailability(UnavailabilityJson unavailabilityJson) async {
    final String? token = await RepositoryHelper.getAdminToken();

    final http.Response response = await http.post(
      Uri.parse(_baseUrl),
      headers: HttpHelper.getHeaders(token!),
      body: jsonEncode(unavailabilityJson.toJson()),
    ).catchError((error) {
      HttpHelper.handleRequestException(error);
    });
    if(response.statusCode == HttpCode.NOT_FOUND) {
      throw NotFoundException('errors.game-not-found'.tr());
    }

    if(response.statusCode == HttpCode.CONFLICT) {
      throw NotFoundException('errors.unavailability-conflict'.tr());
    }

    if(response.statusCode != HttpCode.CREATED) {
      throw InternalServerException('errors.unknown'.tr());
    }
  }

  Future<void> deleteUnavailability(UnavailabilityJson unavailabilityJson) async {
    final String? token = await RepositoryHelper.getAdminToken();

    final http.Response response = await http.delete(
      Uri.parse(_baseUrl),
      headers: HttpHelper.getHeaders(token!),
      body: jsonEncode(unavailabilityJson.toJson()),
    ).catchError((error) {
      HttpHelper.handleRequestException(error);
    });

    if(response.statusCode == HttpCode.NOT_FOUND) {
      throw NotFoundException('errors.game-or-unavailability-not-found'.tr());
    }

    if(response.statusCode != HttpCode.OK) {
      throw InternalServerException('errors.unknown'.tr());
    }
  }
}

