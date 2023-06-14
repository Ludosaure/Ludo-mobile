import 'package:ludo_mobile/domain/models/game.dart';

class FavoriteJson {
  String userId;
  String gameId;
  DateTime createdAt;
  Game game;

  FavoriteJson({
    required this.userId,
    required this.gameId,
    required this.createdAt,
    required this.game,
  });

  factory FavoriteJson.fromJson(Map<String, dynamic> json) {
    return FavoriteJson(
      userId: json['userId'],
      gameId: json['gameId'],
      createdAt: DateTime.parse(json['createdAt']),
      game: Game.fromJson(json['game']),
    );
  }

}