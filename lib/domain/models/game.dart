import 'package:ludo_mobile/utils/extensions.dart';

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
  final double rating;
  final bool isArchived;
  final bool isAvailable;
  final List<DateTime> unavailableDates;

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
    required this.rating,
    required this.isArchived,
    required this.isAvailable,
    required this.unavailableDates,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    final List<String> categories = [];
    json["category"] != null ? json["categories"].forEach((category) {
      categories.add(GameCategory.fromJson(category).name);
    }) : [];

    final List<DateTime> unavailableDates = [];
    json["unavailabilities"] != null ? json["unavailabilities"].forEach((unavailability) {
      unavailableDates.add(DateTime.parse(unavailability['date']).toLocal());
    }) : [];

    return Game(
      id: json['id'],
      name: json['name'].toString().titleCase(),
      description: json['description'],
      imageUrl: json['imageUrl'],
      averageDuration: json['averageDuration'],
      minAge: json['ageMin'],
      minPlayers: json['nbPlayersMin'],
      maxPlayers: json['nbPlayersMax'],
      categories: categories,
      weeklyAmount: json['weeklyAmount'].toDouble(),
      rating: json['averageRating'] != null ? json['averageRating'].toDouble() : 0.0,
      isArchived: json['isArchived'],
      isAvailable: json['isAvailable'],
      unavailableDates: unavailableDates,
    );
  }
}
