import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/favorite_games/favorite_games_provider.dart';

@injectable
class FavoriteGamesRepository {
  final FavoriteGamesProvider favoriteProvider;

  FavoriteGamesRepository({
    required this.favoriteProvider,
  });

  Future<List<FavoriteGame>> getFavorites(String userId) async {
    final GetFavoriteGamesResponse response = await favoriteProvider.getFavorites(userId);

    List<FavoriteGame> games = [];
    //TODO
    // for (var element in response.favorites) {
    //   games.add(element.toFavoriteGame());
    // }

    return games;
  }

  Future<void> addToFavorite(int gameId) async {
    await favoriteProvider.addToFavorite(gameId);
  }

  Future<void> removeFromFavorite(int gameId) async {
    await favoriteProvider.removeFromFavorite(gameId);
  }
}

//TODO
class FavoriteGame {
}