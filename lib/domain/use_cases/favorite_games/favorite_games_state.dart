part of 'favorite_games_cubit.dart';

@immutable
abstract class FavoriteGamesState {
  final List<FavoriteGame> favorites;
  const FavoriteGamesState({
    this.favorites = const [],
  });
}

class GetFavoriteGamesInitial extends FavoriteGamesState {
  const GetFavoriteGamesInitial() : super();
}

class GetFavoriteGamesLoading extends FavoriteGamesState {
  const GetFavoriteGamesLoading() : super();
}

class GetFavoriteGamesUserNotLogged extends FavoriteGamesState {
  const GetFavoriteGamesUserNotLogged() : super();
}

class GetFavoriteGamesSuccess extends FavoriteGamesState {
  const GetFavoriteGamesSuccess({required List<FavoriteGame> favorites})
      : super(favorites: favorites);
}

class GetFavoriteGamesError extends FavoriteGamesState {
  final String message;
  const GetFavoriteGamesError({required this.message}) : super();
}

class OperationInProgress extends FavoriteGamesState {}

class OperationSuccess extends FavoriteGamesState {}

class OperationFailure extends FavoriteGamesState {
  final String message;
  const OperationFailure({required this.message}): super();
}

class UserNotLogged extends FavoriteGamesState {
  const UserNotLogged() : super();
}


