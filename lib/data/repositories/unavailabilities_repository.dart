import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/favorite_games/favorite_games_provider.dart';
import 'package:ludo_mobile/data/providers/favorite_games/get_favorite_games_response.dart';
import 'package:ludo_mobile/data/providers/unavailability/unavailabilities_provider.dart';
import 'package:ludo_mobile/data/providers/unavailability/unavailability_json.dart';
import 'package:ludo_mobile/data/repositories/favorite/favorite_game.dart';

@injectable
class UnavailabilitiesRepository {
  final UnavailabilitiesProvider gameUnavailabilitiesProvider;

  UnavailabilitiesRepository({
    required this.gameUnavailabilitiesProvider,
  });

  Future<void> createUnavailability(String gameId, DateTime date) async {
    UnavailabilityJson unavailabilityJson = UnavailabilityJson(
      gameId: gameId,
      date: date,
    );
    await gameUnavailabilitiesProvider.createUnavailability(unavailabilityJson);
  }

  Future<void> deleteUnavailability(String gameId, DateTime date) async {
    UnavailabilityJson unavailabilityJson = UnavailabilityJson(
      gameId: gameId,
      date: date,
    );
    await gameUnavailabilitiesProvider.deleteUnavailability(unavailabilityJson);
  }
}