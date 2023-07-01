import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/repository_helper.dart';
import 'package:ludo_mobile/data/providers/game/game_json.dart';
import 'package:ludo_mobile/data/providers/game/game_listing_response.dart';
import 'package:ludo_mobile/data/providers/game/game_provider.dart';
import 'package:ludo_mobile/data/providers/game/new_game_request.dart';
import 'package:ludo_mobile/data/providers/game/update_game_request.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

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

  Future<Game> getGame(String gameId, User? user) async {
    if(user == null) {
      final GameJson gameJson = await _gameProvider.getGame(gameId);

      return gameJson.toGame();
    }

    final String? token = await LocalStorageHelper.getTokenFromLocalStorage();
    final GameJson gameJson = await _gameProvider.getGameForLoggedUser(gameId, token!);

    return gameJson.toGame();
  }

  Future<void> createGame(NewGameRequest newGame) async {
    final String? token = await RepositoryHelper.getAdminToken();

    await _gameProvider.createGame(token!, newGame);
  }

  Future<Game> updateGame(UpdateGameRequest game) async {
    final String? token = await RepositoryHelper.getAdminToken();

    GameJson updatedGameJson = await _gameProvider.updateGame(token!, game);

    return updatedGameJson.toGame();
  }

  Future<void> deleteGame(String gameId) async {
    final String? token = await RepositoryHelper.getAdminToken();

    await _gameProvider.deleteGame(gameId, token!);
  }



}