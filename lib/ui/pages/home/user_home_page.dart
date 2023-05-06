import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/get_games/get_games_cubit.dart';
import 'package:ludo_mobile/ui/components/nav_bar/app_bar/custom_app_bar.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/no_account_bottom_nav_bar.dart';
import 'package:ludo_mobile/ui/pages/game/game_list.dart';

class UserHomePage extends StatelessWidget {
  final User? connectedUser;

  UserHomePage({Key? key, required this.connectedUser}) : super(key: key);

  late List<Game> games;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
            if(state is GetGamesInitial) {
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
              );
            }

            if(state is GetGamesError) {
              return const Center(
                child: Text("Aucun jeu trouvé"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ),
      bottomNavigationBar: _getBottomNavigationBar(context, connectedUser),
      appBar: const CustomAppBar().build(context),
    );
  }

  Widget _getBottomNavigationBar(BuildContext context, User? connectedUser) {
    if (connectedUser == null) {
      return const NoAccountBottomNavigationBar();
    }

    return const CustomBottomNavigationBar();
  }
}
