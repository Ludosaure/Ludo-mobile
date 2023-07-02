part of 'game_unavailabilities_cubit.dart';

@immutable
abstract class GameUnavailabilitiesState {

  const GameUnavailabilitiesState();
}

class GameUnavailabilitiesInitial extends GameUnavailabilitiesState {
  GameUnavailabilitiesInitial() : super();
}

class GameUnavailabilitiesLoading extends GameUnavailabilitiesState {
  GameUnavailabilitiesLoading() : super();
}

class GameUnavailabilitiesSuccess extends GameUnavailabilitiesState {
  final DateTime date;
  final bool isCreation;
  const GameUnavailabilitiesSuccess({required this.date, this.isCreation = true}) : super();
}

class GameUnavailabilitiesError extends GameUnavailabilitiesState {
  final String message;

  const GameUnavailabilitiesError({required this.message}) : super();
}

class UserNotLogged extends GameUnavailabilitiesState {
  const UserNotLogged() : super();
}
