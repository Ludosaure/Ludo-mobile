import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/data/repositories/favorite_games_repository.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/get_favorite_games/get_favorite_games_cubit.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/ui/pages/game/favorite_games_list.dart';
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
      child: BlocConsumer<GetFavoriteGamesCubit, GetFavoriteGamesState>(
        listener: (context, state) {
          if (state is GetFavoriteGamesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          if (state is GetFavoriteGamesUserNotLogged) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                    "Vous devez être connecté pour voir vos favoris"),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetFavoriteGamesInitial) {
            BlocProvider.of<GetFavoriteGamesCubit>(context).getFavorites();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetFavoriteGamesError) {
            return const Center(child: Text("Aucun favoris trouvés."));
          }

          if (state is GetFavoriteGamesSuccess) {
            favorites = state.favorites;

            return FavoriteGamesList(
              favorites: favorites,
            );
          }

          if (state is GetFavoriteGamesUserNotLogged) {
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
