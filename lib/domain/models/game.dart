import 'package:ludo_mobile/domain/models/game_category.dart';
import 'package:ludo_mobile/domain/models/review.dart';
import 'package:ludo_mobile/utils/extensions.dart';

class Game {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int averageDuration;
  final int minAge;
  final int minPlayers;
  final int maxPlayers;
  final List<GameCategory> categories;
  final double weeklyAmount;
  final double rating;
  final bool isArchived;
  final bool? isAvailable;
  final List<DateTime> unavailableDates;
  final List<Review> reviews;
  final bool canBeReviewed;

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
    this.isAvailable,
    required this.unavailableDates,
    required this.reviews,
    this.canBeReviewed = false,
  });

  factory Game.fromJson(Map<String, dynamic> json,
      {bool canBeReviewed = false}) {
    final List<DateTime> unavailableDates = [];

    if (json["unavailabilities"] != null) {
      json["unavailabilities"].forEach((unavailability) {
        final DateTime date = DateTime.parse(unavailability['date']);
        unavailableDates.add(DateTime(date.year, date.month, date.day));
      });
    }

    return Game(
      id: json['id'],
      name: json['name'].toString().titleCase(),
      description: json['description'],
      imageUrl: json['picture'] != null ? json['picture']['url'] : null,
      averageDuration: json['averageDuration'],
      minAge: json['ageMin'],
      minPlayers: json['nbPlayersMin'],
      maxPlayers: json['nbPlayersMax'],
      categories: [GameCategory.fromJson(json['category'])],
      weeklyAmount: json['weeklyAmount'].toDouble(),
      rating: json['averageRating'] != null
          ? json['averageRating'].toDouble()
          : 0.0,
      isArchived: json['isArchived'],
      isAvailable: json['isAvailable'] ?? false,
      unavailableDates: unavailableDates,
      reviews: json['reviews'] != null
          ? json['reviews']
              .map<Review>((review) => Review.fromJson(review))
              .toList()
          : [],
      canBeReviewed: canBeReviewed,
    );
  }

  // utilisé pour les favoris
  factory Game.onlyWithId(String id) {
    return Game(
      id: id,
      name: "",
      description: "",
      imageUrl: "",
      averageDuration: 0,
      minAge: 0,
      minPlayers: 0,
      maxPlayers: 0,
      categories: [],
      weeklyAmount: 0.0,
      rating: 0.0,
      isArchived: false,
      isAvailable: false,
      unavailableDates: [],
      reviews: [],
    );
  }
}
