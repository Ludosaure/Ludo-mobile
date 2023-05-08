import 'game_category.dart';

class Game {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int averageDuration;
  final int minAge;
  final int minPlayers;
  final int maxPlayers;
  final List<String> categories;
  final double weeklyAmount;
  final double? rating;

  Game({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.averageDuration,
    required this.minAge,
    required this.minPlayers,
    required this.maxPlayers,
    required this.categories,
    required this.weeklyAmount,
    this.rating,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image'] ?? 'https://picsum.photos/200',
      averageDuration: json['averageDuration'],
      minAge: json['ageMin'],
      minPlayers: json['nbPlayersMin'],
      maxPlayers: json['nbPlayersMax'],
      categories:
          (json['category'] as List<GameCategory>).map((e) => e.name).toList(),
      weeklyAmount: json['weeklyAmount'],
      rating: json['rating'],
    );
  }
}
