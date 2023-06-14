import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

import 'package:http/http.dart' as http;

import 'game_json.dart';
import 'game_listing_response.dart';

@injectable
class GameProvider {
  final String baseUrl = '${AppConstants.API_URL}/game';

  Future<GameListingResponse> getGames() async {
    final http.Response response = await http
        .get(
      Uri.parse(baseUrl),
    )
        .catchError((error) {
      if (error is SocketException) {
        throw ServiceUnavailableException('errors.service-unavailable'.tr());
      }

      throw InternalServerException('errors.unknown'.tr());
    });

    if (response.statusCode != HttpCode.OK) {
      throw InternalServerException('errors.unknown'.tr());
    }

    List<GameJson> games = [];
    final decodedResponse = jsonDecode(response.body);

    decodedResponse["games"].forEach((element) {
      games.add(GameJson.fromJson(element));
    });

    return GameListingResponse(
      games: games,
    );
  }

  Future<GameJson> getGame(String gameId) async {
    final http.Response response = await http
        .get(
      Uri.parse("$baseUrl/id/$gameId"),
    )
        .catchError((error) {
      if (error is SocketException) {
        throw ServiceUnavailableException(
          'errors.service-unavailable'.tr(),
        );
      }

      throw InternalServerException('errors.unknown'.tr());
    });

    if (response.statusCode == HttpCode.NOT_FOUND) {
      throw NotFoundException(
        "errors.game-not-found".tr(),
      );
    }

    if (response.statusCode != HttpCode.OK) {
      throw InternalServerException(
        "errors.unknown".tr(),
      );
    }

    final decodedResponse = jsonDecode(response.body);

    return GameJson.fromJson(decodedResponse["game"]);
  }

  Future<void> deleteGame(String gameId) async {
    final http.Response response = await http
        .delete(
      Uri.parse("$baseUrl/id/$gameId"),
    )
        .catchError((error) {
      if (error is SocketException) {
        throw ServiceUnavailableException(
          'errors.service-unavailable'.tr(),
        );
      }

      throw InternalServerException('errors.unknown'.tr());
    });

    if (response.statusCode == HttpCode.NOT_FOUND) {
      throw NotFoundException(
        "errors.game-not-found".tr(),
      );
    }

    if(response.statusCode == HttpCode.FORBIDDEN) {
      throw ForbiddenException(
        "errors.forbidden".tr(),
      );
    }

    if (response.statusCode != HttpCode.OK) {
      throw InternalServerException(
        "errors.unknown".tr(),
      );
    }
  }
}
