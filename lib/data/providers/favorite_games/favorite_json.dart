class FavoriteJson {
  String userId;
  String gameId;
  DateTime createdAt;

  FavoriteJson({
    required this.userId,
    required this.gameId,
    required this.createdAt,
  });

  factory FavoriteJson.fromJson(Map<String, dynamic> json) {
    return FavoriteJson(
      userId: json['userId'],
      gameId: json['gameId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

}