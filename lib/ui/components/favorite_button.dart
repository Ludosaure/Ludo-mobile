import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/use_cases/get_favorite_games/get_favorite_games_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/handle_favorite_game/handle_favorite_game_cubit.dart';
import 'package:ludo_mobile/injection.dart';

class FavoriteButton extends StatelessWidget {
  final GetFavoriteGamesCubit _getFavoriteGamesCubit =
      locator<GetFavoriteGamesCubit>();
  final HandleFavoriteGameCubit _handleFavoriteGameCubit =
      locator<HandleFavoriteGameCubit>();
  final String gameId;

  FavoriteButton({Key? key, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIcon(),
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  IconData _getIcon() {
    if (_getFavoriteGamesCubit.isFavorite(gameId)) {
      return Icons.favorite;
    }

    return Icons.favorite_border;
  }
}
