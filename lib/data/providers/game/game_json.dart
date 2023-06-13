import 'package:ludo_mobile/domain/models/game.dart';
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
  final List<String> category;
  final double weeklyAmount;
  final double rating;
  final bool isArchived;
  final bool isAvailable;
  final List<DateTime> unavailableDates;

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
    required this.isAvailable,
    required this.unavailableDates,
  });

  factory GameJson.fromJson(Map<String, dynamic> json){
    final List<DateTime> unavailableDates = [];
    json["unavailabilities"] != null ? json["unavailabilities"].forEach((unavailability) {
      unavailableDates.add(DateTime.parse(unavailability["date"]).toLocal());
    }) : [];

    return GameJson(
      id: json["id"],
      name: json["name"].toString().titleCase(),
      description: json["description"] ?? "",
      imageUrl: json["picture"]["url"],
      averageDuration: json["averageDuration"],
      ageMin: json["ageMin"],
      nbPlayersMin: json["nbPlayersMin"],
      nbPlayersMax: json["nbPlayersMax"],
      category: [json["category"]["name"].toString().titleCase()], //TODO
      weeklyAmount: json["weeklyAmount"].toDouble(),
      rating: json["averageRating"].toDouble(),
      isArchived: json["isArchived"],
      isAvailable: json["isAvailable"],
      unavailableDates: unavailableDates,
    );
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
    );
  }
}