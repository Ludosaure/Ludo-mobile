import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/ui/components/game_filter_tab_bar.dart';
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
    return _buildTabBar(context);
  }

  Widget _buildTabBar(BuildContext context) {
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
