class UpdateGameRequest {
  final String id;
  final String? name;
  final String? description;
  final double? weeklyAmount;
  final String? categoryId;
  final int? minAge;
  final int? averageDuration;
  final int? minPlayers;
  final int? maxPlayers;
  final String? image;

  UpdateGameRequest({
    required this.id,
    this.name,
    this.description,
    this.weeklyAmount,
    this.categoryId,
    this.minAge,
    this.averageDuration,
    this.minPlayers,
    this.maxPlayers,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'weeklyAmount': weeklyAmount,
      'categoryId': categoryId,
      'ageMin': minAge,
      'averageDuration': averageDuration,
      'nbPlayersMin': minPlayers,
      'nbPlayersMax': maxPlayers,
      'pictureId': image,
    };
  }
}