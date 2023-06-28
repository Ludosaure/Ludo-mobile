import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/game_category.dart';
import 'package:ludo_mobile/utils/extensions.dart';

class GameJson {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int averageDuration;
  final int ageMin;
  final int nbPlayersMin;
  final int nbPlayersMax;
  final List<GameCategory> category;
  final double weeklyAmount;
  final double rating;
  final bool isArchived;
  final bool? isAvailable;
  final List<DateTime> unavailableDates;
  final bool canBeReviewed;

  GameJson({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.averageDuration,
    required this.ageMin,
    required this.nbPlayersMin,
    required this.nbPlayersMax,
    required this.category,
    required this.weeklyAmount,
    required this.rating,
    required this.isArchived,
    this.isAvailable,
    required this.unavailableDates,
    this.canBeReviewed = false,
  });

  factory GameJson.fromJson(Map<String, dynamic> json,
      {bool canBeReviewed = false}) {
    final List<DateTime> unavailableDates = [];
    if (json["unavailabilities"] != null) {
      json["unavailabilities"].forEach((unavailability) {
        final DateTime date = DateTime.parse(unavailability['date']);
        unavailableDates.add(DateTime(date.year, date.month, date.day));
      });
    }

    return GameJson(
        id: json["id"],
        name: json["name"].toString().titleCase(),
        description: json["description"] ?? "",
        imageUrl: json['picture'] != null ? json['picture']['url'] : null,
        averageDuration: json["averageDuration"],
        ageMin: json["ageMin"],
        nbPlayersMin: json["nbPlayersMin"],
        nbPlayersMax: json["nbPlayersMax"],
        category: [GameCategory.fromJson(json['category'])],
        //TODO
        weeklyAmount: json["weeklyAmount"].toDouble(),
        rating: json["averageRating"] != null
            ? json["averageRating"].toDouble()
            : 0,
        isArchived: json["isArchived"],
        isAvailable: json['isAvailable'],
        unavailableDates: unavailableDates,
        canBeReviewed: canBeReviewed);
  }

  toGame() {
    return Game(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      averageDuration: averageDuration,
      minAge: ageMin,
      minPlayers: nbPlayersMin,
      maxPlayers: nbPlayersMax,
      categories: category,
      weeklyAmount: weeklyAmount,
      rating: rating,
      isArchived: isArchived,
      isAvailable: isAvailable,
      unavailableDates: unavailableDates,
      canBeReviewed: canBeReviewed,
    );
  }
}
