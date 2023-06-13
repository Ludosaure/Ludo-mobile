import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/game.dart';

class NewReservation {
  late String id;
  final DateTimeRange rentPeriod;
  final List<Game> games;

  NewReservation({
    required this.rentPeriod,
    required this.games,
  });

  Map<String, dynamic> toJson() {
    print("date to isostringmachinchosen: ${rentPeriod.start.toIso8601String()}");
    return {
      'startDate': rentPeriod.start.toIso8601String(),
      'endDate': rentPeriod.end.toIso8601String(),
      'games': games.map((game) => game.id).toList(),
    };
  }
}