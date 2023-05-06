import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';

import 'game_card.dart';

class GameList extends StatelessWidget {
  final List<Game> games;

  const GameList({Key? key, required this.games}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final Game game = games[index];
        print(game);
        return GestureDetector(
          onTap: () {
            context.push(
              '/game/${game.id}',
              extra: game,
            );
          },
          child: GameCard(
            game: game,
          ),
        );
      },
    );
  }
}
