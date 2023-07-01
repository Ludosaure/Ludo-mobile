import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/game.dart';

class GameDetailsInfoBar extends StatelessWidget {
  final Game game;

  const GameDetailsInfoBar({
    required this.game,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.88),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        verticalDirection: VerticalDirection.down,
        children: [
          _buildNbPlayersCol(context),
          const SizedBox(
            width: 20,
          ),
          _buildMinAgeCol(context),
          const SizedBox(
            width: 20,
          ),
          _buildGameDurationCol(context),
        ],
      ),
    );
  }

  Widget _buildGameDurationCol(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.down,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(2.0),
          child: Icon(
            Icons.timer_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        const Text(
          "game-duration-label",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ).tr(),
        const SizedBox(height: 8),
        const Text(
          "game-duration",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ).tr(namedArgs: {
          "duration": game.averageDuration.toString(),
        }),
      ],
    );
  }

  Widget _buildMinAgeCol(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.down,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(2.0),
          child: Icon(
            Icons.elderly_woman,
            color: Colors.white,
            size: 20,
          ),
        ),
        const Text(
          "min-age-label",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ).tr(),
        const SizedBox(height: 8),
        const Text(
          "min-age",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ).tr(namedArgs: {
          "age": game.minAge.toString(),
        }),
      ],
    );
  }

  Widget _buildNbPlayersCol(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.groups,
          color: Colors.white,
        ),
        const Text(
          "nb-players-label-long",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ).tr(),
        const SizedBox(height: 8),
        const Text(
          "min-max-players-label",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ).tr(namedArgs: {
          "minPlayers": game.minPlayers.toString(),
          "maxPlayers": game.maxPlayers.toString(),
        }),
      ],
    );
  }
}
