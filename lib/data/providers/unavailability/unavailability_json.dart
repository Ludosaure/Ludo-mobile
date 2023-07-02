class UnavailabilityJson {
  final DateTime date;
  final String gameId;

  UnavailabilityJson({
    required this.date,
    required this.gameId,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'gameId': gameId,
    };
  }
}
