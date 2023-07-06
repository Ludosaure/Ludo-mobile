import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/get_games/get_games_cubit.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/ui/pages/game/list/game_grid_list.dart';
import 'package:ludo_mobile/ui/pages/game/list/game_tile_list.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class UserHomePage extends StatefulWidget {
  final User? connectedUser;

  const UserHomePage({Key? key, required this.connectedUser}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  late List<Game> games;
  bool _gridView = true;

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      body: _buildGameList(),
      navBarIndex: MenuItems.Home.index,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _gridView = !_gridView;
          });
        },
        child: _gridView
            ? const Icon(
                Icons.list,
                color: Colors.white,
              )
            : const Icon(
                Icons.grid_view,
                color: Colors.white,
              ),
      ),
      user: widget.connectedUser,
    );
  }

  Widget _buildGameList() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 10.0,
        bottom: 40,
      ),
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
            return _gridView
                ? GameGridList(games: state.games)
                : GameTileList(games: state.games);
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
