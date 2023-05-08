import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/game/game_provider.dart';
import 'package:ludo_mobile/domain/models/game.dart';

@injectable
class GameRepository {
  final GameProvider gameProvider;

  GameRepository({
    required this.gameProvider,
  });

  Future<List<Game>> getGames() async {
    final GameListingResponse response = await gameProvider.getGames();

    List<Game> games = [];
    for (var element in response.games) {
      games.add(element.toGame());
    }

    return games;
  }

}