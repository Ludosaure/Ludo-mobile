import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/ui/pages/game/list/game_card.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class GameGridList extends StatelessWidget {
  final List<Game> games;

  const GameGridList({
    super.key,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getItemNb(context),
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final Game game = games[index];
        return GestureDetector(
          onTap: () {
            context.push(
              '${Routes.game.path}/${game.id}',
            );
          },
          child: GameCard(
            game: game,
          ),
        );
      },
    );
  }

  int _getItemNb(BuildContext context) {
    if (ResponsiveWrapper.of(context).isSmallerThan(MOBILE)) {
      return 1;
    }
    if (ResponsiveWrapper.of(context).isSmallerThan(TABLET)) {
      return 2;
    }
    if (ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)) {
      return 3;
    }
    if (ResponsiveWrapper.of(context).isSmallerThan("4K")) {
      return 4;
    }
    return 5;
  }
}
