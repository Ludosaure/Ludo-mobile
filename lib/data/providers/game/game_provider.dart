import 'dart:convert';
import 'dart:io';

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
        throw const ServiceUnavailableException(
            'Service indisponible. Veuillez réessayer ultérieurement');
      }

      throw const InternalServerException('Erreur inconnue');
    });

    if (response.statusCode != HttpCode.OK) {
      throw const InternalServerException('Erreur inconnue');
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
    final http.Response response =
        await http.get(Uri.parse("$baseUrl/$gameId")).catchError((error) {
      if (error is SocketException) {
        throw const ServiceUnavailableException(
            'Service indisponible. Veuillez réessayer ultérieurement');
      }

      throw const InternalServerException('Erreur inconnue');
    });

    return Future((() => GameJson(
        id: 'id',
        name: 'name',
        averageDuration: 45,
        ageMin: 10,
        nbPlayersMin: 12,
        nbPlayersMax: 12,
        category: List.empty(),
        weeklyAmount: 10.0,
        rating: 1,
        isArchived: false)));
  }
}
