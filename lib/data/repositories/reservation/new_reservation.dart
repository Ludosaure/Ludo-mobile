import 'package:flutter/material.dart';

class NewReservation {
  final String userId;
  final DateTimeRange rentPeriod;
  final List<String> games;

  NewReservation({
    required this.userId,
    required this.rentPeriod,
    required this.games,
  });
}