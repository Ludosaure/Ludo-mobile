import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/favorite_games/favorite_games_provider.dart';
import 'package:ludo_mobile/data/providers/favorite_games/get_favorite_games_response.dart';
import 'package:ludo_mobile/data/repositories/favorite/favorite_game.dart';

@injectable
class FavoriteGamesRepository {
  final FavoriteGamesProvider favoriteProvider;

  FavoriteGamesRepository({
    required this.favoriteProvider,
  });

  Future<List<FavoriteGame>> getFavorites(String userId) async {
    final GetFavoriteGamesResponse response = await favoriteProvider.getFavorites(userId);

    List<FavoriteGame> games = [];

    for (var element in response.favorites) {
      games.add(FavoriteGame.fromFavoriteJson(element));
    }

    return games;
  }

  Future<void> addToFavorite(String gameId) async {
    await favoriteProvider.addToFavorite(gameId);
  }

  Future<void> removeFromFavorite(String gameId) async {
    await favoriteProvider.removeFromFavorite(gameId);
  }
}