import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/ui/components/game_filter_tab_bar.dart';
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
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const GameFilterTabBar(),
          Expanded(
            child: TabBarView(
              children: [
                _buildGamesList(context, games),
                _buildAvailableGamesList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableGamesList(BuildContext context) {
    final availableGames = games.where((game) => game.isAvailable!).toList();
    return _buildGamesList(context, availableGames);
  }

  Widget _buildGamesList(BuildContext context, List<Game> games) {
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
