import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/ui/pages/game/list/game_tile.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class GameTileList extends StatelessWidget {
  final List<Game> games;
  final bool adminView;

  const GameTileList({
    super.key,
    required this.games,
    this.adminView = false,
  });

  @override
  Widget build(BuildContext context) {
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
            adminView: adminView,
          ),
        );
      },
    );
  }
}
