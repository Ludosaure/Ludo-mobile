part of 'favorite_games_cubit.dart';

@immutable
abstract class FavoriteGamesState {
  final List<FavoriteGame> favorites;

  const FavoriteGamesState({
    required this.favorites,
  });
}

class GetFavoriteGamesInitial extends FavoriteGamesState {
  GetFavoriteGamesInitial() : super(favorites: List.empty());
}

class GetFavoriteGamesLoading extends FavoriteGamesState {
  GetFavoriteGamesLoading() : super(favorites: List.empty());
}

class GetFavoriteGamesSuccess extends FavoriteGamesState {
  const GetFavoriteGamesSuccess({required List<FavoriteGame> favorites})
      : super(favorites: favorites);
}

class GetFavoriteGamesError extends FavoriteGamesState {
  final String message;

  GetFavoriteGamesError({required this.message})
      : super(favorites: List.empty());
}

class OperationInProgress extends FavoriteGamesState {
  const OperationInProgress({required List<FavoriteGame> favorites})
      : super(favorites: favorites);
}

class OperationSuccess extends FavoriteGamesState {
  const OperationSuccess({required List<FavoriteGame> favorites})
      : super(favorites: favorites);
}

class OperationFailure extends FavoriteGamesState {
  final String message;

  const OperationFailure({
    required this.message,
    required List<FavoriteGame> favorites,
  }) : super(favorites: favorites);
}

class UserNotLogged extends FavoriteGamesState {
  UserNotLogged() : super(favorites: List.empty());
}
