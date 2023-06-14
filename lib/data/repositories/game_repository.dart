import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/game/game_json.dart';
import 'package:ludo_mobile/data/providers/game/game_listing_response.dart';
import 'package:ludo_mobile/data/providers/game/game_provider.dart';
import 'package:ludo_mobile/domain/models/game.dart';

@injectable
class GameRepository {
  final GameProvider _gameProvider;

  GameRepository(this._gameProvider);

  Future<List<Game>> getGames() async {
    final GameListingResponse response = await _gameProvider.getGames();

    List<Game> games = [];
    for (var element in response.games) {
      games.add(element.toGame());
    }

    return games;
  }

  Future<Game> getGame(String gameId) async {
    final GameJson gameJson = await _gameProvider.getGame(gameId);

    return gameJson.toGame();
  }

  //TODO implémenter côté backend
  Future<void> deleteGame(String gameId) async {
    await _gameProvider.deleteGame(gameId);
  }

}