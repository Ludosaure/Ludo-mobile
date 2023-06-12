import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/game.dart';

class NewReservation {
  final String userId;
  final DateTimeRange rentPeriod;
  final List<Game> games;

  NewReservation({
    required this.userId,
    required this.rentPeriod,
    required this.games,
  });
}