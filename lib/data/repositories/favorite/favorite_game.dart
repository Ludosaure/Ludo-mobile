import 'package:ludo_mobile/data/providers/favorite_games/favorite_json.dart';

class FavoriteGame {
  String gameId;
  String name;
  String? picture;

  FavoriteGame({
    required this.gameId,
    required this.name,
    required this.picture,
  });

  factory FavoriteGame.fromFavoriteJson(FavoriteJson json) => FavoriteGame(
    gameId: json.gameId,
    name: "name",
    picture: null,
  );
}