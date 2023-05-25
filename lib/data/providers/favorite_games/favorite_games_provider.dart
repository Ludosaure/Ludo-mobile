import 'dart:convert';
import 'dart:io';

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
      throw const UserNotLoggedInException('Vous devez être connecté pour accéder à vos favoris');
    }

    final http.Response response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    ).catchError((error) {
      if(error is SocketException) {
        throw const ServiceUnavailableException('Service indisponible. Veuillez réessayer ultérieurement');
      }

      throw const InternalServerException('Erreur inconnue');
    });

    if(response.statusCode == HttpCode.UNAUTHORIZED) {
      throw const UserNotLoggedInException('Vous devez être connecté pour accéder à vos favoris');
    }

    if(response.statusCode != HttpCode.OK) {
      throw const InternalServerException('Erreur inconnue');
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
      throw const UserNotLoggedInException('Vous devez être connecté pour ajouter un jeu à vos favoris');
    }

    final http.Response response = await http.post(
      Uri.parse("$_baseUrl/$gameId"),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    ).catchError((error) {
      if(error is SocketException) {
        throw const ServiceUnavailableException('Service indisponible. Veuillez réessayer ultérieurement');
      }

      throw const InternalServerException('Erreur inconnue');
    });
    if(response.statusCode == HttpCode.NOT_FOUND) {
      throw const NotFoundException('Impossible de trouver le jeu que vous essayer d\'ajouter.');
    }

    if(response.statusCode == HttpCode.BAD_REQUEST) {
      throw const BadRequestException('Ce jeu est fait déjà partie de vos favoris.');
    }

    if(response.statusCode != HttpCode.CREATED) {
      throw const InternalServerException('Erreur inconnue');
    }
  }

  Future<void> removeFromFavorite(String gameId) async {
    final String? userToken = await LocalStorageHelper.getTokenFromLocalStorage();
    if(userToken == null) {
      throw const UserNotLoggedInException('Vous devez être connecté pour ajouter un jeu à vos favoris');
    }

    final http.Response response = await http.delete(
      Uri.parse("$_baseUrl/$gameId"),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    ).catchError((error) {
      if(error is SocketException) {
        throw const ServiceUnavailableException('Service indisponible. Veuillez réessayer ultérieurement');
      }

      throw const InternalServerException('Erreur inconnue');
    });

    if(response.statusCode == HttpCode.NOT_FOUND) {
      throw const NotFoundException('Ce jeu n\'existe pas ou n\'est pas dans vos favoris');
    }

    if(response.statusCode != HttpCode.OK) {
      throw const InternalServerException('Erreur inconnue');
    }
  }

}
