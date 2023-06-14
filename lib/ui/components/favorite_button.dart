import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/favorite_games/favorite_games_cubit.dart';

class FavoriteButton extends StatelessWidget {
  final Game game;

  const FavoriteButton({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late bool isFavorite = false;

    return BlocConsumer<FavoriteGamesCubit, FavoriteGamesState>(
      builder: (context, state) {
        if (state is GetFavoriteGamesInitial) {
          BlocProvider.of<FavoriteGamesCubit>(context).getFavorites();
          return _buildButton(context, false);
        }

        if(state is OperationInProgress) {
          return _buildButton(context, isFavorite);
        }

        if (state is GetFavoriteGamesSuccess || state is OperationSuccess){
          isFavorite =
              BlocProvider.of<FavoriteGamesCubit>(context).isFavorite(game);
          return _buildButton(context, isFavorite);
        }

        if (state is UserNotLogged) {
          return Container();
        }

        return Container();
      },
      listener: (context, state) {
      },
    );
  }

  Widget _buildButton(BuildContext context, bool isFavorite) {
    return IconButton(
      onPressed: () {
        if (isFavorite) {
          BlocProvider.of<FavoriteGamesCubit>(context).removeFromFavorite(game);
        } else {
          BlocProvider.of<FavoriteGamesCubit>(context).addToFavorite(game);
        }
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
