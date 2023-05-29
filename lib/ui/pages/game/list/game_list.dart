import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

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
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    if (gridView) {
      return _buildGrid(context);
    }
    return _buildTileList();
  }

  Widget _buildGrid(BuildContext context) {
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

  int _getItemNb(BuildContext context) {
    if (ResponsiveWrapper.of(context).isSmallerThan(MOBILE)) {
      return 1;
    } else if (ResponsiveWrapper.of(context).isSmallerThan(TABLET)) {
      return 2;
    } else if (ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)) {
      return 3;
    } else if (ResponsiveWrapper.of(context).isSmallerThan("4K")) {
      return 4;
    }
    return 5;
  }
}
