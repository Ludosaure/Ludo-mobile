import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/data/providers/favorite_games/get_favorite_games_response.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:ludo_mobile/utils/local_storage_helper.dart';

import 'favorite_json.dart';

@injectable
class FavoriteGamesProvider {
  final String _baseUrl ='${AppConstants.API_URL}/favorite';


  Future<GetFavoriteGamesResponse> getFavorites(String userId) async {
    final String? userToken = await LocalStorageHelper.getTokenFromLocalStorage();
    if(userToken == null) {
      throw UserNotLoggedInException('errors.user-must-log-for-action'.tr());
    }

    final http.Response response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    ).catchError((error) {
      if(error is SocketException) {
        throw ServiceUnavailableException('errors.service-unavailable'.tr());
      }

      throw InternalServerException('errors.unknown'.tr());
    });

    if(response.statusCode == HttpCode.UNAUTHORIZED) {
      throw UserNotLoggedInException('errors.user-must-log-for-action'.tr());
    }

    if(response.statusCode != HttpCode.OK) {
      throw InternalServerException('errors.unknown'.tr());
    }

    List<FavoriteJson> games = [];
    final decodedResponse = jsonDecode(response.body);

    decodedResponse["favoriteGames"].forEach((element) {
      games.add(FavoriteJson.fromJson(element));
    });

    return GetFavoriteGamesResponse(
      favorites: games,
    );
  }

  Future<void> addToFavorite(String gameId) async {
    final String? userToken = await LocalStorageHelper.getTokenFromLocalStorage();
    if(userToken == null) {
      throw UserNotLoggedInException('errors.user-must-log-for-action'.tr());
    }

    final http.Response response = await http.post(
      Uri.parse("$_baseUrl/$gameId"),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    ).catchError((error) {
      if(error is SocketException) {
        throw ServiceUnavailableException('errors.service-unavailable'.tr());
      }

      throw InternalServerException('errors.unknown'.tr());
    });
    if(response.statusCode == HttpCode.NOT_FOUND) {
      throw NotFoundException('errors.game-not-found'.tr());
    }

    if(response.statusCode == HttpCode.BAD_REQUEST) {
      throw BadRequestException('errors.favorite-already-exists'.tr());
    }

    if(response.statusCode != HttpCode.CREATED) {
      throw InternalServerException('errors.unknown'.tr());
    }
  }

  Future<void> removeFromFavorite(String gameId) async {
    final String? userToken = await LocalStorageHelper.getTokenFromLocalStorage();
    if(userToken == null) {
      throw UserNotLoggedInException('errors.user-must-log-for-action'.tr());
    }

    final http.Response response = await http.delete(
      Uri.parse("$_baseUrl/$gameId"),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    ).catchError((error) {
      if(error is SocketException) {
        throw ServiceUnavailableException('errors.service-unavailable'.tr());
      }

      throw InternalServerException('errors.unknown'.tr());
    });

    if(response.statusCode == HttpCode.NOT_FOUND) {
      throw NotFoundException('errors.game-not-found'.tr());
    }

    if(response.statusCode != HttpCode.OK) {
      throw InternalServerException('errors.unknown'.tr());
    }
  }

}

