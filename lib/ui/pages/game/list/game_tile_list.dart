import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/get_games/get_games_cubit.dart';
import 'package:ludo_mobile/ui/components/game_filter_tab_bar.dart';
import 'package:ludo_mobile/ui/pages/game/list/game_tile.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class GameTileList extends StatefulWidget {
  List<Game> games;
  final bool adminView;

  GameTileList({
    super.key,
    required this.games,
    this.adminView = false,
  });

  @override
  State<GameTileList> createState() => _GameTileListState();
}

class _GameTileListState extends State<GameTileList> {
  late List<Game> availableGames = widget.games.where((game) =>
  game.isAvailable!).toList();

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
                _buildGamesList(context, widget.games),
                _buildAvailableGamesList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableGamesList(BuildContext context) {
    return _buildGamesList(context, availableGames);
  }

  Widget _buildGamesList(BuildContext context, List<Game> games) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<GetGamesCubit>(context).getGames();
      },
      child: BlocConsumer<GetGamesCubit, GetGamesState>(
        listener: (context, state) {
          if(state is GetGamesSuccess) {
            setState(() {
              widget.games = state.games;
              availableGames = widget.games.where((game) =>
              game.isAvailable!).toList();
            });
          }
        },
        builder: (context, state) {
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
                  adminView: widget.adminView,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
