part of 'handle_favorite_game_cubit.dart';

@immutable
abstract class HandleFavoriteGameState {}

class HandleFavoriteGameInitial extends HandleFavoriteGameState {}

class OperationInProgress extends HandleFavoriteGameState {}

class OperationSuccess extends HandleFavoriteGameState {}

class OperationFailure extends HandleFavoriteGameState {
  final String message;
  OperationFailure({required this.message}): super();
}

class UserNotLogged extends HandleFavoriteGameState {}


