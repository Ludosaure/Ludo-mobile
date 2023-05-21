part of 'get_favorite_games_cubit.dart';

@immutable
abstract class GetFavoriteGamesState {
  final List<FavoriteGame> favorites;
  const GetFavoriteGamesState({
    this.favorites = const [],
  });
}

class GetFavoriteGamesInitial extends GetFavoriteGamesState {
  const GetFavoriteGamesInitial() : super();
}

class GetFavoriteGamesLoading extends GetFavoriteGamesState {
  const GetFavoriteGamesLoading() : super();
}

class GetFavoriteGamesUserNotLogged extends GetFavoriteGamesState {
  const GetFavoriteGamesUserNotLogged() : super();
}

class GetFavoriteGamesSuccess extends GetFavoriteGamesState {
  const GetFavoriteGamesSuccess({required List<FavoriteGame> favorites})
      : super(favorites: favorites);
}

class GetFavoriteGamesError extends GetFavoriteGamesState {
  final String message;
  const GetFavoriteGamesError({required this.message}) : super();
}


