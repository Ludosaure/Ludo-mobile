import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/get_games/get_games_cubit.dart';
import 'package:ludo_mobile/ui/pages/game/list/game_tile_list.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class AdminGamesPage extends StatefulWidget {
  final User user;

  const AdminGamesPage({
    super.key,
    required this.user,
  });

  @override
  State<AdminGamesPage> createState() => _AdminGamesPageState();
}

class _AdminGamesPageState extends State<AdminGamesPage> {
  late List<Game> games;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.go(Routes.adminDashboard.path);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'game-administration-title',
          style: TextStyle(color: Colors.black),
        ).tr(),
      ),
      body: _buildGameList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.addGame.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGameList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: BlocConsumer<GetGamesCubit, GetGamesState>(
        listener: (context, state) {
          if (state is GetGamesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetGamesInitial) {
            BlocProvider.of<GetGamesCubit>(context).getGames();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetGamesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetGamesSuccess) {
            games = state.games;
            return RefreshIndicator(
                child: GameTileList(
                  adminView: true,
                  games: state.games,
                ),
                onRefresh: () async {
                  BlocProvider.of<GetGamesCubit>(context).getGames();
                });
          }

          if (state is GetGamesError) {
            return Column(
              verticalDirection: VerticalDirection.down,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: const Text("no-game-found").tr(),
                ),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<GetGamesCubit>(context).getGames();
                  },
                  child: const Text("try-again-label").tr(),
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
