import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
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

  Future<Game> getGame(String gameId) async {
    final GameJson gameJson = await _gameProvider.getGame(gameId);

    return gameJson.toGame();
  }

  Future<void> createGame(NewGameRequest newGame) async {
    final User? user = await LocalStorageHelper.getUserFromLocalStorage();

    if(user == null) {
      throw UserNotLoggedInException('errors.user-must-log-for-action'.tr());
    }

    if(!user.isAdmin()) {
      throw NotAllowedException('errors.user-must-be-admin-for-action'.tr());
    }

    final String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    await _gameProvider.createGame(token!, newGame);
  }

  Future<Game> updateGame(UpdateGameRequest game) async {
    final User? user = await LocalStorageHelper.getUserFromLocalStorage();

    if(user == null) {
      throw UserNotLoggedInException('errors.user-must-log-for-action'.tr());
    }

    if(!user.isAdmin()) {
      throw NotAllowedException('errors.user-must-be-admin-for-action'.tr());
    }

    final String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    GameJson updatedGameJson = await _gameProvider.updateGame(token!, game);

    return updatedGameJson.toGame();
  }

  //TODO implémenter côté backend
  Future<void> deleteGame(String gameId) async {
    await _gameProvider.deleteGame(gameId);
  }

}