import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/data/repositories/favorite/favorite_game.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/favorite_games/favorite_games_cubit.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/ui/pages/game/favorite/favorite_games_list.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class FavoriteGamesPage extends StatelessWidget {
  final User? user;
  late List<FavoriteGame> favorites;

  FavoriteGamesPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      body: _buildFavoriteList(),
      navBarIndex: MenuItems.Favorites.index,
      user: user,
    );
  }

  Widget _buildFavoriteList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: BlocConsumer<FavoriteGamesCubit, FavoriteGamesState>(
        listener: (context, state) {
          if (state is GetFavoriteGamesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          if (state is UserNotLogged) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  "user-must-log-for-access",
                ).tr(),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetFavoriteGamesInitial) {
            BlocProvider.of<FavoriteGamesCubit>(context).getFavorites();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetFavoriteGamesError) {
            return Center(
              child: const Text("no-favorites-found").tr()
            );
          }

          if (state is GetFavoriteGamesSuccess || state is OperationSuccess) {
            favorites = state.favorites;

            return FavoriteGamesList(
              favorites: favorites,
            );
          }

          if (state is UserNotLogged) {
            context.go(Routes.login.path);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
