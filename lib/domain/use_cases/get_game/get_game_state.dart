part of 'get_game_cubit.dart';

@immutable
abstract class GetGameState {
  const GetGameState();
}

class GetGameInitial extends GetGameState {}

class GetGameLoading extends GetGameState {}

class GetGameSuccess extends GetGameState {
  final Game game;

  const GetGameSuccess({required this.game});
}

class GetGameError extends GetGameState {
  final String message;
  const GetGameError({required this.message});
}
