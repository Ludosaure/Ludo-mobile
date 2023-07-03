import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/core/http_helper.dart';
import 'package:ludo_mobile/data/providers/game/new_game_request.dart';
import 'package:ludo_mobile/data/providers/game/update_game_request.dart';
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
      HttpHelper.handleRequestException(error);
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
      HttpHelper.handleRequestException(error);
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

    return GameJson.fromJson(
      decodedResponse["game"],
      canBeReviewed: decodedResponse["canReviewGame"],
    );
  }

  Future<GameJson> getGameForLoggedUser(
    String gameId,
    String token,
  ) async {
    final http.Response response = await http
        .get(
      Uri.parse("$baseUrl/id/$gameId/logged-user"),
      headers: HttpHelper.getHeaders(token),
    )
        .catchError((error) {
      HttpHelper.handleRequestException(error);
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

    return GameJson.fromJson(
      decodedResponse["game"],
      canBeReviewed: decodedResponse["canReviewGame"],
    );
  }

  Future<void> createGame(String token, NewGameRequest newGame) async {
    final http.Response response = await http
        .post(
      Uri.parse(baseUrl),
      headers: HttpHelper.getHeaders(token),
      body: jsonEncode(newGame),
    )
        .catchError((error) {
      HttpHelper.handleRequestException(error);
    });

    if (response.statusCode == HttpCode.FORBIDDEN) {
      throw NotAllowedException('errors.user-must-be-admin-for-action'.tr());
    }

    if (response.statusCode == HttpCode.BAD_REQUEST) {
      throw BadRequestException(
        "errors.game-creation-failed".tr(),
      );
    }

    if (response.statusCode != HttpCode.CREATED) {
      throw InternalServerException(
        "errors.unknown".tr(),
      );
    }
  }

  Future<GameJson> updateGame(String token, UpdateGameRequest game) async {
    final http.Response response = await http
        .put(
      Uri.parse(baseUrl),
      headers: HttpHelper.getHeaders(token),
      body: jsonEncode(game),
    )
        .catchError((error) {
      HttpHelper.handleRequestException(error);
    });

    if (response.statusCode == HttpCode.UNAUTHORIZED) {
      throw NotAllowedException('errors.user-must-be-admin-for-action'.tr());
    }

    if (response.statusCode == HttpCode.BAD_REQUEST) {
      throw BadRequestException(
        "errors.game-edition-failed".tr(),
      );
    }

    if (response.statusCode == HttpCode.CONFLICT) {
      throw NameAlreadyUsedException(
        "errors.name-already-used".tr(
          namedArgs: {
            "name": game.name!,
          },
        ),
      );
    }

    if (response.statusCode != HttpCode.OK) {
      throw InternalServerException(
        "errors.unknown".tr(),
      );
    }

    return GameJson.fromJson(
      jsonDecode(response.body),
    );
  }

  Future<void> deleteGame(
    String gameId,
    String token,
  ) async {
    final http.Response response = await http
        .delete(
      Uri.parse("$baseUrl/$gameId"),
      headers: HttpHelper.getHeaders(token),
    )
        .catchError((error) {
      HttpHelper.handleRequestException(error);
    });

    if (response.statusCode == HttpCode.NOT_FOUND) {
      throw NotFoundException(
        "errors.game-not-found".tr(),
      );
    }

    if (response.statusCode == HttpCode.BAD_REQUEST) {
      throw BadRequestException(
        "${"errors.game-deletion-failed".tr()} ${"errors.error-detail".tr(
          namedArgs: {
            "error": jsonDecode(response.body)["message"],
          },
        )}",
      );
    }

    if (response.statusCode == HttpCode.FORBIDDEN) {
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
