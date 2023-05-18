import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

import 'package:http/http.dart' as http;

import 'game_json.dart';

@injectable
class GameProvider {
  final String baseUrl = '${AppConstants.API_URL}/game';

  Future<GameListingResponse> getGames() async {
    late http.Response response;

    response = await http.get(
      Uri.parse(baseUrl),
    ).catchError((error) {
      if(error is SocketException) {
        throw const ServiceUnavailableException('Service indisponible. Veuillez réessayer ultérieurement');
      }

      throw const InternalServerException('Erreur inconnue');
    });

    if(response.statusCode != HttpCode.OK) {
      print(response.statusCode);
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

}

class GameListingResponse {
  List<GameJson> games;

  GameListingResponse({
    required this.games,
  });
}