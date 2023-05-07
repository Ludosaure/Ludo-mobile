import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/get_games/get_games_cubit.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/ui/pages/game/list/game_list.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
              return GameList(
                games: state.games,
                gridView: _gridView,
              );
            }

            if (state is GetGamesError) {
              return const Center(
                child: Text("Aucun jeu trouvé"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
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
    );
  }
}
