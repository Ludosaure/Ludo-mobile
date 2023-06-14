import 'package:ludo_mobile/data/providers/game/game_json.dart';

class FavoriteJson {
  String userId;
  String gameId;
  DateTime createdAt;
  GameJson gameJson;

  FavoriteJson({
    required this.userId,
    required this.gameId,
    required this.createdAt,
    required this.gameJson,
  });

  factory FavoriteJson.fromJson(Map<String, dynamic> json) {
    return FavoriteJson(
      userId: json['userId'],
      gameId: json['gameId'],
      createdAt: DateTime.parse(json['createdAt']),
      gameJson: GameJson.fromJson(json['game']),
    );
  }

}