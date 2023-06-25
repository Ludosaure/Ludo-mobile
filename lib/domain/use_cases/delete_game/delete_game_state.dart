part of 'delete_game_cubit.dart';

@immutable
abstract class DeleteGameState {
  const DeleteGameState();
}

class DeleteGameInitial extends DeleteGameState {}

class DeleteGameLoading extends DeleteGameState {}

class DeleteGameSuccess extends DeleteGameState {}

class DeleteGameError extends DeleteGameState {
  final String message;
  const DeleteGameError({required this.message});
}

class UserMustLog extends DeleteGameState {}
