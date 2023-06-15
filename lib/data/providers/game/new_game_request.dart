class NewGameRequest {
  final String name;
  final String? description;
  final double weeklyAmount;
  final String categoryId;
  final int minAge;
  final int averageDuration;
  final int minPlayers;
  final int maxPlayers;

  NewGameRequest({
    required this.name,
    this.description,
    required this.weeklyAmount,
    required this.categoryId,
    required this.minAge,
    required this.averageDuration,
    required this.minPlayers,
    required this.maxPlayers,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'weeklyAmount': weeklyAmount,
      'categoryId': categoryId,
      'ageMin': minAge,
      'averageDuration': averageDuration,
      'nbPlayersMin': minPlayers,
      'nbPlayersMax': maxPlayers,
    };
  }
}