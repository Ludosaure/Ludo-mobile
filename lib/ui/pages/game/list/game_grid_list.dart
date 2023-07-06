import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/get_games/get_games_cubit.dart';
import 'package:ludo_mobile/ui/components/game_filter_tab_bar.dart';
import 'package:ludo_mobile/ui/pages/game/list/game_card.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class GameGridList extends StatefulWidget {
  List<Game> games;

  GameGridList({
    super.key,
    required this.games,
  });

  @override
  State<GameGridList> createState() => _GameGridListState();
}

class _GameGridListState extends State<GameGridList> {
  late List<Game> availableGames =
      widget.games.where((game) => game.isAvailable!).toList();

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const GameFilterTabBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TabBarView(
                children: [
                  _buildGamesList(context, widget.games),
                  _buildGamesList(context, availableGames),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesList(BuildContext context, List<Game> games) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<GetGamesCubit>(context).getGames();
      },
      child: BlocConsumer<GetGamesCubit, GetGamesState>(
        listener: (context, state) {
          if (state is GetGamesSuccess) {
            setState(() {
              widget.games = state.games;
              availableGames =
                  widget.games.where((game) => game.isAvailable!).toList();
            });
          }
        },
        builder: (context, state) {
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
        },
      ),
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
