import 'package:ludo_mobile/domain/models/game.dart';

class GameJson {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int averageDuration;
  final int ageMin;
  final int nbPlayersMin;
  final int nbPlayersMax;
  final List<String> category;
  final double weeklyAmount;
  // final double rating;
  final bool isArchived;

  GameJson({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.averageDuration,
    required this.ageMin,
    required this.nbPlayersMin,
    required this.nbPlayersMax,
    required this.category,
    required this.weeklyAmount,
    // required this.rating,
    required this.isArchived,
  });

  factory GameJson.fromJson(Map<String, dynamic> json) => GameJson(
    id: json["id"],
    name: json["name"],
    description: json["description"]??"",
    imageUrl: "https://picsum.photos/200", //TODO
    averageDuration: json["averageDuration"],
    ageMin: json["ageMin"],
    nbPlayersMin: json["nbPlayersMin"],
    nbPlayersMax: json["nbPlayersMax"],
    category: [json["category"]["name"]], //TODO
    weeklyAmount: json["weeklyAmount"].toDouble(),
    // rating: json["rating"],
    isArchived: json["isArchived"],
  );

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
      rating: 2.5,
    );
  }
}