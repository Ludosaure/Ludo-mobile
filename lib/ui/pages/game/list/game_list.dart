import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

import 'game_card.dart';
import 'game_tile.dart';

class GameList extends StatelessWidget {
  final List<Game> games;
  final bool gridView;

  const GameList({
    Key? key,
    required this.games,
    required this.gridView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    if (gridView) {
      return _buildGrid();
    }
    return _buildTileList();
  }

  Widget _buildGrid() {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
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

  Widget _buildTileList() {
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final Game game = games[index];
        return GestureDetector(
          onTap: () {
            context.push(
              '${Routes.game.path}/${game.id}',
            );
          },
          child: GameTile(
            game: game,
          ),
        );
      },
    );
  }
}
